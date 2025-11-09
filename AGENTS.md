# Agent Onboarding Guide

Welcome! This document is your starting point for understanding how to work effectively with this context template repository. Read this first, then explore the other documentation as needed.

---

## 🎯 Purpose

This repository is a **context management system** designed to help AI agents (and humans) understand project state, workflows, and conventions. It provides:

- **Structured workflows** for picking up and handing off work
- **Centralized documentation** about architecture, decisions, and patterns
- **Automation scripts** for common tasks
- **Standardized protocols** for development work

---

## 🚀 Quick Start

### 1. Understand the Core Workflow

The fundamental workflow is: **Morning Sync → Pickup → Do → Handoff**

1. **Morning Sync**: Read `daily-digest.md` to understand current priorities
2. **Pickup**: Use `prompts/PICKUP.md` to orient yourself to a task
3. **Do**: Implement the work
4. **Handoff**: Use `prompts/HANDOFF.md` to document your progress

### 2. Read These Files First

Start with these files in order:

1. **`README.md`** - Overview of the template and its purpose
2. **`constitution.md`** - Core principles and governance
3. **`daily-digest.md`** - Current project status (if it exists)
4. **`context.json`** - Links to related repositories and resources

### 3. Understand the Directory Structure

```
context-template/
├── prompts/          # Workflow protocols (PICKUP.md, HANDOFF.md)
├── architecture/     # High-level design and decisions
├── perspectives/    # Project-specific context and goals
├── operations/       # Operational patterns and policies
├── specs/            # Feature specifications
├── journal/          # Long-term learnings and notes
├── docs/             # Documentation (definitions, guides)
├── automations/      # Automation scripts
├── examples/         # Example implementations
└── context.json      # Central configuration file
```

---

## 📋 Essential Protocols

### PICKUP Protocol

When starting work on a task, follow `prompts/PICKUP.md`:

1. Read the daily digest
2. Identify what you're working on
3. Review handoff documentation
4. Verify your environment
5. Understand next steps
6. Resume work

**Key Command:**
```bash
cat ${CONTEXT_DIR:-.}/daily-digest.md
```

### HANDOFF Protocol

When finishing work or pausing, follow `prompts/HANDOFF.md`:

1. Document what was completed
2. Document what remains
3. Note any blockers or questions
4. Update handoff document
5. Commit documentation

**Key Command:**
```bash
# Create or update handoff doc
vim docs/TICKET-XXXX-handoff.md
```

---

## 🔧 Configuration

### Environment Variables

- **`CONTEXT_DIR`**: Path to the context repository (defaults to current directory)
  ```bash
  export CONTEXT_DIR=/path/to/context/repo
  ```

### Configuration Files

- **`context.json`**: Links to related repositories, services, and tools
- **`mcp.config.json`**: Configuration for MCP server and document ingestion
- **`constitution.md`**: Project principles and governance

---

## 📚 Key Concepts

### Context is King

All work begins and ends with context. This repository is the definitive source for:
- Project status
- Architecture decisions
- Workflow protocols
- Team conventions

### Systematic Workflows

Follow standardized protocols:
- Use `PICKUP.md` when starting work
- Use `HANDOFF.md` when finishing work
- Document decisions in `journal/` or `architecture/`
- Update `context.json` when adding new resources

### Explicit Handoffs

No work is complete until it's documented in a handoff document. This ensures:
- Context is preserved in the filesystem
- Next person (or agent) can pick up where you left off
- Knowledge is not lost

### Transparency

Blockers must be surfaced immediately. Document them in:
- Handoff documents
- Daily digest
- Ticket comments

---

## 🛠️ Common Tasks

### Finding What to Work On

1. Check `daily-digest.md` for active work
2. List open tickets: `jira issue list -q "assignee = currentUser() AND status IN ('In Progress', 'Selected for Development')"`
3. List open PRs: `gh pr list --author @me --state open`

### Understanding Current State

