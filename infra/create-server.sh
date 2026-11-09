hcloud server create \
  --name nixppr-1 \
  --type cpx22 \
  --image ubuntu-24.04 \
  --location nbg1 \
  --ssh-key CachyOS \
  --primary-ipv4 161525701 \
  --firewall nixppr-fw \
  --user-data-from-file infra/cloud-init.yaml
