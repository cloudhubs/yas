#!/bin/bash

# =============================================================================
# EvoSuite Single Endpoint Runner with Metrics Collection
# =============================================================================
#
# Purpose: Run EvoSuite for a single endpoint and collect all metrics
#
# Usage:
#   ./run-single-endpoint.sh <endpoint_id> <run_number> <output_dir> [options]
#
# Arguments:
#   endpoint_id   - Endpoint ID (1-13) from endpoints.csv
#   run_number    - Run iteration number (1, 2, 3, ...)
#   output_dir    - Directory to store results
#
# Options:
#   --budget SECS - Search budget in seconds (default: 60)
#
# Output:
#   <output_dir>/
#   ├── evosuite-output.log      # Complete EvoSuite stdout/stderr
#   ├── resource-metrics.json    # CPU, memory, time measurements
#   ├── exit-status.json         # Exit code, error classification
#   └── generated-tests/         # Copy of any generated tests
#
# =============================================================================

set -o pipefail

# Script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BENCHMARK_DIR="$(dirname "$SCRIPT_DIR")"
EVOSUITE_DIR="$(dirname "$BENCHMARK_DIR")"
PROJECT_ROOT="$(dirname "$EVOSUITE_DIR")"

# Configuration
CONFIG_DIR="${BENCHMARK_DIR}/config"
ENDPOINTS_CSV="${CONFIG_DIR}/endpoints.csv"

# Default values
SEARCH_BUDGET="${SEARCH_BUDGET:-60}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# =============================================================================
# Functions
# =============================================================================

print_usage() {
    echo "Usage: $0 <endpoint_id> <run_number> <output_dir> [--budget SECS]"
    echo ""
    echo "Arguments:"
    echo "  endpoint_id   Endpoint ID (1-13) from endpoints.csv"
    echo "  run_number    Run iteration number"
    echo "  output_dir    Directory to store results"
    echo ""
    echo "Options:"
    echo "  --budget SECS Search budget in seconds (default: 60)"
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

get_endpoint_info() {
    local endpoint_id=$1
    local field=$2

    # Field indices (0-based): 0=id, 1=service, 2=endpoint, 3=method, 4=controller, 5=method_name, 6=path_params, 7=has_body, 8=status_codes, 9=auth
    local field_index
    case "$field" in
        "service") field_index=2 ;;
        "endpoint") field_index=3 ;;
        "http_method") field_index=4 ;;
        "controller_class") field_index=5 ;;
        "method_name") field_index=6 ;;
        "path_params") field_index=7 ;;
        "has_request_body") field_index=8 ;;
        "expected_status_codes") field_index=9 ;;
        "authorization") field_index=10 ;;
        *) echo ""; return 1 ;;
    esac

    # Get the line for this endpoint (skip header)
    awk -F',' -v id="$endpoint_id" -v idx="$field_index" 'NR>1 && $1==id {print $idx}' "$ENDPOINTS_CSV"
}

