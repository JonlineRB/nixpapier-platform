#!/bin/bash
# Source with:  . /usr/local/bin/restic-env.sh
: "${BACKUP_SSH_HOST:?BACKUP_SSH_HOST not set}"
: "${BACKUP_SSH_USER:?BACKUP_SSH_USER not set}"
BACKUP_SSH_PORT="${BACKUP_SSH_PORT:-23}"
BACKUP_SSH_KEY="${BACKUP_SSH_KEY:-/keys/ssh-key}"

export SFTP_CMD="ssh -p ${BACKUP_SSH_PORT} -i ${BACKUP_SSH_KEY} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${BACKUP_SSH_USER}@${BACKUP_SSH_HOST} -s sftp"

# Where the Postgres dump lives inside the container. Backup and restore must
# agree, because restic records this absolute path in the snapshot.
export DUMP_PATH="${DUMP_PATH:-/tmp/dump.sql}"

restic() { command restic -o sftp.command="$SFTP_CMD" "$@"; }
