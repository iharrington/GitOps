# Weaviate

[Weaviate](https://weaviate.io) is a decentralized vector search engine.
This repository contains the Flux-based deployment manifests and configuration for running Weaviate on AWS EKS.

---

## Overview

This deployment provides:

* Vector search for unstructured data.
* Modular and extensible architecture.
* Optional GPU support for embeddings and inference.

This deployment uses:

* **AWS EKS** for the Kubernetes cluster.
* **Flux** for GitOps-style management.
* **Helm** for deploying the Weaviate chart (OCI in ECR).
* **ECR** for storing the Helm chart as an OCI artifact.
---

## Repository Structure

```
weaviate/
├── base
│   ├── helmrelease.yaml
│   ├── kustomization.yaml
│   ├── namespace.yaml
│   ├── ocirepository.yaml
│   └── rbac.yaml
├── catalog-info.yaml
├── docs/
├── gitrepository.yaml
├── mkdocs.yml
├── overlays/
│   ├── dev/
│   │   ├── kustomization-flux.yaml    # Flux Kustomization (applied into flux-system)
│   │   ├── kustomization.yaml         # kustomize build instructions for this overlay
│   │   ├── kustomizeconfig.yaml       # custom merge/patch behavior
│   │   └── values.yaml                # plain Helm values (consumed by HelmRelease via ConfigMap)
│   ├── prod/
│   └── staging/
└── README.md
```

> **Note:** `kustomization-flux.yaml` is a **Flux CRD** (kind: `Kustomization`) that must be applied into the `flux-system` namespace for Flux to begin reconciling this overlay. See the Quickstart below.

---

## Prerequisites

* Flux installed in the cluster (controllers and `flux-system` namespace).
* IAM roles / IRSA permissions for controllers (ECR read access if chart is in private ECR).
* Helm chart mirrored to private ECR (OCI) if using a private registry.
* Cluster DNS / networking (for Ingress/Gateway) if you intend to expose Weaviate externally.

---

## Quickstart — Getting Flux to reconcile this overlay

> These are the manual steps you must run once (or have your CI run) so Flux will start reconciling the `weaviate` overlay.

1. **Apply the GitRepository** (tells Flux where to fetch this repo):

```bash
kubectl apply -f gitrepository.yaml
```

2. **Apply the Flux Kustomization CR (in `flux-system`)** — this is the important glue that tells Flux *which path* inside the Git repo to apply and how often:

```bash
kubectl apply -f overlays/dev/kustomization-flux.yaml
```

> `kustomization-flux.yaml` should look like:

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: weaviate
  namespace: flux-system
spec:
  interval: 5m
  path: ./overlays/dev      # path relative to the root of THIS GitRepository
  prune: true
  sourceRef:
    kind: GitRepository
    name: weaviate          # must match the GitRepository resource name
  targetNamespace: weaviate
```

3. **(Optional) Create any Secrets** the overlay needs in `flux-system` (or let the overlay create them if intended). Example for a deploy token secret:

```bash
kubectl create secret generic gitlab-credentials \
  --namespace flux-system \
  --from-literal=username=<deploy-token-username> \
  --from-literal=password=<deploy-token> \
  --dry-run=client -o yaml | kubectl apply -f -
```

4. **Verify reconciliation**

```bash
# Does Flux have a Kustomization for weaviate?
flux get kustomizations -n flux-system

# Is the HelmRelease ready in the target namespace?
flux get helmreleases -n weaviate

# If a resource fails, look at logs from the controllers:
kubectl -n flux-system logs deploy/kustomize-controller
kubectl -n flux-system logs deploy/helm-controller
```

---

## How this wiring works (short)

* `GitRepository` → Flux pulls a tarball artifact of the repo.
* `Kustomization` (applied into `flux-system`) refers to that GitRepository and a `path:` inside it. The kustomize-controller runs `kustomize build` on that path and applies the rendered manifests.
* The rendered manifests include `HelmRelease` + `OCIRepository` resources. The Helm controller then installs the Helm chart (from ECR) into the `targetNamespace`.

---

## Common gotchas & troubleshooting

* **`kustomization path not found`** — `path:` is relative to the GitRepository root. Verify the repo contains that path.
* **Private Git repo access** — ensure a Secret with `username` + `password` is referenced by the `GitRepository` with `spec.secretRef.name`.
* **ConfigMap values not applied** — when using `configMapGenerator`, ensure the generated ConfigMap has the key `values.yaml` and your `HelmRelease` uses `valuesKey: values.yaml`.
* **Windows line endings** — remove `\r` (`dos2unix overlays/dev/values.yaml`) to avoid invisible characters that break YAML parsing.
* **Istio Gateway webhook** — if Helm patches a Gateway and Istio rejects it, either delete the Gateway and let Helm recreate it or add a `helm.sh/resource-policy: replace` annotation on the Gateway resource in the chart/overlay to force replace.

---

## CI/CD integration notes

* Your CI can `kubectl apply -f gitrepository.yaml` and `kubectl apply -f overlays/dev/kustomization-flux.yaml` as the bootstrap steps. After that Flux will keep the overlay reconciled.
* Alternatively, your CI can push the repo to GitLab and Flux will pick up updates automatically. The important bit is: **the Flux Kustomization CR must exist in the cluster** and point to the repo path.

---

## References

* [Flux Helm Controller](https://fluxcd.io/docs/components/helm/helmreleases/)
* [Flux Source Controller](https://fluxcd.io/docs/components/source/gitrepositories/)
* [Kustomize ConfigMapGenerator](https://kubectl.docs.kubernetes.io/references/kustomize/configmapgenerator/)
* [Weaviate Documentation](https://weaviate.io/developers/weaviate/current/)

