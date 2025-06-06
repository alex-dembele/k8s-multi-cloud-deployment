#!/bin/bash
# Apply configurations to a specific cluster and environment

CONTEXT=$1
ENV=$2

if [ -z "$CONTEXT" ] || [ -z "$ENV" ]; then
  echo "Usage: ./apply-configs.sh <context-name> <environment>"
  echo "Example: ./apply-configs.sh dev-cluster dev"
  exit 1
fi

if [[ ! "$ENV" =~ ^(dev|staging|prod)$ ]]; then
  echo "Environment must be one of: dev, staging, prod"
  exit 1
fi

echo "Switching to context $CONTEXT"
kubectl config use-context $CONTEXT

echo "Applying ArgoCD namespace and installation"
kubectl apply -f manifests/argocd/namespace.yaml
kubectl apply -f manifests/argocd/install.yaml

echo "Applying $ENV namespace and configurations"
kubectl apply -f manifests/environments/$ENV/namespace.yaml
kubectl apply -f manifests/environments/$ENV/kube-prometheus-stack.yaml

echo "Applying root and $ENV application for ArgoCD"
kubectl apply -f manifests/applications/root-app.yaml
kubectl apply -f manifests/applications/$ENV-app.yaml