# Agent Context Discovery Guide

This document explains how an AI agent (like GitHub Copilot) will interpret and use your workspace structure when starting a new coding session, and what you should reference explicitly for best results.

## How the Agent Reads Your Workspace

### Implicitly Picked Up
- **Workspace Structure**: The agent scans the directory tree, recognizing key folders like `architecture/`, `perspectives/`, `workload/`, `automations/`, and `prompts/`.
- **Central Index Files**: Files like `AGENTS.md`, `copilot-instructions.md`, `README.md`, and `context.json` are read first for high-level context, project purpose, and configuration.
- **Standard Protocols**: Protocol documents in `prompts/` (e.g., `HANDOFF.md`, `PICKUP.md`) are used to guide workflows, especially if their names match common agent tasks.
- **Automation Scripts**: Scripts in `automations/` (like `daily-digest.sh`, `daily-digest.js`) are recognized as automation entry points, especially if referenced in documentation or Makefiles.
- **Recent Context**: Files like `daily-digest.md` and `workload/priorities.md` are read for up-to-date work state, priorities, and active tickets.

### What You Need to Explicitly Reference
- **Non-Standard or Deeply Nested Files**: Reference directly in your prompt or documentation if not obviously named or deeply nested.
- **Custom Workflows**: Mention unique workflows or protocols not named in a standard way.
- **Cross-Repo Links**: Provide explicit links or references for context from other repositories.
- **Ambiguous or Overlapping Files**: Clarify which file is authoritative if multiple could serve a similar purpose.

## Best Practices
- Keep `copilot-instructions.md` and `README.md` up to date.
- Use clear, descriptive filenames for protocols and workflows.
- Reference critical files in your main documentation.
- Document automation entry points and Makefile targets.

## Summary Table

| File/Folder                  | Implicitly Picked Up? | Explicit Reference Needed? |
|------------------------------|:---------------------:|:-------------------------:|
| copilot-instructions.md      | ✅                    | ❌                        |
| README.md                    | ✅                    | ❌                        |
| prompts/HANDOFF.md, etc.     | ✅ (if standard name)  | ❌ (unless custom)        |
| automations/daily-digest.sh  | ✅ (if documented)     | ❌ (unless custom)        |
| architecture/*.md            | ✅                    | ❌                        |
| workload/priorities.md       | ✅                    | ❌                        |
| deeply nested/custom files   | ❌                    | ✅                        |
| cross-repo files             | ❌                    | ✅                        |

## Quick Recipe Book

- **Add a new protocol:**
  1. Place it in `prompts/` with a clear, standard name (e.g., `REVIEW.md`).
  2. Reference it in `copilot-instructions.md` if it’s critical.

- **Automate a workflow:**
  1. Add your script to `automations/`.
  2. Document usage in `README.md` and/or `copilot-instructions.md`.
  3. Add a Makefile target if useful.

- **Update project context:**
  1. Edit `daily-digest.md` or `workload/priorities.md`.
  2. Run automation scripts to refresh context.

- **Onboard a new agent or teammate:**
  1. Point them to `copilot-instructions.md` and `README.md`.
  2. Highlight any custom or non-standard files.

- **Reference another repo:**
  1. Add explicit links in your documentation.
  2. Summarize key context if cross-repo scanning is not supported.

---

*Following these conventions ensures your context is discoverable and actionable for both humans and AI agents.*