1. Read handoff docs: `ls docs/*-handoff.md`
2. Check git status: `git status`
3. Review recent commits: `git log --oneline -10`
4. Check PR status: `gh pr view`

### Documenting Work

1. Create summary: `docs/TICKET-XXXX-summary.md`
2. Create handoff: `docs/TICKET-XXXX-handoff.md`
3. Update journal: `journal/YYYY-MM-DD-topic.md` (for significant learnings)

### Updating Context

1. Update `context.json` when adding new repositories or services
2. Update `perspectives/` for project-specific context
3. Update `architecture/` for design decisions
4. Update `operations/` for operational patterns

---

## 🔍 Discovery Patterns

### Finding Related Information

- **Architecture decisions**: Check `architecture/` directory
- **Project context**: Check `perspectives/` directory
- **Operational patterns**: Check `operations/` directory
- **Feature specs**: Check `specs/` directory
- **Historical learnings**: Check `journal/` directory

### Using context.json

The `context.json` file links to:
- Related repositories (with local paths)
- Documentation files
- Automation scripts
- External services
- CLI tools

**Example:**
```bash
# Find linked repositories
cat context.json | jq '.repositories[].localPath'

# Find documentation
cat context.json | jq '.docs[]'
```

---

## 📖 Documentation Standards

### Handoff Documents

Every ticket should have a handoff document (`docs/TICKET-XXXX-handoff.md`) that includes:
- Current status
- What was completed
- What remains
- Next steps
- Blockers/questions
- Key files to review

### Architecture Documents

Store in `architecture/`:
- High-level design decisions
- System architecture diagrams
- Integration patterns
- Technology choices

### Perspective Documents

Store in `perspectives/`:
- Project goals and status
- Team context
- Business context
- Current priorities

---

## 🚨 Common Pitfalls

### Missing Daily Digest

If `daily-digest.md` doesn't exist:
1. Check if `automations/daily-digest.sh` needs to be customized
2. Run: `./automations/daily-digest.sh generate`
3. Or create a template manually

### Hardcoded Paths

If you see hardcoded paths like `~/github/context/`:
- Replace with `${CONTEXT_DIR:-.}` or relative paths
- Check `context.json` for linked repositories
- Use environment variables when possible

### Project-Specific References

If you see project-specific references (like "OneNews", "DXT-1234"):
- These are placeholders - replace with your project's actual names
- Use generic placeholders like `{{PROJECT_NAME}}` or `TICKET-1234`

---

## 🔗 Related Documentation

- **`prompts/PICKUP.md`** - Detailed pickup protocol
- **`prompts/HANDOFF.md`** - Detailed handoff protocol
- **`constitution.md`** - Project principles and governance
- **`faq.md`** - Frequently asked questions
- **`docs/definitions.md`** - Key vocabulary and definitions

---

## 💡 Best Practices

1. **Always read the daily digest first** - It's your starting point
2. **Follow the protocols** - They're designed to save time
3. **Document as you go** - Don't wait until the end
4. **Update context files** - Keep them current
5. **Ask questions early** - Document blockers immediately
6. **Use handoff docs** - They're your future self's best friend

---

## 🆘 Getting Help

If you're stuck:

1. **Check the daily digest** - Might have relevant info
2. **Read handoff docs** - Previous work might help
3. **Search the codebase** - `grep -r "keyword" .`
4. **Check git history** - `git log -p --all -S "search-term"`
5. **Review architecture docs** - Might explain the design
6. **Check `context.json`** - Might link to relevant resources

---

## 🎓 Learning Path

1. **Start here** - Read this file (AGENTS.md)
2. **Understand the workflow** - Read `prompts/PICKUP.md` and `prompts/HANDOFF.md`
3. **Learn the principles** - Read `constitution.md`
4. **Explore examples** - Check `examples/` and `journal/` directories
5. **Customize for your project** - Update `context.json` and project-specific files

---

**Remember:** This template is designed to be customized. Replace placeholders, update paths, and adapt workflows to fit your project's needs. The structure is a starting point, not a constraint.

