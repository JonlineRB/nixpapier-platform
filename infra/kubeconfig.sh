#!/usr/bin/env bash
set -euo pipefail

HOST=nixppr-1
OUT="$HOME/.kube/nixppr-1.yaml"
PORT=16443

# forget the old host key (a rebuilt server has a new one)
IP=$(ssh -G "$HOST" | awk '/^hostname /{print $2}')
ssh-keygen -R "$IP" >/dev/null 2>&1 || true

# wait for sshd to come up (up to about 5 minutes)
for i in $(seq 1 60); do
  ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new "$HOST" true 2>/dev/null && break
  sleep 5
done

# wait until cloud-init (including the k3s install) is finished
ssh -o StrictHostKeyChecking=accept-new "$HOST" \
  'cloud-init status --wait >/dev/null; until sudo test -s /etc/rancher/k3s/k3s.yaml; do sleep 2; done'

# fetch the kubeconfig and point it at the tunnel port
ssh "$HOST" 'sudo cat /etc/rancher/k3s/k3s.yaml' \
  | sed -e "s#https://127.0.0.1:6443#https://127.0.0.1:${PORT}#" -e 's/: default/: nixppr-1/' > "$OUT"
chmod 600 "$OUT"

# restart the tunnel in the background
pkill -f "L ${PORT}:127.0.0.1:6443" || true
ssh -f -N -o ExitOnForwardFailure=yes -L "${PORT}:127.0.0.1:6443" "$HOST"

echo "Done. In your shell run: set -x KUBECONFIG $OUT"
