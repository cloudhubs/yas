---
name: generate-synthetic-data
description: Analyzes a microservices codebase and generates consistent synthetic seed data, Keycloak users, and a Postman collection for API test generators
when-to-use: When you need to provision test databases and auth users for a microservices system covering all inter-service flows and authorization roles
arguments:
  - name: target-path
    description: Root path of the microservices codebase to analyze
    required: true
  - name: output-path
    description: Directory where all output artifacts will be written
    required: true
allowed-tools: Read, Bash, Write
---

You are a synthetic test data generator for microservices systems.
Analyze the codebase at `$ARGUMENTS.target-path` and write all output to `$ARGUMENTS.output-path`.

Create `$ARGUMENTS.output-path` if it does not exist.

## Idempotency Check

If `$ARGUMENTS.output-path/flow-matrix.md` already exists, skip to **Phase D** and use it as input.
This allows humans to edit the flow matrix and re-generate data without re-running codebase analysis.

---

## Phase A — Service Discovery

Read `$ARGUMENTS.target-path/docker-compose.yml` (fall back to `docker-compose.yaml`).

For each entry under `services:`, extract:
- Service name
- `image` value (used to classify the service type)
- Port mappings (`ports:`)
- Environment variables (`environment:`)

Classify each service:
- **Database**: image contains `postgres`, `mysql`, `mariadb`, or `mongo`
- **Identity provider**: image contains `keycloak`
- **Application**: everything else

For application services, find which database they connect to by inspecting environment variables:
- `SPRING_DATASOURCE_URL`, `DATABASE_URL`, `POSTGRES_HOST`, `MYSQL_HOST`, `DB_HOST`
- Extract the database name from the URL (the path segment after the last `/`)

For shared database instances (one postgres service, multiple databases), note all database names used across all application services.

Store: list of (application-service, db-name, db-type) tuples.
Store: identity provider type (`keycloak`, `custom-jwt`, or `none`).
Store: Keycloak admin credentials from env vars (`KC_BOOTSTRAP_ADMIN_USERNAME`, `KC_BOOTSTRAP_ADMIN_PASSWORD`).
Store: Keycloak realm name from volume mounts (look for `realm-export.json` volume — read that file and extract `"realm"` field).

---

## Phase B — Call Graph Construction

For each application service directory under `$ARGUMENTS.target-path`, scan source files for outbound HTTP calls.

**Java/Spring — scan all `*.java` files:**
- `RestTemplate`: grep for `.exchange(`, `.getForObject(`, `.postForObject(`, `.put(`, `.delete(`
- `WebClient`: grep for `.get().uri(`, `.post().uri(`, `.put().uri(`, `.delete().uri(`
- `@FeignClient`: grep for the annotation and extract `url` or `name` attribute
- `RestClient`: grep for `.get().uri(`, `.post().uri(`

**TypeScript/JavaScript — scan all `*.ts`, `*.js` files:**
- `fetch(`, `axios.get(`, `axios.post(`, `axios.put(`, `axios.delete(`, `axios.patch(`
- `got.get(`, `got.post(`, `ky.get(`, `ky.post(`

For each call, identify the target service from the URL string (look for service names, hostnames from docker-compose, or environment variable names like `PRODUCT_SERVICE_URL`).

Build directed graph: `caller-service → target-service`.

Classify each node:
- **Orchestrator**: ≥2 distinct outbound calls to other application services
- **Core data service**: ≥2 inbound calls, few outbound
- **Terminal**: no outbound calls to other application services

---

## Phase C — Flow Matrix

For each orchestrator service:

1. List all controller endpoints:
   - Spring: scan `*Controller.java` for `@GetMapping`, `@PostMapping`, `@PutMapping`, `@DeleteMapping`, `@PatchMapping`, `@RequestMapping`
   - TypeScript: scan `*router.ts`, `*routes.ts`, `*controller.ts` for `.get(`, `.post(`, `.put(`, `.delete(`, `.patch(`

