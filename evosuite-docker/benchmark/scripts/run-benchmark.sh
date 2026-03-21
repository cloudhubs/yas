#!/bin/bash

# =============================================================================
# EvoSuite Benchmark Orchestrator
# =============================================================================
#
# Purpose: Run complete benchmark across all endpoints defined in endpoints.txt
#
# Usage:
#   ./run-benchmark.sh [OPTIONS]
#
# Options:
#   --runs N          Number of runs per endpoint (default: 3)
#   --budget SECS     Search budget in seconds (default: 60)
#   --output DIR      Output directory (default: results/run_TIMESTAMP)
#   --endpoint ID     Run single endpoint only (by line number in endpoints.txt)
#   --skip-existing   Skip endpoints that already have results
#   --verbose         Enable verbose output
#   --help            Show this help message
#
# Output:
#   results/run_YYYYMMDD_HHMMSS/
#   ├── endpoint_01/
#   │   ├── run_01/
#   │   │   ├── evosuite-output.log
#   │   │   ├── resource-metrics.json
#   │   │   └── exit-status.json
#   │   ├── run_02/
#   │   ├── run_03/
#   │   └── manual-evaluation.md
#   ├── endpoint_02/
#   ├── ...
#   ├── benchmark-results.csv
#   └── summary-report.md
#
# =============================================================================

set -o pipefail

# Script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BENCHMARK_DIR="$(dirname "$SCRIPT_DIR")"
EVOSUITE_DIR="$(dirname "$BENCHMARK_DIR")"
CONFIG_DIR="${BENCHMARK_DIR}/config"
TEMPLATES_DIR="${BENCHMARK_DIR}/templates"
LIB_DIR="${BENCHMARK_DIR}/lib"

# Configuration files - USE endpoints.txt as the source of truth
ENDPOINTS_TXT="${EVOSUITE_DIR}/endpoints.txt"
ENDPOINTS_CSV="${CONFIG_DIR}/endpoints.csv"
BENCHMARK_CONFIG="${CONFIG_DIR}/benchmark-config.yml"

# Default values
RUNS_PER_ENDPOINT=3
SEARCH_BUDGET=60
OUTPUT_DIR=""
SINGLE_ENDPOINT=""
SKIP_EXISTING=false
VERBOSE=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# =============================================================================
# Functions
# =============================================================================

print_banner() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║                                                               ║"
    echo "║     EvoSuite Endpoint Test Generation Benchmark               ║"
    echo "║     Research Paper Data Collection Framework                  ║"
    echo "║                                                               ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --runs N          Number of runs per endpoint (default: 3)"
    echo "  --budget SECS     Search budget in seconds (default: 60)"
    echo "  --output DIR      Output directory (default: results/run_TIMESTAMP)"
    echo "  --endpoint ID     Run single endpoint only (by line number)"
    echo "  --skip-existing   Skip endpoints that already have results"
    echo "  --verbose         Enable verbose output"
    echo "  --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                           # Run all endpoints, 3 runs each"
    echo "  $0 --runs 5 --budget 120     # 5 runs, 120s budget"
    echo "  $0 --endpoint 1              # Run only endpoint 1"
    echo "  $0 --endpoint 1 --runs 1     # Quick test: endpoint 1, 1 run"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_header() {
    echo ""
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}  $1${NC}"
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Get total number of endpoints from endpoints.txt
get_endpoint_count() {
    grep -v '^#' "$ENDPOINTS_TXT" | grep -v '^$' | wc -l | tr -d ' '
}

# Get endpoint info from endpoints.txt (pipe-delimited: service|endpoint|method|controller)
get_endpoint_info_from_txt() {
    local endpoint_id=$1
    local field=$2

    # Get the line (skip comments and empty lines)
    local line=$(grep -v '^#' "$ENDPOINTS_TXT" | grep -v '^$' | sed -n "${endpoint_id}p")

    case "$field" in
        "service") echo "$line" | cut -d'|' -f1 ;;
        "endpoint") echo "$line" | cut -d'|' -f2 ;;
        "http_method") echo "$line" | cut -d'|' -f3 ;;
        "controller_class") echo "$line" | cut -d'|' -f4 ;;
    esac
}

