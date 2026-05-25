#!/bin/bash
# Deploy a given environment to multiple cluster contexts using apply-configs.sh

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <environment> <context1> [context2 ...]"
  echo "Example: $0 prod aws-prod-cluster gcp-prod-cluster azure-prod-cluster"
  exit 1
fi

ENV=$1
shift

for CONTEXT in "$@"; do
  echo "\n--- Deploying environment '$ENV' to context '$CONTEXT' ---"
  ./scripts/apply-configs.sh "$CONTEXT" "$ENV" || {
    echo "Deployment to $CONTEXT failed"
  }
done

echo "All deployments attempted."
