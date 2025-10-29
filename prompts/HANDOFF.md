# Agent Handoff Protocol

## Purpose
This prompt provides comprehensive instructions for AI coding agents to understand the current state of work and continue development tasks effectively. Use this when handing off work between sessions or when a new agent needs to pick up where you left off.

---

## 🎯 Quick Orientation

### Current Context Access
**ALWAYS START HERE** - These are your essential context sources:

1.  **Daily Digest** (`~/github/context/daily-digest.md`)
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
onenews/              # Main OneNews platform (web + API)
duplex-quartz/        # Quartz email platform
duplex-infra-services/# Infrastructure & tooling
duplex-feature-flags/ # ConfigCat feature flag management
context/              # This repo - documentation & context
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

# For Python projects (content-firehose)
cd content-firehose && make test

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
jira issue view DXT-1234

# Add a comment
jira issue comment DXT-1234 "Working on implementation"

# Transition ticket
jira issue move DXT-1234 "In Progress"

# Open ticket in browser
jira issue view DXT-1234 --web
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
gh pr create --draft --title "DXT-1234: Feature name" --body "Description"

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
cd ~/github/context

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
    jira issue view DXT-1234
    ```

2.  **Create feature branch**
    ```bash
    git checkout main
    git pull origin main
    git checkout -b DXT-1234
    ```

3.  **Move ticket to "In Progress"**
    ```bash
    jira issue move DXT-1234 "In Progress"
    ```

4.  **Create documentation**
    Create in `docs/`:
    - `DXT-1234-summary.md` - What you're building
    - `DXT-1234-implementation-journal.md` - Development log
    - `DXT-1234-testing-checklist.md` - QA steps
    - `DXT-1234-handoff.md` - Next person's guide

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
    # For web-services
    cd web-services && pnpm test
    
    # For content-firehose
    cd content-firehose && make test
    ```

### Opening a Pull Request

1.  **Ensure tests pass locally**
    ```bash
    pnpm test  # or make test
    ```

2.  **Create PR**
    ```bash
    gh pr create --draft \
      --title "DXT-1234: Brief description" \
      --body "$(cat docs/DXT-1234-summary.md)"
    ```

