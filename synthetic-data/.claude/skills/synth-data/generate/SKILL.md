---
name: generate-synthetic-data
description: Analyzes a microservices codebase and generates consistent synthetic seed data, Keycloak users, and a Postman collection for API test generators
when-to-use: When you need to provision test databases and auth users for a microservices system covering all inter-service flows and authorization roles
arguments: "target-path output-path scenarios-per-flow"
allowed-tools: Read, Bash, Write
---

You are a synthetic test data generator for microservices systems.
**Start executing immediately. Do not ask for confirmation. Do not summarize the plan. Call tools now.**

Analyze the codebase at `$target-path` and write all output to `$output-path`.
Use the Bash tool to run `mkdir -p $output-path` as your first action.

Scenarios per success flow: `$scenarios-per-flow` (default 10 if not provided).

## Idempotency and Batch Strategy

This skill is designed to be re-invoked multiple times. Each invocation picks up exactly where the previous one left off. **Never redo work that is already done.**

### Resume logic — check in this order:

1. **`$output-path/flow-matrix.md` does not exist** → run all phases A through D from scratch.

2. **`$output-path/flow-matrix.md` exists** → skip Phases A–C.5. Compare data state groups already covered in `$output-path/scenarios.md` against the full group list derived from Phase C.6 logic:

   - Read `$output-path/scenarios.md` (may not exist yet). Collect all `## Data State:` headings already present. These groups are **done** — do not regenerate them.
   - Derive the full list of data state groups from `$output-path/flow-matrix.md` (see Phase C.6).
   - If **covered < total groups**: run Phase C.6 for the next batch of uncovered groups (up to `$scenarios-per-flow` groups per invocation, default 10). After writing the batch, check again:
     - If **covered = total**: proceed to Phase D.
     - If **covered < total**: stop and output the progress report.
   - If **covered = total** and `$output-path/seed-all.sql` does not exist: run Phase D now.
   - If **covered = total** and `$output-path/seed-all.sql` already exists: report all done, nothing to do.

### Why batching matters

Each data state group generates `$scenarios-per-flow` scenarios. Many groups can produce a large `scenarios.md` that exhausts context. The batch strategy ensures each invocation makes measurable progress and is safe to re-run.

### Progress report format

When stopping after a batch (more groups remain), output exactly:

```
Batch complete: X of Y data state groups covered in $output-path/scenarios.md.
Re-invoke this skill to continue with the next batch.
```

---

## Phase A — Service Discovery

Read `$target-path/docker-compose.yml` (fall back to `docker-compose.yaml`).

For each entry under `services:`, extract:
- Service name
- `image` value (used to classify the service type)
- Port mappings (`ports:`)
- Environment variables (`environment:`)

Classify each service:
- **Database**: image contains `postgres`, `mysql`, `mariadb`, or `mongo`
- **Identity provider**: image contains `keycloak`, `auth0`, `cognito`, `firebase`, `okta`
- **Application**: everything else

For application services, find which database they connect to by inspecting environment variables:
- `SPRING_DATASOURCE_URL`, `DATABASE_URL`, `POSTGRES_HOST`, `MYSQL_HOST`, `DB_HOST`
- Extract the database name from the URL (the path segment after the last `/`)

For shared database instances (one postgres service, multiple databases), note all database names used across all application services.

Store: list of (application-service, db-name, db-type) tuples.

### A.1 — Identity Provider Classification

Classify the IdP found (or absent) and extract the information needed for D1:

| IdP type | Detection signal | Extract |
|---|---|---|
| `keycloak` | image contains `keycloak` | admin user/pass from `KC_BOOTSTRAP_ADMIN_USERNAME` / `KC_BOOTSTRAP_ADMIN_PASSWORD`; realm name from `realm-export.json` volume (read file, extract `"realm"` field); base URL from nginx `server_name` or port mapping |
| `auth0` | env vars contain `AUTH0_DOMAIN` or `AUTH0_ISSUER` | domain, Management API client ID/secret from env vars |
| `cognito` | env vars contain `COGNITO_USER_POOL_ID` or `AWS_COGNITO_` prefix | user pool ID, region, admin credentials from env vars |
| `firebase` | env vars contain `FIREBASE_PROJECT_ID` or image contains `firebase` | project ID, service account JSON path |
| `custom` | application has a `/register`, `/signup`, or `POST /users` endpoint with no auth guard (discovered in Phase B/C) | registration endpoint path, required fields |
| `none` | no IdP service found, no auth annotations in source | — |

