#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

FEATURE_DIR="specs"
[ -d "$FEATURE_DIR" ] || mkdir -p "$FEATURE_DIR"
AVAILABLE_DOCS=(spec plan tasks checklist)

missing=()
for cmd in git; do command -v $cmd >/dev/null || missing+=("$cmd"); done
if (( ${#missing[@]} )); then die "Missing required commands: ${missing[*]}"; fi

require_tasks=false
include_tasks=false
for arg in "$@"; do
  case $arg in
    --require-tasks) require_tasks=true ;;
    --include-tasks) include_tasks=true ;;
    --json) ;; # ignore
  esac
done

if $require_tasks && [ ! -f tasks/tasks.md ]; then die "Task list required but not found"; fi

json_out=$(cat <<EOF
{
  "FEATURE_DIR": "$(repo_root)/$FEATURE_DIR",
  "AVAILABLE_DOCS": ["spec","plan","tasks","checklist"],
  "includeTasks": $include_tasks
}
EOF
)

echo "$json_out"
