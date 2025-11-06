---
description: Create or update a feature specification from natural language.
---

## User Input

```text
$ARGUMENTS
```

If empty → ERROR "No feature description provided".

## Outline
1. Generate short branch name (2–4 words, action-noun when possible).
2. Fetch remote + local branches; inspect `specs/` for existing numeric prefixes.
3. Determine next number N+1.
4. Run `.specify/scripts/bash/create-new-feature.sh --json --number N+1 --short-name <short> "$ARGUMENTS"`.
5. Load `spec-template.md`.
6. Extract actors, actions, data, constraints; add assumptions where defaults chosen.
7. Insert at most 3 `[NEEDS CLARIFICATION: question]` markers only for scope/security/UX critical decisions.
8. Populate User Scenarios (independently testable, prioritized P1..Pn) with Given/When/Then.
9. List Functional Requirements (testable, no implementation tech).
10. Define Success Criteria (measurable, technology-agnostic).
11. Identify Key Entities if data involved.
12. Write spec file; respond SUCCESS.

## Validation
Create checklist file (requirements.md) and ensure:
- No implementation details leak
- All acceptance scenarios testable
- ≤3 clarification markers

If clarifications remain → present options table (A/B/C/Custom) and wait.