2. For each endpoint, find required authorization role:
   - Spring `@PreAuthorize("hasRole('X')")` or `@Secured("ROLE_X")` on the method
   - Spring `HttpSecurity` config in `WebSecurityConfig.java` — match the endpoint path
   - Spring `application.yml` with `security.authorization-rules` or `security.path-roles`
   - Keycloak realm export: check if the client has role-based policies
   - TypeScript middleware: look for `requireRole`, `hasRole`, `authenticate`, JWT guard decorators
   - No role found → mark as `PUBLIC`

3. Extract Keycloak realm roles by reading the realm export JSON file found in Phase A.
   Look for the `"roles"` → `"realm"` array and collect all role names that are not built-in Keycloak roles (exclude: `default-roles-*`, `offline_access`, `uma_authorization`).

4. For each endpoint × role combination, generate these data-state scenarios:
   - `success`: all prerequisites met, correct role
   - `unauthorized`: valid token but wrong role (skip if PUBLIC)
   - `unauthenticated`: no token (skip if PUBLIC)
   - `not_found`: path parameter entity does not exist (only for endpoints with `{id}` or `{slug}` path params)

---

## Phase C.5 — Write Auditable Graph Artifacts

Write `$ARGUMENTS.output-path/flow-graph.mmd`:

```
%% Service call graph — generated by generate-synthetic-data
graph LR
  ServiceA --> ServiceB
  ServiceA --> ServiceC
```

One `-->` line per edge in the call graph from Phase B. Use the exact service names from docker-compose.yml.

Write `$ARGUMENTS.output-path/flow-matrix.md`:

```markdown
# Flow Matrix

| Flow Name | Path | Operation | Role | Data State |
|-----------|------|-----------|------|------------|
| order_create_customer_success | storefront-bff → order → inventory → payment | POST /api/orders | CUSTOMER | success |
| order_create_unauthorized | storefront-bff → order | POST /api/orders | ADMIN | unauthorized |
```

Rules:
- Flow Name: unique snake_case combining service slug, endpoint slug, role (lowercase), state
- Path: arrow-separated service names from orchestrator to leaf
- Operation: `METHOD /path` using the actual path from the controller
- Role: exact role name as found in security config, or `PUBLIC` or `NONE` for unauthenticated
- Data State: `success`, `unauthorized`, `unauthenticated`, or `not_found`

---

## Phase D — Generate Output Artifacts

Read `$ARGUMENTS.output-path/flow-matrix.md` to get all flows.

### D1 — Keycloak User Setup (only if identity provider = keycloak)

Write `$ARGUMENTS.output-path/setup-auth.sh`:

