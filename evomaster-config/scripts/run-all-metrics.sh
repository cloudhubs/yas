#!/bin/bash

# Script to run code_metrics.py on all EvoMaster test files

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTS_DIR="$SCRIPT_DIR/../../generated-tests/blackbox"
METRICS_SCRIPT="$SCRIPT_DIR/code_metrics.py"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Collecting metrics from all EvoMaster tests ===${NC}\n"

# Check if metrics script exists
if [ ! -f "$METRICS_SCRIPT" ]; then
    echo -e "${YELLOW}Error: Metrics script not found: $METRICS_SCRIPT${NC}"
    exit 1
fi

# Counter
TOTAL=0
PROCESSED=0

# Count total files
TOTAL=$(find "$TESTS_DIR" -name "*.java" -type f | wc -l)
echo -e "${YELLOW}Total test files: $TOTAL${NC}\n"

# Process each file
find "$TESTS_DIR" -name "*.java" -type f | sort | while read -r TEST_FILE; do
    PROCESSED=$((PROCESSED + 1))
    
    # Extract path info
    # Format: .../ts-SERVICE/ROLE/FILE.java
    REL_PATH="${TEST_FILE#$TESTS_DIR/}"
    SERVICE=$(echo "$REL_PATH" | cut -d'/' -f1)
    ROLE=$(echo "$REL_PATH" | cut -d'/' -f2)
    FILENAME=$(basename "$TEST_FILE")
    TEST_DIR=$(dirname "$TEST_FILE")
    
    echo -e "${BLUE}[$PROCESSED/$TOTAL]${NC} $SERVICE/$ROLE/$FILENAME"
    
    # Run metrics script from the test file's directory so JSON is saved there
    (cd "$TEST_DIR" && python3 "$METRICS_SCRIPT" "$FILENAME" --json)
    
    if [ $? -eq 0 ]; then
        echo -e "  ${GREEN}✓${NC} JSON saved to $SERVICE/$ROLE/"
    else
        echo -e "  ${YELLOW}⚠ Error processing${NC}"
    fi
done

echo -e "\n${GREEN}=== Processing complete ===${NC}"

