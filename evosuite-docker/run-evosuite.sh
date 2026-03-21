#!/bin/bash

# =============================================================================
# EvoSuite Docker Runner for YAS Microservices
# =============================================================================
#
# This script handles the Java 21 -> Java 11 cross-compilation challenge
# by using Spring Boot 2.7.x (which supports Java 11) with javax.* packages.
#
# Usage:
#   ./run-evosuite.sh <service-name> [class-name]
#
# =============================================================================

# Note: Not using 'set -e' to allow capturing full output even on failures

# Configuration
SERVICE_NAME="${1:-product}"
CLASS_NAME="${2:-}"
SEARCH_BUDGET="${SEARCH_BUDGET:-120}"
CORES="${CORES:-4}"
CRITERION="${CRITERION:-LINE:BRANCH:EXCEPTION:WEAKMUTATION:OUTPUT:METHOD}"

# Paths
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SERVICE_DIR="${PROJECT_ROOT}/${SERVICE_NAME}"

# Colors for output (disabled when piped or LOG_FILE is set)
if [ -t 1 ] && [ -z "$LOG_FILE" ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}  EvoSuite Test Generation for YAS${NC}"
echo -e "${BLUE}=============================================${NC}"
echo ""
echo -e "Service:       ${GREEN}${SERVICE_NAME}${NC}"
echo -e "Search Budget: ${SEARCH_BUDGET} seconds"
if [ -n "$CLASS_NAME" ]; then
    echo -e "Target Class:  ${YELLOW}${CLASS_NAME}${NC}"
fi
echo ""

# Check if service exists
if [ ! -d "$SERVICE_DIR" ]; then
    echo -e "${RED}Error: Service directory not found: $SERVICE_DIR${NC}"
    exit 1
fi

# =============================================================================
# Step 1: Create evosuite-compat directory with modified sources
# =============================================================================
echo -e "${BLUE}Step 1: Creating Java 11 compatible sources...${NC}"
echo ""

# Create working directory
WORK_DIR="${SERVICE_DIR}/.evosuite-work"
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR/src/main/java"

# Copy source files
cp -r "${SERVICE_DIR}/src/main/java/"* "$WORK_DIR/src/main/java/" 2>/dev/null || true

# Convert jakarta.* to javax.* in all Java files (YAS uses jakarta.* from Spring Boot 4)
echo "Converting jakarta.* to javax.* imports..."
find "$WORK_DIR/src" -name "*.java" -exec sed -i.bak \
    -e 's/jakarta\.persistence/javax.persistence/g' \
    -e 's/jakarta\.validation/javax.validation/g' \
    -e 's/jakarta\.servlet/javax.servlet/g' \
    -e 's/jakarta\.annotation/javax.annotation/g' \
    -e 's/jakarta\.transaction/javax.transaction/g' \
    {} \;

# Remove backup files
find "$WORK_DIR/src" -name "*.bak" -delete

# Remove Java record files (Java 16+ feature not supported in Java 11)
echo "Removing Java record files (not supported in Java 11)..."
find "$WORK_DIR/src" -name "*.java" -exec grep -l "public record " {} \; 2>/dev/null | while read -r file; do
    echo "  Removing record: $(basename "$file")"
    rm -f "$file"
done

# Convert Java text blocks (Java 15+) to regular strings
echo "Converting Java text blocks to regular strings..."
find "$WORK_DIR/src" -name "*.java" | while read -r file; do
    if grep -q '"""' "$file" 2>/dev/null; then
        echo "  Converting text blocks in: $(basename "$file")"
        # Use Python for reliable multi-line text block conversion
        python3 -c "
import re
import sys

with open('$file', 'r') as f:
    content = f.read()

# Pattern to match text blocks: \"\"\"...\"\"\"
def convert_text_block(match):
    text = match.group(1)
    # Remove leading/trailing whitespace from each line, join with space
    lines = [line.strip() for line in text.strip().split('\n') if line.strip()]
    return '\"' + ' '.join(lines) + '\"'

# Replace text blocks with regular strings
content = re.sub(r'\"\"\"(.*?)\"\"\"', convert_text_block, content, flags=re.DOTALL)

with open('$file', 'w') as f:
    f.write(content)
" 2>/dev/null || true
    fi
done