```bash
#!/usr/bin/env bash
# setup-auth.sh — Creates test users in Keycloak for each role found in the flow matrix
# Usage: ./setup-auth.sh <keycloak-base-url> <realm>
# Example: ./setup-auth.sh http://localhost:80 yas

set -euo pipefail

KEYCLOAK_URL="${1:-http://localhost:80}"
REALM="${2:-yas}"
ADMIN_USER="<admin-username-from-compose>"
ADMIN_PASS="<admin-password-from-compose>"
TEST_PASSWORD="Test@1234"

echo "Getting admin token..."
ADMIN_TOKEN=$(curl -s -X POST \
  "${KEYCLOAK_URL}/realms/master/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password&client_id=admin-cli&username=${ADMIN_USER}&password=${ADMIN_PASS}" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")

create_user() {
  local USERNAME="$1"
  local PASSWORD="$2"
  local ROLE="$3"

  echo "Creating user ${USERNAME} with role ${ROLE}..."

  # Check if user already exists
  EXISTING=$(curl -s \
    "${KEYCLOAK_URL}/admin/realms/${REALM}/users?username=${USERNAME}" \
    -H "Authorization: Bearer ${ADMIN_TOKEN}")
  
  if echo "$EXISTING" | python3 -c "import sys,json; d=json.load(sys.stdin); exit(0 if len(d)==0 else 1)" 2>/dev/null; then
    USER_ID=$(curl -s -X POST \
      "${KEYCLOAK_URL}/admin/realms/${REALM}/users" \
      -H "Authorization: Bearer ${ADMIN_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "{\"username\":\"${USERNAME}\",\"email\":\"${USERNAME}@test.com\",\"enabled\":true,\"emailVerified\":true}" \
      | python3 -c "import sys; loc=sys.stdin.read(); print(loc)" 2>/dev/null || true)
    
    USER_ID=$(curl -s \
      "${KEYCLOAK_URL}/admin/realms/${REALM}/users?username=${USERNAME}" \
      -H "Authorization: Bearer ${ADMIN_TOKEN}" \
      | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['id'])")
  else
    USER_ID=$(echo "$EXISTING" | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['id'])")
    echo "User ${USERNAME} already exists (${USER_ID}), updating..."
  fi

  # Set password
  curl -s -X PUT \
    "${KEYCLOAK_URL}/admin/realms/${REALM}/users/${USER_ID}/reset-password" \
    -H "Authorization: Bearer ${ADMIN_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"type\":\"password\",\"value\":\"${PASSWORD}\",\"temporary\":false}"

  # Get role representation
  ROLE_REP=$(curl -s \
    "${KEYCLOAK_URL}/admin/realms/${REALM}/roles/${ROLE}" \
    -H "Authorization: Bearer ${ADMIN_TOKEN}")

  # Assign role
  curl -s -X POST \
    "${KEYCLOAK_URL}/admin/realms/${REALM}/users/${USER_ID}/role-mappings/realm" \
    -H "Authorization: Bearer ${ADMIN_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "[${ROLE_REP}]"

  echo "User ${USERNAME} ready."
}

# One call per role found in the flow matrix
# <ROLE_CALLS_PLACEHOLDER — replace with actual create_user calls per role>
```

Replace `<ROLE_CALLS_PLACEHOLDER>` with one `create_user` call per distinct role found across the flow matrix:
```bash
create_user "test_<rolename_lowercase>" "${TEST_PASSWORD}" "<ROLE_NAME>"
```

Make the file executable: `chmod +x $ARGUMENTS.output-path/setup-auth.sh`

### D2 — Business Data Seed SQL

For each (application-service, db-name) pair from Phase A:

**Schema discovery:**
- JPA/Java: read `@Entity` classes, extract `@Column` field names and types, `@Enumerated` values, `@Table(name=...)` for table name
- Prisma: read `schema.prisma`, extract `model` blocks
- TypeORM: read `@Entity()` classes with `@Column()` decorators
- Fallback: look for Flyway/Liquibase migration files (`V*.sql`, `changelog*.sql`) and extract `CREATE TABLE` statements

**ID generation strategy:**
Use deterministic UUIDs with a counter: `550e8400-e29b-41d4-a716-{counter:012d}` (counter starts at 1, increments per entity instance). Maintain a cross-service map of `entity-type:role → UUID` so the same UUID is reused wherever a foreign key references it.

**Field value generation:**
- `id` / primary key: deterministic UUID from counter
- `email` fields: `<role_lowercase>_test_<N>@example.com`
- `password` / `password_hash`: bcrypt hash `$2b$10$xqORlPNqPELheCmKJOx5AuXE5MJVbhlwqWd7Z8fSJwK2VGqxO/wHa` (pre-computed for `Test@1234` at cost 10)
- `name` / `title` fields: `<fieldname>_test_<N>`
- `price` / `amount` / `quantity` fields: `10.00` / `10` / `5`
- Enum fields: first value found in the enum definition
- Date/timestamp fields: `2026-01-15T10:00:00Z` + (N-1 days per additional row)
- Boolean fields: `true`
- Foreign key fields: use the UUID of the referenced entity from the cross-service map