3.  **Add PR number to handoff doc**
    Update `docs/DXT-1234-handoff.md` with PR link

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
    - OneNews: [Cloudflare Dashboard](https://dash.cloudflare.com/8ef0462e0a2648876153c476d336d574/workers-and-pages)
    - Monitor in Slack deployment channel

3.  **Update Jira**
    ```bash
    jira issue move DXT-1234 "Done"
    ```

---

## 🏗️ Project-Specific Patterns

### OneNews Web Services

**Location:** `~/github/onenews/web-services/`

**Key Directories:**
- `common/` - Shared components and utilities
- `onenews/` - OneNews-specific code
- `shiftnews/` - ShiftNews white-label
- `gen-digital/` - Gen Digital white-label

**Running Locally:**
```bash
cd web-services
pnpm install
pnpm dev:on   # OneNews on :3001
pnpm dev:sn   # ShiftNews on :3002
pnpm dev      # All services
```

**Testing:**
```bash
pnpm test           # Unit tests
pnpm test:watch     # Watch mode
pnpm test:e2e       # E2E tests (requires build first)
pnpm test:e2e:ui    # E2E with Playwright UI
```

**Common Tasks:**
- Components live in `common/components/`
- Composables in `common/composables/`
- Split test configs in `server/assets/configs/layoutSettings/`
- Feature flags via OpenFeature/ConfigCat

### Content Firehose (Python API)

**Location:** `~/github/onenews/content-firehose/`

**Running Locally:**
```bash
# Docker (recommended)
make run  # http://localhost:5001

# Direct
make run-server  # http://localhost:5000

# With live reload
make run-dev  # http://localhost:5001
```

**Testing:**
```bash
make test        # Unit tests
make etl         # Run all ETLs
make etl-stn     # Run STN ETL only
make migrate     # Run DB migrations
```

**Swagger UI:** http://localhost:5001/openapi/swagger

**Key Files:**
- `presentation/` - API endpoints
- `adapters/` - ETL integrations
- `domain/` - Business logic
- `infrastructure/` - Database & external services

### Feature Flags System

**Location:** `~/github/duplex-feature-flags/`

**Terraform-based ConfigCat management:**
```bash
cd terraform
terraform plan
terraform apply
```

**Key Concepts:**
- 10 user cohorts per tenant for A/B testing
- Cookie-based persistence
- Integration with MixPanel, OpenFeature

**Common Tasks:**
```bash
./scripts/add-experiment.sh  # Interactive experiment creation
./scripts/cohort-client.js    # Test cohort assignment
```

### Quartz Platform

**Location:** `~/github/quartz/duplex-quartz/`

**Email subscription management platform**

**Running Locally:**
```bash
pnpm install
pnpm dev  # Next.js on :3000
```

**Testing:**
```bash
pnpm test
pnpm test:watch
```

---

## 📝 Documentation Standards

### Create These Documents For Every Ticket

#### 1. Summary (`DXT-XXXX-summary.md`)
```markdown
# DXT-XXXX Implementation Summary

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

#### 2. Implementation Journal (`DXT-XXXX-implementation-journal.md`)
Log your thought process:
```markdown
# DXT-XXXX Implementation Journal

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

#### 3. Testing Checklist (`DXT-XXXX-testing-checklist.md`)
```markdown
# DXT-XXXX Testing Checklist

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

#### 4. Handoff Document (`DXT-XXXX-handoff.md`)
**This is the most critical document:**
```markdown
# DXT-XXXX Handoff Document

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

1.  Check daily digest: `cat ~/github/context/daily-digest.md`
2.  List your Jira tickets: `jira issue list -q "assignee = currentUser() AND status != Done"`
3.  Check recent git activity: `git log --oneline --author="$(git config user.name)" -20`
4.  Look for handoff docs: `ls docs/*-handoff.md`

### "The environment won't start"

**For web-services:**
```bash
# 1. Check .env files exist
ls web-services/{onenews,shiftnews}/.env

# 2. Install dependencies
cd web-services && pnpm install

# 3. Check Node version
node --version  # Should be 20.x or 22.x

# 4. Clear cache if needed
rm -rf .nuxt .output node_modules/.cache
pnpm install
```

**For content-firehose:**
```bash
# 1. Check .env exists
ls content-firehose/.env

# 2. Test with Docker
cd content-firehose && make run

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

**Slack channels:**
- #onenews - OneNews development
- #quartz - Quartz development
- #dx-team - DX team general

**Key people mentioned in docs:**
- Tristan - Feature flags and split testing
- Check CODEOWNERS file for code areas

### "I need access to something"

**1Password vaults:**
- `Duplex General` - Most .env files and credentials
- Search for: "OneNews dotenv", "content-api dotenv"

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
    git commit -m "docs: update handoff for DXT-1234"
    git push
    ```

3.  **Update Jira:**
    ```bash
    jira issue comment DXT-1234 "Updated handoff doc. Status: [...]"
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
- `~/github/context/perspectives/[relevant-topic].md`
- `~/github/context/architecture/[relevant-pattern].md`
- Project-specific `.github/copilot-instructions.md`

---

## 🔗 Quick Reference Links

### Documentation
- **OneNews README**: `~/github/onenews/README.md`
- **Content API README**: `~/github/onenews/content-firehose/README.md`
- **Feature Flags README**: `~/github/duplex-feature-flags/README.md`
- **Contributing Guide**: `~/github/onenews/docs/CONTRIBUTING.md`

### Jira & Planning
- [DX Jira Board](https://redbrickmedia.atlassian.net/jira/software/c/projects/DXT/boards/129)
- [OneNews Board](https://redbrickmedia.atlassian.net/jira/software/c/projects/ON/boards/102)
- [Confluence](https://redbrickmedia.atlassian.net/wiki/spaces/TRON/overview)

### Deployments & Monitoring
- [Cloudflare Dashboard](https://dash.cloudflare.com/8ef0462e0a2648876153c476d336d574/workers-and-pages)
- [MixPanel](https://mixpanel.com/project/2083804/view/99051/app/boards#id=6354384)

### Live Sites
- [onenews.com](https://onenews.com)
- [staging.onenews.com](https://staging.onenews.com)
- [shiftntp.com](https://shiftntp.com)
- [staging.shiftntp.com](https://staging.shiftntp.com)

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