Store: `idp.type`, `idp.admin_credentials`, `idp.base_url`, `idp.realm` (Keycloak only).

### A.2 — Identity FK Detection

Scan application source files for columns that store identity provider user IDs as foreign keys.
These are the columns that will need UUID placeholders in seed SQL.

Grep patterns:
```bash
# JPA entities
grep -r "customer_id\|user_id\|owner_id\|created_by\|account_id" \
  --include="*.java" $target-path

# Prisma / TypeORM
grep -r "userId\|customerId\|ownerId\|accountId" \
  --include="*.ts" --include="*.prisma" $target-path
```

For each match, check if the column type is UUID/String (not a numeric FK to a local `users` table).
If the column stores an IdP-issued ID, mark the (service, table, column) tuple as an **identity FK**.

Store: list of (service, table, column) identity FK tuples.
If `idp.type == none` or no identity FKs found, D1 is skipped entirely.

---

## Phase B — Call Graph Construction

For each application service directory under `$target-path`, scan source files for outbound HTTP calls.

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

Write `$output-path/flow-graph.mmd`:

```
%% Service call graph — generated by generate-synthetic-data
graph LR
  ServiceA --> ServiceB
  ServiceA --> ServiceC
```

One `-->` line per edge in the call graph from Phase B. Use the exact service names from docker-compose.yml.

Write `$output-path/flow-matrix.md`:

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

## Phase C.6 — Write Scenario Catalog

Write (or append to) `$output-path/scenarios.md`.

### Core insight: organize by data state, not by API flow

Many API flows share the same database prerequisites. For example, GET /cart/items, POST /cart/items, PUT /cart/items/{id}, and DELETE /cart/items/{id} all require the same data to exist: a product and a Keycloak user. Generating separate scenario sets per flow would produce massive duplication.

Instead, **group flows by their shared data requirements** and generate one scenario set per group. Each scenario in a group describes a complete, consistent database snapshot that enables ALL flows in that group.

### Step 1 — Derive data state groups

Read `$output-path/flow-matrix.md`. For each `success` row, identify which DB entities must exist for that flow to return a non-error response. Then cluster flows that share the same set of required entities into one group.

Common group patterns:

| Group name | Required DB entities | Flows enabled |
|---|---|---|
| `product_catalog` | product: brand, category, product | product browse, search, brand/category browse |
| `customer_with_cart` | product + Keycloak user (CUSTOMER) + cart: cart_item | all cart CRUD flows |
| `customer_with_address` | Keycloak user + location: country, state/province, district, address + customer: user_address | user-address CRUD flows |
| `customer_with_order` | everything above + order: checkout, order, order_item | checkout/order flows, order history |
| `customer_with_rating` | everything above (with completed order) + rating: rating | rating create, rating read |
| `admin_product_management` | product + Keycloak user (ADMIN) | backoffice product CRUD |
| `active_promotion` | product + promotion: promotion | promotion verify, promotion list |
| `inventory_setup` | product + inventory: warehouse, stock | inventory flows |
| `tax_setup` | location + tax: tax_class, tax_rate | tax flows |
| `payment_provider_setup` | payment: payment_provider | payment init |

Adapt these groups to what actually exists in the target codebase. Add or remove groups based on what services and entities you found in Phases A–C.5. Name groups with snake_case.

### Step 2 — Batch execution

Every time Phase C.6 runs:

1. Derive the full group list (as above).
2. Read `$output-path/scenarios.md`. Collect `## Data State: <name>` headings already present — these are **done**.
3. Compute **remaining** = full list minus done.
4. Take the first `$scenarios-per-flow` groups from remaining (default 10) as the **current batch**.
5. For each group in the current batch, generate `$scenarios-per-flow` scenarios and **append** to `scenarios.md`.
6. After writing: if remaining groups still exist beyond this batch → output progress report and stop. If all groups covered → proceed to Phase D.

### Scenario content rules

