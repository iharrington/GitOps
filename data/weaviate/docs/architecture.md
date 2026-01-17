# 🏗 Weaviate EKS Architecture

This document describes the architecture and deployment of **Weaviate** on Amazon EKS using GitOps principles with Flux and Helm.

---

## 1. Overview

Weaviate is a vector database deployed on EKS to provide fast, scalable similarity search.  
The deployment follows a GitOps workflow, where configuration and Helm charts are managed declaratively in a Git repository and synchronized by Flux.

Key aspects:

- Isolated **namespace** (`weaviate`) for all resources.
- Deployment via **HelmRelease**, monitored and reconciled by Flux.
- Helm chart stored in an **OCI repository** (AWS ECR).
- Configurable resource requests, limits, storage, and GPU scheduling via a **ConfigMap**.
- **RBAC** enforces controlled access to pods, logs, and exec actions for end-users.

---

## 2. Namespace Isolation

All Weaviate resources (pods, services, PVCs, etc.) are contained in a dedicated Kubernetes namespace called `weaviate`.  
This provides:

- Resource isolation from other workloads.
- Simpler RBAC management.
- Clear separation for monitoring and metrics.

---

## 3. GitOps Deployment with Flux

The deployment uses **Flux** to maintain the desired state:

- **HelmRelease** defines the Weaviate release and references values stored in a ConfigMap.
- Flux periodically reconciles the cluster state to match the declared HelmRelease.
- Updates to the Helm chart or values in Git trigger automated deployment changes.

Benefits:

- Consistent, reproducible deployments.
- Easy rollback by reverting Git commits.
- Reduced manual intervention.

---

## 4. Configuration and Customization

Resource allocation, storage size, node selectors, tolerations, and other runtime parameters are defined in a central ConfigMap:

- Requests and limits for CPU, memory, and GPU.
- Persistent volume storage class and size.
- Node selection for GPU-enabled nodes.
- Tolerations for GPU scheduling.

This allows end-users to adjust performance and capacity without modifying Helm charts directly.

---

## 5. Access Control (RBAC)

End-user access is controlled using Kubernetes Roles and RoleBindings:

- Users can read pod logs, list resources, and perform exec operations in the Weaviate namespace.
- Full administrative privileges are restricted.
- Ensures secure and auditable access to the database pods.

---

## 6. Summary

The Weaviate deployment on EKS leverages:

- **Namespace isolation** for safe multi-tenant operation.
- **GitOps with Flux and Helm** for declarative, reproducible deployments.
- **Centralized configuration** via ConfigMaps for flexibility.
- **RBAC policies** to secure access for end-users.

This architecture supports scalable, maintainable, and secure operations for Weaviate as a vector database in your cloud environment.
