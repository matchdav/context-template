# Agent Pickup Protocol


## Purpose

This prompt guides you through a systematic process to pick up work from where it was left off. Follow this checklist to quickly orient yourself and continue development effectively.


------


## 🚀 Quick Start Checklist


Use this checklist at the start of every session. Check off items as you go:


- [ ] Read the daily digest
- [ ] Identify active work
- [ ] Review handoff documentation
- [ ] Check Spec-Driven Phase
- [ ] Verify environment
- [ ] Understand next steps
- [ ] Resume work


------


## 📋 Step-by-Step Pickup Process


### Step 1: Read the Daily Digest (2 min)

**This is your most important starting point.**

```bash
# If CONTEXT_DIR environment variable is set, use it; otherwise use current directory
cat ${CONTEXT_DIR:-.}/daily-digest.md
```

**What to look for:**
- 🎯 **My Active Work** - Tickets in progress or ready to start
- 🔄 **Team Activity** - Recent updates that might affect your work
- 🐙 **GitHub Activity** - Your open PRs and recent comments
- 📊 **Metrics** - Total active tickets and their status

**Key Questions:**
- What tickets are marked "In Progress"?
- Are there any open PRs waiting for action?
- What was updated in the last 24 hours?

---


### Step 2: Identify What You're Working On (3 min)

#### Option A: If you have active work in progress

Check your current git status:

```bash
# See what branch you're on
git branch --show-current

# See if there are uncommitted changes
git status

# Check if there's an open PR for this branch
gh pr view
```

#### Option B: If starting fresh

Check for assigned work:

```bash
# List your active Jira tickets
jira issue list -q "assignee = currentUser() AND status IN ('In Progress', 'Selected for Development')"

# List your open PRs that might need work
gh pr list --author @me --state open --json number,title,isDraft,updatedAt
```

**Decision Point:**
- ✅ **Found active work?** → Continue to Step 3
- ❓ **Multiple things in progress?** → Check handoff docs to prioritize
- 🆕 **Nothing in progress?** → Pick from "Selected for Development" or ask in Slack

---


### Step 3: Review Handoff Documentation (5 min)

**Look for handoff documents first - they're your fastest path to understanding the work.**

```bash
# Find handoff documents for current branch
ls docs/*-handoff.md

# If on a feature branch like TICKET-1234
cat docs/TICKET-*-handoff.md

# Alternative: search by ticket number
ls docs/ | grep -i "TICKET-1234"
```

**What to extract from handoff docs:**
- ✅ What was completed
- ⏳ What remains to be done
- 🚧 Any blockers or issues
- 🔍 Key files to review
- ❓ Open questions or decisions needed

**If no handoff doc exists:**

Check other documentation:

```bash
# Look for related docs
ls docs/ | grep -i "$(git branch --show-current)"

# Check for ADRs if architectural
ls decision-records/
```

---


### Step 4: Check Spec-Driven Phase (3 min)

**Understand where you are in the spec-driven workflow.**

```bash
# Check the status of the spec
ls spec/

# Check the status of the plan
ls plan/

# Check the status of the tasks
ls tasks/
```

**Key Questions:**
- Are we in the `spec`, `plan`, `tasks`, or `src` phase?
- Is there a `spec.md` file? Is it approved?
- Is there a `plan.md` file? Does it cover the spec?
- What is the current task in `tasks.md`?

---


### Step 5: Understand the Technical Context (5-10 min)

#### Review the Jira Ticket

```bash
# View full ticket details
TICKET=$(git branch --show-current)
jira issue view $TICKET

# Or manually specify
jira issue view TICKET-1234
```

**What to extract:**
- Acceptance criteria (what defines "done")
- Requirements and specifications
- Design mockups or links
- Comments with context or decisions

#### Review Recent Commits

```bash
# See what was done recently on this branch
git log --oneline -10

# See detailed changes
git log -p -3

# Compare with main to see all changes
git log main..HEAD --oneline
```

**Questions to answer:**
- What changes were made?
- What patterns are being followed?
- Are there test files that show intent?

#### Review the Pull Request (if exists)

```bash
# View PR description
gh pr view

# View PR comments and reviews
gh pr view --comments

# Check CI status
gh pr checks

# View the diff
gh pr diff
```

**What to look for:**
- PR description explains the changes
- Review comments might have guidance
- Failed checks indicate what needs fixing
- Draft vs ready for review status

