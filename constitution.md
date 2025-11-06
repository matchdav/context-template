# Project Constitution (Template)

---
Constitution Version: 1.0.0
Last Updated: 2025-11-06
Status: Active
---

This constitution defines the principles, roles, governance, and workflows for this project. It is a living document that should be adapted to your team's needs. Amendments follow the governance process below and always bump the version.

## Principles

*   **Context is King**: All work begins and ends with context. This repository is the definitive source for project status, architecture, and workflows.
*   **Systematic Workflows**: We adhere to standardized, repeatable protocols for all development tasks. The core workflow is **Morning Sync -> Pickup -> Do -> Handoff**.
*   **Automation First**: Any repetitive task should be automated. The `automations` directory is the home for these scripts.
*   **Explicit Handoffs**: No work is complete until it is documented in a handoff document. By this we mean a plain Markdown file, not a vector database or internal agent memory.  This ensures context is preserved *in the file system* rather than lost somewhere in the MCP network.
*   **Transparency is Everything**: Blockers must be surfaced immediately—never hidden or ignored. Just like in scrum, clear and early communication prevents wasted effort and enables rapid problem-solving, rather than agents madly throwing spaghetti at the wall.

## Roles

* **Maintainer:** Stewards the constitution, approves workflow changes, ensures hygiene and archival policies are enforced.
* **Contributor:** Implements work using prescribed protocols (specify → plan → tasks → implement → analyze → checklist → clarify → handoff) and proposes improvements.
* **Reviewer:** Provides structured review on specs, plans, and implementation changes; enforces quality gates (build, lint, tests, documentation).
* **Operator:** Oversees automations, ingestion jobs, monitoring, and incident response; can enact emergency operational amendments (see Governance).

## Workflows

### The Daily Rhythm

1.  **Morning Sync**: Start your day by running the `daily-digest.sh` script to get a current snapshot of the project.
2.  **Pickup Work**: Use the `prompts/PICKUP.md` protocol to orient yourself to a specific task.
3.  **Do the Work**: Implement changes, write tests, and document decisions. Log your process in a local `.context/journal/` directory within the project you are working on.
4.  **Handoff Work**: At the end of your session, use the `prompts/HANDOFF.md` protocol to create a clear, concise handoff document.

### Documentation

*   **Architecture:** High-level architectural decisions and diagrams are stored in the `architecture/` directory.
*   **Perspectives:** Project-specific context, goals, and status are stored in the `perspectives/` directory.
*   **Journaling:** Long-term, significant findings are summarized and saved in the central `journal/` directory.

## Governance & Amendments

### Decision Categories
1. **Routine:** Minor clarifications or typo fixes in docs. Approval: 1 Maintainer.
2. **Workflow Change:** Alters any protocol (e.g., PICKUP, HANDOFF, Spec Kit sequence). Approval: Majority of Maintainers + at least 1 Reviewer.
3. **Structural Change:** Directory layout, archival policy, ingestion architecture. Approval: 2 Maintainers + 1 Operator.
4. **Emergency Operational:** Required to restore service or data integrity. Operator may apply immediately; retrospective PR within 24h.

### Amendment Process
1. **Proposal:** Open a PR with a summary and rationale; label `constitution-amendment`.
2. **Review:** Collect inline comments; unresolved items tagged `[NEEDS CLARIFICATION:]` (≤ 3 total allowed).
3. **Consensus:** Required approvals per category; remove all clarification tags.
4. **Version Bump:** Increment `Constitution Version` (semantic: MAJOR for structural/workflow change, MINOR for added sections, PATCH for wording).
5. **Merge & Record:** Merge PR; add an entry to `journal/` summarizing change.

### Emergency Path
Operator applies minimal change -> documents incident & justification -> opens retrospective PR within 24h for formalization.

## Spec Kit Integration

Work items must flow through: **Specify → Plan → Tasks → Implement → Analyze → Checklist → Clarify → Handoff**.

Quality gates (Build, Lint, Tests) must pass before checklist completion. Parallelizable tasks marked with `[P]`. Clarification markers limited to 3 and must be resolved before merge.

## Quality Gates
* **Build:** Project compiles / scripts run without error.
* **Lint:** No critical lint violations.
* **Tests:** Added/updated tests cover happy path + 1–2 edge cases.
* **Docs:** README / spec reflect current behavior.
* **Security:** No secrets committed; dependencies reviewed for license/security impact.
