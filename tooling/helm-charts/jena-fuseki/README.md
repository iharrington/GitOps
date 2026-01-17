# Apache Jena Fuseki

Internal Docker image and Helm chart for deploying Apache Jena Fuseki to Kubernetes clusters.

---

## Prerequisites

* [Helm](https://helm.sh/docs/)
* Kubernetes cluster (local dev: Minikube, kind, or cloud cluster like EKS)
* [Flux](https://fluxcd.io/) installed in the cluster

---

## Building and Publishing OCI Images

Both the Docker image and Helm chart are published as OCI artifacts to ECR.

### Build and Push Docker Image

```bash
# Build the Docker image
docker build -t <account-id>.dkr.ecr.<region>.amazonaws.com/jena-fuseki:<tag> .

# Authenticate with ECR
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

# Push the Docker image to ECR
docker push <account-id>.dkr.ecr.<region>.amazonaws.com/jena-fuseki:<tag>
```

### Package and Push Helm Chart as OCI Artifact

```bash
# Package the Helm chart
helm package helm/jena-fuseki --destination ./dist

# Push the Helm chart to ECR
helm push ./dist/jena-fuseki-<version>.tgz oci://<account-id>.dkr.ecr.<region>.amazonaws.com/helm/jena-fuseki
```

---

## Deployment

Deployments are fully managed via Flux using the `HelmRelease` in this repository:

[jena-fuseki](https://gitlab.com/devops/tooling/jena-fuseki)

Flux will automatically reconcile the HelmRelease and deploy resources to the target namespace.

### Recommended Dev/POC Configuration

* Persistence enabled with PVC of `10Gi`
* Single replica (`replicaCount: 1`)
* Shiro secret must be provided as a Kubernetes `Secret`

Example `values.yaml`:

```yaml
deployment:
  replicaCount: 1
image:
  repository: "123456789011.dkr.ecr.us-west-1.amazonaws.com/jena-fuseki"
  tag: "1.0.0"
  pullPolicy: IfNotPresent
service:
  type: ClusterIP
  port: 3030
ingressHostName: "jena-fuseki.dev.example.com"
persistence:
  enabled: true
  size: 10Gi
shiro:
  secretName: "jena-fuseki-secrets"
```

---

## Creating the Shiro Secret

Create a Kubernetes secret with the admin password to override the default `shiro.ini`:

```bash
kubectl create secret generic jena-fuseki-secrets \
  --namespace <namespace> \
  --from-file=shiro.ini=./shiro.ini
```

The HelmRelease references this secret via `.Values.shiro.secretName`.

---

## Accessing Jena Fuseki

### Port Forward

For local testing:

```bash
kubectl port-forward svc/<release-name>-svc 3030:3030 -n <namespace>
```

Then connect your clients to `http://localhost:3030`.

### Logs

```bash
kubectl logs -f statefulset/<release-name> -n <namespace>
```

### Restart Pods

```bash
kubectl delete pod -l app.kubernetes.io/instance=<release-name> -n <namespace>
```

Flux will automatically recreate the pod(s).

---

## Notes

* All resources are deployed in the namespace defined in the HelmRelease (`targetNamespace`).
* The HelmRelease is designed for **stateful deployment** using a StatefulSet with headless service for persistent storage.
* SecurityContext, Pod security policies, and RBAC can be enhanced later for production.
