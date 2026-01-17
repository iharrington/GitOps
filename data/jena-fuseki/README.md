# Jena-Fuseki

[Apache Jena Fuseki](https://jena.apache.org/documentation/fuseki2/) is an HTTP interface to RDF data, providing a SPARQL 1.1 server.
This repository contains the Flux-based deployment manifests and configuration for running Jena-Fuseki on AWS EKS.

## Overview

Jena-Fuseki provides:

* A SPARQL 1.1 query and update endpoint.
* Persistent storage of RDF datasets (backed by TDB2 or external stores).
* A modular and extensible architecture for semantic web applications.

This deployment uses:

* **AWS EKS** for Kubernetes cluster.
* **Flux** for GitOps-style management.
* **Helm** for deploying the Jena-Fuseki chart.
* **ECR** for storing the Helm chart as an OCI artifact.

## Repository Structure

```
jena-fuseki/
├── base
│   ├── helmrelease.yaml
│   ├── kustomization.yaml
│   ├── namespace.yaml
│   ├── ocirepository.yaml
│   └── rbac.yaml
├── catalog-info.yaml
├── docs
│   ├── architecture.md
│   ├── index.md
│   └── jena-eks-user-guide.md
├── gitrepository.yaml
├── mkdocs.yml
├── overlays
│   ├── dev
│   │   ├── kustomization-flux.yaml #<-- Flux Kustomization (Flux CRD in cluster)
│   │   ├── kustomization.yaml #<-- Kustomize manifest (kubectl/kustomize thing)
│   │   ├── kustomizeconfig.yaml #<-- Custom merge/patch behavior
│   │   ├── secret.yaml #<-- Plain Kubernetes Secret (for shiro)
│   │   └── values.yaml #<-- Helm values (consumed by HelmRelease)
│   ├── prod
│   │   └── kustomization.yaml
│   └── staging
│       └── kustomization.yaml
└── README.md
```

## Deployment

### Prerequisites

* Flux installed in the cluster (`flux-system` namespace).
* Service accounts annotated with IAM roles that have **ECR read access**.
* Helm chart mirrored to private ECR repo.

### Apply Manifests (via Flux)

This repository is intended to be fully managed by Flux. Once Flux is pointing at the repo and the overlays are committed, it will automatically reconcile the HelmRelease and keep Jena-Fuseki up to date.

#### Quickstart: Manual Flux Bootstrap

For a new environment, you may need to apply the Flux Kustomization once manually to bootstrap reconciliation:

```bash
kubectl apply -f overlays/dev/kustomization-flux.yaml
```

Replace `dev` with `staging` or `prod` as appropriate. After this first apply, Flux takes over.

### Optional: Apply with Kustomize (manual testing / dev)

If you need to test deployments manually, you can apply the environment overlay with Kustomize:

```bash
kubectl apply -k overlays/dev
```

Swap dev with staging or prod depending on the environment.

> ⚠️ Note: Manual kubectl apply is only needed for local testing or debugging. In production, Flux handles all deployments automatically.

## Configuration

Overrides are defined in the `values/` ConfigMap and Secret. Example parameters include:

* **Datasets** — configuration for TDB2 or in-memory datasets.
* **Authentication** — basic authentication via `shiro.ini` or custom auth.
* **CPU / Memory** requests and limits.
* **Persistence** (EBS volume size, storage class).
* **Node selectors / tolerations** if you want to control scheduling.
* **Other Helm chart-specific settings**.

Flux will pass these values to the Helm chart during deployment.

## CI/CD Integration

A GitLab pipeline can deploy Jena-Fuseki automatically:

* Assumes an IAM role for EKS access.
* Applies namespace, OCIRepository, HelmRelease, and values ConfigMap/Secret.
* Can override cluster name and environment via pipeline variables.

### Branch-to-Environment Mapping

* **Feature branches (non-MR, non-main):** Deploy to `dev` overlay.
* **Merge Requests:** Deploy to `staging` overlay.
* **Main branch:** Deploy to `prod` overlay.

This ensures that feature development is tested in dev, validated in staging, and only merged into production once approved.

## References

* [Apache Jena Fuseki Documentation](https://jena.apache.org/documentation/fuseki2/)
* [Flux Helm Controller](https://fluxcd.io/docs/components/helm/helmreleases/)
* [AWS EKS and IRSA](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)

## Notes

* Authentication and access control are configured via `shiro.ini`.
* ECR authentication is handled via IRSA; no secrets are stored in the cluster.
* Namespace must exist before deploying HelmRelease.