---


### Step 5: Verify Your Environment (3 min)

#### Check Current Working Directory

```bash
pwd
ls -la
```

**Expected locations:**
- Check `context.json` for linked repositories and their local paths
- Common locations might include:
  - `~/projects/{{PROJECT_NAME}}/` - Main project directory
  - `~/projects/{{PROJECT_NAME}}-api/` - API service
  - `~/projects/{{PROJECT_NAME}}-frontend/` - Frontend service

#### Verify Dependencies Are Installed

**For Node.js projects:**
```bash
# Check if node_modules exists
ls node_modules/ > /dev/null 2>&1 && echo "✅ Dependencies installed" || echo "❌ Need to run pnpm install"

# Install if needed
pnpm install
```

**For Python projects:**
```bash
# Check if virtual env is active
echo $VIRTUAL_ENV

# For Python projects, use Make if available
cd {{PROJECT_DIR}}
make test  # This also verifies dependencies
```

#### Check Environment Variables

```bash
# Verify .env exists
ls .env && echo "✅ .env file found" || echo "❌ Need .env from 1Password"

# Quick check (don't print sensitive values)
cat .env | grep -v "#" | grep -c "=" && echo "✅ .env has content"
```

**If missing .env:**
```bash
# Get from password manager using CLI (example with 1Password)
eval $(op signin)
op document get "{{PROJECT_NAME}} dotenv" --out-file .env

# Or download manually from your password manager:
# Vault: "{{VAULT_NAME}}"
# Item: "{{PROJECT_NAME}} dotenv" or "{{SERVICE_NAME}} dotenv"
```

#### Test the Development Server

**For Node.js projects:**
```bash
cd {{PROJECT_DIR}}
pnpm dev   # Or npm run dev, yarn dev, etc.
```

**For Python projects:**
```bash
cd {{PROJECT_DIR}}
make run  # Or python -m uvicorn main:app, etc.
```

**Success indicators:**
- Server starts without errors
- Can access localhost URL
- No missing dependency errors

---


### Step 6: Review Code Changes in Detail (5-10 min)

#### Look at Uncommitted Changes

```bash
# See what files have changes
git status

# View the actual changes
git diff

# If changes are staged
git diff --staged
```

**Questions:**
- Are these intentional changes?
- Do they match what the handoff doc says should be done?
- Are there any debug statements or TODOs?

#### Identify Key Files Modified

```bash
# See all files changed in this branch
git diff --name-only main..HEAD

# See files with most changes
git diff --stat main..HEAD
```

**For each key file, understand:**
- What is this file's purpose?
- What changes were made and why?
- Are there related test files?

#### Read Related Test Files

```bash
# Find test files for a component
# Example: For ComponentName.vue, look for ComponentName.test.ts
ls {{PROJECT_DIR}}/components/**/*.test.ts
ls {{PROJECT_DIR}}/composables/**/*.test.ts

# View test file
cat path/to/component.test.ts
```

**Tests tell you:**
- What the code is supposed to do
- What edge cases are handled
- What the API/interface looks like

---


### Step 7: Understand What's Next (3 min)

#### Check Handoff Doc "Next Steps"

The handoff document should have a clear "Next Steps" section. Example:

```markdown
## Next Steps
1. ⏳ Run E2E tests: `pnpm test:e2e`
2. ⏳ Manual QA using testing checklist
3. ⏳ Request code review on PR #1940
```

#### If No Clear Next Steps

Use this decision tree:

**Is there an open PR?**
- ✅ Yes → Check PR status:
  - 🔴 Failed checks? → Fix failing tests/builds
  - 🟡 Draft PR? → Complete implementation, then mark ready
  - 🟢 Ready for review? → Ping reviewers, address comments
  - ✅ Approved? → Merge it

- ❌ No PR yet → Check implementation status:
  - Tests passing locally? → Open draft PR
  - Tests failing? → Fix tests
  - No tests yet? → Write tests
  - Implementation incomplete? → Continue coding

**Has the ticket been updated?**
```bash
jira issue view TICKET-1234
```
- Check for new comments or changed requirements

---


### Step 8: Create Your Action Plan (2 min)

Based on everything you've learned, write a clear plan:

