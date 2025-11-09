# Agent Handoff Protocol

## Purpose
This prompt provides comprehensive instructions for AI coding agents to understand the current state of work and continue development tasks effectively. Use this when handing off work between sessions or when a new agent needs to pick up where you left off.

---

## 🎯 Quick Orientation

### Current Context Access
**ALWAYS START HERE** - These are your essential context sources:

1.  **Daily Digest** (`${CONTEXT_DIR:-.}/daily-digest.md`)
    - Auto-generated at 9 AM daily from Jira and GitHub
    - Shows active tickets, PRs, and recent activity
    - **Read this FIRST** to understand current priorities

2.  **Active Pull Request** 
    ```bash
    gh pr view
    ```
    - Shows the current PR you're working on
    - Includes description, status checks, and comments

3.  **Git Status & Branch**
    ```bash
    git status
    git branch --show-current
    ```
    - Verify which branch you're on
    - Check for uncommitted changes

4.  **Jira Ticket Details**
    ```bash
    jira issue view <TICKET-ID>
    ```
    - Get acceptance criteria, requirements, and context
    - Check comments and attachments

---

## 🔍 Discovery Process

### Step 1: Understand What Was Being Worked On

#### Check Active Work
```bash
# View current Jira tickets
jira issue list -q "assignee = currentUser() AND status IN ('In Progress', 'Selected for Development')"

# View your open PRs
gh pr list --author @me --state open

# Check the most recent PR
gh pr view

# View recent commits
git log --oneline -10
```

#### Check Documentation Trail
Look for these in the codebase:
- `docs/*-handoff.md` - Explicit handoff documents
- `docs/*-summary.md` - Implementation summaries
- `docs/*-implementation-journal.md` - Detailed development logs
- `docs/*-testing-checklist.md` - QA procedures
- `decision-records/` - Architecture Decision Records (ADRs)

#### Check Terminal History
```bash
# What commands were run recently?
history | tail -20
```

### Step 2: Verify the Environment

#### Workspace Structure
```
{{PROJECT_NAME}}/              # Main project platform (web + API)
{{PROJECT_NAME}}-services/     # Supporting services
{{PROJECT_NAME}}-infra/         # Infrastructure & tooling
{{PROJECT_NAME}}-flags/         # Feature flag management
context/                        # This repo - documentation & context
```

#### Check Current Directory
```bash
pwd
ls -la
```

#### Verify Dependencies
```bash
# For Node.js projects
pnpm install

# For Python projects
cd {{PROJECT_DIR}} && make test

# Check environment variables
cat .env | grep -v "^#" | head -10
```

### Step 3: Review Recent Changes

#### Git Diff
```bash
# View uncommitted changes
git diff

# View staged changes
git diff --staged

# Compare with main branch
git diff main..HEAD
```

#### Pull Request Context
```bash
# View PR details with comments
gh pr view --comments

# View PR checks status
gh pr checks

# View PR diff
gh pr diff
```

---

## 🛠️ Available Tools & Commands

### Jira CLI
```bash
# List your active tickets
jira issue list -q "assignee = currentUser()"

# View specific ticket
jira issue view TICKET-1234

# Add a comment
jira issue comment TICKET-1234 "Working on implementation"

# Transition ticket
jira issue move TICKET-1234 "In Progress"

# Open ticket in browser
jira issue view TICKET-1234 --web
```

### GitHub CLI
```bash
# View current PR
gh pr view

# List PRs
gh pr list --author @me

# Check PR status
gh pr checks

# View PR comments
gh pr view --comments

# Create new PR
gh pr create --draft --title "TICKET-1234: Feature name" --body "Description"

# Review PR
gh pr review --approve
gh pr review --comment --body "LGTM!"
gh pr review --request-changes --body "Please address..."

# Merge PR
gh pr merge --squash
```

### VS Code Tasks
Access via Command Palette (`Cmd+Shift+P` → "Tasks: Run Task"):

- **Generate Daily Context Digest** - Refresh Jira data
- **Quick Jira Status Check** - Terminal status of active tickets
- **Open Jira Board** - Launch browser to board
- **Quick Status Check (Jira + GitHub)** - Combined overview

