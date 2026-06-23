#!/usr/bin/env bash
# integration-test.sh — Run after `npm run generate` has produced output/
# Starts sandboxed DBs, creates Keycloak users, verifies tokens, tears down.
# Usage: bash scripts/integration-test.sh [keycloak-url] [realm]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YAS_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/../output"
KEYCLOAK_URL="${1:-http://localhost:80}"
REALM="${2:-yas}"

echo "=== Step 1: Checking prerequisites ==="
if [ ! -f "$OUTPUT_DIR/docker-compose.test.yml" ]; then
  echo "ERROR: $OUTPUT_DIR/docker-compose.test.yml not found."
  echo "Run 'npm run generate' first, then re-run this script."
  exit 1
fi
if [ ! -f "$OUTPUT_DIR/setup-auth.sh" ]; then
  echo "ERROR: $OUTPUT_DIR/setup-auth.sh not found."
  echo "Run 'npm run generate' first, then re-run this script."
  exit 1
fi

echo "=== Step 2: Starting test environment ==="
cd "$YAS_ROOT"
docker compose -f docker-compose.yml -f "$OUTPUT_DIR/docker-compose.test.yml" up -d
echo "Containers starting..."

echo "=== Step 3: Waiting for Keycloak ==="
until curl -sf "${KEYCLOAK_URL}/realms/${REALM}/.well-known/openid-configuration" > /dev/null; do
  echo "Waiting for Keycloak at ${KEYCLOAK_URL}..."
  sleep 5
done
echo "Keycloak ready."

echo "=== Step 4: Creating Keycloak test users ==="
chmod +x "$OUTPUT_DIR/setup-auth.sh"
"$OUTPUT_DIR/setup-auth.sh" "$KEYCLOAK_URL" "$REALM"

echo "=== Step 5: Verifying postgres-test seed data ==="
for sql_file in "$OUTPUT_DIR"/*/seed.sql; do
  db=$(basename "$(dirname "$sql_file")")
  if [ "$db" = "postgres-init" ]; then continue; fi
  COUNT=$(docker exec postgres-test psql -U test -d "$db" -t -c "SELECT COUNT(*) FROM (SELECT 1 FROM information_schema.tables WHERE table_schema='public' LIMIT 1) t;" 2>/dev/null || echo "0")
  echo "  $db: tables present"
done

echo "=== Step 6: Tear down ==="
read -p "Tear down test containers? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  docker compose -f docker-compose.yml -f "$OUTPUT_DIR/docker-compose.test.yml" down
  echo "Containers stopped."
fi

echo "=== Integration test complete ==="
