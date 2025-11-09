# Specs Directory

This directory houses formal specifications that drive implementation phases. Each spec follows the [GitHub Spec Kit](https://github.com/github/spec-kit) conventions.

## Directory Structure

Each feature gets a numbered directory:
```
specs/
  001-feature-name/
    spec.md       # Feature specification (problem, goals, scenarios, requirements)
    plan.md       # Implementation plan (phases, tasks, risks)
    tasks.md      # Task breakdown with dependencies
    research.md   # (Optional) Prior art and alternatives
    data-model.md # (Optional) Entity definitions
    contracts/    # (Optional) API contracts
```

## Naming Convention
- Format: `NNN-kebab-case-topic/` where NNN is zero-padded (e.g., `001`, `002`)
- Branch names match directory names: `001-feature-name`

## Lifecycle
1. **Draft** → Initial problem framing (spec.md)
2. **Plan** → Execution approach (plan.md)
3. **Tasks** → Actionable breakdown (tasks.md)
4. **Implementation** → Active delivery on feature branch
5. **Completed** → Merged to main, outcomes documented

## Current Specs

| ID  | Title | Status | Branch |
|-----|-------|--------|--------|
| 001 | MCP Server & Document Ingestion | In Progress | `001-mcp-server-and-ingestion` |
| 002 | Multi-Project Management | Draft | `002-multi-project-management` |
| 003 | Cloud Service Infrastructure | Draft | `003-cloud-service-infrastructure` |
| 004 | Local-Cloud Sync | Draft | `004-local-cloud-sync` |
| 005 | Cross-Project Search | Draft | `005-cross-project-search` |

## Spec Overview

### 001: MCP Server & Document Ingestion
Provides a minimal, extensible MCP server implementation blueprint and document ingestion pipeline for local context access.

### 002: Multi-Project Management
Enable management of multiple project contexts from a single installation with project switching, discovery, and relationship management.

### 003: Cloud Service Infrastructure
Provide REST API, authentication, multi-tenancy, and cloud deployment capabilities for remote context access.

### 004: Local-Cloud Sync
Bidirectional sync between local and cloud contexts with conflict detection, resolution, and offline support.

### 005: Cross-Project Search
Enable search across multiple project contexts with unified index, project filtering, and relationship awareness.

See `GAP-ANALYSIS.md` in the root for a comprehensive overview of gaps and roadmap.

## Creating New Specs

Use the Spec Kit helper script:
```bash
./.specify/scripts/bash/create-new-feature.sh "My New Feature"
```

This creates:
- A numbered branch (e.g., `002-my-new-feature`)
- A spec directory stub under `specs/002-my-new-feature/`
- An initial `spec.md` file

Then populate using the `/speckit.specify` workflow.