### Context Automation Scripts
```bash
cd ${CONTEXT_DIR:-.}

# Generate fresh digest
./automations/daily-digest.sh generate

# Quick status check
./automations/daily-digest.sh quick

# View digest in terminal
./automations/daily-digest.sh view

# Open Jira board
./automations/daily-digest.sh board
```

---

## 📋 Common Workflows

### Starting a New Ticket

1.  **Get ticket details**
    ```bash
    jira issue view TICKET-1234
    ```

2.  **Create feature branch**
    ```bash
    git checkout main
    git pull origin main
    git checkout -b TICKET-1234
    ```

3.  **Move ticket to "In Progress"**
    ```bash
    jira issue move TICKET-1234 "In Progress"
    ```

4.  **Create documentation**
    Create in `docs/`:
    - `TICKET-1234-summary.md` - What you're building
    - `TICKET-1234-implementation-journal.md` - Development log
    - `TICKET-1234-testing-checklist.md` - QA steps
    - `TICKET-1234-handoff.md` - Next person's guide

### Continuing Work on Existing Branch

1.  **Check branch status**
    ```bash
    git status
    gh pr view  # If PR exists
    ```

2.  **Review documentation**
    ```bash
    ls docs/ | grep -i "$(git branch --show-current)"
    ```

3.  **Check for handoff document**
    ```bash
    cat docs/*-handoff.md
    ```

4.  **Review recent commits**
    ```bash
    git log --oneline -5
    ```

5.  **Check if tests are passing**
    ```bash
    # For Node.js projects
    cd {{PROJECT_DIR}} && pnpm test
    
    # For Python projects
    cd {{PROJECT_DIR}} && make test
    ```

### Opening a Pull Request

1.  **Ensure tests pass locally**
    ```bash
    pnpm test  # or make test
    ```

2.  **Create PR**
    ```bash
    gh pr create --draft \
      --title "TICKET-1234: Brief description" \
      --body "$(cat docs/TICKET-1234-summary.md)"
    ```

3.  **Add PR number to handoff doc**
    Update `docs/TICKET-1234-handoff.md` with PR link

4.  **Monitor CI checks**
    ```bash
    gh pr checks --watch
    ```

### Code Review Process

1.  **Check who should review**
    - Look at CODEOWNERS file
    - Check Jira ticket for stakeholders
    - Ask in Slack if unsure

2.  **Request review**
    ```bash
    gh pr edit --add-reviewer username
    ```

3.  **Address feedback**
    - Make changes
    - Push commits
    - Reply to comments: `gh pr comment <PR> --body "Fixed in commit abc123"`

### Deploying Changes

1.  **Merge to main**
    ```bash
    gh pr merge --squash
    ```

2.  **Check deployment status**
    - Check deployment dashboard (see `context.json` for links)
    - Monitor in team communication channel

3.  **Update Jira**
    ```bash
    jira issue move TICKET-1234 "Done"
    ```

---

## 🏗️ Project-Specific Patterns

> **Note:** Customize this section with your project's specific patterns, tools, and workflows. The examples below are templates.

### Frontend/Web Services

**Location:** Check `context.json` for linked repositories

**Key Directories:**
- `src/` or `app/` - Application code
- `components/` - Reusable components
- `lib/` or `utils/` - Shared utilities

**Running Locally:**
```bash
cd {{PROJECT_DIR}}
pnpm install  # or npm install, yarn install
pnpm dev      # Start development server
```

**Testing:**
```bash
pnpm test           # Unit tests
pnpm test:watch     # Watch mode
pnpm test:e2e       # E2E tests (if configured)
```

### Backend/API Services

**Location:** Check `context.json` for linked repositories

**Running Locally:**
```bash
# Docker (if available)
make run  # or docker-compose up

# Direct
cd {{PROJECT_DIR}}
make run-server  # or python -m uvicorn main:app, etc.
```

**Testing:**
```bash
make test        # Unit tests
pytest           # Python projects
npm test         # Node.js projects
```

**Key Files:**
- `src/` or `app/` - Application code
- `routes/` or `endpoints/` - API endpoints
- `services/` - Business logic
- `models/` - Data models

### Feature Flags System

