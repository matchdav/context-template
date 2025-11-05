# Project Constitution (Template)

This constitution defines the principles, roles, and workflows for this project. It is a living document that should be adapted to your team's needs.

## Principles

*   **Context is King**: All work begins and ends with context. This repository is the definitive source for project status, architecture, and workflows.
*   **Systematic Workflows**: We adhere to standardized, repeatable protocols for all development tasks. The core workflow is **Morning Sync -> Pickup -> Do -> Handoff**.
*   **Automation First**: Any repetitive task should be automated. The `automations` directory is the home for these scripts.
*   **Explicit Handoffs**: No work is complete until it is documented in a handoff document. By this we mean a plain Markdown file, not a vector database or internal agent memory.  This ensures context is preserved *in the file system* rather than lost somewhere in the MCP network.
*   **Transparency is Everything**: Blockers must be surfaced immediately—never hidden or ignored. Just like in scrum, clear and early communication prevents wasted effort and enables rapid problem-solving, rather than agents madly throwing spaghetti at the wall.

## Roles

*   **Maintainer:** Oversees the context repository, ensuring the constitution and workflows are followed.
*   **Contributor:** Follows the prescribed workflows, contributes to the context repository, and suggests improvements.

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

## Amendments

Propose changes to this constitution via pull request. All team members are encouraged to suggest improvements to our workflows and principles.