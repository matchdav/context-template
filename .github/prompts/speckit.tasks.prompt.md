---
description: Break implementation plan into executable task list.
---

## Steps
1. Load implementation plan.
2. Extract phases & scenarios.
3. For each scenario produce tasks with IDs, descriptions, file targets.
4. Mark tasks as sequential unless explicitly independent; add [P] for parallel.
5. Output tasks file via `tasks-template.md`.
6. Return SUCCESS.
