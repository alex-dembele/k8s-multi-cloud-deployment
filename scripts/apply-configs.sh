#!/bin/bash
# Apply configurations to a specific cluster and environment

CONTEXT=$1
ENV=$2
REPO_URL=${3:-}

if [ -z "$CONTEXT" ] || [ -z "$ENV" ]; then
  echo "Usage: ./apply-configs.sh <context-name> <environment> [repo-url]"
  echo "Example: ./apply-configs.sh dev-cluster dev https://github.com/youruser/yourrepo"
  exit 1
fi

if [[ ! "$ENV" =~ ^(dev|staging|prod)$ ]]; then
  echo "Environment must be one of: dev, staging, prod"
  exit 1
fi

# verify context exists
if ! kubectl config get-contexts -o name | grep -q "^${CONTEXT}$"; then
  echo "Error: kubectl context '${CONTEXT}' not found"
  exit 2
fi

echo "Switching to context $CONTEXT"
kubectl config use-context "$CONTEXT"

echo "Applying ArgoCD namespace and installation"
kubectl apply -f manifests/argocd/namespace.yaml
kubectl apply -f manifests/argocd/install.yaml

echo "Applying $ENV namespace and configurations"
kubectl apply -f manifests/environments/$ENV/namespace.yaml
kubectl apply -f manifests/environments/$ENV/kube-prometheus-stack.yaml

echo "Preparing ArgoCD Applications (root + ${ENV})"
# If a custom repo URL is provided, patch the ArgoCD Application manifests in-memory before applying
if [ -n "$REPO_URL" ]; then
  echo "Using custom repo URL: $REPO_URL"
  kubectl apply -f - <<EOF
$(sed "s|https://github.com/alex-dembele/k8s-multi-cloud-deployment|$REPO_URL|g" manifests/applications/root-app.yaml)
EOF
  kubectl apply -f - <<EOF
$(sed "s|https://github.com/alex-dembele/k8s-multi-cloud-deployment|$REPO_URL|g" manifests/applications/${ENV}-app.yaml)
EOF
else
  kubectl apply -f manifests/applications/root-app.yaml
  kubectl apply -f manifests/applications/${ENV}-app.yaml
fi

echo "Done applying manifests to context ${CONTEXT} for environment ${ENV}."