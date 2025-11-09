# Tasks: Multi-Project Management

**Branch**: `002-multi-project-management` | **Date**: 2025-01-XX
**Derived From**: `specs/002-multi-project-management/plan.md`
**Status**: Active

## Conventions
- [P] denotes parallelizable
- Dependencies by ID

## Tasks
1. [ ] [P] Design project registry schema (JSON structure, fields, relationships)
2. [ ] Create `~/.context/projects.json` structure with validation
3. [ ] Implement `context list` command (show all projects with metadata)
4. [ ] Implement `context switch <project-name>` command (update active project)
5. [ ] Implement `context create <project-name>` command (initialize from template)
6. [ ] Update context loading to use active project from registry (depends: 4)
7. [ ] Add project validation on load (check path exists, context.json valid) (depends: 6)
8. [ ] [P] Add relationship storage in registry (depends-on, related-to, part-of) (depends: 2)
9. [ ] Implement relationship queries (find related projects, dependencies) (depends: 8)
10. [ ] [P] Add project auto-discovery (scan directories for context.json) (depends: 2)
11. [ ] [P] Add project template support (create from template, customize) (depends: 5)
12. [ ] Tests for project management (registry, switching, relationships) (depends: 9)
13. [ ] Update documentation (AGENTS.md, README.md with multi-project usage) (depends: 12)
14. [ ] Delivery checklist & polish (depends: 13)

## Blockers
- None identified yet.

## Decisions
- Use `~/.context/` for global config (home directory)
- Project IDs are unique, names can have aliases
- Maintain backward compatibility with single-project mode
- **Project = Context Repository Instance** with organizational boundary
- Projects can share repositories (same repo in multiple projects' `context.json`)
- Relationship types: `part-of` (hierarchical), `depends-on`, `related-to`

## Follow-ups
- Consider project archiving for inactive projects
- Add project templates marketplace in future