**Each scenario describes one complete database snapshot:**
- Give each persona a realistic first and last name matching the target system's locale
- Assign a concrete address: street, district, city, postal code
- Invent specific product names with SKUs, sizes, colors, prices — never "product_test_1"
- Use plausible monetary values
- Where a coupon applies, invent a realistic coupon code and discount amount
- Use sequential integer IDs starting from 1, tracked across all scenarios globally (IDs must not collide between scenarios)

**Seed requirements table:**
After each scenario narrative, write a Markdown table: `DB | Entity | Key values`
List every entity that must exist across all relevant service DBs. For Keycloak-managed user IDs stored as FKs in business DBs: use `<USERNAME>_UUID` placeholder if the IdP assigns IDs at runtime, or hardcode a fixed UUID if the IdP supports fixed IDs at creation time (e.g. Keycloak ≥19).

**Diversity requirements:**
- Vary personas, cities, product types, payment methods, coupon usage across scenarios in the same group
- Do not repeat the same persona within one group

**Format:**

```markdown
# Scenario Catalog

## Data State: <group_name>

*Enables flows: <comma-separated list of flow names from flow-matrix.md that this data state covers>*

### Scenario 1 — <one-line title>

<2–5 sentence narrative. Persona name, goal, products, address, payment method, outcome.>

**Seed requirements:**

| DB | Entity | Key values |
|----|--------|------------|
| product | brand | id=1, name='...', slug='...' |
| product | product | id=1, name='...', sku='...', price=... |
| cart | cart_item | customer_id='<PERSONA>_UUID', product_id=1, quantity=2 |
| ... | ... | ... |

---

### Scenario 2 — <one-line title>

...
```

---

## Phase D — Generate Output Artifacts

Read `$output-path/scenarios.md` as the primary source of entity IDs and field
values. Read `$output-path/flow-matrix.md` for the complete flow list.
All concrete values in seed SQL, Postman requests, and setup-auth.sh must match
the names, prices, IDs, coupon codes, and addresses invented in scenarios.md.

### D1 — Identity Provider User Setup

**Skip entirely** if `idp.type == none` or no identity FK columns were found in Phase A.2.

Write `$output-path/setup-auth.sh`.

The script must:
1. Create each persona user in the IdP (idempotent — update if already exists)
2. Resolve each user's runtime-assigned ID
3. **Auto-patch `<USERNAME>_UUID` placeholders** in `seed-all.sql` and per-service seed files immediately after each user is created
4. Print the single DB seed command to run next

**UUID placeholder strategy:**
Before writing the script, attempt to determine whether fixed IDs can be provided at creation time:
- Keycloak ≥ 19: accepts `"id"` field in the POST body → use fixed UUIDs, hardcode them in seed SQL, no placeholder patching needed
- Keycloak < 19, Auth0, Cognito, Firebase, custom: IDs are assigned by the server → use `<USERNAME>_UUID` placeholder + sed patch pattern

When fixed IDs are used, document the chosen UUIDs as a comment block at the top of `seed-all.sql`.

---

#### D1 strategy by IdP type

**`keycloak`** — Keycloak Admin REST API

Derive base URL from nginx `server_name` config (Phase A). If nginx routes by `server_name` (e.g. `server_name identity`), default URL is `http://identity`, not `http://localhost:80`. Include `/etc/hosts` note in script comments.

