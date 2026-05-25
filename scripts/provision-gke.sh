#!/bin/bash
# Example: provision a simple GKE cluster with gcloud
# Replace project/zone/cluster names as needed. Requires gcloud SDK configured.

PROJECT=${1:-my-gcp-project}
CLUSTER_NAME=${2:-example-gke-cluster}
ZONE=${3:-us-central1-a}
NUM_NODES=${4:-2}

echo "Provisioning GKE cluster '${CLUSTER_NAME}' in ${PROJECT}/${ZONE} (nodes=${NUM_NODES})"

if ! command -v gcloud >/dev/null 2>&1; then
  echo "gcloud is not installed. Install from https://cloud.google.com/sdk/docs/install"
  exit 1
fi

gcloud container clusters create "$CLUSTER_NAME" \
  --project "$PROJECT" \
  --zone "$ZONE" \
  --num-nodes "$NUM_NODES" \
  --machine-type "e2-medium"

echo "GKE cluster provisioning command completed (check gcloud output for status)."