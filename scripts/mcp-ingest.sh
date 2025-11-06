#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="mcp.config.json"
STATE_FILE=".context/index/state.json"
INDEX_DIR=".context/index"
ERROR_LOG="$INDEX_DIR/errors.log"
INGEST_LOG="$INDEX_DIR/ingestion.log"
LOCK_FILE="$INDEX_DIR/.lock"

mkdir -p "$INDEX_DIR"

log() { printf "[%s] %s\n" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$1"; }
warn() { log "WARN: $1"; }
err() { log "ERROR: $1" >&2; }

if [[ -f "$LOCK_FILE" ]]; then
  err "Another ingestion appears to be running (lock file present)."; exit 1
fi
trap 'rm -f "$LOCK_FILE"' EXIT
: > "$LOCK_FILE"

if [[ ! -f $CONFIG_FILE ]]; then err "Missing $CONFIG_FILE"; exit 1; fi

DIRECTORIES=$(jq -r '.directories[]' "$CONFIG_FILE")
CHUNK_SIZE=$(jq -r '.chunkSize' "$CONFIG_FILE")
CHUNK_OVERLAP=$(jq -r '.chunkOverlap' "$CONFIG_FILE")
MAX_FILE_SIZE=$(jq -r '.maxFileSizeBytes' "$CONFIG_FILE")
EMBED_PROVIDER=$(jq -r '.embeddings.provider' "$CONFIG_FILE")

# Load previous state
if [[ -f "$STATE_FILE" ]]; then
  PREV_HASH=$(jq -r '.globalHash' "$STATE_FILE")
else
  PREV_HASH=""
fi

TEMP_FILE=$(mktemp)
TOTAL_FILES=0
CHANGED_FILES=0
SKIPPED=0
ERRORS=0
CHUNKS=0
START_TS=$(date -u +%s)

hash_file() { shasum "$1" | awk '{print $1}'; }

process_file() {
  local file="$1"
  local fsize
  fsize=$(wc -c < "$file")
  if (( fsize > MAX_FILE_SIZE )); then
    warn "Skipping large file $file ($fsize bytes)"; ((SKIPPED++)); return
  fi
  local hash
  hash=$(hash_file "$file")
  echo "$hash $file" >> "$TEMP_FILE"
  ((TOTAL_FILES++))
}

for dir in $DIRECTORIES; do
  if [[ -d "$dir" ]]; then
    while IFS= read -r f; do
      process_file "$f"
    done < <(find "$dir" -type f -name "*.md" -o -name "*.markdown" 2>/dev/null)
  else
    warn "Directory $dir not found"
  fi
done

GLOBAL_HASH=$(awk '{print $1}' "$TEMP_FILE" | shasum | awk '{print $1}')

if [[ "$GLOBAL_HASH" == "$PREV_HASH" ]]; then
  log "No changes detected (global hash match).";
else
  # Build index JSON
  INDEX_JSON="$INDEX_DIR/index.json"
  CHUNKS_JSON="$INDEX_DIR/chunks.json"
  : > "$CHUNKS_JSON"
  {
    echo '{"artifacts": ['
    first=true
    while read -r hash path; do
      # Chunking
      content=$(cat "$path") || { err "Failed reading $path"; ((ERRORS++)); continue; }
      title=$(basename "$path")
      mtime=$(date -u -r "$path" +%Y-%m-%dT%H:%M:%SZ)
      type="generic"
      if [[ "$path" == specs/*/spec.md ]]; then type="spec"; fi
      if [[ "$path" == specs/*/plan.md ]]; then type="plan"; fi
      if [[ "$path" == specs/*/tasks.md ]]; then type="tasks"; fi
      artifact_id=$(echo "$path" | sed 's/[^a-zA-Z0-9]/-/g')
      $first || echo ','
      first=false
      echo "{\"id\":\"$artifact_id\",\"path\":\"$path\",\"type\":\"$type\",\"title\":\"$title\",\"updated\":\"$mtime\"}" 

      # Simple chunker
      length=${#content}
      start=0
      while (( start < length )); do
        end=$(( start + CHUNK_SIZE ))
        if (( end > length )); then end=$length; fi
        chunk=${content:start:end-start}
        chunk_id=$(printf "%s-%s" "$artifact_id" "$start")
        printf '{"chunkId":"%s","artifactPath":"%s","content":%s}' "$chunk_id" "$path" "$(jq -Rs '.' <<< "$chunk")" >> "$CHUNKS_JSON"
        echo >> "$CHUNKS_JSON"
        ((CHUNKS++))
        (( start = end - CHUNK_OVERLAP ))
        if (( start < 0 )); then start=0; fi
        if (( start >= length )); then break; fi
      done
    done < "$TEMP_FILE"
    echo ']}'
  } > "$INDEX_JSON"

  jq -s '.[0] as $chunks | {artifacts: (.[1].artifacts), chunks: ($chunks | map(.))}' "$CHUNKS_JSON" "$INDEX_JSON" > "$INDEX_DIR/combined.json" || err "Combining index failed"

  CHANGED_FILES=$TOTAL_FILES # Simplified: treat all as changed when global hash differs
  jq -n --arg gh "$GLOBAL_HASH" --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '{globalHash:$gh, updated:$ts}' > "$STATE_FILE"
fi

DURATION=$(( $(date -u +%s) - START_TS ))
log "Ingestion complete: files=$TOTAL_FILES changed=$CHANGED_FILES chunks=$CHUNKS skipped=$SKIPPED errors=$ERRORS duration=${DURATION}s"
{
  printf '{"timestamp":"%s","files":%s,"changed":%s,"chunks":%s,"skipped":%s,"errors":%s,"durationSeconds":%s}\n' \
    "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$TOTAL_FILES" "$CHANGED_FILES" "$CHUNKS" "$SKIPPED" "$ERRORS" "$DURATION"
} >> "$INGEST_LOG"

exit 0