```markdown
## My Action Plan

**Current Status:** [e.g., "Draft PR open, tests passing, needs E2E testing"]

**Immediate Tasks:**
1. [ ] Run E2E tests locally
2. [ ] Fix any E2E failures
3. [ ] Update handoff doc with results
4. [ ] Mark PR as ready for review

**Blockers:**
- None currently

**Questions:**
- Need to confirm with {{TEAM_MEMBER}} about feature flag setup

**Time Estimate:** ~2 hours
```

---


### Step 9: Verify Tests Pass (5 min)

**Always run tests before continuing work.**

#### For JavaScript/TypeScript Projects

```bash
cd {{PROJECT_DIR}}

# Run unit tests
pnpm test  # or npm test, yarn test, etc.

# Run specific test file if working on particular feature
pnpm test path/to/file.test.ts

# Run in watch mode while developing
pnpm test:watch
```

#### For Python Projects

```bash
cd {{PROJECT_DIR}}

# Run all tests
make test  # or pytest, python -m pytest, etc.

# Run specific test
pytest tests/path/to/test_file.py -v
```

#### Check E2E Tests (if applicable)

```bash
cd {{PROJECT_DIR}}

# Build first (E2E tests require a build)
pnpm build  # or npm run build, etc.

# Run E2E tests
pnpm test:e2e

# Or with UI for debugging
pnpm test:e2e:ui
```

**If tests fail:**
1. Read the error messages carefully
2. Check if failures are related to your changes
3. Verify the failure isn't environmental (try `git stash` and re-run)
4. Fix issues before proceeding

---


### Step 10: Resume Work (Start coding!)

You're now ready to continue! You should know:
- ✅ What ticket you're working on
- ✅ What's been completed
- ✅ What remains to be done
- ✅ Where the code is
- ✅ What tests exist
- ✅ Any blockers or questions
- ✅ Tests are passing

**Pro Tips:**
- Keep the handoff doc open in a tab
- Update it as you make progress
- Commit frequently with clear messages
- Run tests after each logical change
- Document any new decisions or learnings

---


## 🔄 Common Scenarios & Fast Paths

### Scenario 1: "I just opened this workspace"

**Fast Path:**
1. `cat ${CONTEXT_DIR:-.}/daily-digest.md` - See what's active
2. `gh pr list --author @me` - Check your open PRs
3. `gh pr view` - See the most recent one
4. `cat docs/*-handoff.md` - Read handoff doc
5. Continue from Step 5 (Verify Environment)

### Scenario 2: "I was working on this yesterday"

**Fast Path:**
1. `git status` - See current state
2. `cat docs/*-handoff.md` - Quick refresh
3. `pnpm test` or `make test` - Verify tests still pass
4. Continue coding!

### Scenario 3: "There's a PR but I don't remember what's needed"

**Fast Path:**
1. `gh pr view --comments` - Read PR description and comments
2. `gh pr checks` - See if CI is passing
3. `cat docs/*-handoff.md` - Check handoff doc
4. Address PR feedback or blockers

### Scenario 4: "Multiple things in progress, which do I work on?"

**Decision Framework:**
1. Check Jira priorities: `jira issue list -q "assignee = currentUser() AND status = 'In Progress'" --order-by priority`
2. Check PR status: Which ones are blocking others?
3. Check for blockers: What's unblocked and ready to continue?
4. When in doubt: Ask in Slack or check team standup notes

### Scenario 5: "I'm stuck and don't understand the code"

**Investigation Path:**
1. `git log -p path/to/file` - See how the file evolved
2. `git blame path/to/file` - See who wrote each line
3. `gh pr list --search "related-keyword"` - Find related PRs
4. Search for similar patterns: `grep -r "similarFunction" {{PROJECT_DIR}}/`
5. Check ADRs: `ls decision-records/`
6. Ask in Slack with specific questions

### Scenario 6: "Tests are failing and I don't know why"

**Debug Path:**
1. Read the full error message - don't skim
2. Check if it's your changes: `git stash && pnpm test && git stash pop`
3. Run just the failing test: `pnpm test path/to/failing.test.ts`
4. Check for environment issues:
   - Missing .env variables
   - Outdated dependencies: `pnpm install`
   - Cache issues: `pnpm test --clearCache`
5. Check if it's a known issue: `gh issue list --search "test-name"`

---


## 🎯 Quick Commands Reference

### Get Context Fast