classify_error() {
    local log_file=$1
    local error_type="UNKNOWN"
    local error_message=""
    local error_details=""

    # Check for "No class files generated" - common compilation failure
    if grep -q "No class files generated\|Error: target/classes directory not created" "$log_file" 2>/dev/null; then
        error_type="NO_CLASS_FILES"
        error_message="No class files generated - compilation failed"
        # Try to get the first compilation error
        error_details=$(grep -m3 "\[ERROR\]" "$log_file" 2>/dev/null | head -3 | tr '\n' ' ')
        if [ -n "$error_details" ]; then
            error_message="$error_message: $error_details"
        fi
    # Check for Maven/compilation errors (package not found, cannot find symbol)
    elif grep -q "\[ERROR\].*package.*does not exist\|\[ERROR\].*cannot find symbol" "$log_file" 2>/dev/null; then
        error_type="COMPILATION_MISSING_DEPENDENCY"
        # Get all unique missing packages
        error_details=$(grep "\[ERROR\]" "$log_file" 2>/dev/null | grep -oE "package [^ ]+ does not exist" | sort -u | head -3 | tr '\n' '; ')
        if [ -z "$error_details" ]; then
            error_details=$(grep -m1 "\[ERROR\].*cannot find symbol" "$log_file" 2>/dev/null)
        fi
        error_message="Missing dependencies: $error_details"
    # Check for RMI serialization errors (EvoSuite master-client boundary)
    elif grep -q "NoClassDefFoundError.*HttpEntity\|NoClassDefFoundError.*ResponseEntity\|NoClassDefFoundError.*HttpHeaders\|ClassNotFoundException.*springframework\|NotSerializableException" "$log_file" 2>/dev/null; then
        error_type="RMI_SERIALIZATION"
        error_message=$(grep -m1 "NoClassDefFoundError\|ClassNotFoundException\|NotSerializableException" "$log_file" 2>/dev/null | head -1)
    # Check for EvoSuite-specific errors
    elif grep -q "EvoSuite.*error\|Could not load class\|Could not find\|Unable to instrument" "$log_file" 2>/dev/null; then
        error_type="EVOSUITE_ERROR"
        error_message=$(grep -m1 "EvoSuite.*error\|Could not load class\|Could not find\|Unable to instrument" "$log_file" 2>/dev/null | head -1)
    # Check for Java compilation errors (general)
    elif grep -q "Compilation failed\|\[ERROR\].*error:" "$log_file" 2>/dev/null; then
        error_type="COMPILATION"
        error_message=$(grep -m1 "\[ERROR\].*error:\|Compilation failed" "$log_file" 2>/dev/null | head -1)
    # Check for timeout
    elif grep -q "Timeout reached\|Search budget exhausted\|timed out" "$log_file" 2>/dev/null; then
        error_type="TIMEOUT"
        error_message="Search budget exhausted or process timed out"
    # Check for OOM
    elif grep -q "OutOfMemoryError\|Java heap space\|GC overhead\|Cannot allocate memory" "$log_file" 2>/dev/null; then
        error_type="OOM"
        error_message=$(grep -m1 "OutOfMemoryError\|heap space\|GC overhead\|Cannot allocate memory" "$log_file" 2>/dev/null | head -1)
    # Check for RMI connection issues
    elif grep -q "Connection refused\|RMI.*Exception\|RemoteException\|Registry.*not available" "$log_file" 2>/dev/null; then
        error_type="RMI_CONNECTION"
        error_message=$(grep -m1 "Connection refused\|RemoteException\|Registry" "$log_file" 2>/dev/null | head -1)
    # Check for Docker errors
    elif grep -q "docker:.*error\|Error response from daemon\|container.*failed" "$log_file" 2>/dev/null; then
        error_type="DOCKER_ERROR"
        error_message=$(grep -m1 "docker:.*error\|Error response from daemon\|container.*failed" "$log_file" 2>/dev/null | head -1)
    # Check for generic Java exceptions
    elif grep -q "Exception in thread\|java\.lang\.[A-Z].*Exception" "$log_file" 2>/dev/null; then
        error_type="JAVA_EXCEPTION"
        error_message=$(grep -m1 "Exception in thread\|java\.lang\.[A-Z].*Exception" "$log_file" 2>/dev/null | head -1)
    # Check if exit code indicates failure but no specific error found
    elif grep -q "Exit Code:.*[^0]" "$log_file" 2>/dev/null; then
        error_type="UNKNOWN_FAILURE"
        # Try to find any error-like message
        error_message=$(grep -iE "error|fail|exception" "$log_file" 2>/dev/null | grep -v "failOnError" | head -1)
        if [ -z "$error_message" ]; then
            error_message="Process exited with non-zero code, check log for details"
        fi
    fi

    # Truncate very long messages
    error_message=$(echo "$error_message" | head -c 500)

    echo "${error_type}|${error_message}"
}

monitor_docker_stats() {
    local container_pattern=$1
    local output_file=$2
    local interval=${3:-5}

    echo "[]" > "$output_file"

    while true; do
        # Get Docker stats for EvoSuite containers
        local stats=$(docker stats --no-stream --format '{"cpu":"{{.CPUPerc}}","memory":"{{.MemUsage}}","mem_percent":"{{.MemPerc}}"}' 2>/dev/null | head -1)

        if [ -n "$stats" ]; then
            # Append to JSON array (simplified approach)
            local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
            echo "${timestamp}: ${stats}" >> "${output_file}.raw"
        fi

        sleep "$interval"
    done
}

