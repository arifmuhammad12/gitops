FROM jenkins/jenkins:lts-jdk21

LABEL maintainer="Reza Naipospos <rezanaipospos@gmail.com>"
LABEL description="Pre-configured Jenkins LTS Image for DevOps Engineering Course"

# Switch to root to install system tools & Docker CLI
USER root

# Install prerequisites & Docker CLI
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    wget \
    jq \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    docker-ce-cli \
    docker-compose-plugin \
    docker-buildx-plugin \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install KinD CLI (untuk load image ke KinD cluster via shared Docker socket)
RUN curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-$(dpkg --print-architecture) \
    && chmod +x /usr/local/bin/kind

# Install Aqua Security Trivy for DevSecOps scanning
RUN curl -fsSL https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor -o /etc/apt/keyrings/trivy.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" > /etc/apt/sources.list.d/trivy.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends trivy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
