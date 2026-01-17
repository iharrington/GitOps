# 🏗 Jena-Fuseki EKS Architecture

This document describes the architecture and deployment of **Apache Jena Fuseki** on Amazon EKS using GitOps principles with Flux and Helm.

---

## 1. Overview

Jena-Fuseki is a SPARQL server and RDF triple store, used to host and query semantic web data.  
The deployment follows a GitOps workflow, where configuration and Helm charts are managed declaratively in a Git repository and synchronized by Flux.

Key aspects:

- Isolated **namespace** (`jena-fuseki`) for all resources.
- Deployment via **HelmRelease**, monitored and reconciled by Flux.
- Helm chart stored in an **OCI repository** (AWS ECR).
- Configurable resource requests, limits, and storage through values/ConfigMaps.
- **RBAC** enforces controlled access to pods, logs, and exec actions for end-users.

---

## 2. Namespace Isolation

All Jena-Fuseki resources (pods, services, PVCs, etc.) are contained in a dedicated Kubernetes namespace called `jena-fuseki`.  
This provides:

- Resource isolation from other workloads.
- Simplified RBAC and policy enforcement.
- Clear separation for monitoring and metrics.

---

## 3. GitOps Deployment with Flux

The deployment uses **Flux** to maintain the desired state:

- **HelmRelease** defines the Jena-Fuseki release and references values stored in Git (ConfigMap/values.yaml).
- Flux continuously reconciles the cluster state to match the declared HelmRelease.
- Updates to the Helm chart or values in Git trigger automated deployment changes.

Benefits:

- Consistent, reproducible deployments.
- Easy rollback by reverting Git commits.
- Reduced manual intervention.

---

## 4. Configuration and Customization

Resource allocation, storage size, node selectors, tolerations, and other runtime parameters are defined in central configuration (values/ConfigMaps):

- Requests and limits for CPU and memory.
- Persistent volume storage class and size (for RDF dataset persistence).
- Optional node selectors or tolerations for scheduling.
- Environment variables for Jena/Fuseki tuning.

This allows teams to adjust performance and capacity without modifying Helm charts directly.

---

## 5. Access Control (RBAC)

End-user access is controlled using Kubernetes Roles and RoleBindings:

- Users can read pod logs, list resources, and perform exec operations in the `jena-fuseki` namespace.
- Full administrative privileges are restricted to operators.
- Ensures secure and auditable access to the service.

---

## 6. Summary

The Jena-Fuseki deployment on EKS leverages:

- **Namespace isolation** for clean separation from other workloads.
- **GitOps with Flux and Helm** for declarative, reproducible deployments.
- **Centralized configuration** for flexible resource and storage tuning.
- **RBAC policies** to secure access for end-users.

This architecture supports scalable, maintainable, and secure operation of Jena-Fuseki as a SPARQL endpoint and RDF data store in your cloud environment.