# Sync endpoints.csv from endpoints.txt for compatibility with other scripts
sync_endpoints_csv() {
    log_info "Syncing endpoints.csv from endpoints.txt..."

    # Write CSV header
    echo "endpoint_id,service,endpoint,http_method,controller_class,method_name,path_params,has_request_body,expected_status_codes,authorization" > "$ENDPOINTS_CSV"

    # Read endpoints.txt and convert to CSV
    local id=0
    while IFS='|' read -r service endpoint method controller; do
        # Skip comments and empty lines
        [[ "$service" =~ ^#.*$ || -z "$service" ]] && continue

        ((id++))

        # Determine if has request body based on method
        local has_body="false"
        [[ "$method" == "POST" || "$method" == "PUT" || "$method" == "PATCH" ]] && has_body="true"

        # Extract path params from endpoint (e.g., {id}, {count})
        local path_params=$(echo "$endpoint" | grep -oE '\{[^}]+\}' | tr -d '{}' | tr '\n' ',' | sed 's/,$//')

        # Write CSV line
        echo "${id},${service},${endpoint},${method},${controller},,${path_params},${has_body},\"200\",\"USER\"" >> "$ENDPOINTS_CSV"
    done < "$ENDPOINTS_TXT"

    log_success "Synced $id endpoints to endpoints.csv"
}

create_manual_evaluation_template() {
    local endpoint_id=$1
    local output_file=$2

    local service=$(get_endpoint_info_from_txt "$endpoint_id" "service")
    local http_method=$(get_endpoint_info_from_txt "$endpoint_id" "http_method")
    local endpoint_path=$(get_endpoint_info_from_txt "$endpoint_id" "endpoint")
    local controller=$(get_endpoint_info_from_txt "$endpoint_id" "controller_class")

    cat > "$output_file" << EOF
# Manual Evaluation Checklist

## Endpoint Information
- **Endpoint ID**: $endpoint_id
- **Service**: $service
- **Method**: $http_method
- **Path**: /$endpoint_path
- **Controller**: $controller
- **Evaluation Date**: _________________
- **Evaluator**: _________________

## Pre-Evaluation Status
- **Generation Status**: _________________
- **Tests Generated**: _________________
- **Test Methods**: _________________

---

## Semantic Validity Checklist

### 1. Targets the correct endpoint?
- [ ] Yes
- [ ] No
- [ ] N/A (no tests generated)

**Evidence/Notes**:
_______________________________________

### 2. Asserts the expected HTTP status codes?
- [ ] Yes (all expected codes covered)
- [ ] Partial (some codes covered)
- [ ] No
- [ ] N/A

**Status codes found in tests**:
_______________________________________

### 3. Uses the correct comparator in assertions?
- [ ] Yes (assertEquals, assertNotNull used appropriately)
- [ ] No (incorrect comparators)
- [ ] N/A

**Issues found**:
_______________________________________

### 4. Inline with the endpoint scenarios?
- [ ] Yes (tests match expected behavior)
- [ ] Partial
- [ ] No
- [ ] N/A

**Scenario coverage notes**:
_______________________________________

### 5. Missing URL parameter values?
- [ ] No (all params handled)
- [ ] Yes (missing required params)
- [ ] N/A

**Missing parameters**:
_______________________________________

### 6. Missing request body?
- [ ] No (body included where needed)
- [ ] Yes (body missing for POST/PUT/PATCH)
- [ ] N/A

**Notes**:
_______________________________________

---

## Semantic Quality Checklist

### 7. Are assertions specific and meaningful?
- [ ] Yes (values are specific, not just null checks)
- [ ] Partial
- [ ] No
- [ ] N/A

**Examples of assertions**:
_______________________________________

### 8. Boundary conditions covered?
- [ ] Yes (null, empty, edge cases)
- [ ] Partial
- [ ] No
- [ ] N/A

**Boundary tests found**:
_______________________________________

### 9. Verifies authorization decisions?
- [ ] Yes (tests auth scenarios)
- [ ] No
- [ ] N/A

**Auth-related tests**:
_______________________________________

### 10. Invalid URL parameter values?
- [ ] No (params are valid)
- [ ] Yes (contains invalid/random params)
- [ ] N/A

**Invalid params found**:
_______________________________________

### 11. Invalid request body?
- [ ] No (body is valid)
- [ ] Yes (body is malformed/random)
- [ ] N/A

**Body issues**:
_______________________________________

---

## Summary Scores

| Category | Score | Max | Notes |
|----------|-------|-----|-------|
| Semantic Validity | __/6 | 6 | |
| Semantic Quality | __/5 | 5 | |
| **Total** | __/11 | 11 | |

## Overall Assessment
_______________________________________

## Recommendations
_______________________________________
EOF
}

generate_summary_report() {
    local output_dir=$1
    local total_endpoints=$2
    local runs_per_endpoint=$3
    local successful=$4
    local failed=$5
    local duration=$6

    cat > "${output_dir}/summary-report.md" << EOF
# EvoSuite Benchmark Summary Report

## Benchmark Information
- **Timestamp**: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
- **Total Endpoints**: $total_endpoints
- **Runs per Endpoint**: $runs_per_endpoint
- **Total Runs**: $((total_endpoints * runs_per_endpoint))
- **Search Budget**: ${SEARCH_BUDGET}s per run
- **Total Duration**: ${duration}s

## Results Summary
- **Successful Generations**: $successful
- **Failed Generations**: $failed
- **Success Rate**: $(echo "scale=2; $successful * 100 / ($successful + $failed)" | bc 2>/dev/null || echo "0")%

## Expected Behavior

Due to EvoSuite's RMI serialization boundary limitation, all controller endpoints
are expected to fail test generation. This is a documented architectural constraint
where Spring framework types (HttpEntity, ResponseEntity, HttpHeaders) cannot be
serialized across the RMI boundary between EvoSuite's master and client processes.

**Expected Error**: \`NoClassDefFoundError: org/springframework/http/HttpEntity\`

## Output Files

| File | Description |
|------|-------------|
| \`benchmark-results.csv\` | Main research data (all metrics) |
| \`endpoint_XX/run_YY/\` | Per-run detailed logs and metrics |
| \`endpoint_XX/manual-evaluation.md\` | Manual evaluation checklist |

## Next Steps

1. Review \`benchmark-results.csv\` for automated metrics
2. Complete manual evaluation checklists for any generated tests
3. Run \`generate-report.sh\` to finalize CSV with manual evaluations
4. Import CSV into statistical analysis software for research paper

## Notes

_Add any observations or notes about this benchmark run here._

EOF
}

# =============================================================================
# Main Script
# =============================================================================

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --runs)
            RUNS_PER_ENDPOINT="$2"
            shift 2
            ;;
        --budget)
            SEARCH_BUDGET="$2"
            shift 2
            ;;
        --output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --endpoint)
            SINGLE_ENDPOINT="$2"
            shift 2
            ;;
        --skip-existing)
            SKIP_EXISTING=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help)
            print_usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            print_usage
            exit 1
            ;;
    esac
done

# Print banner
print_banner

# Validate endpoints.txt exists
if [ ! -f "$ENDPOINTS_TXT" ]; then
    log_error "Endpoints file not found: $ENDPOINTS_TXT"
    exit 1
fi

# Get total endpoint count from endpoints.txt
TOTAL_ENDPOINT_COUNT=$(get_endpoint_count)

if [ "$TOTAL_ENDPOINT_COUNT" -eq 0 ]; then
    log_error "No endpoints found in $ENDPOINTS_TXT"
    exit 1
fi

log_info "Found $TOTAL_ENDPOINT_COUNT endpoints in endpoints.txt"

# Sync endpoints.csv from endpoints.txt
sync_endpoints_csv

# Set output directory
if [ -z "$OUTPUT_DIR" ]; then
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    OUTPUT_DIR="${BENCHMARK_DIR}/results/run_${TIMESTAMP}"
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Determine endpoints to process
if [ -n "$SINGLE_ENDPOINT" ]; then
    if ! [[ "$SINGLE_ENDPOINT" =~ ^[0-9]+$ ]] || [ "$SINGLE_ENDPOINT" -lt 1 ] || [ "$SINGLE_ENDPOINT" -gt "$TOTAL_ENDPOINT_COUNT" ]; then
        log_error "Invalid endpoint ID: $SINGLE_ENDPOINT (must be 1-$TOTAL_ENDPOINT_COUNT)"
        exit 1
    fi
    ENDPOINT_IDS=("$SINGLE_ENDPOINT")
    TOTAL_ENDPOINTS=1
else
    ENDPOINT_IDS=($(seq 1 "$TOTAL_ENDPOINT_COUNT"))
    TOTAL_ENDPOINTS="$TOTAL_ENDPOINT_COUNT"
fi

# Print configuration
log_header "Benchmark Configuration"
log_info "Endpoints File:      $ENDPOINTS_TXT"
log_info "Output Directory:    $OUTPUT_DIR"
log_info "Endpoints to Test:   $TOTAL_ENDPOINTS"
log_info "Runs per Endpoint:   $RUNS_PER_ENDPOINT"
log_info "Search Budget:       ${SEARCH_BUDGET}s"
log_info "Total Runs:          $((TOTAL_ENDPOINTS * RUNS_PER_ENDPOINT))"
echo ""

# List endpoints
echo "Endpoints:"
for i in "${ENDPOINT_IDS[@]}"; do
    local_service=$(get_endpoint_info_from_txt "$i" "service")
    local_method=$(get_endpoint_info_from_txt "$i" "http_method")
    local_endpoint=$(get_endpoint_info_from_txt "$i" "endpoint")
    echo "  $i. $local_service - $local_method /$local_endpoint"
done
echo ""

# Confirm with user
read -p "Press Enter to start benchmark, or Ctrl+C to cancel..."
echo ""

# Track results
SUCCESSFUL=0
FAILED=0
START_TIME=$(date +%s)

# Process each endpoint
for ENDPOINT_ID in "${ENDPOINT_IDS[@]}"; do
    SERVICE=$(get_endpoint_info_from_txt "$ENDPOINT_ID" "service")
    HTTP_METHOD=$(get_endpoint_info_from_txt "$ENDPOINT_ID" "http_method")
    ENDPOINT_PATH=$(get_endpoint_info_from_txt "$ENDPOINT_ID" "endpoint")

    log_header "Endpoint $ENDPOINT_ID/$TOTAL_ENDPOINTS: $HTTP_METHOD /$ENDPOINT_PATH"
    log_info "Service: $SERVICE"

    # Create endpoint output directory
    ENDPOINT_DIR="${OUTPUT_DIR}/endpoint_$(printf "%02d" "$ENDPOINT_ID")"
    mkdir -p "$ENDPOINT_DIR"

    # Create manual evaluation template
    create_manual_evaluation_template "$ENDPOINT_ID" "${ENDPOINT_DIR}/manual-evaluation.md"

    # Run N times
    for RUN_NUM in $(seq 1 "$RUNS_PER_ENDPOINT"); do
        RUN_DIR="${ENDPOINT_DIR}/run_$(printf "%02d" "$RUN_NUM")"

        # Skip if exists and --skip-existing is set
        if [ "$SKIP_EXISTING" = true ] && [ -d "$RUN_DIR" ]; then
            log_warning "Skipping run $RUN_NUM (already exists)"
            continue
        fi

        echo ""
        log_info "Run $RUN_NUM/$RUNS_PER_ENDPOINT"
        echo ""

        # Execute single endpoint runner
        "${SCRIPT_DIR}/run-single-endpoint.sh" \
            "$ENDPOINT_ID" \
            "$RUN_NUM" \
            "$RUN_DIR" \
            --budget "$SEARCH_BUDGET"

        RUN_EXIT_CODE=$?

        # Track results
        if [ "$RUN_EXIT_CODE" -eq 0 ]; then
            ((SUCCESSFUL++))
        else
            ((FAILED++))
        fi

        # Brief pause between runs
        if [ "$RUN_NUM" -lt "$RUNS_PER_ENDPOINT" ]; then
            log_info "Waiting 5 seconds before next run..."
            sleep 5
        fi
    done

    # Generate aggregated averages for this endpoint
    log_info "Generating run averages for endpoint $ENDPOINT_ID..."
    if [ -f "${LIB_DIR}/aggregator.py" ]; then
        python3 "${LIB_DIR}/aggregator.py" "$ENDPOINT_DIR" 2>/dev/null
        if [ $? -eq 0 ]; then
            log_success "Run averages saved to ${ENDPOINT_DIR}/run-averages.json"
        else
            log_warning "Failed to generate run averages for endpoint $ENDPOINT_ID"
        fi
    else
        log_warning "Aggregator not found at ${LIB_DIR}/aggregator.py"
    fi

    # Pause between endpoints
    if [ "$ENDPOINT_ID" -lt "$TOTAL_ENDPOINTS" ]; then
        log_info "Waiting 10 seconds before next endpoint..."
        sleep 10
    fi
done

# Calculate duration
END_TIME=$(date +%s)
TOTAL_DURATION=$((END_TIME - START_TIME))

# Generate summary report
generate_summary_report "$OUTPUT_DIR" "$TOTAL_ENDPOINTS" "$RUNS_PER_ENDPOINT" "$SUCCESSFUL" "$FAILED" "$TOTAL_DURATION"

# Generate initial CSV (automated metrics only)
log_header "Generating Results CSV"

if [ -f "${LIB_DIR}/csv_generator.py" ]; then
    python3 "${LIB_DIR}/csv_generator.py" "$OUTPUT_DIR" 2>/dev/null
else
    log_warning "CSV generator not found. Run generate-report.sh manually."
fi

# Print final summary
log_header "Benchmark Complete"

echo -e "${GREEN}Results Summary:${NC}"
echo "  Total Runs:        $((SUCCESSFUL + FAILED))"
echo "  Successful:        $SUCCESSFUL"
echo "  Failed:            $FAILED"
echo "  Duration:          ${TOTAL_DURATION}s ($(( TOTAL_DURATION / 60 ))m $(( TOTAL_DURATION % 60 ))s)"
echo ""
echo -e "${CYAN}Output Files:${NC}"
echo "  Results Directory: $OUTPUT_DIR"
echo "  Summary Report:    ${OUTPUT_DIR}/summary-report.md"
echo "  Results CSV:       ${OUTPUT_DIR}/benchmark-results.csv (if generated)"
echo "  Run Averages:      ${OUTPUT_DIR}/endpoint_XX/run-averages.json (per endpoint)"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Review run averages in endpoint_XX/run-averages.json and run-averages.txt"
echo "  2. Review generated tests in endpoint_XX/run_YY/generated-tests/"
echo "  3. Complete manual-evaluation.md checklists"
echo "  4. Run: ./generate-report.sh $OUTPUT_DIR"
echo ""

exit 0
