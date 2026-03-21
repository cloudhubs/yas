# EvoSuite Test Generation for YAS Microservices

This directory contains the infrastructure for running EvoSuite automated test generation against the YAS (Yet Another Shop) e-commerce microservice platform.

## Overview

EvoSuite is a search-based test generation tool for Java. This setup enables:
- Cross-compilation from Java 21 (YAS) to Java 11 (EvoSuite target)
- Automated test generation for REST API endpoints
- Benchmark data collection for research comparison with train-ticket

### Key Challenge

| Aspect | YAS | EvoSuite Target |
|--------|-----|-----------------|
| Java Version | 21 | 11 |
| Spring Boot | 4.0.2 | 2.7.18 (cross-compiled) |
| Package Prefix | `jakarta.*` | `javax.*` (converted) |

## Quick Start

### 1. Build the Docker Image

```bash
cd yas/evosuite-docker
docker build -t evosuite-yas:1.2.0 .
```

### 2. Test a Single Service

```bash
./run-evosuite.sh product
```

### 3. Test a Specific Controller

```bash
./run-evosuite.sh product com.yas.product.controller.ProductController
```

### 4. Run Full Benchmark (13 Endpoints)

```bash
./benchmark/scripts/run-benchmark.sh --runs 3 --budget 60
```

## Directory Structure

```
evosuite-docker/
├── Dockerfile                    # EvoSuite 1.2.0 builder
├── docker-compose.yml            # Orchestration
├── run-evosuite.sh               # Single service generator
├── run-all-services.sh           # Batch generator
├── run-endpoint-tests.sh         # Endpoint-specific runner
├── benchmark/
│   ├── config/
│   │   ├── benchmark-config.yml  # Benchmark configuration
│   │   └── endpoints.csv         # 13 YAS benchmark endpoints
│   ├── lib/                      # Python analysis tools
│   │   ├── metrics_collector.py
│   │   ├── csv_generator.py
│   │   ├── test_analyzer.py
│   │   └── aggregator.py
│   ├── scripts/                  # Benchmark scripts
│   │   ├── run-benchmark.sh
│   │   ├── run-single-endpoint.sh
│   │   ├── collect-metrics.sh
│   │   └── generate-report.sh
│   ├── results/                  # Benchmark output
│   └── templates/
│       └── manual-evaluation.md  # Evaluation template
└── README.md
```

## Services Inventory

| Service | Controllers | EvoSuite Priority | Notes |
|---------|------------|-------------------|-------|
| product | 10 | HIGH | Main e-commerce functionality |
| order | 2 | HIGH | Order management |
| cart | 1 | HIGH | Shopping cart |
| customer | 2 | HIGH | Customer management |
| inventory | 3 | MEDIUM | Stock management |
| payment | 2 | MEDIUM | Payment processing |
| promotion | 1 | MEDIUM | Promotions/discounts |
| rating | 1 | MEDIUM | Product ratings |
| location | 6 | HIGH | Address/location (no external deps) |
| tax | 2 | LOW | Tax calculations |
| media | 1 | LOW | Media management |
| search | 1 | **SKIP** | Kafka dependencies |
| recommendation | 1 | **SKIP** | Kafka dependencies |
| webhook | 1 | LOW | Webhook handling |
| sampledata | 1 | LOW | Sample data generation |

## Benchmark Endpoints (13)

| ID | Service | Method | Endpoint | Auth |
|----|---------|--------|----------|------|
| 1 | product | GET | /backoffice/products | ADMIN |
| 2 | product | POST | /backoffice/products | ADMIN |
| 3 | product | DELETE | /backoffice/products/{id} | ADMIN |
| 4 | order | GET | /backoffice/orders | ADMIN |
| 5 | order | POST | /storefront/orders | USER |
| 6 | cart | GET | /storefront/cart/items | USER |
| 7 | cart | PUT | /storefront/cart/items/{productId} | USER |
| 8 | customer | GET | /backoffice/customers | ADMIN |
| 9 | customer | POST | /backoffice/customers | ADMIN |
| 10 | inventory | GET | /backoffice/stocks | ADMIN |
| 11 | payment | POST | /init | USER |
| 12 | promotion | GET | /backoffice/promotions | ADMIN |
| 13 | rating | POST | /storefront/ratings | USER |

