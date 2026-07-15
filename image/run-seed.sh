#!/bin/bash
PROFILE="${SEED_PROFILE:-none}"

if [ "$PROFILE" = "none" ] || [ -z "$PROFILE" ]; then
    echo "[seed] No profile configured, vanilla instance."
    exit 0
fi

if [ ! -d "/seeds/$PROFILE" ]; then
    echo "[seed] ERROR: unknown profile '$PROFILE' — skipping seed" >&2
    exit 0
fi

cd /usr/src/paperless/src
for script in /seeds/"$PROFILE"/*.py; do
    echo "[seed] running $(basename "$script")"
    python manage.py shell < "$script"
done
