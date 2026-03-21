#!/bin/bash

# =============================================================================
# Generate EvoSuite Tests for All YAS Microservices
# =============================================================================
#
# Usage:
#   ./run-all-services.sh
#
# Environment Variables:
#   SEARCH_BUDGET - Time in seconds per class (default: 60)
#   CORES        - Number of CPU cores to use (default: 4)
#   SERVICES     - Space-separated list of services (default: all)
#
# Examples:
#   # Run with defaults
#   ./run-all-services.sh
#
#   # Run with custom budget
#   SEARCH_BUDGET=120 ./run-all-services.sh
#
#   # Run only specific services
#   SERVICES="product order cart" ./run-all-services.sh
#
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
SEARCH_BUDGET="${SEARCH_BUDGET:-60}"
CORES="${CORES:-4}"

# All YAS microservices (excluding BFFs, common-library, and services with heavy Kafka deps)
# Note: search and recommendation are skipped due to Kafka dependencies
ALL_SERVICES=(
    "product"
    "order"
    "cart"
    "customer"
    "inventory"
    "payment"
    "promotion"
    "rating"
    "location"
    "tax"
    "media"
    "webhook"
    "sampledata"
    "delivery"
)

# Use provided services or all
if [ -n "$SERVICES" ]; then
    IFS=' ' read -ra SERVICE_LIST <<< "$SERVICES"
else
    SERVICE_LIST=("${ALL_SERVICES[@]}")
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Results tracking
SUCCESSFUL=()
FAILED=()
SKIPPED=()

echo -e "${BLUE}========================================================${NC}"
echo -e "${BLUE}  EvoSuite Batch Test Generation for YAS${NC}"
echo -e "${BLUE}========================================================${NC}"
echo ""
echo -e "Services to process: ${#SERVICE_LIST[@]}"
echo -e "Search Budget:       ${SEARCH_BUDGET}s per class"
echo -e "Cores:               ${CORES}"
echo ""

START_TIME=$(date +%s)

for i in "${!SERVICE_LIST[@]}"; do
    service="${SERVICE_LIST[$i]}"
    progress=$((i + 1))

    echo -e "${BLUE}========================================================${NC}"
    echo -e "${BLUE}  [$progress/${#SERVICE_LIST[@]}] Processing: ${service}${NC}"
    echo -e "${BLUE}========================================================${NC}"

    SERVICE_DIR="${PROJECT_ROOT}/${service}"

    if [ ! -d "$SERVICE_DIR" ]; then
        echo -e "${YELLOW}Skipping: Directory not found${NC}"
        SKIPPED+=("$service")
        continue
    fi

    if [ ! -f "$SERVICE_DIR/pom.xml" ]; then
        echo -e "${YELLOW}Skipping: No pom.xml found${NC}"
        SKIPPED+=("$service")
        continue
    fi

    # Run EvoSuite
    if SEARCH_BUDGET="$SEARCH_BUDGET" CORES="$CORES" "$SCRIPT_DIR/run-evosuite.sh" "$service"; then
        SUCCESSFUL+=("$service")
        echo -e "${GREEN}Success: ${service}${NC}"
    else
        FAILED+=("$service")
        echo -e "${RED}Failed: ${service}${NC}"
    fi

    echo ""
done

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# =============================================================================
# Summary Report
# =============================================================================
echo -e "${BLUE}========================================================${NC}"
echo -e "${BLUE}  Batch Processing Complete${NC}"
echo -e "${BLUE}========================================================${NC}"
echo ""
echo -e "Total Time: $((DURATION / 60))m $((DURATION % 60))s"
echo ""

echo -e "${GREEN}Successful (${#SUCCESSFUL[@]}):${NC}"
for s in "${SUCCESSFUL[@]}"; do
    echo -e "  - $s"
done

if [ ${#FAILED[@]} -gt 0 ]; then
    echo ""
    echo -e "${RED}Failed (${#FAILED[@]}):${NC}"
    for s in "${FAILED[@]}"; do
        echo -e "  - $s"
    done
fi

if [ ${#SKIPPED[@]} -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}Skipped (${#SKIPPED[@]}):${NC}"
    for s in "${SKIPPED[@]}"; do
        echo -e "  - $s"
    done
fi

echo ""
echo -e "${BLUE}========================================================${NC}"
echo -e "Generated tests are in each service's evosuite-tests/ directory"
echo -e "${BLUE}========================================================${NC}"

# Exit with error if any failed
if [ ${#FAILED[@]} -gt 0 ]; then
    exit 1
fi
