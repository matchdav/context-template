# Lessons Learned (Template)

Append insights here under dated headings. Group by domain for faster future retrieval.

## 2025-01-01 (Example)
### Tooling
- Migrated to unified CLI wrapper reduced duplicated scripts.

### Architecture
- Splitting ingestion and query services improved restart isolation.

### Workflow
- Daily digest rotation lowered noise in journal folder.

### Reliability
- Adding retry with jitter to embedding calls reduced transient failures.

---

## Template Format
```
## YYYY-MM-DD
### Domain
- Brief insight (cause → change → outcome)
```

Link to archived source when derived from a journal entry: `([source](../archive/journal/2025-01-01-debug-session.md))`.
