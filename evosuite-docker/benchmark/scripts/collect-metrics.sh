#!/bin/bash

# =============================================================================
# EvoSuite Benchmark Metrics Collector
# =============================================================================
#
# Purpose: Collect and aggregate metrics from benchmark results
#
# Usage:
#   ./collect-metrics.sh <results_dir>
#
# Output:
#   - Prints summary to stdout
#   - Creates metrics-summary.json in results directory
#
# =============================================================================

set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BENCHMARK_DIR="$(dirname "$SCRIPT_DIR")"
LIB_DIR="${BENCHMARK_DIR}/lib"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 <results_dir>"
    echo ""
    echo "Example:"
    echo "  $0 results/run_20251211_120000"
    exit 1
fi

RESULTS_DIR="$1"

if [ ! -d "$RESULTS_DIR" ]; then
    log_error "Results directory not found: $RESULTS_DIR"
    exit 1
fi

echo -e "${CYAN}=============================================${NC}"
echo -e "${CYAN}  EvoSuite Metrics Collector${NC}"
echo -e "${CYAN}=============================================${NC}"
echo ""
log_info "Results Directory: $RESULTS_DIR"
echo ""

# Check for Python
if ! command -v python3 &> /dev/null; then
    log_error "Python 3 is required but not found"
    exit 1
fi

# Run Python metrics collector
log_info "Collecting metrics from all endpoints..."
python3 "${LIB_DIR}/metrics_collector.py" "$RESULTS_DIR"

# Count endpoints and runs
ENDPOINT_COUNT=$(find "$RESULTS_DIR" -maxdepth 1 -type d -name "endpoint_*" | wc -l | tr -d ' ')
RUN_COUNT=$(find "$RESULTS_DIR" -type d -name "run_*" | wc -l | tr -d ' ')

echo ""
log_info "Summary:"
echo "  Endpoints processed: $ENDPOINT_COUNT"
echo "  Total runs: $RUN_COUNT"

# Count successes and failures
SUCCESSFUL=$(find "$RESULTS_DIR" -name "exit-status.json" -exec grep -l '"runs_without_error": true' {} \; 2>/dev/null | wc -l | tr -d ' ')
FAILED=$((RUN_COUNT - SUCCESSFUL))

echo "  Successful runs: $SUCCESSFUL"
echo "  Failed runs: $FAILED"

# Calculate average generation time
AVG_TIME=$(find "$RESULTS_DIR" -name "resource-metrics.json" -exec cat {} \; 2>/dev/null | \
    grep '"duration_seconds"' | \
    awk -F': ' '{sum+=$2; count++} END {if(count>0) printf "%.1f", sum/count; else print "0"}')

echo "  Avg generation time: ${AVG_TIME}s"

# Count tests generated
TESTS_GENERATED=$(find "$RESULTS_DIR" -name "resource-metrics.json" -exec cat {} \; 2>/dev/null | \
    grep '"tests_generated"' | \
    awk -F': ' '{sum+=$2} END {print sum+0}')

echo "  Total tests generated: $TESTS_GENERATED"

echo ""
log_success "Metrics collection complete"

# Create summary JSON
SUMMARY_FILE="${RESULTS_DIR}/metrics-summary.json"
cat > "$SUMMARY_FILE" << EOF
{
    "collection_timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "results_directory": "$RESULTS_DIR",
    "endpoints_processed": $ENDPOINT_COUNT,
    "total_runs": $RUN_COUNT,
    "successful_runs": $SUCCESSFUL,
    "failed_runs": $FAILED,
    "average_generation_time_sec": $AVG_TIME,
    "total_tests_generated": $TESTS_GENERATED
}
EOF

log_info "Summary saved to: $SUMMARY_FILE"
