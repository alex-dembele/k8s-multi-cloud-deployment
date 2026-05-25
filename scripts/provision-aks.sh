#!/bin/bash
# Example: provision a simple AKS cluster with az CLI
# Replace resource group/cluster names as needed. Requires Azure CLI configured.

RESOURCE_GROUP=${1:-myResourceGroup}
CLUSTER_NAME=${2:-example-aks-cluster}
LOCATION=${3:-westeurope}
NODE_COUNT=${4:-2}

echo "Provisioning AKS cluster '${CLUSTER_NAME}' in ${RESOURCE_GROUP}/${LOCATION} (nodes=${NODE_COUNT})"

if ! command -v az >/dev/null 2>&1; then
  echo "Azure CLI (az) is not installed. Install from https://learn.microsoft.com/cli/azure/install-azure-cli"
  exit 1
fi

az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
az aks create --resource-group "$RESOURCE_GROUP" --name "$CLUSTER_NAME" --node-count "$NODE_COUNT" --generate-ssh-keys

echo "AKS cluster provisioning command completed (check az output for status)."