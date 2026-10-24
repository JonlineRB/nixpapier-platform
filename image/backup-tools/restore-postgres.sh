#!/bin/bash
set -Eeuo pipefail

. /usr/local/bin/hc.sh
hc_init "${HC_RESTORE_UUID:-}"
hc_fail_on_error

. /usr/local/bin/restic-env.sh

SNAPSHOT="${RESTORE_SNAPSHOT:-latest}"
STAGE_DIR="${STAGE_DIR:-/initdb}"
TMP=/restore-tmp

echo "[restore-postgres] restoring snapshot '$SNAPSHOT' (tag postgres)..."
restic restore "$SNAPSHOT" --tag postgres --target "$TMP"
cp "${TMP}${DUMP_PATH}" "${STAGE_DIR}/dump.sql"
echo "Postgres dump staged for restore."