# Remove problematic files that won't compile (YAS-specific patterns)
# Security configs (OAuth2/Keycloak)
rm -f "$WORK_DIR/src/main/java/com/yas/"*/config/SecurityConfig.java 2>/dev/null || true
rm -f "$WORK_DIR/src/main/java/com/yas/"*/config/SecurityProperties.java 2>/dev/null || true
rm -f "$WORK_DIR/src/main/java/com/yas/"*/config/WebSecurityConfig.java 2>/dev/null || true

# Application entry points
rm -f "$WORK_DIR/src/main/java/com/yas/"*/*Application.java 2>/dev/null || true

# Kafka directories (affects: search, recommendation, common-library)
rm -rf "$WORK_DIR/src/main/java/com/yas/"*/kafka/ 2>/dev/null || true

# OpenFeign clients (external service calls)
rm -rf "$WORK_DIR/src/main/java/com/yas/"*/service/client/ 2>/dev/null || true

# OpenTelemetry/observability configs
rm -f "$WORK_DIR/src/main/java/com/yas/"*/config/*Telemetry*.java 2>/dev/null || true
rm -f "$WORK_DIR/src/main/java/com/yas/"*/config/*Tracing*.java 2>/dev/null || true

# Elasticsearch configs (search service)
rm -f "$WORK_DIR/src/main/java/com/yas/"*/config/ElasticsearchConfig.java 2>/dev/null || true
rm -f "$WORK_DIR/src/main/java/com/yas/"*/config/*Elastic*.java 2>/dev/null || true

# Swagger/OpenAPI configs
rm -f "$WORK_DIR/src/main/java/com/yas/"*/config/SwaggerConfig.java 2>/dev/null || true
rm -f "$WORK_DIR/src/main/java/com/yas/"*/config/OpenApiConfig.java 2>/dev/null || true

# Create pom.xml with Spring Boot 2.7.x (Java 11 compatible)
cat > "$WORK_DIR/pom.xml" << 'EVOPOM'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.7.18</version>
        <relativePath/>
    </parent>
    <groupId>com.yas</groupId>
    <artifactId>evosuite-compat</artifactId>
    <version>0.0.1-SNAPSHOT</version>

    <properties>
        <java.version>11</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-api</artifactId>
            <version>0.10.8</version>
        </dependency>
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>javax.servlet-api</artifactId>
            <version>4.0.1</version>
            <scope>provided</scope>
        </dependency>
        <!-- MapStruct for mapper interfaces -->
        <dependency>
            <groupId>org.mapstruct</groupId>
            <artifactId>mapstruct</artifactId>
            <version>1.5.5.Final</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <source>11</source>
                    <target>11</target>
                    <failOnError>false</failOnError>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-dependency-plugin</artifactId>
                <version>3.6.0</version>
            </plugin>
        </plugins>
    </build>
</project>
EVOPOM

echo -e "${GREEN}Created Java 11 compatible sources${NC}"
echo ""

# =============================================================================
# Step 2: Compile with Java 11 and copy dependencies
# =============================================================================
echo -e "${BLUE}Step 2: Compiling with Java 11 and Spring Boot 2.7.x...${NC}"
echo ""

# Clear old Maven cache for this project to avoid conflicts
docker run --rm \
    -v "evosuite-maven-java11:/root/.m2" \
    maven:3.8.6-eclipse-temurin-11 \
    rm -rf /root/.m2/repository/com/yas 2>/dev/null || true

# Compile and copy dependencies
docker run --rm \
    -v "$WORK_DIR:/project" \
    -v "evosuite-maven-java11:/root/.m2" \
    -w /project \
    maven:3.8.6-eclipse-temurin-11 \
    mvn clean compile dependency:copy-dependencies -DskipTests 2>&1 | grep -E "(ERROR|Building|Compiling|Copying|BUILD)" || true

# Check if classes were generated
if [ ! -d "$WORK_DIR/target/classes" ]; then
    echo -e "${RED}Error: target/classes directory not created${NC}"
    exit 1
fi

CLASS_COUNT=$(find "$WORK_DIR/target/classes" -name "*.class" 2>/dev/null | wc -l | tr -d ' ')
if [ "$CLASS_COUNT" -eq 0 ]; then
    echo -e "${RED}Error: No class files generated${NC}"
    exit 1
fi

DEP_COUNT=$(find "$WORK_DIR/target/dependency" -name "*.jar" 2>/dev/null | wc -l | tr -d ' ')

echo -e "${GREEN}Compilation completed! Generated ${CLASS_COUNT} class files and copied ${DEP_COUNT} dependencies.${NC}"
echo ""

