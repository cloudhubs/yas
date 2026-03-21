#!/bin/bash

# =============================================================================
# EvoSuite Endpoint Test Runner with Full Logging
# =============================================================================
#
# Purpose: Run EvoSuite against 13 specific endpoints and capture all logs
#          for research documentation, even when tests fail.
#
# Usage:
#   ./run-endpoint-tests.sh                    # Run all endpoints from endpoints.txt
#   ./run-endpoint-tests.sh --budget 60        # Custom search budget (seconds)
#
# Output:
#   logs/run_<timestamp>/
#   ├── 01_GET_backoffice_products.log
#   ├── 02_POST_backoffice_products.log
#   ├── ...
#   └── summary_report.txt
#
# =============================================================================

set -o pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENDPOINTS_FILE="${SCRIPT_DIR}/endpoints.txt"
SEARCH_BUDGET="${SEARCH_BUDGET:-60}"  # Default 60 seconds per endpoint

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --budget)
            SEARCH_BUDGET="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Create timestamped log directory
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_DIR="${SCRIPT_DIR}/logs/run_${TIMESTAMP}"
mkdir -p "$LOG_DIR"

echo -e "${CYAN}=============================================${NC}"
echo -e "${CYAN}  EvoSuite Endpoint Test Runner for YAS${NC}"
echo -e "${CYAN}=============================================${NC}"
echo ""
echo -e "Timestamp:     ${GREEN}${TIMESTAMP}${NC}"
echo -e "Log Directory: ${GREEN}${LOG_DIR}${NC}"
echo -e "Search Budget: ${GREEN}${SEARCH_BUDGET} seconds${NC}"
echo -e "Endpoints:     ${GREEN}${ENDPOINTS_FILE}${NC}"
echo ""

# Check endpoints file exists
if [ ! -f "$ENDPOINTS_FILE" ]; then
    echo -e "${RED}Error: endpoints.txt not found at $ENDPOINTS_FILE${NC}"
    exit 1
fi

# Count endpoints (excluding comments and empty lines)
TOTAL_ENDPOINTS=$(grep -v '^#' "$ENDPOINTS_FILE" | grep -v '^$' | wc -l | tr -d ' ')
echo -e "Total Endpoints to Test: ${YELLOW}${TOTAL_ENDPOINTS}${NC}"
echo ""

# Arrays to track results
declare -a SUCCESSFUL=()
declare -a FAILED=()
declare -a TEST_COUNTS=()

# Start time
START_TIME=$(date +%s)