**FK ordering:**
Write seed files in topological order: no-FK entities first, then entities whose FKs point to already-written entities.

**Do NOT seed entities for `not_found` scenarios** — the absence of data IS the test condition.

For each service DB, write `$ARGUMENTS.output-path/<db-name>/seed.sql`:

```sql
-- <db-name>/seed.sql
-- Generated by generate-synthetic-data skill

BEGIN;

INSERT INTO <table_name> (<col1>, <col2>, <col3>) VALUES
  ('<val1>', '<val2>', '<val3>'),
  ('<val1b>', '<val2b>', '<val3b>');

-- repeat per table

COMMIT;
```

### D3 — Postman Collection

Write `$ARGUMENTS.output-path/postman_seed.json` as a valid Postman Collection v2.1:

Top-level structure:
```json
{
  "info": {
    "name": "Synthetic Seed Collection",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [],
  "variable": [
    { "key": "baseUrl", "value": "http://localhost:80" }
  ]
}
```

For Keycloak systems, add one folder per role with a login request first:

```json
{
  "name": "<ROLE> flows",
  "item": [
    {
      "name": "Login as <role_lowercase>",
      "event": [{
        "listen": "test",
        "script": {
          "exec": ["pm.collectionVariables.set('<role_lowercase>_token', pm.response.json().access_token);"]
        }
      }],
      "request": {
        "method": "POST",
        "header": [{"key": "Content-Type", "value": "application/x-www-form-urlencoded"}],
        "body": {
          "mode": "urlencoded",
          "urlencoded": [
            {"key": "grant_type", "value": "password"},
            {"key": "client_id", "value": "<keycloak-client-id-for-this-app>"},
            {"key": "username", "value": "test_<role_lowercase>"},
            {"key": "password", "value": "Test@1234"}
          ]
        },
        "url": {"raw": "{{baseUrl}}/realms/<realm>/protocol/openid-connect/token"}
      }
    }
  ]
}
```

Then add one request per flow row that belongs to this role. For `success` flows:
- Method and path from the flow matrix Operation column
- Path parameters filled with seed UUIDs from the cross-service map
- `Authorization: Bearer {{<role_lowercase>_token}}` header
- Request body: JSON object with all required fields from the matching entity seed data

For `unauthorized` flows: use the wrong role's token (e.g., CUSTOMER token on an ADMIN endpoint).
For `unauthenticated` flows: omit the Authorization header.
For `not_found` flows: use a UUID that was NOT inserted (e.g., `550e8400-e29b-41d4-a716-999999999999`).

### D4 — Docker Compose Override

Write `$ARGUMENTS.output-path/docker-compose.test.yml`:

For systems with a **shared postgres** (one postgres service, multiple databases): override the single postgres service with a test instance and mount an init script that creates all databases and seeds them.

Write `$ARGUMENTS.output-path/postgres-init/` with one `.sql` file per database, plus a `00-create-databases.sql`:

```sql
-- 00-create-databases.sql
CREATE DATABASE product;
CREATE DATABASE customer;
CREATE DATABASE cart;
-- etc.
```

```yaml
# docker-compose.test.yml
# Usage: docker compose -f docker-compose.yml -f synthetic-data/output/docker-compose.test.yml up -d
services:
  postgres:
    image: postgres:16
    container_name: postgres-test
    environment:
      POSTGRES_USER: test
      POSTGRES_PASSWORD: test
      POSTGRES_DB: postgres
    volumes:
      - ./synthetic-data/output/postgres-init:/docker-entrypoint-initdb.d
    ports:
      - "<original-port+100>:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U test"]
      interval: 5s
      timeout: 5s
      retries: 10
```

For systems with **per-service postgres** instances: generate one service entry per DB.

For systems with **MySQL**: use `image: mysql:8.0`, `MYSQL_ROOT_PASSWORD: test`, `MYSQL_DATABASE: <db>`, and healthcheck `mysqladmin ping -h localhost`.
