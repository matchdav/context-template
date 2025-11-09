# Feature Spec: Multi-Project Management

**Branch**: `002-multi-project-management` | **Date**: 2025-01-XX | **Status**: Draft
**Related**: See `CONCEPT.md` for detailed definition of "project" vs "repository" vs "context repository"
**Owner**: TBD | **Version**: 0.1.0

## 1. Problem Statement

The context template currently supports a single project context. To function as a cross-project knowledge base usable both locally and as a cloud service, it needs the ability to manage multiple projects, switch between them, and maintain organizational boundaries across projects.

**Definition**: A **project** is a context repository instance that defines an organizational boundary (company, division, product, personal, etc.) and links to a subset of code repositories via `context.json`. The same repository can appear in multiple projects with different context/focus.

## 2. Goals

- Enable management of multiple context repository instances (projects) from a single installation
- Provide project switching to change organizational scope/focus
- Support project discovery and registry
- Allow cross-project relationships (e.g., division project is part of company project)
- Support overlapping repositories across projects (same repo in multiple projects)
- Maintain backward compatibility with single-project usage

## 3. Non-Goals

- Multi-tenant cloud infrastructure (handled in separate spec)
- Real-time collaboration features
- Project-level access control (handled in separate spec)

## 4. Scenarios

### Scenario: List Available Projects
Given a user has multiple project contexts configured
When they run `context list projects`
Then the system returns a list of all available projects with metadata

### Scenario: Switch Active Project
Given multiple projects are configured
When a user runs `context switch project-name`
Then the active project context changes and environment variables update

### Scenario: Create New Project Context
Given a user wants to add a new project
When they run `context create project-name --from-template`
Then a new project context is initialized with template structure

### Scenario: Cross-Project Search
Given multiple projects are indexed
When a user searches across all projects
Then results include project context and can be filtered by project

### Scenario: Link Related Projects
Given two projects are related (e.g., UI division project is part of company project)
When a user links them via `context link project-a project-b --type part-of`
Then relationships are stored and can be queried

### Scenario: Overlapping Repositories
Given a repository appears in multiple projects
When a user searches for that repository
Then results show which projects contain it and their respective context

## 5. Functional Requirements

1. **Project Registry**
   - Store project metadata in `~/.context/projects.json`
   - Each project has: id, name, path (to context repository), description, tags, organizational boundary type (company, division, product, personal, etc.), created date, last accessed
   - Support project templates and initialization

2. **Project Switching**
   - CLI command: `context switch <project-name>`
   - Update `CONTEXT_DIR` environment variable
   - Load project-specific `context.json`
   - Maintain project history/recents

3. **Project Discovery**
   - Auto-discover projects in configured directories
   - Support manual project registration
   - List projects with status (active, available, archived)

4. **Cross-Project Relationships**
   - Define project relationships: `part-of` (division is part of company), `depends-on` (product depends on infrastructure), `related-to` (products share components)
   - Store in project metadata
   - Enable relationship traversal in queries
   - Support hierarchical relationships (e.g., division project → company project)

5. **Project Isolation**
   - Each project (context repository instance) maintains its own `context.json`, `daily-digest.md`, `docs/`, `architecture/`
   - Shared resources in global `~/.context/` (templates, automations, registry)
   - Project-specific vs global configuration
   - Repositories can appear in multiple projects' `context.json` with different context

## 6. Success Criteria

- Can list 10+ projects in <1s
- Project switch completes in <2s
- Cross-project search returns results with project context
- Backward compatible: single project works without registry

## 7. Data Shapes

