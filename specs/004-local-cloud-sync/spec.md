# Feature Spec: Local-Cloud Sync

**Branch**: `004-local-cloud-sync` | **Date**: 2025-01-XX | **Status**: Draft
**Owner**: TBD | **Version**: 0.1.0

## 1. Problem Statement

Users need the ability to sync their local context repositories with cloud storage, enabling access from multiple machines, backup, and collaboration while maintaining local-first workflow.

## 2. Goals

- Bidirectional sync between local and cloud contexts
- Conflict detection and resolution
- Incremental sync (only changed files)
- Offline support with sync queue
- Selective sync (choose what to sync)

## 3. Non-Goals

- Real-time collaboration (handled separately)
- Automatic conflict resolution (manual resolution required)
- File versioning system (basic versioning only)

## 4. Scenarios

### Scenario: Initial Cloud Sync
Given a local project context exists
When a user runs `context sync --to-cloud --project project-a`
Then all project files are uploaded to cloud storage

### Scenario: Pull Latest from Cloud
Given cloud context has updates
When a user runs `context sync --from-cloud --project project-a`
Then local context is updated with cloud changes

### Scenario: Conflict Detection
Given local and cloud both have changes to the same file
When sync runs
Then conflicts are detected and user is prompted to resolve

### Scenario: Incremental Sync
Given a project was previously synced
When sync runs again
Then only changed files are transferred

### Scenario: Offline Sync Queue
Given user is offline
When they make local changes
Then changes are queued and synced when connection restored

## 5. Functional Requirements

1. **Sync Engine**
   - Compare local and cloud file hashes/timestamps
   - Detect changes, additions, deletions
   - Generate sync plan (upload, download, conflict)
   - Execute sync with progress reporting

2. **Conflict Resolution**
   - Detect conflicts (same file modified in both places)
   - Create conflict markers in files
   - Provide resolution UI/CLI
   - Support merge strategies (local-wins, cloud-wins, manual)

3. **Sync Modes**
   - Full sync: all files
   - Incremental: only changed files
   - Selective: user chooses files/directories
   - Auto-sync: watch for changes and sync automatically

4. **Sync State Management**
   - Track last sync timestamp per project
   - Store sync metadata (file hashes, sizes)
   - Maintain sync queue for offline changes
   - Log sync history

5. **Error Handling**
   - Retry failed syncs
   - Handle network interruptions
   - Validate file integrity after sync
   - Rollback on sync failure

## 6. Success Criteria

- Initial sync of 100MB completes in <2min
- Incremental sync of 10 changed files in <10s
- Conflicts detected accurately (no false positives)
- Offline queue persists across restarts
- Sync can resume after interruption

## 7. Data Shapes

### Sync State (`~/.context/sync-state.json`)
```json
{
  "projects": {
    "project-a": {
      "lastSync": "2025-01-15T10:30:00Z",
      "syncMode": "incremental",
      "fileHashes": {
        "context.json": "abc123...",
        "daily-digest.md": "def456..."
      },
      "pendingChanges": [
        {"file": "docs/handoff.md", "action": "upload", "timestamp": "2025-01-15T11:00:00Z"}
      ]
    }
  }
}
```

### Conflict Marker
```markdown
<<<<<<< LOCAL
Local changes here
=======
Cloud changes here
>>>>>>> CLOUD
```

### Sync Plan
```json
{
  "projectId": "project-a",
  "actions": [
    {"type": "upload", "file": "docs/new.md", "size": 1024},
    {"type": "download", "file": "daily-digest.md", "size": 2048},
    {"type": "conflict", "file": "context.json", "localHash": "abc", "cloudHash": "def"}
  ],
  "totalSize": 3072,
  "estimatedTime": 5
}
```

## 8. Architecture Overview

- Sync engine compares local and cloud state
- Generates sync plan with actions
- Executes sync with progress tracking
- Updates sync state after completion
- Handles errors and retries

## 9. Edge Cases

- File deleted locally but exists in cloud: prompt for action
- Large file exceeds quota: skip with warning
- Sync interrupted mid-transfer: resume from checkpoint
- Cloud storage unavailable: queue for later
- Corrupted sync state: reset and full sync

## 10. Open Questions

- Should sync be automatic or manual?
- How to handle binary files (images, PDFs)?
- Should there be a sync frequency limit?
- How to handle deleted files?

## 11. Assumptions

- Cloud storage API available (from spec 003)
- Local filesystem is accessible
- Network connectivity available (with offline queue)
- File hashing is fast enough for large projects

## 12. Implementation Sketch

```
scripts/
├── context-sync.sh        # Main sync command
└── sync-engine.js        # Sync logic

lib/
├── sync/
│   ├── comparator.js     # Compare local vs cloud
│   ├── planner.js       # Generate sync plan
│   ├── executor.js       # Execute sync
│   └── conflict.js       # Conflict resolution
```

## 13. Risks & Mitigations

- Risk: Data loss during sync → backup before sync, validate after
- Risk: Sync conflicts overwhelm user → batch conflicts, clear UI
- Risk: Large projects slow sync → incremental, compression
- Risk: Network costs → compression, delta sync

## 14. Rollout Plan

1. Implement sync state management
2. Build file comparison logic
3. Implement upload/download
4. Add conflict detection
5. Add offline queue
6. Add CLI/UI for conflict resolution
7. Test with large projects

## 15. Future Extensions

- Real-time sync (watch mode)
- Advanced merge strategies
- Selective sync UI
- Sync analytics and reporting
- Multi-cloud sync support

## 16. Acceptance Validation

- Can sync project to cloud and back
- Conflicts detected and resolved
- Incremental sync only transfers changes
- Offline changes queued and synced
- Large projects sync successfully

---
End of Spec.

