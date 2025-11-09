# Tasks: Cross-Project Search

**Branch**: `005-cross-project-search` | **Date**: 2025-01-XX
**Derived From**: `specs/005-cross-project-search/plan.md`
**Status**: Active

## Conventions
- [P] denotes parallelizable
- Dependencies by ID

## Tasks
1. [ ] [P] Design unified index structure (aggregate project indices, metadata)
2. [ ] Implement index aggregation (combine project indices into unified index)
3. [ ] Add project metadata to results (project ID, name, path in results) (depends: 2)
4. [ ] Implement cross-project query (search across all projects or subset) (depends: 2)
5. [ ] Add result aggregation (combine results, rank, deduplicate) (depends: 4)
6. [ ] Implement project filtering (filter results by project) (depends: 4)
7. [ ] Add project selection UI/CLI (choose projects to search) (depends: 6)
8. [ ] [P] Integrate relationship graph (load project relationships) (depends: 2)
9. [ ] Add related project results (include related projects in search) (depends: 8)
10. [ ] Show relationship context (display relationship info in results) (depends: 9)
11. [ ] Implement parallel search (search projects in parallel) (depends: 4)
12. [ ] Add result caching (cache frequent queries) (depends: 5)
13. [ ] Add index sharding (split large indices for performance) (depends: 2)
14. [ ] Tests for search (cross-project queries, filtering) (depends: 5,6)
15. [ ] Performance tests (search time, index size, memory usage) (depends: 11,12)
16. [ ] Document search usage (CLI commands, query syntax) (depends: 15)

## Blockers
- Requires spec 001 (MCP server) and spec 002 (multi-project) to be complete

## Decisions
- Start with keyword search, add semantic search later
- Cache results for 5 minutes
- Parallel search with 5 concurrent projects max

## Follow-ups
- Add semantic search with embeddings
- Add search result personalization
- Add search analytics and insights