### Project Registry (`~/.context/projects.json`)
```json
{
  "version": "1.0.0",
  "activeProject": "company-project",
  "projects": [
    {
      "id": "company-project",
      "name": "Company Project",
      "path": "~/context-repos/company",
      "description": "All company repositories",
      "boundaryType": "company",
      "tags": ["production", "all-repos"],
      "created": "2025-01-01T00:00:00Z",
      "lastAccessed": "2025-01-15T10:30:00Z",
      "relationships": [
        {"type": "part-of", "projectId": null, "direction": "parent"},
        {"type": "has-child", "projectId": "ui-division-project", "direction": "child"}
      ]
    },
    {
      "id": "ui-division-project",
      "name": "UI Division Project",
      "path": "~/context-repos/ui-division",
      "description": "UI division repositories",
      "boundaryType": "division",
      "tags": ["ui", "frontend"],
      "created": "2025-01-05T00:00:00Z",
      "lastAccessed": "2025-01-15T09:00:00Z",
      "relationships": [
        {"type": "part-of", "projectId": "company-project", "direction": "child"}
      ]
    }
  ]
}
```

### Project Context Structure
Each project is a context repository instance:
```
~/context-repos/company/
├── context.json          # Links to all company repositories
├── daily-digest.md       # Company-wide digest
├── docs/                 # Company-specific docs
├── architecture/         # Company architecture
└── .context/             # Project-specific index
```

## 8. Architecture Overview

- **Project Registry**: Central registry at `~/.context/projects.json` tracks all projects
- **CLI Commands**: `context list`, `context switch`, `context create` for project management
- **Environment Variables**: `CONTEXT_DIR` points to active project's context repository path
- **Context Loading**: System loads `context.json` from active project's path
- **Cross-Project Query**: Query layer can aggregate results across multiple projects

## 9. Edge Cases

- **Project path no longer exists**: Mark as unavailable in registry, don't auto-remove, allow manual cleanup
- **Duplicate project names**: Require unique IDs, allow name aliases for display
- **Corrupted project registry**: Backup/restore mechanism, validate on load
- **Missing project context.json**: Prompt for creation or use template
- **Repository appears in multiple projects**: Each project maintains its own context for that repository
- **Switching to non-existent project**: Validate path exists, show error with suggestions

## 10. Assumptions

- Users have a home directory for global config (`~/.context/`)
- Projects (context repository instances) are stored in predictable locations
- CLI tools are available for project management
- Each project is a complete context repository instance (has `context.json`, `docs/`, etc.)
- Projects can share repositories (same repo in multiple projects' `context.json`)

## 11. Implementation Sketch

```
~/.context/
├── projects.json          # Project registry (central metadata)
├── templates/             # Shared templates for project creation
└── automations/           # Shared automations

scripts/
├── context-switch.sh      # Switch active project (updates CONTEXT_DIR)
├── context-list.sh        # List all projects with metadata
└── context-create.sh      # Create new project from template

Each project (context repository instance):
~/context-repos/{project-name}/
├── context.json           # Links to repositories for this project
├── daily-digest.md        # Project-specific digest
├── docs/                  # Project-specific documentation
├── architecture/          # Project-specific architecture
└── .context/              # Project-specific index
```

## 12. Risks & Mitigations

- **Registry corruption**: Backup/restore mechanism, validate JSON on load, auto-backup before writes
- **Path changes break projects**: Use project IDs (not paths) as primary key, validate paths on load, allow path updates
- **Too many projects**: Pagination, filtering, archiving, search/filter in CLI
- **Repository overlap confusion**: Clear project context in search results, show which project each result belongs to

## 13. Rollout Plan

1. Design and implement project registry structure (`~/.context/projects.json`)
2. Implement CLI commands (`context list`, `context switch`, `context create`)
3. Update context loading to use active project from registry
4. Add project relationship support (part-of, depends-on, related-to)
5. Add project discovery (auto-detect context repositories)
6. Document multi-project usage in README and AGENTS.md

## 14. Future Extensions

- Project archiving and restoration
- Project templates marketplace
- Project sharing and collaboration (requires spec 003)
- Project analytics and insights
- Isolated environments per project (Docker, workspaces)

## 15. Acceptance Validation

- Can create and switch between 3+ projects (company, division, product)
- Cross-project search returns results with project context
- Single project mode still works without registry (backward compatible)
- Project relationships are queryable (e.g., find all division projects under company)
- Same repository can appear in multiple projects with different context

---
End of Spec.

