# Implementation Plan: MCP Server & Document Ingestion

**Branch**: `001-mcp-server-and-ingestion` | **Date**: 2025-11-06 
**Derived From**: `specs/001-mcp-server-and-ingestion/spec.md`
**Status**: Draft

## Scenarios (From Spec)
- Retrieve spec artifacts via artifacts.list
- Query tasks by status
- Ingest new document & index
- Fallback when embeddings provider absent
- Health probe metrics

## Phases
1. Config & Skeleton
2. Ingestion Core (scan/chunk/index)
3. MCP Endpoints (artifacts, context, health, tasks, search)
4. Incremental & Error Handling
5. Optional Embeddings Abstraction
6. Polish & Docs

## Task Outline
| ID | Phase | Description | Depends | Parallel |
|----|-------|-------------|---------|----------|
| 1  | 1 | Create `mcp.config.json` | - | Yes |
| 2  | 1 | Scaffold examples/mcp-server project | 1 | Yes |
| 3  | 2 | Implement scanner (list & filter markdown) | 2 | No |
| 4  | 2 | Implement chunker (size/overlap) | 3 | No |
| 5  | 2 | Implement index writer (JSON) | 4 | No |
| 6  | 3 | Load index on server start | 5 | No |
| 7  | 3 | Implement artifacts.list/get endpoints | 6 | No |
| 8  | 3 | Implement context.get endpoint | 6 | Yes |
| 9  | 3 | Implement tasks.open parser & endpoint | 5 | Yes |
| 10 | 3 | Implement search.query (keyword) | 5 | Yes |
| 11 | 3 | Implement health.status endpoint | 6 | Yes |
| 12 | 4 | Add incremental ingest (state file hash/mtime) | 5 | No |
| 13 | 4 | Add error logging & skip strategy | 12 | Yes |
| 14 | 5 | Add embeddings provider interface stub | 10 | Yes |
| 15 | 5 | Integrate optional embeddings step | 14 | No |
| 16 | 6 | README usage docs & curl examples | 11 | Yes |
| 17 | 6 | Add tests for endpoints & ingestion | 10 | No |
| 18 | 6 | Final polish & checklist | 17 | No |

## Risks
- Embedding latency → start with provider=none.
- Large file memory usage → enforce size threshold.
- Corrupt index on concurrent write → use lock file.

## Rollback Strategy
Delete `.context/index/` and re-run full ingestion; revert server to prior stable commit.

## Metrics
- Full ingest duration
- Chunk count & average size
- Search latency (keyword)

## Notes
Keep initial dependencies minimal; prefer standard Node APIs.