```bash
#!/usr/bin/env bash
# setup-auth.sh — Creates test users in Keycloak and patches UUID placeholders in seed files
# Usage: ./setup-auth.sh <keycloak-base-url> <realm>
# Example: ./setup-auth.sh http://identity <realm-name>
# Note: add '127.0.0.1 identity' to /etc/hosts if using nginx server_name routing

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEYCLOAK_URL="${1:-<idp.base_url>}"
REALM="${2:-<idp.realm>}"
ADMIN_USER="<idp.admin_credentials.user>"
ADMIN_PASS="<idp.admin_credentials.pass>"
TEST_PASSWORD="Test@1234"

SEED_FILES=(
  "${SCRIPT_DIR}/seed-all.sql"
  # <one entry per service with identity FK columns — from Phase A.2>
)

ADMIN_TOKEN=$(curl -s -X POST \
  "${KEYCLOAK_URL}/realms/master/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password&client_id=admin-cli&username=${ADMIN_USER}&password=${ADMIN_PASS}" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")

create_user() {
  local USERNAME="$1" PASSWORD="$2" ROLE="$3" PLACEHOLDER="$4"

  EXISTING=$(curl -s "${KEYCLOAK_URL}/admin/realms/${REALM}/users?username=${USERNAME}" \
    -H "Authorization: Bearer ${ADMIN_TOKEN}")

  if echo "$EXISTING" | python3 -c "import sys,json; exit(0 if len(json.load(sys.stdin))==0 else 1)" 2>/dev/null; then
    curl -s -X POST "${KEYCLOAK_URL}/admin/realms/${REALM}/users" \
      -H "Authorization: Bearer ${ADMIN_TOKEN}" -H "Content-Type: application/json" \
      -d "{\"username\":\"${USERNAME}\",\"email\":\"${USERNAME}@test.com\",\"enabled\":true,\"emailVerified\":true}" > /dev/null
    USER_ID=$(curl -s "${KEYCLOAK_URL}/admin/realms/${REALM}/users?username=${USERNAME}" \
      -H "Authorization: Bearer ${ADMIN_TOKEN}" \
      | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['id'])")
  else
    USER_ID=$(echo "$EXISTING" | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['id'])")
  fi

  curl -s -X PUT "${KEYCLOAK_URL}/admin/realms/${REALM}/users/${USER_ID}/reset-password" \
    -H "Authorization: Bearer ${ADMIN_TOKEN}" -H "Content-Type: application/json" \
    -d "{\"type\":\"password\",\"value\":\"${PASSWORD}\",\"temporary\":false}" > /dev/null

  ROLE_REP=$(curl -s "${KEYCLOAK_URL}/admin/realms/${REALM}/roles/${ROLE}" \
    -H "Authorization: Bearer ${ADMIN_TOKEN}")
  curl -s -X POST "${KEYCLOAK_URL}/admin/realms/${REALM}/users/${USER_ID}/role-mappings/realm" \
    -H "Authorization: Bearer ${ADMIN_TOKEN}" -H "Content-Type: application/json" \
    -d "[${ROLE_REP}]" > /dev/null

  echo "    ${USERNAME} id=${USER_ID}"

  if [[ -n "${PLACEHOLDER}" ]]; then
    for f in "${SEED_FILES[@]}"; do
      grep -q "${PLACEHOLDER}" "$f" 2>/dev/null && sed -i "s/${PLACEHOLDER}/${USER_ID}/g" "$f"
    done
  fi
}

# <one create_user call per persona from scenarios.md — personas get PLACEHOLDER; admin/guest get "">
# create_user "test_alice"  "${TEST_PASSWORD}" "CUSTOMER" "ALICE_UUID"
# create_user "test_admin"  "${TEST_PASSWORD}" "ADMIN"    ""

echo "==> Done. Apply seeds:"
echo "    PGPASSWORD=<db-pass> psql -h localhost -p <db-port> -U <db-user> -d postgres -f seed-all.sql"
```

---

**`auth0`** — Auth0 Management API

```bash
#!/usr/bin/env bash
# setup-auth.sh — Creates test users in Auth0 and patches UUID placeholders
# Usage: ./setup-auth.sh
# Requires: AUTH0_DOMAIN, AUTH0_CLIENT_ID, AUTH0_CLIENT_SECRET in env

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOMAIN="${AUTH0_DOMAIN:-<idp.domain>}"
SEED_FILES=("${SCRIPT_DIR}/seed-all.sql")  # add per-service files from Phase A.2

MGMT_TOKEN=$(curl -s -X POST "https://${DOMAIN}/oauth/token" \
  -H "Content-Type: application/json" \
  -d "{\"client_id\":\"${AUTH0_CLIENT_ID}\",\"client_secret\":\"${AUTH0_CLIENT_SECRET}\",
       \"audience\":\"https://${DOMAIN}/api/v2/\",\"grant_type\":\"client_credentials\"}" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])")

create_user() {
  local EMAIL="$1" PASSWORD="$2" ROLE="$3" PLACEHOLDER="$4"

  RESPONSE=$(curl -s -X POST "https://${DOMAIN}/api/v2/users" \
    -H "Authorization: Bearer ${MGMT_TOKEN}" -H "Content-Type: application/json" \
    -d "{\"email\":\"${EMAIL}\",\"password\":\"${PASSWORD}\",
         \"connection\":\"Username-Password-Authentication\",\"app_metadata\":{\"role\":\"${ROLE}\"}}")

  USER_ID=$(echo "$RESPONSE" | python3 -c \
    "import sys,json; print(json.load(sys.stdin)['user_id'])")

  if [[ -n "${PLACEHOLDER}" ]]; then
    for f in "${SEED_FILES[@]}"; do
      grep -q "${PLACEHOLDER}" "$f" 2>/dev/null && sed -i "s|${PLACEHOLDER}|${USER_ID}|g" "$f"
    done
  fi
  echo "    ${EMAIL} id=${USER_ID}"
}

# create_user "alice@test.com" "Test@1234" "customer" "ALICE_UUID"
```