```bash
# See current work
git branch --show-current && git status --short && gh pr view --json title,number,url

# See recent activity
git log --oneline --author="$(git config user.name)" -5

# Check Jira
jira issue list -q "assignee = currentUser() AND status IN ('In Progress', 'Selected for Development')"

# See test status
pnpm test --reporter=verbose || make test
```

### Refresh Your Knowledge

```bash
# Re-read daily digest
cat ${CONTEXT_DIR:-.}/daily-digest.md

# Update digest with latest data
cd ${CONTEXT_DIR:-.} && ./automations/daily-digest.sh generate

# See all your open PRs
gh pr list --author @me --json number,title,updatedAt,isDraft

# Check what changed recently
git diff main..HEAD --stat
```

### Validate Your Environment

```bash
# One-liner environment check
[ -f .env ] && echo "✅ .env" || echo "❌ .env" && \
[ -d node_modules ] && echo "✅ node_modules" || echo "❌ node_modules" && \
pnpm test --reporter=minimal && echo "✅ tests pass" || echo "❌ tests fail"
```

---


## 📱 VS Code Integration

### Use VS Code Tasks for Common Actions

Press `Cmd+Shift+P` → type "Tasks: Run Task" → select:

- **Generate Daily Context Digest** - Refresh your daily digest
- **Quick Jira Status Check** - See active tickets in terminal
- **Open Jira Board** - View board in browser
- **Quick Status Check (Jira + GitHub)** - Combined status

### Use VSCode Extensions

Available extensions that help with pickup:
- **GitLens** - See git blame and history inline
- **GitHub Pull Requests** - Review PRs in editor
- **Todo Tree** - See all TODO/FIXME comments
- **Error Lens** - See errors inline

---


## ✅ Pickup Complete Checklist

Before you start coding, verify you can answer these:

- [ ] **What ticket am I working on?** → ________________
- [ ] **What's the current status?** → ________________
- [ ] **What's the next step?** → ________________
- [ ] **Where's the handoff doc?** → ________________
- [ ] **Are tests passing?** → YES / NO
- [ ] **Is the environment working?** → YES / NO
- [ ] **Do I understand the code changes?** → YES / NO
- [ ] **Are there any blockers?** → ________________
- [ ] **Who do I ask if I have questions?** → ________________

**If you answered "NO" or "I don't know" to any question above, go back and re-investigate that area.**

---


## 🎓 Learning From Pickups

Each time you pick up work, you're learning about the system. Document insights:

### Update Context Files

If you learned something valuable:

```bash
# Update perspective documents
vim ${CONTEXT_DIR:-.}/perspectives/[topic].md

# Update architecture docs
vim ${CONTEXT_DIR:-.}/architecture/[pattern].md

# Add to cheat sheets
vim ${CONTEXT_DIR:-.}/cheat-sheets/[tool].md
```

### Improve Handoff Docs

If the handoff doc was missing something you needed:

```bash
# Update it now
vim docs/TICKET-XXXX-handoff.md
```

# Add what you wish had been there
# Future you will thank you
```

### Create Better Handoffs

When you finish your session, remember what you just went through:
- What did you need to know?
- What took time to figure out?
- What was confusing?

**Make your handoff doc address those things.**

---


## 🔗 See Also

- **[DEFINITIONS.md](./docs/definitions.md)** - Key vocabulary and definitions
- **[HANDOFF.md](./HANDOFF.md)** - How to hand off work to the next person
- **[daily-digest.md](../../daily-digest.md)** - Your daily starting point
- **[automations/README.md](../../automations/README.md)** - Automation tools
- Check `context.json` for links to project-specific documentation

---


## 💡 Pro Tips

1. **Use the 15-minute rule**: If you're still confused after 15 minutes of investigation, ask for help
2. **Always read the handoff doc first** - It's specifically written for you
3. **Run tests immediately** - Catch issues before you start coding
4. **Update handoff docs as you work** - Don't wait until the end
5. **Take notes** - You'll need to hand off again later
6. **Check timestamps** - Recent PRs and commits show current focus areas
7. **Look at test files** - They document expected behavior
8. **Trust the tools** - `jira`, `gh`, and `git` give you truth

---

**Remember:** A good pickup is about quickly building a complete mental model of the work. Take the time to understand before you start coding. 15 minutes of investigation saves hours of confusion later.
