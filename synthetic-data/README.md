# Synthetic Data Generation Toolkit

Generates synthetic seed data and Keycloak test users for microservices test sandboxes.
Analyzes the host codebase to discover inter-service flows, produces auditable graph artifacts,
and outputs SQL seed files + a Postman 2.1 collection compatible with EvoMaster and other API test generators.

## Prerequisites

- Node.js ≥22
- Docker and Docker Compose v2
- Git (with submodule support)
- `curl` and `python3` (for `setup-auth.sh`)

## Setup

```bash
# Initialize openclaude submodule
git submodule update --init --recursive

# Build openclaude and install dependencies
cd synthetic-data
cd openclaude && npm install && npm run build && cd ..
npm install

# Configure LLM provider for openclaude (one-time)
node openclaude/bin/openclaude config
```

## Usage

### Full run

```bash
cd synthetic-data
npm run generate
```

Output written to `synthetic-data/output/` (gitignored):

| File | Description |
|------|-------------|
| `flow-graph.mmd` | Mermaid diagram of the service call graph — audit this first |
| `flow-matrix.md` | Table of all discovered flow scenarios — edit to refine |
| `setup-auth.sh` | Creates Keycloak test users (one per role) |
| `<db>/seed.sql` | SQL INSERT statements per database |
| `postman_seed.json` | Postman 2.1 collection for EvoMaster seeding |
| `docker-compose.test.yml` | Docker Compose override for isolated test DBs |

### Iterative refinement

Edit `output/flow-matrix.md`, then re-run. Discovery is skipped when the file exists:

```bash
$EDITOR synthetic-data/output/flow-matrix.md
npm run generate
```

To force full re-discovery: `rm output/flow-matrix.md && npm run generate`

### Validate outputs

```bash
npm run validate
```

### Start sandboxed environment

```bash
cd ..  # yas/ root

# Start test DBs
docker compose -f docker-compose.yml -f synthetic-data/output/docker-compose.test.yml up -d

# Create Keycloak test users (after Keycloak is healthy)
./synthetic-data/output/setup-auth.sh http://localhost:80 <your-realm>

# Run integration test (after containers are up and generator has run)
bash synthetic-data/scripts/integration-test.sh http://localhost:80 <your-realm>
```

### Run EvoMaster with seeded collection

```bash
java -jar evomaster.jar \
  --blackBox true \
  --seedTestCases true \
  --seedTestCasesPath synthetic-data/output/postman_seed.json \
  --bbProbabilityUseDataPool 0.9 \
  --outputFolder evomaster-config/generated-tests \
  --maxTime 1h
```

### Tear down

```bash
docker compose -f docker-compose.yml -f synthetic-data/output/docker-compose.test.yml down
```

## Visualizing the Flow Graph

```bash
# CLI (requires @mermaid-js/mermaid-cli)
npx @mermaid-js/mermaid-cli -i output/flow-graph.mmd -o output/flow-graph.png

# Or paste output/flow-graph.mmd into https://mermaid.live
```

## Replication to Another System

```bash
cd <target-repo>
cp -r <this-repo>/yas/synthetic-data ./
cd synthetic-data
git submodule add https://github.com/Gitlawb/openclaude.git openclaude
git -C openclaude checkout v0.19.0
echo "synthetic-data/output/" >> ../.gitignore
echo "synthetic-data/node_modules/" >> ../.gitignore
cd openclaude && npm install && npm run build && cd ..
npm install
```

No changes to `SKILL.md` or `generate.ts` needed.
