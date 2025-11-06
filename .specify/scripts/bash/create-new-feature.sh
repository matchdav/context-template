#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

usage() { echo "Usage: $0 --number N --short-name slug [--json] <feature description>"; }

number=""; short=""; json=false
while (( $# )); do
  case $1 in
    --number) number=$2; shift 2 ;;
    --short-name) short=$2; shift 2 ;;
    --json) json=true; shift ;;
    *) desc+="$1 " ; shift ;;
  esac
done

desc=${desc:-}
[ -n "$number" ] || die "--number required"
[ -n "$short" ] || die "--short-name required"
[ -n "$desc" ] || die "feature description required"

branch="${number}-${short}"
info "Creating branch $branch"

git checkout -b "$branch" || die "Failed to create branch"
mkdir -p "specs/${branch}"

spec_file="specs/${branch}/spec.md"
cat > "$spec_file" <<EOF
# Feature Specification: $desc

**Feature Branch**: \

(Generated skeleton; populate via speckit.specify.)
EOF

if $json; then
  cat <<JSON
{
  "BRANCH_NAME": "$branch",
  "SPEC_FILE": "$(repo_root)/$spec_file"
}
JSON
else
  info "Spec file created at $spec_file"
fi
