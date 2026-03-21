# EvoSuite Docker Image for YAS Microservices
# Builds EvoSuite v1.2.0 from source and provides a ready-to-use environment

FROM maven:3.8.6-eclipse-temurin-11 AS builder

# Build EvoSuite from source
WORKDIR /evosuite-build
RUN git clone https://github.com/EvoSuite/evosuite.git && \
    cd evosuite && \
    git checkout v1.2.0 && \
    mvn package -DskipTests -q

# Runtime image
FROM eclipse-temurin:11-jdk

LABEL maintainer="YAS Project"
LABEL description="EvoSuite v1.2.0 for automated test generation"

# Copy EvoSuite JARs from builder
COPY --from=builder /evosuite-build/evosuite/master/target/evosuite-master-1.2.0.jar /opt/evosuite/evosuite.jar
COPY --from=builder /evosuite-build/evosuite/standalone_runtime/target/evosuite-standalone-runtime-1.2.0.jar /opt/evosuite/evosuite-runtime.jar

# Create wrapper script that includes project dependencies in classpath
# This solves the RMI serialization issue where master process needs Spring classes
# Uses CLASSPATH env var which is inherited by child processes (master spawns client via RMI)
COPY <<'EOF' /opt/evosuite/run-evosuite.sh
#!/bin/bash
# Build classpath from project dependencies if available
EXTRA_CP=""
if [ -d "/project/target/dependency" ]; then
    for jar in /project/target/dependency/*.jar; do
        if [ -f "$jar" ]; then
            EXTRA_CP="$EXTRA_CP:$jar"
        fi
    done
fi
if [ -d "/project/target/classes" ]; then
    EXTRA_CP="/project/target/classes$EXTRA_CP"
fi
# Export CLASSPATH so child processes (RMI spawned) also have access to dependencies
export CLASSPATH="/opt/evosuite/evosuite.jar$EXTRA_CP"
# Run EvoSuite with the jar option
exec java -Xmx4g -jar /opt/evosuite/evosuite.jar "$@"
EOF
RUN chmod +x /opt/evosuite/run-evosuite.sh

# Create symlinks for easier access
RUN ln -s /opt/evosuite/evosuite.jar /usr/local/bin/evosuite.jar && \
    ln -s /opt/evosuite/evosuite-runtime.jar /usr/local/bin/evosuite-runtime.jar

# Set working directory
WORKDIR /project

# Default environment variables
ENV SEARCH_BUDGET=120
ENV CORES=4

# Set wrapper script as entrypoint
ENTRYPOINT ["/opt/evosuite/run-evosuite.sh"]

# Default command shows help
CMD ["-help"]
