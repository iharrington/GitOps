FROM 123456789011.dkr.ecr.us-west-1.amazonaws.com/mirrors/ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
  TERRAFORM_VERSION=1.12.2 \
  AWS_CLI_VERSION=2.31.26 \
  AWS_CLI_SHA256="fca9d80afb77f4cf5f2df6078b30ebb123b40e5b070ee7c1d5c3fba92d6b3755" \
  HELM_VERSION=3.17.3 \
  HELM_SHA256="ee88b3c851ae6466a3de507f7be73fe94d54cbf2987cbaa3d1a3832ea331f2cd" \
  YQ_VERSION=4.44.3 \
  YQ_SHA256="a347ccde5e32c607670e15526e295c58a555a68cbb36d15cf18d24fd7af0e2fd"

# Install base packages and dependencies
RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends \
  curl unzip jq git ca-certificates gnupg lsb-release groff less \
  && rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
  && unzip terraform.zip \
  && mv terraform /usr/local/bin/terraform \
  && rm terraform.zip

# Install AWS CLI v2 with checksum validation
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o awscliv2.zip \
  && echo "${AWS_CLI_SHA256}  awscliv2.zip" | sha256sum -c - \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -rf aws awscliv2.zip

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
  apt-get install -y -qq --no-install-recommends azure-cli && \
  rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
  rm -f kubectl

# Install Helm
RUN curl -fsSL "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" -o helm.tar.gz \
  && echo "${HELM_SHA256}  helm.tar.gz" | sha256sum -c - \
  && tar -zxvf helm.tar.gz \
  && mv linux-amd64/helm /usr/local/bin/helm \
  && rm -rf linux-amd64 helm.tar.gz

# Install yq
RUN curl -fsSL "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64.tar.gz" -o yq.tar.gz \
  && echo "${YQ_SHA256}  yq.tar.gz" | sha256sum -c - \
  && tar -xzf yq.tar.gz \
  && mv yq_linux_amd64 /usr/local/bin/yq \
  && chmod +x /usr/local/bin/yq \
  && rm yq.tar.gz

# Verify versions
RUN terraform version \
  && aws --version \
  && az version \
  && kubectl version --client \
  && helm version --short \
  && jq --version \
  && yq --version
