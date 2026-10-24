#!/bin/bash
# healthchecks.io helpers. Source with:  . /usr/local/bin/hc.sh
#   hc_init "<uuid>"      empty uuid = alerting disabled
#   hc_ping [start|fail]  no argument = success ping
#   hc_fail_on_error      any non-zero exit sends a /fail ping

hc_init() {
  HC_BASE=""
  if [ -n "${1:-}" ]; then
    HC_BASE="${HC_BASE_URL:-https://hc-ping.com}/$1"
  fi
}

hc_ping() {
  [ -n "${HC_BASE:-}" ] || return 0
  curl -fsS -m 10 --retry 3 "${HC_BASE}${1:+/$1}" >/dev/null 2>&1 || true
}

_hc_on_exit() {
  local rc=$?
  if [ "$rc" -ne 0 ]; then hc_ping fail; fi
  exit "$rc"
}

hc_fail_on_error() { trap _hc_on_exit EXIT; }
