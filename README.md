# Kubernetes Multi-Cloud Deployment with Environments

This repository provides a Kubernetes multi-cloud deployment setup with three environments: **dev**, **staging**, and **prod**. It uses **ArgoCD** for GitOps, **Prometheus** for monitoring, and **Grafana** for visualization. The architecture supports deployment on a single cloud provider or a redundant setup across multiple clouds (e.g., AWS, GCP, Azure).

## Features
- **Three Environments**: Separate namespaces for `dev`, `staging`, and `prod` with tailored resource configurations.
- **GitOps with ArgoCD**: Automates deployment and synchronization of Kubernetes manifests.
- **Monitoring with Prometheus**: Collects metrics from each environment.
- **Visualization with Grafana**: Provides dashboards for monitoring data, accessible per environment.
- **Multi-Cloud Support**: Deploy on one or multiple Kubernetes clusters across different cloud providers.
- **Extensible**: Add your application manifests in `manifests/environments/<env>/`.

## Prerequisites
- Kubernetes clusters (e.g., AWS EKS, GCP GKE, Azure AKS) with `kubectl` configured.
- `kubectl` and `kubeconfig` set up with contexts for each cluster (e.g., `dev-cluster`, `staging-cluster`, `prod-cluster`).
- Helm (optional, for manual chart installations).
- GitHub repository access to store this project.

## Setup Instructions

### 1. Clone the Repository

git clone https://github.com/<your-username>/k8s-multi-cloud-deployment.git
cd k8s-multi-cloud-deployment


### 2. Configure Kubernetes Clusters
Update scripts/setup-clusters.sh with your cluster details (e.g., AWS EKS, GCP GKE, Azure AKS). Example for AWS EKS:

chmod +x scripts/setup-clusters.sh
./scripts/setup-clusters.sh

**Verify contexts**:

kubectl config get-contexts

### 3. Update Repository URL
Replace <your-username> in manifests/applications/*.yaml with your GitHub username.

### 4. Deploy to a Cluster
Run the deployment script for a specific cluster and environment:

chmod +x scripts/apply-configs.sh
./scripts/apply-configs.sh <context-name> <environment>

**Example: ./scripts/apply-configs.sh dev-cluster dev**

Repeat for other environments:

./scripts/apply-configs.sh staging-cluster staging
./scripts/apply-configs.sh prod-cluster prod

### 5. Access ArgoCD
Get the ArgoCD server URL for the cluster:

kubectl -n argocd get svc argocd-server

**Access ArgoCD UI via the LoadBalancer IP. Retrieve the admin password:**

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d


### 6. Access Grafana
Get the Grafana service URL for the environment:

kubectl -n <environment> get svc grafana

**Example: kubectl -n dev get svc grafana**
Access Grafana via the LoadBalancer IP. Default credentials: admin/admin.

### 7. Multi-Cloud Redundancy
To deploy across multiple clouds for an environment:
Configure additional clusters in scripts/setup-clusters.sh (e.g., GCP or Azure for prod).
Run apply-configs.sh for each cluster context and environment:

./scripts/apply-configs.sh gcp-prod-cluster prod
./scripts/apply-configs.sh azure-prod-cluster prod

ArgoCD will sync the same manifests across all clusters, ensuring consistency.

Environment Configurations
**Dev: Lower resource limits (e.g., 512Mi memory for Prometheus) for development.**
**Staging: Moderate resources to mimic production but with less scale.**
**Prod: Higher resources (e.g., 2Gi memory for Prometheus) for production reliability.**

### Extending the Project
Add application manifests in manifests/environments/<env>/.

Create new ArgoCD Application resources in manifests/applications/ to manage them.

Customize Grafana dashboards or Prometheus ServiceMonitors in manifests/environments/<env>/.


### Troubleshooting
ArgoCD Sync Issues: Check the ArgoCD UI for sync status and logs.

Prometheus/Grafana Issues: Verify ServiceMonitors and Pod status in the environment namespace:

kubectl -n <environment> get pods

Cluster Access: Ensure kubectl contexts are correctly configured.

### Contributing
Feel free to open issues or submit pull requests to improve this project.


### .gitignore
Kubernetes
*.kubeconfig
Local env files
.env *.local