#!/bin/bash
set -Eeuo pipefail

. /usr/local/bin/hc.sh

hc_init "${HC_RESTORE_UUID:-}"
hc_fail_on_error

SNAPSHOT="${RESTORE_SNAPSHOT:-latest}"
MEDIA_DIR="${MEDIA_DIR:-/usr/src/paperless/media}"
MARKER="${MEDIA_DIR}/.restore-complete"

if [ -f "$MARKER" ]; then
  echo "Media already restored, skipping."
  exit 0
fi

. /usr/local/bin/restic-env.sh

echo "[restore-media] restoring snapshot '$SNAPSHOT' (tag media)..."
restic restore "$SNAPSHOT" --tag media --target /
touch "$MARKER"