Note: Auth0 `user_id` format is `auth0|<hex>` — use `|` as sed delimiter to avoid `/` conflicts.

---

**`cognito`** — AWS CLI

```bash
#!/usr/bin/env bash
# setup-auth.sh — Creates test users in Cognito and patches UUID placeholders
# Usage: ./setup-auth.sh
# Requires: AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, COGNITO_USER_POOL_ID in env

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POOL_ID="${COGNITO_USER_POOL_ID:-<idp.pool_id>}"
SEED_FILES=("${SCRIPT_DIR}/seed-all.sql")

create_user() {
  local USERNAME="$1" PASSWORD="$2" ROLE="$3" PLACEHOLDER="$4"

  aws cognito-idp admin-create-user \
    --user-pool-id "${POOL_ID}" \
    --username "${USERNAME}" \
    --temporary-password "${PASSWORD}" \
    --user-attributes Name=email,Value="${USERNAME}@test.com" Name=custom:role,Value="${ROLE}" \
    --message-action SUPPRESS > /dev/null

  aws cognito-idp admin-set-user-password \
    --user-pool-id "${POOL_ID}" \
    --username "${USERNAME}" \
    --password "${PASSWORD}" --permanent > /dev/null

  USER_ID=$(aws cognito-idp admin-get-user \
    --user-pool-id "${POOL_ID}" \
    --username "${USERNAME}" \
    --query 'Username' --output text)

  if [[ -n "${PLACEHOLDER}" ]]; then
    for f in "${SEED_FILES[@]}"; do
      grep -q "${PLACEHOLDER}" "$f" 2>/dev/null && sed -i "s/${PLACEHOLDER}/${USER_ID}/g" "$f"
    done
  fi
  echo "    ${USERNAME} id=${USER_ID}"
}

# create_user "alice" "Test@1234" "CUSTOMER" "ALICE_UUID"
```

---

**`custom`** — App's own registration endpoint

When no managed IdP is present, Phase B/C will have found a user registration endpoint (e.g. `POST /api/users` or `POST /auth/register`) with no auth guard.

```bash
#!/usr/bin/env bash
# setup-auth.sh — Creates test users via app registration endpoint
# Usage: ./setup-auth.sh <base-url>

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_URL="${1:-http://localhost:8080}"
SEED_FILES=("${SCRIPT_DIR}/seed-all.sql")

create_user() {
  local USERNAME="$1" PASSWORD="$2" ROLE="$3" PLACEHOLDER="$4"

  # <adjust request body to match the registration endpoint schema found in Phase B>
  RESPONSE=$(curl -s -X POST "${BASE_URL}/<registration-path>" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"${USERNAME}\",\"password\":\"${PASSWORD}\",\"role\":\"${ROLE}\"}")

  USER_ID=$(echo "$RESPONSE" | python3 -c \
    "import sys,json; d=json.load(sys.stdin); print(d.get('id') or d.get('userId') or d.get('sub'))")

  if [[ -n "${PLACEHOLDER}" ]]; then
    for f in "${SEED_FILES[@]}"; do
      grep -q "${PLACEHOLDER}" "$f" 2>/dev/null && sed -i "s/${PLACEHOLDER}/${USER_ID}/g" "$f"
    done
  fi
  echo "    ${USERNAME} id=${USER_ID}"
}

# create_user "alice" "Test@1234" "CUSTOMER" "ALICE_UUID"
```

