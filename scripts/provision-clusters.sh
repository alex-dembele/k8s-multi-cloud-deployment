#!/bin/bash
# Wrapper to provision clusters for providers you choose (example scripts)
# Usage: ./scripts/provision-clusters.sh aws|gcp|azure [args...]

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <provider> [provider-args]"
  echo "Providers: aws gcp azure"
  exit 1
fi

PROVIDER=$1
shift

case "$PROVIDER" in
  aws)
    ./scripts/provision-eks.sh "$@"
    ;;
  gcp)
    ./scripts/provision-gke.sh "$@"
    ;;
  azure|aks)
    ./scripts/provision-aks.sh "$@"
    ;;
  *)
    echo "Unknown provider: $PROVIDER"
    exit 2
    ;;
esac
