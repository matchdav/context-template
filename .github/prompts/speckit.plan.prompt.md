---
description: Generate implementation plan from approved specification.
---

## User Input
```text
$ARGUMENTS
```
(Feature key or spec path.)

## Steps
1. Load spec; verify no `[NEEDS CLARIFICATION]` markers.
2. Derive BDD Scenarios → Implementation Tasks.
3. Group tasks into phases: Setup, Tests, Core, Integration, Polish.
4. Identify dependencies; mark parallel-capable tasks with [P].
5. Output plan file using `plan-template.md`.
6. Include risk list + rollback notes.
7. Emit SUCCESS when plan written.
