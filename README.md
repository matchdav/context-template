
# Context Template (GitHub Template)

This repository is a **GitHub Template** for creating a central hub to manage perspective, workflows, and automation across all your active projects. Use the "Use this template" button on GitHub to quickly generate your own context repository, pre-populated with best practices and structure.

As a template, it acts as a meta-repository, providing a single source of truth that enables efficient context switching and seamless collaboration between developers and AI agents.

## Using This Template

1. Click the **"Use this template"** button at the top of the repository page on GitHub.
2. Name your new repository and choose its visibility (public or private).
3. Clone your new repository and follow the setup instructions below to customize it for your team or project.

## Core Principles

A successful context repository revolves around a few key principles, which you should adapt in your own `constitution.md`:

*   **Context is King**: All work begins and ends with context. This repository should be the definitive source for project status, architecture, and workflows.
*   **Systematic Workflows**: Adhere to standardized, repeatable protocols for all development tasks (e.g., `PICKUP`, `HANDOFF`, `DEBUGGING`). These are not suggestions; they are the way you work.
*   **Automation First**: Any repetitive task should be automated. This repository contains the scripts and tools to enforce this principle.

## How It Works

The ecosystem is designed to be self-discoverable. Here are the key components:

1.  **Daily Digest**: The `daily-digest.md` is the primary entry point for any work session. It can be automatically generated each morning and provides a snapshot of active tickets, open pull requests, and recent team activity. A sample automation script is provided in `automations/daily-digest.sh`.
2.  **Standardized Protocols**: The `prompts/` directory contains markdown-based checklists and templates for common developer workflows. `PICKUP.md` and `HANDOFF.md` are provided as examples.
3.  **Automation Scripts**: The `automations/` directory houses scripts that power the ecosystem.
4.  **Centralized Documentation**: The `architecture/` and `perspectives/` directories store cross-cutting concerns and project-specific knowledge.

## Getting Started: The Daily Workflow

A typical work session follows a predictable rhythm:

1.  **Morning Sync**: Start your day by reviewing `daily-digest.md` to understand current priorities and tasks.
    ```bash
    cat daily-digest.md
    ```
2.  **Pickup Work**: Use the `prompts/PICKUP.md` protocol to orient yourself to a specific task. This involves reviewing the ticket, related code, and any existing handoff documents.
3.  **Do the Work**: Implement changes, write tests, and document decisions. Use a local `.context/journal/` directory within a project to log your process.
4.  **Handoff Work**: At the end of your session, use the `prompts/HANDOFF.md` protocol to create a clear, concise handoff document. This ensures that context is preserved for the next session.

## Customizing The Template

1.  **Fork or Use as Template:** Create your own repository from this template.
2.  **Customize `constitution.md`:** Define the principles, roles, and workflows for your team.
3.  **Customize `automations/daily-digest.sh`:** Update the script to integrate with your project management tools (e.g., Jira, GitHub Issues).
4.  **Populate `architecture/` and `perspectives/`:** Add your own architectural diagrams, decision records, and project-specific context.
5.  **Start Using the Workflow:** Begin your daily work by following the "Morning Sync -> Pickup -> Do -> Handoff" cycle.

## Linking Contexts & Discovery
- Use `context.json` to link related repositories, documentation, services, and automations.
- See `architecture/team-context-design.md` for design ideas on discoverability and onboarding.
- Automations can leverage `context.json` for richer digests and dashboards.
