# Bootstrap Multi-Cloud — Guide pas-à-pas

Ce guide explique comment utiliser les scripts du dépôt pour provisionner des clusters (exemples), configurer les contexts `kubectl`, et déployer l'infrastructure GitOps + une application sample.

Pré-requis
- `kubectl` configuré
- Un ou plusieurs CLI clouds selon votre provider: `aws` + `eksctl`, `gcloud`, `az`
- `git` (pour cloner le repo sur la machine qui exécutera ArgoCD)

1) Provisionner des clusters (exemples)

- AWS EKS (eksctl):

```bash
# crée un cluster EKS exemple
./scripts/provision-clusters.sh aws example-eks-cluster us-west-2 2
```

- GKE (gcloud):

```bash
./scripts/provision-clusters.sh gcp my-gcp-project example-gke-cluster us-central1-a 2
```

- AKS (az):

```bash
./scripts/provision-clusters.sh azure myResourceGroup example-aks-cluster westeurope 2
```

2) Vérifier les contexts `kubectl`

```bash
kubectl config get-contexts
```

Assurez-vous que les contexts attendus apparaissent (ex: `dev-cluster`, `staging-cluster`, `prod-cluster` ou les noms créés lors du provisioning).

3) Déployer ArgoCD, monitoring, et applications sur un cluster

```bash
# déployer sur un contexte unique
./scripts/apply-configs.sh <context-name> <environment> [repo-url]

# Exemple
./scripts/apply-configs.sh dev-cluster dev
```

Le script va appliquer:
- `manifests/argocd/*` (namespace + install Application qui installe ArgoCD via helm chart)
- `manifests/environments/<env>/namespace.yaml` et `kube-prometheus-stack.yaml` (ArgoCD Application qui installe le chart kube-prometheus-stack)
- `manifests/applications/root-app.yaml` et `manifests/applications/<env>-app.yaml` pour gérer le déploiement GitOps.

4) Déployer le même environnement sur plusieurs clusters

```bash
# déployer prod sur plusieurs contexts
./scripts/deploy-multi-cloud.sh prod aws-prod-cluster gcp-prod-cluster azure-prod-cluster
```

5) Application sample

Les manifests `manifests/environments/<env>/sample-app.yaml` contiennent une application `sample-app` (nginx) pour valider le pipeline. ArgoCD applicera ces manifests via les Applications `<env>-app`.

6) Personnalisation et sécurité
- Remplacez les exemples de noms de repo dans `manifests/applications/*.yaml` par votre repo si besoin, ou utilisez le paramètre `repo-url` dans `apply-configs.sh`.
- Ajoutez un gestionnaire de secrets (SealedSecrets, HashiCorp Vault, ExternalSecrets) selon votre stratégie.
- Configurez Ingress et certificats TLS (cert-manager + issuer) pour exposer services.

Support & bonnes pratiques
- Gardez les manifests immuables dans git et gérez les changements via PRs.
- Utilisez des modules Terraform / IaC si vous voulez provisionner les clusters de manière reproductible.