# Process each endpoint
COUNTER=0
while IFS='|' read -r service endpoint method controller; do
    # Skip comments and empty lines
    [[ "$service" =~ ^#.*$ || -z "$service" ]] && continue

    COUNTER=$((COUNTER + 1))
    PADDED_NUM=$(printf "%02d" $COUNTER)

    # Create safe filename from endpoint
    SAFE_NAME=$(echo "$endpoint" | tr '/' '_' | tr -d '{}?')
    LOG_FILE="${LOG_DIR}/${PADDED_NUM}_${method}_${SAFE_NAME}.log"

    echo -e "${BLUE}=============================================${NC}"
    echo -e "${BLUE}[${COUNTER}/${TOTAL_ENDPOINTS}] Testing Endpoint${NC}"
    echo -e "${BLUE}=============================================${NC}"
    echo -e "Service:    ${GREEN}${service}${NC}"
    echo -e "Endpoint:   ${YELLOW}${method} /${endpoint}${NC}"
    echo -e "Controller: ${CYAN}${controller}${NC}"
    echo -e "Log File:   ${LOG_FILE}"
    echo ""

    # Write header to log file
    {
        echo "============================================="
        echo "EvoSuite Endpoint Test Log"
        echo "============================================="
        echo ""
        echo "Timestamp:  $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Test #:     ${COUNTER}/${TOTAL_ENDPOINTS}"
        echo "Service:    ${service}"
        echo "Endpoint:   ${method} /${endpoint}"
        echo "Controller: ${controller}"
        echo "Budget:     ${SEARCH_BUDGET} seconds"
        echo ""
        echo "============================================="
        echo "EvoSuite Output"
        echo "============================================="
        echo ""
    } > "$LOG_FILE"

    # Run EvoSuite and capture output
    ENDPOINT_START=$(date +%s)

    SEARCH_BUDGET="$SEARCH_BUDGET" "${SCRIPT_DIR}/run-evosuite.sh" "$service" "$controller" 2>&1 | tee -a "$LOG_FILE"
    EXIT_CODE=${PIPESTATUS[0]}

    ENDPOINT_END=$(date +%s)
    ENDPOINT_DURATION=$((ENDPOINT_END - ENDPOINT_START))

    # Count generated test files
    SERVICE_DIR="${SCRIPT_DIR}/../${service}"
    TEST_COUNT=$(find "${SERVICE_DIR}/evosuite-tests" -name "*_ESTest.java" 2>/dev/null | wc -l | tr -d ' ')
    TEST_COUNTS+=("$TEST_COUNT")

    # Write footer to log file
    {
        echo ""
        echo "============================================="
        echo "Test Summary"
        echo "============================================="
        echo ""
        echo "Exit Code:      ${EXIT_CODE}"
        echo "Duration:       ${ENDPOINT_DURATION} seconds"
        echo "Tests Generated: ${TEST_COUNT}"
        echo "Completed:      $(date '+%Y-%m-%d %H:%M:%S')"
        echo ""
    } >> "$LOG_FILE"

    # Track result
    if [ $EXIT_CODE -eq 0 ] && [ "$TEST_COUNT" -gt 0 ]; then
        SUCCESSFUL+=("${PADDED_NUM}_${method}_${SAFE_NAME}")
        echo -e "${GREEN}Result: SUCCESS (${TEST_COUNT} tests generated)${NC}"
    else
        FAILED+=("${PADDED_NUM}_${method}_${SAFE_NAME}")
        echo -e "${RED}Result: FAILED (Exit code: ${EXIT_CODE}, Tests: ${TEST_COUNT})${NC}"
    fi

    echo ""

done < "$ENDPOINTS_FILE"

# End time
END_TIME=$(date +%s)
TOTAL_DURATION=$((END_TIME - START_TIME))

# Generate summary report
SUMMARY_FILE="${LOG_DIR}/summary_report.txt"

{
    echo "============================================="
    echo "EvoSuite Endpoint Test Summary Report"
    echo "============================================="
    echo ""
    echo "Run Timestamp:    ${TIMESTAMP}"
    echo "Total Duration:   ${TOTAL_DURATION} seconds ($(( TOTAL_DURATION / 60 )) min $(( TOTAL_DURATION % 60 )) sec)"
    echo "Search Budget:    ${SEARCH_BUDGET} seconds per endpoint"
    echo ""
    echo "============================================="
    echo "Results"
    echo "============================================="
    echo ""
    echo "Total Endpoints:  ${TOTAL_ENDPOINTS}"
    echo "Successful:       ${#SUCCESSFUL[@]}"
    echo "Failed:           ${#FAILED[@]}"
    echo ""

    if [ ${#SUCCESSFUL[@]} -gt 0 ]; then
        echo "--- Successful Tests ---"
        for item in "${SUCCESSFUL[@]}"; do
            echo "  ✓ ${item}"
        done
        echo ""
    fi

    if [ ${#FAILED[@]} -gt 0 ]; then
        echo "--- Failed Tests ---"
        for item in "${FAILED[@]}"; do
            echo "  ✗ ${item}"
        done
        echo ""
    fi

    echo "============================================="
    echo "Log Files"
    echo "============================================="
    echo ""
    echo "Directory: ${LOG_DIR}"
    echo ""
    ls -1 "$LOG_DIR"/*.log 2>/dev/null | while read -r f; do
        echo "  - $(basename "$f")"
    done
    echo ""

    echo "============================================="
    echo "Notes for Research"
    echo "============================================="
    echo ""
    echo "EvoSuite Architectural Limitation:"
    echo "  EvoSuite uses a master-client RMI architecture where the master"
    echo "  process cannot deserialize Spring framework types (HttpEntity,"
    echo "  ResponseEntity, etc.) because they are not in its classpath."
    echo "  This causes test generation to fail for most Spring controllers."
    echo ""
    echo "Expected Behavior:"
    echo "  - Controllers will likely show 0 generated tests"
    echo "  - Errors like 'NoClassDefFoundError: org/springframework/http/HttpEntity'"
    echo "    are expected and documented in the log files"
    echo ""
    echo "Cross-Compilation Note (YAS-specific):"
    echo "  - YAS uses Java 21 and Spring Boot 4.0.2"
    echo "  - EvoSuite targets Java 11 maximum"
    echo "  - Cross-compilation gap is larger than train-ticket (Java 17)"
    echo ""

} > "$SUMMARY_FILE"

# Print summary to console
echo -e "${CYAN}=============================================${NC}"
echo -e "${CYAN}  Test Run Complete${NC}"
echo -e "${CYAN}=============================================${NC}"
echo ""
echo -e "Total Duration: ${GREEN}${TOTAL_DURATION} seconds${NC}"
echo -e "Successful:     ${GREEN}${#SUCCESSFUL[@]}${NC}"
echo -e "Failed:         ${RED}${#FAILED[@]}${NC}"
echo ""
echo -e "Summary Report: ${YELLOW}${SUMMARY_FILE}${NC}"
echo -e "Log Directory:  ${YELLOW}${LOG_DIR}${NC}"
echo ""

# List log files
echo "Generated Log Files:"
ls -1 "$LOG_DIR"/*.log 2>/dev/null | while read -r f; do
    echo "  - $(basename "$f")"
done
echo ""

# Exit with appropriate code
if [ ${#FAILED[@]} -eq $TOTAL_ENDPOINTS ]; then
    echo -e "${RED}All tests failed (expected for Spring controllers due to RMI limitation)${NC}"
    exit 0  # Exit 0 because failure is expected
else
    exit 0
fi
