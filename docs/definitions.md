
# Definitions

This file contains definitions of common terms used in this project. These terms have specific meanings within the context-template ecosystem.

## Core Concepts

* **Context Repository**: The central hub for managing perspective, workflows, and automation across all active projects. This repository acts as the single source of truth for project status, architecture, and workflows.
* **Daily Digest**: An auto-generated summary of active tickets, open pull requests, and recent team activity. The primary entry point for any work session, typically found in `daily-digest.md`.
* **Handoff**: The process and documentation for transferring work to another developer or future session, ensuring context is preserved. Formalized via the `prompts/HANDOFF.md` protocol.
* **Pickup**: The process and checklist for starting a new work session, orienting to current context and next steps. Formalized via the `prompts/PICKUP.md` protocol.
* **Morning Sync**: The daily review of the current state using the daily digest to set priorities and plan work.
* **Systematic Workflows**: Standardized, repeatable protocols (e.g., PICKUP, HANDOFF) that structure all development work and ensure consistency.
* **Automation First**: The principle that all repetitive tasks should be automated via scripts in the `automations/` directory.
* **Explicit Handoffs**: The requirement that all work sessions end with a documented handoff, preserving context for the next contributor or session.

## Technical Terms

* **MCP (Master Control Program/Model Context Protocol)**: A (now deprecated) protocol for tool discovery and automation, being replaced by `context.json`. MCP provided a low-level, universal interface for agents to discover and interact with tools, but did not encode project-specific workflows or reasoning.
* **context.json**: The unified configuration file that links related repositories, documentation, automations, and services for the project. Replaces the need for MCP.
* **Service**: Any external API or webhook used by automations (e.g., GitHub API, Slack webhook).
* **Central Index Files**: Files like `README.md`, `copilot-instructions.md`, and `context.json` that provide high-level project context and configuration for both humans and agents.
* **Standard Protocols**: Markdown-based checklists in `prompts/` (e.g., `PICKUP.md`, `HANDOFF.md`) that define core workflows for development and collaboration.
* **Perspective**: Documents in `perspectives/` capturing viewpoints, goals, or summaries on project topics, often used to provide additional context or rationale.
* **Architecture Docs**: High-level design and decision records in `architecture/`, including onboarding guides and system overviews.
* **Journal**: The `journal/` directory for long-term findings, session logs, and significant discoveries, supporting knowledge retention and handoff.
