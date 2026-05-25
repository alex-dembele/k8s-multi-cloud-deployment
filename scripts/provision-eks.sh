#!/bin/bash
# Example: provision a simple EKS cluster with eksctl
# Replace names/regions/versions as needed. Requires eksctl and AWS CLI configured.

CLUSTER_NAME=${1:-example-eks-cluster}
REGION=${2:-us-west-2}
NODES=${3:-2}

echo "Provisioning EKS cluster '${CLUSTER_NAME}' in ${REGION} (nodes=${NODES})"

if ! command -v eksctl >/dev/null 2>&1; then
  echo "eksctl is not installed. Install from https://eksctl.io/"
  exit 1
fi

eksctl create cluster \
  --name "$CLUSTER_NAME" \
  --region "$REGION" \
  --nodegroup-name standard-workers \
  --node-type t3.medium \
  --nodes "$NODES" \
  --managed

echo "EKS cluster provisioning command completed (check eksctl output for status)."