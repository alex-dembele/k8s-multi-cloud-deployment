#!/bin/bash
# Setup multiple Kubernetes clusters for multi-cloud deployment

# Example for AWS EKS
echo "Configuring AWS EKS cluster for dev..."
aws eks --region us-west-2 update-kubeconfig --name dev-cluster --alias dev-cluster

echo "Configuring AWS EKS cluster for staging..."
aws eks --region us-east-1 update-kubeconfig --name staging-cluster --alias staging-cluster

echo "Configuring AWS EKS cluster for prod..."
aws eks --region eu-west-1 update-kubeconfig --name prod-cluster --alias prod-cluster

# Example for GCP GKE (optional for multi-cloud)
# echo "Configuring GCP GKE cluster..."
# gcloud container clusters get-credentials prod-cluster --zone us-central1-a --project my-gcp-project --name gcp-prod-cluster

# Example for Azure AKS (optional for multi-cloud)
# echo "Configuring Azure AKS cluster..."
# az aks get-credentials --resource-group myResourceGroup --name prod-cluster --name azure-prod-cluster

echo "Available contexts:"
kubectl config get-contexts