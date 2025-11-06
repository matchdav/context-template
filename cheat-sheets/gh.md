# GitHub CLI Cheat Sheet (Template)

Daily activity & collaboration essentials.

## Standup Summary
```bash
# Open PRs authored by you
gh pr list --author "@me"

# Issues assigned to you
gh issue list --assignee "@me"
```

## Review Queue
```bash
gh pr list --search "review-requested:@me -author:@me"
```

## Recent Activity (macOS)
```bash
gh search issues --author @me --updated-after $(date -v-1d +%Y-%m-%d)
```

## Recent Activity (Linux)
```bash
gh search issues --author @me --updated-after $(date -d "1 day ago" +%Y-%m-%d)
```

## PR Lifecycle
```bash
# Create
gh pr create --fill --web

# View / Diff
gh pr view 123
gh pr diff 123

# Review
gh pr review 123 --approve --body "LGTM"

# Merge (squash)
gh pr merge 123 --squash
```

## Tips
- Use filters: `--search "label:bug state:open"`
- Combine queries: `gh pr list --search "author:@me label:enhancement"`
