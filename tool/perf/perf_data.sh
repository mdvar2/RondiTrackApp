#!/usr/bin/env bash
# Adds or removes the 300 test contributions (README "Performance").
#
#   tool/perf/perf_data.sh add      # before a DevTools pass
#   tool/perf/perf_data.sh remove   # after it: exactly those rows go
#
# Local only: it connects to localhost and refuses any other host. The
# database defaults to the mobile seed (ronditrack_mobile); the password
# comes from PGPASSWORD, never from this repository.
set -euo pipefail

action="${1:-}"
db="${PERF_DB:-ronditrack_mobile}"
psql="${PSQL:-psql}"
here="$(cd "$(dirname "$0")" && pwd)"

case "$action" in
  add) script="$here/add_test_contributions.sql" ;;
  remove) script="$here/remove_test_contributions.sql" ;;
  *) echo "Usage: $0 add|remove" >&2; exit 2 ;;
esac

if [ -z "${PGPASSWORD:-}" ]; then
  echo "Set PGPASSWORD to your local PostgreSQL password first." >&2
  exit 2
fi

"$psql" -h localhost -U "${PGUSER:-postgres}" -d "$db" -f "$script"