**Location:** Check `context.json` for linked repositories

**Common Tools:**
- ConfigCat, LaunchDarkly, OpenFeature, etc.

**Key Concepts:**
- Feature flag configuration
- A/B testing cohorts
- Environment-based flags

**Common Tasks:**
```bash
# Customize based on your feature flag system
./scripts/manage-flags.sh
```

---

## 📝 Documentation Standards

### Create These Documents For Every Ticket

#### 1. Summary (`TICKET-XXXX-summary.md`)
```markdown
# TICKET-XXXX Implementation Summary

## Ticket Overview
**Title:** [Title from Jira]
**Status:** [Implementation stage]

## What Was Implemented
- [List of completed work]

## Acceptance Criteria Met
- [x] Criterion 1
- [ ] Criterion 2 (in progress)

## Next Steps
1. [Next action]
2. [Then this]
```

#### 2. Implementation Journal (`TICKET-XXXX-implementation-journal.md`)
Log your thought process:
```markdown
# TICKET-XXXX Implementation Journal

## Investigation Phase
- Found X in file Y
- Discovered pattern Z

## Implementation Steps
1. Did A because B
2. Modified C to achieve D

## Learnings
- Pattern to follow: ...
- Pattern to avoid: ...
```

#### 3. Testing Checklist (`TICKET-XXXX-testing-checklist.md`)
```markdown
# TICKET-XXXX Testing Checklist

## Setup
- [ ] Dependencies installed
- [ ] Environment variables set

## Manual Testing
- [ ] Feature works on desktop
- [ ] Feature works on mobile
- [ ] Edge case: ...

## Automated Tests
- [ ] Unit tests pass
- [ ] E2E tests pass
```

#### 4. Handoff Document (`TICKET-XXXX-handoff.md`)
**This is the most critical document:**
```markdown
# TICKET-XXXX Handoff Document

## Status: [IN PROGRESS | BLOCKED | READY FOR REVIEW]

## Spec-Driven Phase Summary

*   **Current Phase:** [spec | plan | tasks | src]
*   **Current Task:** [Description of the current task]

## Quick Summary
[One paragraph - what was done, what remains]

## What Was Done
- [x] Completed item 1
- [x] Completed item 2

## What Remains
- [ ] Todo item 1
- [ ] Todo item 2

## Next Steps
1. [First thing to do when picking this up]
2. [Then this]

## Blockers
- [Any issues preventing progress]

## Key Files to Review
- `path/to/file.ts` - [Why important]

## Questions/Decisions Needed
- [Any open questions]

## Documentation Created
- [List other docs]
```

### When to Create ADRs

Create an Architecture Decision Record in `decision-records/` when:
- Making significant architectural changes
- Identifying technical debt patterns
- Proposing refactoring strategies
- Documenting trade-offs

**Format:**
```markdown
# ADR-XXXX: [Title]

- **Status**: Proposed/Accepted/Deprecated
- **Date**: YYYY-MM-DD

## Context
[Why is this decision needed?]

## Decision
[What are we doing?]

## Consequences
### Positive
- [Benefits]

### Negative
- [Trade-offs]
```

---

## 🚨 Common Pitfalls & Solutions

### "I don't know what I'm supposed to be working on"

1.  Check daily digest: `cat ${CONTEXT_DIR:-.}/daily-digest.md`
2.  List your Jira tickets: `jira issue list -q "assignee = currentUser() AND status != Done"`
3.  Check recent git activity: `git log --oneline --author="$(git config user.name)" -20`
4.  Look for handoff docs: `ls docs/*-handoff.md`

### "The environment won't start"

**For Node.js projects:**
```bash
# 1. Check .env files exist
ls {{PROJECT_DIR}}/.env

# 2. Install dependencies
cd {{PROJECT_DIR}} && pnpm install  # or npm install, yarn install

# 3. Check Node version
node --version  # Check your project's required version

# 4. Clear cache if needed
rm -rf .next .nuxt .output node_modules/.cache
pnpm install
```

**For Python projects:**
```bash
# 1. Check .env exists
ls {{PROJECT_DIR}}/.env

# 2. Test with Docker (if available)
cd {{PROJECT_DIR}} && make run

# 3. Check Docker is running
docker ps
```

