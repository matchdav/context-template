# Tasks: MCP Server & Document Ingestion

**Branch**: `001-mcp-server-and-ingestion` | **Date**: 2025-11-06
**Derived From**: `specs/001-mcp-server-and-ingestion/plan.md`
**Status**: Active

## Conventions
- [P] denotes parallelizable
- Dependencies by ID

## Tasks
1. [ ] [P] Create `mcp.config.json` (directories, chunk params, refresh interval)
2. [ ] [P] Scaffold `examples/mcp-server` project structure
3. [ ] Scanner: list & filter markdown (skip >100KB) (depends: 2)
4. [ ] Chunker: implement size/overlap logic (depends: 3)
5. [ ] Index writer: JSON index + state file (depends: 4)
6. [ ] Load index on server start (depends: 5)
7. [ ] artifacts.list/get endpoints (depends: 6)
8. [ ] [P] context.get endpoint (depends: 6)
9. [ ] [P] tasks.open endpoint + checkbox parser (depends: 5)
10. [ ] [P] search.query keyword implementation (depends: 5)
11. [ ] [P] health.status endpoint (depends: 6)
12. [ ] Incremental ingest (mtime/hash state) (depends: 5)
13. [ ] Error logging & skip strategy (depends: 12)
14. [ ] [P] Embeddings provider interface stub (depends: 10)
15. [ ] Integrate optional embeddings step (depends: 14)
16. [ ] [P] README usage docs & example queries (depends: 11)
17. [ ] Tests for ingestion + endpoints (depends: 10)
18. [ ] Delivery checklist & polish (depends: 17)

## Blockers
- None identified yet.

## Decisions
- Start with provider=none for embeddings.

## Follow-ups
- Consider sqlite storage if JSON index grows.
