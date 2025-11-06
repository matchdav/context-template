# Feature Spec: MCP Server & Document Ingestion Pattern

**Branch**: `001-mcp-server-and-ingestion` | **Date**: 2025-11-06 | **Status**: Draft
**Owner**: TBD | **Version**: 0.1.0

## 1. Problem Statement
Agents need a standardized, reproducible MCP (Model Context Protocol) server plus a document ingestion pipeline to surface repository and organizational knowledge as structured, queryable context. The template currently lacks an executable pattern showing how to implement this.

## 2. Goals
- Provide a minimal, extensible MCP server implementation blueprint.
- Define ingestion workflow for markdown/docs into chunked, embedded, queryable store.
- Enable agents to retrieve context slices (specs, plans, tasks, decisions) via MCP.
- Keep initial implementation lightweight (local filesystem + in-memory / optional pluggable vector index).

## 3. Non-Goals
- Production-grade scalability (handled later by operators).
- Advanced auth / multi-tenant isolation.
- Real-time synchronization across external services.

## 4. Scenarios
### Scenario: Retrieve Spec Artifacts
Given an agent wants the latest spec files
When it requests `context.artifacts` with filter type=spec
Then the server returns metadata + content for each spec.

### Scenario: Query for Tasks by Status
Given tasks are ingested and indexed
When agent queries for status=open
Then MCP returns list of open tasks with file paths.

### Scenario: Ingest New Document
Given a new markdown file is added under `architecture/`
When ingestion job runs
Then file is chunked, embedded, and indexed for semantic search.

### Scenario: Fallback Without Embeddings
Given embeddings provider is not configured
When ingestion runs
Then server still exposes raw chunked text for keyword matching.

### Scenario: Health Probe
Given the MCP server is running
When `/health` is requested
Then it returns uptime, counts (artifacts, chunks, embeddings), and ingestion timestamp.

## 5. Functional Requirements
1. Provide MCP endpoints (WebSocket or HTTP) implementing:
   - `context.get` – return raw context.json + derived inventory summary.
   - `artifacts.list` – list specs/plans/tasks/checklists with metadata.
   - `artifacts.get` – return full content of a specific artifact (path or id).
   - `search.query` – semantic or keyword search over ingested chunks.
   - `tasks.open` – list open tasks from task artifacts.
   - `health.status` – operational metrics.
2. Ingestion pipeline:
   - Scans configurable directories: `architecture/`, `perspectives/`, `operations/`, `specs/`, `.specify/templates/`.
   - Excludes large binary or media assets.
   - Chunks markdown (configurable size e.g. 800 chars / overlap 100).
   - Embeds chunks if provider configured (e.g. OpenAI, local model) else stores plain text.
   - Persists index (JSON or sqlite) under `.context/index/`.
3. Config via `mcp.config.json` (directories, chunkSize, overlap, embeddings provider, refresh interval).
4. CLI script `scripts/mcp-ingest.sh` that performs incremental ingestion based on a state file `.context/index/state.json` (hash or mtime cache).
5. Error handling: ingestion should skip failed files and record errors in `.context/index/errors.log`.
6. Observability: ingestion log in `.context/index/ingestion.log` with timestamp, counts, duration.

## 6. Success Criteria
- Cold ingest completes < 30s for <= 300 markdown files (~<5MB total).
- Subsequent incremental ingest processes only changed files.
- Search returns relevant artifacts (top 5) for a keyword present in multiple directories.
- Agents can fetch spec + plan content via artifacts API with <1s latency locally.

## 7. Data Shapes
### `mcp.config.json`
```json
{
  "directories": ["architecture", "perspectives", "operations", "specs", ".specify/templates"],
  "chunkSize": 800,
  "chunkOverlap": 100,
  "embeddings": {"provider": "none"},
  "refreshIntervalSeconds": 1800
}
```

### Artifact Metadata
```json
{
  "id": "spec-001-mcp-server",
  "path": "specs/001-mcp-server-and-ingestion/spec.md",
  "type": "spec",
  "title": "MCP Server & Document Ingestion Pattern",
  "updated": "2025-11-06T12:00:00Z"
}
```

### Search Result Chunk
```json
{
  "chunkId": "chunk-abc123",
  "artifactPath": "architecture/deployment-strategy.md",
  "score": 0.82,
  "content": "Deployment strategy involves blue-green..."
}
```

## 8. Architecture Overview
- CLI ingestion script -> Scanner -> Chunker -> (Embedder?) -> Index Writer
- MCP Server runtime:
  - Loads index into memory on startup
  - Exposes query endpoints
  - Refresh trigger (interval or manual) reloads changed artifacts

## 9. Edge Cases
- Empty directory: ingestion logs zero processed, still updates timestamp.
- Large file > 100KB: warn and skip (configurable size threshold).
- Embeddings provider timeout: fallback to plain text chunk storage.
- Concurrent ingest run: state file lock to prevent corruption.
- Deleted file: purge chunks referencing removed path on next run.

## 10. Open Questions
- Should embeddings provider interface support batching and streaming now or later? (Defer)
- Do we normalize markdown (strip frontmatter) before chunking? (Likely yes)
- Should tasks parse checkbox status automatically? (Yes, minimal parser)

## 11. Assumptions
- Local environment has bash + node available.
- Agents can call CLI or schedule via cron/PM2.
- Directory structure stable per template conventions.

## 12. Implementation Sketch (Non-binding)
```
/scripts/mcp-ingest.sh
/examples/mcp-server/src/indexer/scan.ts
/examples/mcp-server/src/indexer/chunk.ts
/examples/mcp-server/src/indexer/embed.ts
/examples/mcp-server/src/indexer/write.ts
/examples/mcp-server/src/server/endpoints/*.ts
```
In-memory index: artifactMap, chunkList, embeddings(optional).

## 13. Risks & Mitigations
- Risk: Embeddings cost/latency → default provider=none.
- Risk: Index size growth → enforce max chunk size & skip large files.
- Risk: Stale data → refresh interval + manual trigger endpoint.

## 14. Rollout Plan
1. Add config + ingestion script (no embeddings).
2. Implement MCP server endpoints (artifacts + health + search keyword).
3. Add checkbox parser for tasks.
4. Add optional embeddings abstraction.
5. Document usage in README + example curl/websocket calls.

## 15. Future Extensions
See `FUTURE-ENHANCEMENTS.md` for related evolution paths (vector DB, dashboard, automated plan/task derivation).

## 16. Acceptance Validation
- Run ingestion -> index artifacts -> server responds to artifacts.list.
- Modify a spec -> incremental ingest updates chunk count.
- Query keyword found in >=2 files returns both.
- Simulate missing embeddings provider: ingestion still succeeds.

---
End of Spec.