### "Tests are failing"

1.  **Check if it's your changes:**
    ```bash
    git stash
    pnpm test
    git stash pop
    ```

2.  **Look for test output:**
    - Read the error messages carefully
    - Check file paths mentioned in errors
    - Look for missing mocks or imports

3.  **Common fixes:**
    ```bash
    # Clear test cache
    pnpm test --clearCache
    
    # Update snapshots (if needed)
    pnpm test -u
    
    # Run single test file
    pnpm test path/to/file.test.ts
    ```

### "I need to coordinate with someone"

**Check Jira ticket** for:
- Watchers
- Comments mentioning people
- "Relates to" links to other tickets

**Communication channels:**
- Check `context.json` for links to team communication tools
- Check project documentation for team channels
- Check CODEOWNERS file for code areas and reviewers

### "I need access to something"

**Password manager:**
- Check your team's password manager for .env files and credentials
- Search for: "{{PROJECT_NAME}} dotenv", "{{SERVICE_NAME}} dotenv"

**AWS Access:**
- Credentials in .env files have read-only staging access
- For write access, ask in Slack

**ConfigCat:**
- Credentials in 1Password
- Feature flag configs in `duplex-feature-flags` repo

---

## 🎯 Before You End Your Session

### Create/Update Handoff Document

1.  **Capture current state:**
    ```markdown
    ## Status: [Current status]
    
    Last commit: [hash and message]
    PR: [link if exists]
    
    ## What I Just Did
    - [List recent work]
    
    ## What's Next
    1. [Next immediate step]
    2. [Then this]
    
    ## Blockers/Questions
    - [Any issues]
    ```

2.  **Commit documentation:**
    ```bash
    git add docs/
    git commit -m "docs: update handoff for TICKET-1234"
    git push
    ```

3.  **Update ticket:**
    ```bash
    jira issue comment TICKET-1234 "Updated handoff doc. Status: [...]"
    ```

### Clean Workspace

```bash
# Commit or stash changes
git status
git add .
git commit -m "WIP: [description]"
# or
git stash save "WIP: [description]"

# Push if on feature branch
git push origin HEAD
```

### Update Context Files

If you learned something important, update:
- `${CONTEXT_DIR:-.}/perspectives/[relevant-topic].md`
- `${CONTEXT_DIR:-.}/architecture/[relevant-pattern].md`
- Project-specific `.github/copilot-instructions.md` or `AGENTS.md`

---

## 🔗 Quick Reference Links

### Documentation
- **Definitions**: `${CONTEXT_DIR:-.}/docs/definitions.md`
- Check `context.json` for links to project-specific READMEs and documentation
- Check linked repositories in `context.json` for contributing guides

### Project Management & Planning
- Check `context.json` for links to your project management tools (Jira, Linear, etc.)
- Check `context.json` for links to documentation wikis (Confluence, Notion, etc.)

### Deployments & Monitoring
- Check `context.json` for links to deployment dashboards and monitoring tools
- Check project documentation for deployment URLs and monitoring links

---

## 💡 Tips for Effective Handoffs

1.  **Write for your future self** - Assume you'll forget everything
2.  **Be specific** - "Run pnpm test" not "run tests"
3.  **Include context** - WHY decisions were made, not just WHAT
4.  **Link everything** - PR numbers, Jira tickets, Slack threads
5.  **Test your handoff** - Could someone pick this up cold?
6.  **Update as you go** - Don't wait until the end
7.  **Use checkboxes** - Makes progress visible
8.  **Note what DIDN'T work** - Save future you from dead ends

---

## 🆘 When You're Stuck

1.  **Check the daily digest** - Might have relevant info
2.  **Search the codebase** - `grep -r "similar-pattern"`
3.  **Check git history** - `git log -p --all -S "search-term"`
4.  **Look at related PRs** - `gh pr list --search "keyword"`
5.  **Review ADRs** - `ls decision-records/`
6.  **Ask in Slack** - Include what you've tried
7.  **Update handoff doc** - Document the blocker for next session

---

**Remember:** The goal is to make the next session (or agent) as productive as possible. Invest time in documentation now to save multiples of that time later.