# Cross-platform timeout function (works on macOS and Linux)
run_with_timeout() {
    local timeout_seconds=$1
    shift
    local cmd="$@"

    # Check if GNU timeout is available (Linux or installed via coreutils on macOS)
    if command -v timeout &> /dev/null; then
        timeout "${timeout_seconds}s" $cmd
        return $?
    # Check for gtimeout (GNU coreutils on macOS via Homebrew)
    elif command -v gtimeout &> /dev/null; then
        gtimeout "${timeout_seconds}s" $cmd
        return $?
    else
        # Fallback: run without timeout on macOS (Docker has its own timeouts)
        log_warning "timeout command not found - running without timeout wrapper"
        log_warning "Install coreutils via: brew install coreutils"
        $cmd
        return $?
    fi
}

# =============================================================================
# Main Script
# =============================================================================

# Parse arguments
if [ $# -lt 3 ]; then
    print_usage
    exit 1
fi

ENDPOINT_ID="$1"
RUN_NUMBER="$2"
OUTPUT_DIR="$3"
shift 3

# Parse options
while [[ $# -gt 0 ]]; do
    case $1 in
        --budget)
            SEARCH_BUDGET="$2"
            shift 2
            ;;
        *)
            log_error "Unknown option: $1"
            print_usage
            exit 1
            ;;
    esac
done

# Validate endpoint ID
if ! [[ "$ENDPOINT_ID" =~ ^[0-9]+$ ]] || [ "$ENDPOINT_ID" -lt 1 ] || [ "$ENDPOINT_ID" -gt 13 ]; then
    log_error "Invalid endpoint ID: $ENDPOINT_ID (must be 1-13)"
    exit 1
fi

# Get endpoint information
SERVICE=$(get_endpoint_info "$ENDPOINT_ID" "service")
HTTP_METHOD=$(get_endpoint_info "$ENDPOINT_ID" "http_method")
ENDPOINT_PATH=$(get_endpoint_info "$ENDPOINT_ID" "endpoint")
CONTROLLER_CLASS=$(get_endpoint_info "$ENDPOINT_ID" "controller_class")

if [ -z "$SERVICE" ] || [ -z "$CONTROLLER_CLASS" ]; then
    log_error "Could not find endpoint information for ID: $ENDPOINT_ID"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Log files
LOG_FILE="${OUTPUT_DIR}/evosuite-output.log"
METRICS_FILE="${OUTPUT_DIR}/resource-metrics.json"
STATUS_FILE="${OUTPUT_DIR}/exit-status.json"
STATS_RAW_FILE="${OUTPUT_DIR}/docker-stats.raw"

# Print header
echo -e "${CYAN}=============================================${NC}"
echo -e "${CYAN}  EvoSuite Single Endpoint Runner${NC}"
echo -e "${CYAN}=============================================${NC}"
echo ""
log_info "Endpoint ID:     $ENDPOINT_ID"
log_info "Run Number:      $RUN_NUMBER"
log_info "Service:         $SERVICE"
log_info "HTTP Method:     $HTTP_METHOD"
log_info "Endpoint:        $ENDPOINT_PATH"
log_info "Controller:      $CONTROLLER_CLASS"
log_info "Search Budget:   ${SEARCH_BUDGET}s"
log_info "Output Dir:      $OUTPUT_DIR"
echo ""

# Write log header
{
    echo "============================================="
    echo "EvoSuite Endpoint Test Generation Log"
    echo "============================================="
    echo ""
    echo "Timestamp:       $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    echo "Endpoint ID:     $ENDPOINT_ID"
    echo "Run Number:      $RUN_NUMBER"
    echo "Service:         $SERVICE"
    echo "HTTP Method:     $HTTP_METHOD"
    echo "Endpoint:        $ENDPOINT_PATH"
    echo "Controller:      $CONTROLLER_CLASS"
    echo "Search Budget:   ${SEARCH_BUDGET} seconds"
    echo ""
    echo "============================================="
    echo "EvoSuite Output"
    echo "============================================="
    echo ""
} > "$LOG_FILE"

# Initialize metrics
CPU_SAMPLES=()
MEMORY_SAMPLES=()
START_TIME=$(date +%s.%N)
START_TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Start Docker stats monitoring in background
> "$STATS_RAW_FILE"
(
    while [ ! -f "${OUTPUT_DIR}/.done" ]; do
        # Try to capture stats from any running evosuite container
        STATS=$(docker stats --no-stream --format "{{.CPUPerc}},{{.MemUsage}}" 2>/dev/null | head -1)
        if [ -n "$STATS" ]; then
            echo "$(date +%s.%N),$STATS" >> "$STATS_RAW_FILE"
        fi
        sleep 5
    done
) &
MONITOR_PID=$!

# Track hang detection
LAST_OUTPUT_TIME=$(date +%s)
HUNG_UP=false

# Run EvoSuite
log_info "Starting EvoSuite test generation..."

SERVICE_DIR="${PROJECT_ROOT}/${SERVICE}"
cd "$EVOSUITE_DIR"

# Execute EvoSuite with timeout detection
TIMEOUT_SECONDS=$((SEARCH_BUDGET * 3))  # 3x budget for safety

{
    export SEARCH_BUDGET="$SEARCH_BUDGET"
    run_with_timeout "$TIMEOUT_SECONDS" ./run-evosuite.sh "$SERVICE" "$CONTROLLER_CLASS" 2>&1
} | while IFS= read -r line; do
    echo "$line" >> "$LOG_FILE"
    echo "$line"
    LAST_OUTPUT_TIME=$(date +%s)
done

EXIT_CODE=${PIPESTATUS[0]}
END_TIME=$(date +%s.%N)
END_TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Stop monitoring
touch "${OUTPUT_DIR}/.done"
kill $MONITOR_PID 2>/dev/null
wait $MONITOR_PID 2>/dev/null
rm -f "${OUTPUT_DIR}/.done"

# Calculate duration
DURATION=$(echo "$END_TIME - $START_TIME" | bc 2>/dev/null || echo "0")

# Check for timeout
TIMED_OUT=false
if [ "$EXIT_CODE" -eq 124 ]; then
    TIMED_OUT=true
    EXIT_CODE=1
fi

# Check for hung (no output for 60+ seconds - approximate)
# This is a simplified check; real hang detection would need more sophisticated monitoring

# Process Docker stats
AVG_CPU="0"
PEAK_MEMORY="0"
if [ -f "$STATS_RAW_FILE" ] && [ -s "$STATS_RAW_FILE" ]; then
    # Parse CPU percentages (remove % sign and calculate average)
    CPU_VALUES=$(awk -F',' '{gsub(/%/,"",$2); if($2+0>0) print $2}' "$STATS_RAW_FILE" 2>/dev/null)
    if [ -n "$CPU_VALUES" ]; then
        AVG_CPU=$(echo "$CPU_VALUES" | awk '{sum+=$1; count++} END {if(count>0) printf "%.2f", sum/count; else print "0"}')
    fi

    # Parse memory (extract MB value)
    MEMORY_VALUES=$(awk -F',' '{split($3,a,"/"); gsub(/[^0-9.]/,"",a[1]); if(a[1]+0>0) print a[1]}' "$STATS_RAW_FILE" 2>/dev/null)
    if [ -n "$MEMORY_VALUES" ]; then
        PEAK_MEMORY=$(echo "$MEMORY_VALUES" | sort -rn | head -1)
    fi
fi

# Classify any errors
ERROR_INFO=$(classify_error "$LOG_FILE")
ERROR_TYPE=$(echo "$ERROR_INFO" | cut -d'|' -f1)
ERROR_MESSAGE=$(echo "$ERROR_INFO" | cut -d'|' -f2-)

# Extract detailed errors to a separate file for analysis
ERROR_DETAILS_FILE="${OUTPUT_DIR}/error-details.txt"
{
    echo "============================================="
    echo "DETAILED ERROR REPORT"
    echo "============================================="
    echo ""
    echo "Endpoint ID:   $ENDPOINT_ID"
    echo "Run Number:    $RUN_NUMBER"
    echo "Error Type:    $ERROR_TYPE"
    echo ""

    # Extract all [ERROR] lines from Maven/compilation
    MAVEN_ERRORS=$(grep "\[ERROR\]" "$LOG_FILE" 2>/dev/null)
    if [ -n "$MAVEN_ERRORS" ]; then
        echo "=== MAVEN/COMPILATION ERRORS ==="
        echo "$MAVEN_ERRORS"
        echo ""
    fi

    # Extract exception stack traces
    EXCEPTIONS=$(grep -A5 "Exception\|Error:" "$LOG_FILE" 2>/dev/null | head -50)
    if [ -n "$EXCEPTIONS" ]; then
        echo "=== EXCEPTIONS/STACK TRACES ==="
        echo "$EXCEPTIONS"
        echo ""
    fi

    # Count error types
    MISSING_PACKAGES=$(grep "\[ERROR\]" "$LOG_FILE" 2>/dev/null | grep -c "package.*does not exist" || echo "0")
    CANNOT_FIND_SYMBOL=$(grep "\[ERROR\]" "$LOG_FILE" 2>/dev/null | grep -c "cannot find symbol" || echo "0")

    echo "=== ERROR COUNTS ==="
    echo "Missing packages:    $MISSING_PACKAGES"
    echo "Cannot find symbol:  $CANNOT_FIND_SYMBOL"
    echo ""

    # List unique missing packages
    if [ "$MISSING_PACKAGES" -gt 0 ]; then
        echo "=== MISSING PACKAGES (unique) ==="
        grep "\[ERROR\]" "$LOG_FILE" 2>/dev/null | grep -oE "package [^ ]+ does not exist" | sort -u
        echo ""
    fi

} > "$ERROR_DETAILS_FILE"

# Count total errors for metrics
TOTAL_ERRORS=$(grep -c "\[ERROR\]" "$LOG_FILE" 2>/dev/null || echo "0")
MISSING_PACKAGES_COUNT=$(grep "\[ERROR\]" "$LOG_FILE" 2>/dev/null | grep -c "package.*does not exist" || echo "0")
CANNOT_FIND_SYMBOL_COUNT=$(grep "\[ERROR\]" "$LOG_FILE" 2>/dev/null | grep -c "cannot find symbol" || echo "0")

# Determine generation status
GENERATION_STATUS="FAILED"
if [ "$EXIT_CODE" -eq 0 ]; then
    GENERATION_STATUS="SUCCESS"
fi

# Count generated tests
TESTS_DIR="${SERVICE_DIR}/evosuite-tests"
TESTS_GENERATED=0
TEST_METHODS=0
ASSERTIONS=0

if [ -d "$TESTS_DIR" ]; then
    TESTS_GENERATED=$(find "$TESTS_DIR" -name "*_ESTest.java" 2>/dev/null | wc -l | tr -d ' ')

    # Count test methods and assertions if tests exist
    if [ "$TESTS_GENERATED" -gt 0 ]; then
        TEST_METHODS=$(grep -r "@Test" "$TESTS_DIR" 2>/dev/null | wc -l | tr -d ' ')
        ASSERTIONS=$(grep -rE "assert[A-Z]|verify[A-Z]|expect[A-Z]" "$TESTS_DIR" 2>/dev/null | wc -l | tr -d ' ')

        # Copy generated tests to output
        mkdir -p "${OUTPUT_DIR}/generated-tests"
        cp -r "$TESTS_DIR"/* "${OUTPUT_DIR}/generated-tests/" 2>/dev/null
    fi
fi

# Get coverage from statistics.csv if available
COVERAGE="N/A"
TOTAL_GOALS="N/A"
COVERED_GOALS="N/A"
STATS_CSV="${SERVICE_DIR}/evosuite-report/statistics.csv"
if [ -f "$STATS_CSV" ]; then
    # Parse the last line (most recent run)
    STATS_LINE=$(tail -1 "$STATS_CSV" 2>/dev/null)
    if [ -n "$STATS_LINE" ]; then
        COVERAGE=$(echo "$STATS_LINE" | awk -F',' '{print $3}')
        TOTAL_GOALS=$(echo "$STATS_LINE" | awk -F',' '{print $4}')
        COVERED_GOALS=$(echo "$STATS_LINE" | awk -F',' '{print $5}')
    fi
fi

# Write resource metrics JSON
cat > "$METRICS_FILE" << EOF
{
    "endpoint_id": $ENDPOINT_ID,
    "run_number": $RUN_NUMBER,
    "start_timestamp": "$START_TIMESTAMP",
    "end_timestamp": "$END_TIMESTAMP",
    "duration_seconds": $DURATION,
    "search_budget_seconds": $SEARCH_BUDGET,
    "cpu_average_percent": $AVG_CPU,
    "memory_peak_mb": ${PEAK_MEMORY:-0},
    "tests_generated": $TESTS_GENERATED,
    "test_methods": $TEST_METHODS,
    "assertions": $ASSERTIONS,
    "coverage": "$COVERAGE",
    "total_goals": "$TOTAL_GOALS",
    "covered_goals": "$COVERED_GOALS"
}
EOF

# Write exit status JSON with comprehensive error details
cat > "$STATUS_FILE" << EOF
{
    "endpoint_id": $ENDPOINT_ID,
    "run_number": $RUN_NUMBER,
    "generation_status": "$GENERATION_STATUS",
    "exit_code": $EXIT_CODE,
    "timed_out": $TIMED_OUT,
    "hung_up": $HUNG_UP,
    "error_type": "$ERROR_TYPE",
    "error_message": "$(echo "$ERROR_MESSAGE" | sed 's/"/\\"/g' | tr '\n' ' ' | head -c 500)",
    "runs_without_error": $([ "$EXIT_CODE" -eq 0 ] && echo "true" || echo "false"),
    "threw_errors": $([ "$EXIT_CODE" -ne 0 ] && echo "true" || echo "false"),
    "error_counts": {
        "total_errors": $TOTAL_ERRORS,
        "missing_packages": $MISSING_PACKAGES_COUNT,
        "cannot_find_symbol": $CANNOT_FIND_SYMBOL_COUNT
    },
    "error_details_file": "error-details.txt"
}
EOF

# Write log footer
{
    echo ""
    echo "============================================="
    echo "Execution Summary"
    echo "============================================="
    echo ""
    echo "End Timestamp:   $END_TIMESTAMP"
    echo "Duration:        ${DURATION}s"
    echo "Exit Code:       $EXIT_CODE"
    echo "Status:          $GENERATION_STATUS"
    echo "Error Type:      $ERROR_TYPE"
    echo "Error Count:     $TOTAL_ERRORS"
    echo "Tests Generated: $TESTS_GENERATED"
    echo "Test Methods:    $TEST_METHODS"
    echo "Assertions:      $ASSERTIONS"
    echo "Coverage:        $COVERAGE"
    echo "Avg CPU:         ${AVG_CPU}%"
    echo "Peak Memory:     ${PEAK_MEMORY}MB"
    echo ""
    if [ "$EXIT_CODE" -ne 0 ] && [ -n "$ERROR_MESSAGE" ]; then
        echo "Error Message:"
        echo "  $ERROR_MESSAGE"
        echo ""
    fi
} >> "$LOG_FILE"

# Print summary
echo ""
echo -e "${CYAN}=============================================${NC}"
echo -e "${CYAN}  Execution Complete${NC}"
echo -e "${CYAN}=============================================${NC}"
echo ""

if [ "$EXIT_CODE" -eq 0 ]; then
    log_success "Generation Status: $GENERATION_STATUS"
else
    log_error "Generation Status: $GENERATION_STATUS"
    log_warning "Error Type: $ERROR_TYPE"
    if [ -n "$ERROR_MESSAGE" ]; then
        log_warning "Error: $(echo "$ERROR_MESSAGE" | head -c 200)"
    fi
fi

echo ""
log_info "Duration:        ${DURATION}s"
log_info "Tests Generated: $TESTS_GENERATED"
log_info "Test Methods:    $TEST_METHODS"
log_info "Coverage:        $COVERAGE"
log_info "Avg CPU:         ${AVG_CPU}%"
log_info "Peak Memory:     ${PEAK_MEMORY}MB"
if [ "$TOTAL_ERRORS" -gt 0 ]; then
    log_info "Total Errors:    $TOTAL_ERRORS"
fi
echo ""
log_info "Output files:"
echo "  - $LOG_FILE"
echo "  - $METRICS_FILE"
echo "  - $STATUS_FILE"
if [ "$EXIT_CODE" -ne 0 ]; then
    echo "  - $ERROR_DETAILS_FILE"
fi
echo ""

# Clean up temp files
rm -f "$STATS_RAW_FILE"

exit $EXIT_CODE
