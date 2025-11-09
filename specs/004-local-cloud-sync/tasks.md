# Tasks: Local-Cloud Sync

**Branch**: `004-local-cloud-sync` | **Date**: 2025-01-XX
**Derived From**: `specs/004-local-cloud-sync/plan.md`
**Status**: Active

## Conventions
- [P] denotes parallelizable
- Dependencies by ID

## Tasks
1. [ ] [P] Design sync state schema (`~/.context/sync-state.json` structure)
2. [ ] Implement sync state storage (read/write sync state, validation)
3. [ ] Implement file comparison (hash files, compare timestamps) (depends: 2)
4. [ ] Implement change detection (identify added, modified, deleted files) (depends: 3)
5. [ ] Implement upload to cloud (upload files, update sync state) (depends: 4)
6. [ ] Implement download from cloud (download files, update local) (depends: 4)
7. [ ] Add progress reporting (show sync progress, ETA) (depends: 5,6)
8. [ ] Implement conflict detection (detect same file modified in both places) (depends: 3)
9. [ ] Add conflict markers (insert conflict markers in files) (depends: 8)
10. [ ] Implement conflict resolution UI/CLI (prompt user, apply resolution) (depends: 9)
11. [ ] [P] Implement offline queue (queue changes when offline) (depends: 2)
12. [ ] Add queue persistence (save queue to disk, restore on restart) (depends: 11)
13. [ ] Implement queue processing (process queue when online) (depends: 12)
14. [ ] Tests for sync (upload, download, incremental sync) (depends: 7,10)
15. [ ] Tests for conflict resolution (detect, resolve conflicts) (depends: 10)
16. [ ] Document sync usage (CLI commands, conflict resolution guide) (depends: 15)

## Blockers
- None identified yet.

## Decisions
- Use file hashes (SHA-256) for comparison
- Conflict resolution: manual (user chooses), no auto-merge
- Offline queue: persist to disk, process on next sync

## Follow-ups
- Consider automatic conflict resolution strategies
- Add sync analytics and reporting
- Support selective sync (choose files/directories)

