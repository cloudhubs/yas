# Scripts — Quick Reference

> For full documentation see [`../README.md`](../README.md).

## Scripts

| Script | Purpose |
|---|---|
| `run-all.sh` | Run EvoMaster for all services and all roles |
| `evomaster-blackbox.sh` | Run EvoMaster for a single service and role |
| `evomaster-analysis.py` | Single entrypoint: index methods, compile by class, run by method, and generate one CSV |
| `auth-config.sh` | Keycloak credentials and token helpers (sourced, not run directly) |
| `update-generated-test-tokens.sh` | Refresh expired bearer tokens inside already generated Java tests |

## Common commands

```bash
# Full experiment — all 13 services × 3 roles (admin, customer, none)
./run-all.sh

# Single role only
./run-all.sh admin
./run-all.sh customer
./run-all.sh none

# Single service
./evomaster-blackbox.sh product admin
./evomaster-blackbox.sh cart customer
./evomaster-blackbox.sh tax none

# Refresh hardcoded bearer tokens in existing generated tests
./update-generated-test-tokens.sh

# Preview only one role without editing files
./update-generated-test-tokens.sh --role customer --dry-run

# Read the file "documentation_python_script" for documentation on each column of the CSV
# (Less recommended) Execute ALL Tests Validation - Unified analysis pipeline - More time needed ~ 2 hours
python3 ./evomaster-analysis.py

# Linux VM / WSL: filter by target endpoints listed in a text file
python3 ./evomaster-analysis.py --targets-file ./yas_targets.txt

# Windows PowerShell / CMD
py -3 .\evomaster-analysis.py
py -3 .\evomaster-analysis.py --targets-file .\yas_targets.txt

# If the tests were generated with EvoMaster 5.1.0, keep the analysis dependencies aligned
python3 ./evomaster-analysis.py --evomaster-dependency-version 5.1.0 --targets-file ./yas_targets.txt

# targets.txt format:
# Target Endpoint
# GET:/rating/backoffice/ratings/latest/{count}
# GET:/customer/storefront/customer/profile

# Extended budget (1 hour per service)
EVOMASTER_MAX_TIME=3600 EVOMASTER_SEED=42 ./run-all.sh

# Pin EvoMaster Docker image / recorded version (defaults: webfuzzing/evomaster:4.0.0, 4.0.0)
EVOMASTER_IMAGE=webfuzzing/evomaster:4.0.0 EVOMASTER_VERSION=4.0.0 ./evomaster-blackbox.sh product admin
```

## Output location

```
../generated-tests/blackbox/<service>/<role>/
```

## Outputs

The unified script generates:

- one CSV final report with one row per test method
- class compilation logs under `../runtime-logs/classes/`
- method execution logs under `../runtime-logs/methods/`
- temporary Maven projects under `../tmp-test-runner/`
