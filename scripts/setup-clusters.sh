#!/bin/bash
#!/bin/bash
# Setup multiple Kubernetes clusters for multi-cloud deployment

usage() {
	cat <<EOF
Usage: $0 [providers...]
If no providers are supplied the script will run the AWS EKS example configuration.

Supported providers: aws gcp azure

Examples:
	$0                # runs the AWS example
	$0 aws gcp        # runs AWS and GCP config examples

Note: This script contains examples. Replace cluster names, regions and project names
with your actual cluster identifiers before running in production.
EOF
}

configure_aws() {
	echo "Configuring AWS EKS cluster for dev..."
	aws eks --region us-west-2 update-kubeconfig --name dev-cluster --alias dev-cluster || true

	echo "Configuring AWS EKS cluster for staging..."
	aws eks --region us-east-1 update-kubeconfig --name staging-cluster --alias staging-cluster || true

	echo "Configuring AWS EKS cluster for prod..."
	aws eks --region eu-west-1 update-kubeconfig --name prod-cluster --alias prod-cluster || true
}

configure_gcp() {
	echo "Configuring GCP GKE cluster example (update with your project/zone)..."
	# Replace with your GCP project/zone/cluster names
	# gcloud container clusters get-credentials my-gke-cluster --zone us-central1-a --project my-gcp-project
}

configure_azure() {
	echo "Configuring Azure AKS cluster example (update with your resource-group/cluster)..."
	# Replace with your Azure resource group and cluster name
	# az aks get-credentials --resource-group myResourceGroup --name myAksCluster
}

if [ "$#" -eq 0 ]; then
	configure_aws
else
	for p in "$@"; do
		case "$p" in
			aws) configure_aws ;;
			gcp) configure_gcp ;;
			azure|aks) configure_azure ;;
			-h|--help) usage; exit 0 ;;
			*) echo "Unknown provider: $p"; usage; exit 1 ;;
		esac
	done
fi

echo "Available contexts:"
kubectl config get-contexts || true