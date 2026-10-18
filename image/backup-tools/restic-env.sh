#!/bin/sh
# Source with:  . /usr/local/bin/restic-env.sh
: "${BACKUP_SSH_HOST:?BACKUP_SSH_HOST not set}"
: "${BACKUP_SSH_USER:?BACKUP_SSH_USER not set}"
BACKUP_SSH_PORT="${BACKUP_SSH_PORT:-23}"
BACKUP_SSH_KEY="${BACKUP_SSH_KEY:-/keys/ssh-key}"

export SFTP_CMD="ssh -p ${BACKUP_SSH_PORT} -i ${BACKUP_SSH_KEY} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${BACKUP_SSH_USER}@${BACKUP_SSH_HOST} -s sftp"

# After sourcing, plain `restic ...` always carries the right SFTP options
restic() { command restic -o sftp.command="$SFTP_CMD" "$@"; }
