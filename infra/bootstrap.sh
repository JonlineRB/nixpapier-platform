#!/usr/bin/env bash
set -euo pipefail

: "${ACME_EMAIL:?set ACME_EMAIL first, e.g. in fish: set -Ux ACME_EMAIL you@example.com}"

# always target the Hetzner cluster, whatever the calling shell has set
export KUBECONFIG="$HOME/.kube/nixppr-1.yaml"

helm repo add jetstack https://charts.jetstack.io >/dev/null 2>&1 || true
helm repo update >/dev/null

helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager --create-namespace \
  --version v1.21.3 \
  --set crds.enabled=true \
  --wait --timeout 5m

# the cert-manager webhook needs a few seconds before it accepts issuers
for i in $(seq 1 12); do
  sed "s/YOUR-EMAIL/${ACME_EMAIL}/" "$(dirname "$0")/cluster-issuers.yaml" | kubectl apply -f - && break
  sleep 5
done

kubectl get clusterissuer