# =============================================================================
# Step 3: Check EvoSuite Docker image
# =============================================================================
echo -e "${BLUE}Step 3: Checking EvoSuite Docker image...${NC}"

EVOSUITE_IMAGE="evosuite-yas:1.2.0"

if ! docker image inspect "$EVOSUITE_IMAGE" > /dev/null 2>&1; then
    echo -e "${YELLOW}Building EvoSuite Docker image...${NC}"
    docker build -t "$EVOSUITE_IMAGE" "$SCRIPT_DIR"
else
    echo -e "${GREEN}EvoSuite Docker image ready${NC}"
fi
echo ""

# =============================================================================
# Step 4: Run EvoSuite with full classpath
# =============================================================================
echo -e "${BLUE}Step 4: Running EvoSuite...${NC}"
echo ""

# Create output directories
mkdir -p "${SERVICE_DIR}/evosuite-tests"
mkdir -p "${SERVICE_DIR}/evosuite-report"

# Build classpath including all dependencies (EvoSuite doesn't support wildcard *)
# Create a classpath file with all JARs - this file is used by EvoSuite master process
docker run --rm \
    -v "$WORK_DIR:/project" \
    -w /project \
    eclipse-temurin:11-jdk \
    bash -c 'echo -n "/project/target/classes"; for jar in /project/target/dependency/*.jar; do echo -n ":$jar"; done' > "$WORK_DIR/classpath.txt"

EVOSUITE_CP=$(cat "$WORK_DIR/classpath.txt")
echo "Classpath has $(echo "$EVOSUITE_CP" | tr ':' '\n' | wc -l | tr -d ' ') entries"
echo ""

# Write classpath to a file that EvoSuite master can read (solves RMI serialization issue)
# The master process needs the same classpath to deserialize test cases from client
echo "$EVOSUITE_CP" > "$WORK_DIR/evosuite_cp.txt"

if [ -n "$CLASS_NAME" ]; then
    echo -e "Generating tests for: ${YELLOW}${CLASS_NAME}${NC}"
    echo ""

    # Use -generateMOSuite for multi-objective test generation
    # This mode works reliably with Spring dependencies
    docker run --rm \
        -v "$WORK_DIR:/project" \
        -v "${SERVICE_DIR}/evosuite-tests:/project/evosuite-tests" \
        -v "${SERVICE_DIR}/evosuite-report:/project/evosuite-report" \
        -w /project \
        "$EVOSUITE_IMAGE" \
        -generateMOSuite \
        -class "$CLASS_NAME" \
        -projectCP "$EVOSUITE_CP" \
        -Dsearch_budget="${SEARCH_BUDGET}" \
        -Dcriterion="${CRITERION}" \
        -Dassertion_strategy=all \
        -Dminimize=true \
        -Dshow_progress=true
else
    echo -e "Generating tests for all classes"
    echo ""

    # For multiple classes, use -target with -generateMOSuite
    docker run --rm \
        -v "$WORK_DIR:/project" \
        -v "${SERVICE_DIR}/evosuite-tests:/project/evosuite-tests" \
        -v "${SERVICE_DIR}/evosuite-report:/project/evosuite-report" \
        -w /project \
        "$EVOSUITE_IMAGE" \
        -generateMOSuite \
        -target /project/target/classes \
        -projectCP "$EVOSUITE_CP" \
        -Dsearch_budget="${SEARCH_BUDGET}" \
        -Dcores="${CORES}" \
        -Dcriterion="${CRITERION}" \
        -Dassertion_strategy=all \
        -Dminimize=true \
        -Dshow_progress=true
fi

# =============================================================================
# Summary
# =============================================================================
echo ""
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}  EvoSuite Test Generation Complete!${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""
echo -e "Generated tests: ${SERVICE_DIR}/evosuite-tests/"
echo -e "Reports:         ${SERVICE_DIR}/evosuite-report/"

TEST_COUNT=$(find "${SERVICE_DIR}/evosuite-tests" -name "*_ESTest.java" 2>/dev/null | wc -l | tr -d ' ')
echo -e "Test files:      ${GREEN}${TEST_COUNT}${NC}"

if [ "$TEST_COUNT" -gt 0 ]; then
    echo ""
    echo "Generated test files:"
    find "${SERVICE_DIR}/evosuite-tests" -name "*_ESTest.java" | head -5 | sed 's/.*evosuite-tests\//  /'
fi
