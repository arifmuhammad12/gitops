# ==========================================
# Stage 1: Get Trivy binary directly from official multi-arch image
# ==========================================
FROM aquasec/trivy:0.59.1 AS trivy-source

# ==========================================
# Stage 2: Final Jenkins Image
# ==========================================
FROM jenkins/jenkins:lts-jdk21

LABEL maintainer="Reza Naipospos <rezanaipospos@gmail.com>"
LABEL description="Optimized Lightweight Jenkins LTS for DevOps Course"

USER root

# Install minimal prerequisites, Docker CLI & KinD CLI
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    git \
    jq \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    docker-ce-cli \
    docker-compose-plugin \
    docker-buildx-plugin \
    # Install KinD CLI (for KinD cluster image loading)
    && curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-$(dpkg --print-architecture) \
    && chmod +x /usr/local/bin/kind \
    # Clean up APT caches
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy Trivy static binary from Stage 1
COPY --from=trivy-source /usr/local/bin/trivy /usr/local/bin/trivy

# Give jenkins user access to docker socket
RUN groupadd -f docker && usermod -aG docker jenkins

# Copy JCasC configuration & plugins list
COPY jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# Disable Jenkins Setup Wizard and set JCasC path
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV CASC_JENKINS_CONFIG="/usr/share/jenkins/ref/jenkins.yaml"

# Switch back to jenkins user and install plugins
USER jenkins
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt \
    && rm -rf /tmp/* ~/.cache
