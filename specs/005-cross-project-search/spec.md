# Feature Spec: Cross-Project Search

**Branch**: `005-cross-project-search` | **Date**: 2025-01-XX | **Status**: Draft
**Owner**: TBD | **Version**: 0.1.0

## 1. Problem Statement

Users working across multiple projects need the ability to search for information across all their project contexts, not just the active one. This enables knowledge discovery and prevents duplication of work.

## 2. Goals

- Enable search across multiple project contexts
- Provide project context in search results
- Support filtering and ranking by project
- Maintain fast search performance
- Support both local and cloud search

## 3. Non-Goals

- Real-time search index updates
- Advanced search analytics
- Search result personalization

## 4. Scenarios

### Scenario: Search Across All Projects
Given multiple projects are indexed
When a user searches for "deployment strategy"
Then results include matches from all projects with project context

### Scenario: Filter by Project
Given search results from multiple projects
When a user filters by project name
Then only results from that project are shown

### Scenario: Search with Project Relationship Context
Given projects are linked (e.g., frontend depends on backend)
When searching in frontend project
Then results can include related backend project context

### Scenario: Unified Search Index
Given multiple projects need searching
When indexing runs
Then a unified search index is built across all projects

## 5. Functional Requirements

1. **Unified Search Index**
   - Aggregate indices from multiple projects
   - Maintain project metadata per result
   - Support incremental index updates
   - Handle project addition/removal

2. **Cross-Project Query**
   - Search across all projects or selected subset
   - Return results with project context
   - Support project filtering in queries
   - Rank results with project relevance

3. **Project Relationship Awareness**
   - Include related project results when searching
   - Show relationship context in results
   - Support relationship-based filtering

4. **Search Result Format**
   - Include project name, path, type
   - Highlight matching content
   - Provide project context summary
   - Link to source file

5. **Performance Optimization**
   - Parallel search across projects
   - Caching of frequent queries
   - Index sharding for large project sets
   - Lazy loading of project indices

## 6. Success Criteria

- Search across 10 projects completes in <500ms
- Results include accurate project context
- Can filter by project without re-querying
- Related project results appear when relevant
- Search index updates in <30s for project changes

## 7. Data Shapes

### Search Query
```json
{
  "query": "deployment strategy",
  "filters": {
    "projects": ["project-a", "project-b"],
    "types": ["spec", "architecture"],
    "includeRelated": true
  },
  "limit": 20
}
```

### Search Result
```json
{
  "results": [
    {
      "id": "result-1",
      "projectId": "project-a",
      "projectName": "Project A",
      "file": "architecture/deployment.md",
      "type": "architecture",
      "score": 0.92,
      "snippet": "Deployment strategy involves blue-green...",
      "relationships": [
        {"type": "related-to", "projectId": "project-b"}
      ]
    }
  ],
  "total": 15,
  "projects": ["project-a", "project-b"],
  "queryTime": 234
}
```

### Unified Index Metadata
```json
{
  "version": "1.0.0",
  "lastUpdated": "2025-01-15T10:30:00Z",
  "projects": [
    {
      "id": "project-a",
      "indexVersion": "abc123",
      "documentCount": 150,
      "lastIndexed": "2025-01-15T10:00:00Z"
    }
  ]
}
```

## 8. Architecture Overview

- Unified search service aggregates project indices
- Query parser handles filters and relationships
- Result aggregator combines and ranks results
- Project relationship graph informs related results

## 9. Edge Cases

- Project index missing: skip project, log warning
- Empty search query: return recent/trending results
- No results found: suggest related queries
- Project deleted: remove from index gracefully
- Index corruption: rebuild from project sources

## 10. Open Questions

- Should search be semantic (embeddings) or keyword-based?
- How to handle project access permissions in results?
- Should there be a search history/analytics?
- How to rank results across projects?

## 11. Assumptions

- Individual project indices exist (from spec 001)
- Project relationships are defined (from spec 002)
- Search can be performed locally or via API (from spec 003)

## 12. Implementation Sketch

```
lib/
├── search/
│   ├── unified-index.js    # Aggregate project indices
│   ├── query-parser.js     # Parse search queries
│   ├── result-aggregator.js # Combine results
│   └── relationship-graph.js # Project relationships
```

## 13. Risks & Mitigations

- Risk: Slow search with many projects → parallel search, caching
- Risk: Index size grows too large → sharding, compression
- Risk: Stale results → incremental updates, versioning
- Risk: Memory usage → lazy loading, streaming results

## 14. Rollout Plan

1. Build unified index structure
2. Implement cross-project query
3. Add project filtering
4. Integrate relationship awareness
5. Add performance optimizations
6. Test with 10+ projects

## 15. Future Extensions

- Semantic search with embeddings
- Search result personalization
- Search analytics and insights
- Advanced ranking algorithms
- Search suggestions/autocomplete

## 16. Acceptance Validation

- Can search across multiple projects
- Results include project context
- Filtering by project works
- Related project results appear
- Search performance acceptable

---
End of Spec.