## Expected Results

Due to EvoSuite's RMI serialization boundary limitation, **Spring controllers are expected to fail test generation**. This is documented behavior for research purposes.

**Expected Error:**
```
NoClassDefFoundError: org/springframework/http/HttpEntity
```

### What Works

| Component | Expected Result |
|-----------|----------------|
| Utility Classes | SUCCESS |
| Entity/DTO Classes | SUCCESS |
| Simple Service Classes | PARTIAL |
| Spring Controllers | FAIL (RMI boundary) |
| Mapper Interfaces | FAIL (MapStruct) |

## Cross-Compilation Details

The `run-evosuite.sh` script handles:

1. **Package Conversion** (jakarta.* → javax.*):
   - `jakarta.persistence` → `javax.persistence`
   - `jakarta.validation` → `javax.validation`
   - `jakarta.servlet` → `javax.servlet`
   - `jakarta.annotation` → `javax.annotation`
   - `jakarta.transaction` → `javax.transaction`

2. **File Removal** (incompatible with Spring Boot 2.7.x):
   - `*/config/SecurityConfig.java`
   - `*/config/SecurityProperties.java`
   - `*/*Application.java`
   - `*/kafka/**/*.java`
   - `*/service/client/*.java` (OpenFeign)
   - `*/config/*Elastic*.java`
   - `*/config/*Telemetry*.java`

3. **Spring Boot Version**: Uses 2.7.18 (latest Java 11 compatible)

## Running the Benchmark

### Full Benchmark

```bash
cd evosuite-docker/benchmark/scripts
./run-benchmark.sh --runs 3 --budget 60
```

### Single Endpoint Test

```bash
./run-single-endpoint.sh 1 1 ./results/test_run --budget 60
```

### Generate CSV Report

```bash
./generate-report.sh results/run_YYYYMMDD_HHMMSS
```

## Output Format

The benchmark generates a CSV with 46 columns matching the train-ticket format:

### Identification (6 columns)
- endpoint_id, service, http_method, endpoint_path, controller_class, run_number

### Generation Results (4 columns)
- generation_status, generation_time_sec, generation_cpu_pct, generation_memory_mb

### Test Metrics (3 columns)
- tests_generated, test_methods_count, assertions_count

### Coverage Metrics (4 columns)
- line_coverage, branch_coverage, total_goals, covered_goals

### Error Information (3 columns)
- exit_code, error_type, error_message

### Semantic Validity - Manual (6 columns)
- targets_correct_endpoint, asserts_http_status, correct_comparator, inline_with_scenarios, missing_url_params, missing_request_body

### Semantic Quality - Manual (5 columns)
- assertions_meaningful, boundary_conditions, verifies_authorization, invalid_url_params, invalid_request_body

### Runtime Validity - Automated (5 columns)
- runs_without_error, threw_errors, runtime_anomalies, timed_out, hung_up

### Runtime Quality (3 columns)
- test_flakiness_rate, test_exec_memory_mb, test_exec_cpu_sec

### Performance Quality (2 columns)
- mean_test_exec_time_ms, exec_time_std_dev_ms

### Metadata (2 columns)
- manual_evaluation_complete, evaluator_notes

## Troubleshooting

### Docker Build Issues

If EvoSuite build fails, ensure you have sufficient memory:
```bash
docker build --memory=4g -t evosuite-yas:1.2.0 .
```

### Compilation Failures

Check the `.evosuite-work` directory in the service folder for compilation logs:
```bash
cat product/.evosuite-work/target/surefire-reports/*.txt
```

### Maven Cache Issues

Clear the cached Maven dependencies:
```bash
docker volume rm evosuite-maven-java11
```

## Research Notes

This infrastructure is designed to match the train-ticket benchmark setup for research paper comparison. Key considerations:

1. **Same CSV Format**: 46 columns identical to train-ticket output
2. **Same Error Classification**: RMI_SERIALIZATION, COMPILATION, TIMEOUT, OOM
3. **Same Benchmark Configuration**: 3 runs, 60s budget, DynaMOSA algorithm
4. **Consistent Manual Evaluation**: Same checklist template

## License

Part of the YAS research project for automated test generation comparison.
