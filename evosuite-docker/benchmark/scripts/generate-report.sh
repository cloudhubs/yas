#!/bin/bash

# =============================================================================
# EvoSuite Benchmark Report Generator
# =============================================================================
#
# Purpose: Generate final CSV report from benchmark results
#
# Usage:
#   ./generate-report.sh <results_dir> [options]
#
# Options:
#   --merge-manual    Merge manual evaluation data from markdown files
#   --analyze-tests   Run test analyzer on generated tests
#
# Output:
#   - benchmark-results.csv       (main research data)
#   - detailed-metrics.csv        (raw metrics)
#   - test-analysis.json          (if --analyze-tests)
#
# =============================================================================

set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BENCHMARK_DIR="$(dirname "$SCRIPT_DIR")"
LIB_DIR="${BENCHMARK_DIR}/lib"
CONFIG_DIR="${BENCHMARK_DIR}/config"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Options
MERGE_MANUAL=false
ANALYZE_TESTS=false

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

print_usage() {
    echo "Usage: $0 <results_dir> [options]"
    echo ""
    echo "Options:"
    echo "  --merge-manual    Merge manual evaluation data from markdown files"
    echo "  --analyze-tests   Run test analyzer on generated tests"
    echo ""
    echo "Example:"
    echo "  $0 results/run_20251211_120000"
    echo "  $0 results/run_20251211_120000 --merge-manual"
}

# Parse arguments
if [ $# -lt 1 ]; then
    print_usage
    exit 1
fi

RESULTS_DIR="$1"
shift

while [[ $# -gt 0 ]]; do
    case $1 in
        --merge-manual)
            MERGE_MANUAL=true
            shift
            ;;
        --analyze-tests)
            ANALYZE_TESTS=true
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

if [ ! -d "$RESULTS_DIR" ]; then
    log_error "Results directory not found: $RESULTS_DIR"
    exit 1
fi

echo -e "${CYAN}=============================================${NC}"
echo -e "${CYAN}  EvoSuite Report Generator${NC}"
echo -e "${CYAN}=============================================${NC}"
echo ""
log_info "Results Directory: $RESULTS_DIR"
log_info "Merge Manual: $MERGE_MANUAL"
log_info "Analyze Tests: $ANALYZE_TESTS"
echo ""

# Check for Python
if ! command -v python3 &> /dev/null; then
    log_error "Python 3 is required but not found"
    exit 1
fi

# Step 1: Generate main CSV
log_info "Generating benchmark results CSV..."

PYTHON_ARGS="$RESULTS_DIR"
if [ "$MERGE_MANUAL" = true ]; then
    PYTHON_ARGS="$PYTHON_ARGS --merge-manual"
fi

python3 "${LIB_DIR}/csv_generator.py" $PYTHON_ARGS

if [ $? -eq 0 ]; then
    log_success "CSV files generated"
else
    log_error "CSV generation failed"
    exit 1
fi

# Step 2: Analyze tests if requested
if [ "$ANALYZE_TESTS" = true ]; then
    log_info "Analyzing generated tests..."

    for endpoint_dir in "$RESULTS_DIR"/endpoint_*; do
        if [ -d "$endpoint_dir" ]; then
            endpoint_id=$(basename "$endpoint_dir" | sed 's/endpoint_//')

            # Check each run for generated tests
            for run_dir in "$endpoint_dir"/run_*; do
                tests_dir="$run_dir/generated-tests"
                if [ -d "$tests_dir" ] && [ "$(ls -A "$tests_dir" 2>/dev/null)" ]; then
                    log_info "Analyzing tests in: $tests_dir"
                    python3 "${LIB_DIR}/test_analyzer.py" "$tests_dir" > "$run_dir/test-analysis.json" 2>&1
                fi
            done
        fi
    done

    log_success "Test analysis complete"
fi

# Step 3: Generate summary statistics
log_info "Generating summary statistics..."

CSV_FILE="${RESULTS_DIR}/benchmark-results.csv"
if [ -f "$CSV_FILE" ]; then
    # Count rows (excluding header)
    TOTAL_ROWS=$(tail -n +2 "$CSV_FILE" | wc -l | tr -d ' ')

    # Count successful vs failed
    SUCCESSFUL=$(grep -c "SUCCESS" "$CSV_FILE" 2>/dev/null || echo "0")
    FAILED=$(grep -c "FAILED" "$CSV_FILE" 2>/dev/null || echo "0")

    # Count N/A values for manual fields
    MANUAL_NA=$(grep -o "N/A" "$CSV_FILE" | wc -l | tr -d ' ')

    echo ""
    echo -e "${CYAN}Report Statistics:${NC}"
    echo "  Total data rows: $TOTAL_ROWS"
    echo "  Successful generations: $SUCCESSFUL"
    echo "  Failed generations: $FAILED"
    echo "  Manual evaluation fields (N/A): $MANUAL_NA"
fi

echo ""
echo -e "${CYAN}Generated Files:${NC}"
echo "  - ${RESULTS_DIR}/benchmark-results.csv"
echo "  - ${RESULTS_DIR}/detailed-metrics.csv"

if [ -f "${RESULTS_DIR}/metrics-summary.json" ]; then
    echo "  - ${RESULTS_DIR}/metrics-summary.json"
fi

if [ "$ANALYZE_TESTS" = true ]; then
    test_analysis_count=$(find "$RESULTS_DIR" -name "test-analysis.json" | wc -l | tr -d ' ')
    if [ "$test_analysis_count" -gt 0 ]; then
        echo "  - ${test_analysis_count} test-analysis.json files"
    fi
fi

echo ""
echo -e "${YELLOW}Next Steps:${NC}"
if [ "$MERGE_MANUAL" = false ]; then
    echo "  1. Complete manual-evaluation.md checklists in each endpoint directory"
    echo "  2. Re-run with --merge-manual to update CSV with manual evaluations:"
    echo "     ./generate-report.sh $RESULTS_DIR --merge-manual"
else
    echo "  1. Import benchmark-results.csv into your analysis tool"
    echo "  2. Review detailed-metrics.csv for raw data"
fi

echo ""
log_success "Report generation complete"