The registration endpoint path and request body schema must be derived from the source files found in Phase B. Check the controller file for required fields and adapt the JSON body accordingly.

---

Make executable: `chmod +x $output-path/setup-auth.sh`

The `SEED_FILES` array must include exactly the files that contain identity FK placeholders, as identified in Phase A.2. Always include `seed-all.sql`; add per-service files only if they also contain placeholders.

### D2 — Business Data Seed SQL

**Single consolidated file:** Write `$output-path/seed-all.sql` using `\c <dbname>` psql meta-commands to switch databases within a single psql session. This lets the user apply all seeds with one command:

```bash
PGPASSWORD=<pass> psql -h <host> -p <port> -U <user> -d postgres -f seed-all.sql
```

Also write individual `$output-path/<db-name>/seed.sql` files (same content, split by DB) for cases where per-service application is needed.

**Schema discovery:**
- JPA/Java: read `@Entity` classes, extract `@Column` field names and types, `@Enumerated` values, `@Table(name=...)` for table name
- Prisma: read `schema.prisma`, extract `model` blocks
- TypeORM: read `@Entity()` classes with `@Column()` decorators
- Fallback: look for Flyway/Liquibase migration files (`V*.sql`, `changelog*.sql`) and extract `CREATE TABLE` statements

**PERSONA_UUID placeholders:**
For Keycloak-managed user IDs referenced in business DBs (e.g. `cart.customer_id`, `user_address.user_id`), write the placeholder `<USERNAME>_UUID` (e.g. `MARIA_UUID`). The `setup-auth.sh` script patches these automatically via `sed -i` after creating each user — no manual replacement needed.

**FK ordering in seed-all.sql:**
Write sections in topological order: no-FK entities first (product, location), then entities with cross-service FKs (inventory, customer, cart, rating, order). Within each `\c` block, insert parent tables before child tables.

**Do NOT seed entities for `not_found` scenarios** — the absence of data IS the test condition.

Format:

```sql
-- seed-all.sql — All seed data in a single file
-- Run AFTER setup-auth.sh (it patches PERSONA_UUID placeholders)
-- Usage: PGPASSWORD=<pass> psql -h <host> -p <port> -U <user> -d postgres -f seed-all.sql

-- ============================================================
-- <DB_NAME> DB
-- ============================================================
\c <db_name>

BEGIN;

INSERT INTO <table_name> (<col1>, <col2>) VALUES
  ('<val1>', '<val2>'),
  ('<val1b>', '<val2b>');

COMMIT;

-- ============================================================
-- <NEXT_DB_NAME> DB
-- ============================================================
\c <next_db_name>

BEGIN;
-- ...
COMMIT;
```

**Note:** databases whose name is a reserved SQL word (e.g. `order`) must be quoted: `\c "order"`

### D3 — Postman Collection

Write `$output-path/postman_seed.json` as a valid Postman Collection v2.1:

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

Write `$output-path/docker-compose.test.yml`:

For systems with a **shared postgres** (one postgres service, multiple databases): override the single postgres service with a test instance and mount an init script that creates all databases and seeds them.

Write `$output-path/postgres-init/` with one `.sql` file per database, plus a `00-create-databases.sql`:

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
      - $output-path/postgres-init:/docker-entrypoint-initdb.d
    ports:
      - "<original-port+100>:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U test"]
      interval: 5s
      timeout: 5s
      retries: 10
