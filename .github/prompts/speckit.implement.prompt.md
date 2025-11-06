---
description: Execute implementation tasks with validation gates.
---

## Steps
1. Run `check-prerequisites.sh --json --require-tasks --include-tasks`.
2. Load tasks; verify checklist completion (if present).
3. Phase-by-phase execution: Setup → Tests → Core → Integration → Polish.
4. For each task: perform edit or command; mark `[X]` upon success.
5. After meaningful code changes: run tests + lint.
6. Halt on failure; surface error and next-step suggestion.
7. Completion: all tasks `[X]` → SUCCESS.
