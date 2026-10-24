#!/bin/bash
set -Eeuo pipefail

# Alerting first, so any later failure (even missing config) is reported.
. /usr/local/bin/hc.sh
hc_init "${HC_UUID:-}"
hc_fail_on_error
hc_ping start

. /usr/local/bin/restic-env.sh

MEDIA_DIR="${MEDIA_DIR:-/usr/src/paperless/media}"
KEEP_DAILY="${KEEP_DAILY:-7}"
KEEP_WEEKLY="${KEEP_WEEKLY:-4}"
KEEP_MONTHLY="${KEEP_MONTHLY:-12}"

echo "[backup] dumping postgres..."
pg_dump > "$DUMP_PATH"

echo "[backup] backing up postgres dump..."
restic backup "$DUMP_PATH" --tag postgres

echo "[backup] backing up media..."
restic backup "$MEDIA_DIR" --tag media

echo "[backup] pruning old snapshots..."
for tag in postgres media; do
  restic forget --tag "$tag" \
    --keep-daily "$KEEP_DAILY" --keep-weekly "$KEEP_WEEKLY" --keep-monthly "$KEEP_MONTHLY" --prune
done

echo "[backup] done."
hc_ping