```

Note: substitute `$output-path` with the actual absolute path when writing the YAML file — Docker Compose does not expand SKILL.md argument syntax.

For systems with **per-service postgres** instances: generate one service entry per DB, using port offset `<original-port + 100 + N>` where N is the 0-based index of the service in alphabetical order, to avoid port collisions between test containers.

For systems with **MySQL**: use `image: mysql:8.0`, `MYSQL_ROOT_PASSWORD: test`, `MYSQL_DATABASE: <db>`, and healthcheck `mysqladmin ping -h localhost`.

---

## Phase E — System Startup Instructions

After all Phase D artifacts are generated, derive and print startup instructions **from the context found in Phase A**. Do not hardcode paths or service names — reconstruct them from what was discovered.

### Step 1 — Reconstruct paths

From Phase A:
- `COMPOSE_FILE` = absolute path to the compose file found (e.g. `/path/to/project/docker-compose.yml`)
- `COMPOSE_DIR` = directory containing `COMPOSE_FILE`
- `OUTPUT_DIR` = `$output-path` (absolute)
- `OVERRIDE_REL` = relative path from `COMPOSE_DIR` to `$output-path/docker-compose.test.yml`

Compute `OVERRIDE_REL` with:
```bash
python3 -c "import os; print(os.path.relpath('$output-path/docker-compose.test.yml', '$COMPOSE_DIR'))"
```

### Step 2 — Volume path caveat

Docker Compose resolves all `./`-relative paths in **every** `-f` file relative to the **first** `-f` file's directory (`COMPOSE_DIR`), not relative to the override file's own location.

For every `volumes:` bind-mount in `docker-compose.test.yml` that uses `./`, the source path must be written relative to `COMPOSE_DIR`. Verify the generated `docker-compose.test.yml` uses the correct relative paths. If the files live under `OVERRIDE_REL`'s directory, prefix each volume source with the subdirectory portion of `OVERRIDE_REL`.

Example: if `COMPOSE_DIR=/project/yas` and `output-path=/project/yas/synthetic-data/output`, then volume sources must be `./synthetic-data/output/seed-all.sql`, not `./seed-all.sql`.

### Step 3 — Healthcheck for identity provider

The IdP container (found in Phase A, service name stored in `idp_service`) may not have `curl` or `wget` available depending on its base image. Use a bash TCP check that works on minimal images:

```yaml
healthcheck:
  test: ["CMD", "bash", "-c", "exec 3<>/dev/tcp/localhost/<idp_port>"]
  interval: 5s
  timeout: 5s
  retries: 30
  start_period: 30s
```

Where `<idp_port>` is the port the IdP listens on inside the container (extracted from Phase A env vars, e.g. `KC_HTTP_PORT`).

### Step 4 — Print startup instructions

Output the following block verbatim, with all placeholders substituted:

```
=== Startup Instructions ===

1. Start the system with seed data:

   cd <COMPOSE_DIR>
   docker compose \
     -f <COMPOSE_FILE_BASENAME> \
     -f <OVERRIDE_REL> \
     up -d

   Two seed jobs run automatically after dependencies are healthy:
     • db-seed  → connects to <db_service_name> and applies seed-all.sql
     • kc-seed  → calls <idp_service_name> REST API and creates test users

2. Check seed job status:

   docker ps -a | grep seed
   docker logs <project>-db-seed-1
   docker logs <project>-kc-seed-1

   Both should show "Exited (0)". Exit code 1 means a failure — check logs.

3. Verify data:

   # Count rows in one of the seeded tables
   docker exec <project>-<db_service_name>-1 \
     psql -U <db_user> -d <first_db_name> -c "SELECT COUNT(*) FROM <first_seeded_table>;"

4. Seed containers are ephemeral — they run once and exit.
   Data lives in the <db_service_name> Docker volume and persists across restarts.
   It is only lost if you run: docker compose down -v

5. To reset and reseed from scratch:

   docker compose -f <COMPOSE_FILE_BASENAME> \
     -f <OVERRIDE_REL> down -v
   docker compose -f <COMPOSE_FILE_BASENAME> \
     -f <OVERRIDE_REL> up -d

=== End of Startup Instructions ===
```

Substitute:
- `<COMPOSE_DIR>` — absolute path to compose file's directory
- `<COMPOSE_FILE_BASENAME>` — filename only (e.g. `docker-compose.yml`)
- `<OVERRIDE_REL>` — relative path from `COMPOSE_DIR` to the generated override file
- `<db_service_name>` — postgres/mysql service name from Phase A
- `<db_user>` — database user from Phase A env vars
- `<first_db_name>` — first application database name found in Phase A
- `<first_seeded_table>` — first table written in `seed-all.sql`
- `<idp_service_name>` — IdP service name from Phase A
- `<project>` — Docker Compose project name (defaults to directory name of `COMPOSE_DIR`; check for `name:` field at top of compose file)
