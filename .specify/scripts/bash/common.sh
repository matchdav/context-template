#!/usr/bin/env bash
set -euo pipefail

color() { local c=$1; shift; printf "\033[%sm%s\033[0m" "$c" "$*"; }
info() { color 36 "[info]"; echo " $*"; }
warn() { color 33 "[warn]"; echo " $*"; }
err()  { color 31 "[error]"; echo " $*" 1>&2; }

ts() { date -u +%Y-%m-%dT%H:%M:%SZ; }

die() { err "$*"; exit 1; }

repo_root() { git rev-parse --show-toplevel 2>/dev/null || pwd; }
json_escape() { python -c 'import json,sys; print(json.dumps(sys.stdin.read()) )'; }

next_number_for() {
  local short=$1
  local max=0
  # specs dirs
  while IFS= read -r d; do
    local n=${d%%-*}; [[ $n =~ ^[0-9]+$ ]] && (( n>max )) && max=$n || true
  done < <(ls -1 specs 2>/dev/null | grep -E '^[0-9]+-' || true)
  # branches
  while IFS= read -r b; do
    local base=${b##*/}; local n=${base%%-*}; [[ $n =~ ^[0-9]+$ ]] && (( n>max )) && max=$n || true
  done < <(git branch -a --format='%(refname)' | grep -E 'refs/(heads|remotes)/[0-9]+-' || true)
  echo $((max+1))
}

slugify() {
  echo "$*" | tr 'A-Z' 'a-z' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'
}
