---
id: weaviate-eks-user-guide
title: Weaviate EKS User Guide
description: How to connect to the EKS cluster and work with Weaviate safely
---

# 🚀 Weaviate EKS User Guide

This guide explains how to connect to the EKS cluster, set up your tools, and interact with Weaviate pods safely.

---

## 1. Prerequisites

### Install AWS CLI

**Windows (CMD / PowerShell):**
1. Download the installer: [AWS CLI MSI](https://awscli.amazonaws.com/AWSCLIV2.msi)
2. Run installer → next, next, finish.
3. Verify:
   ```powershell
   aws --version
   ```

**Windows Subsystem for Linux (WSL):**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

---

### Install `kubectl`

**Windows (CMD/PowerShell):**
```powershell
choco install kubernetes-cli -y
kubectl version --client
```

**WSL (Linux):**
```bash
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client
```

---

### Install Optional GUI

- **Freelens** → GUI for Kubernetes  
  Download: [https://github.com/MuhammedKalkan/OpenLens](https://github.com/MuhammedKalkan/OpenLens)

---

## 2. Logging Into AWS

We use **AWS SSO** for authentication.

## 2. Logging Into AWS

We use **AWS SSO** for authentication.

1. Configure SSO profile (one-time setup):
   ```bash
   aws configure sso
   ```
   - SSO start URL: `https://start.us-gov-west-1.us-gov-home.awsapps.com/directory/d-986776d931#`
   - Region: `us-gov-west-1` (or your cluster region)
   - SSO account ID: `123456789011`
   - SSO role name: `DBA`
  
  Ensure you set this as the profile name `DBA` or the following commands won't work properly

2. Login before each session:
   ```bash
   aws sso login --profile DBA 
   ```

---

## 3. Retrieve EKS Kubeconfig

Run this after logging in:
```bash
SSO_PROFILE="DBA"
ROLE_ARN="arn:aws-us-gov:iam::123456789011:role/dba-eks-role"
ASSUME_PROFILE="dba-eks"
REGION="us-west-1"
EKS_CLUSTER="isaac-eks-cluster"
aws configure set region "$REGION" --profile "$ASSUME_PROFILE"
aws configure set role_arn "$ROLE_ARN" --profile "$ASSUME_PROFILE"
aws configure set source_profile "$SSO_PROFILE" --profile "$ASSUME_PROFILE"
aws eks update-kubeconfig --region "$REGION" --name "$EKS_CLUSTER" --profile "$ASSUME_PROFILE"
```

---

## 4. Set Default Namespace

To avoid typing `-n weaviate` every time:

```bash
kubectl config set-context --current --namespace=weaviate
```

Verify:
```bash
kubectl get pods -n weaviate
```

---

## 5. Common Workflows

### 🔌 Port-Forward Weaviate
This makes Weaviate available locally at `http://localhost:8080`.

```bash
kubectl port-forward svc/weaviate 8080:80 -n weaviate
```

Leave this running in a terminal window → now connect your SDKs/clients to `localhost:8080`.

---

### 📜 Check Pod Logs
List pods:
```bash
kubectl get pods -n weaviate
```

Check logs of one pod:
```bash
kubectl logs -f -l app.kubernetes.io/name=weaviate -n weaviate
```

---

### 🔄 Restart a Pod *(if allowed)*
Delete pod → Kubernetes will auto-create a replacement:
```bash
kubectl delete pod -l app.kubernetes.io/name=weaviate -n weaviate
```

---

### 🖥 GUI: Freelens
1. Open **Freelens**
2. “Add Cluster” → point to your kubeconfig (usually `~/.kube/config`)
3. Browse pods, view logs, and port-forward with right-clicks.

---

## 6. Good Practices

- ✅ Always use the **`weaviate` namespace**
- ✅ Prefer **port-forward** for database access
- 🚫 Don’t run `kubectl delete` outside of restart workflows
- 🔒 Your access is logged; follow least privilege
