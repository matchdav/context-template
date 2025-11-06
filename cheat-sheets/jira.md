# Jira CLI Cheat Sheet (Template)

Core daily flows for issue tracking.

## Standup Snapshot
```bash
jira issue list --assignee currentUser() --status "In Progress"
jira issue list --assignee currentUser() --status "To Do"
```

## Attention Needed
```bash
jira issue list --watcher currentUser()
jira issue list --reporter currentUser()
```

## Recent Activity (macOS)
```bash
jira issue list --jql "updated >= \"$(date -v-1d +%Y-%m-%d)\" AND (assignee = currentUser() OR reporter = currentUser() OR watcher = currentUser() OR comment ~ currentUser())"
```

## Recent Activity (Linux)
```bash
jira issue list --jql "updated >= \"$(date -d \"1 day ago\" +%Y-%m-%d)\" AND (assignee = currentUser() OR reporter = currentUser() OR watcher = currentUser() OR comment ~ currentUser())"
```

## Issue Creation
```bash
jira issue create --type Task --summary "Short summary" --body "Details here." --web
```

## Issue Viewing
```bash
jira issue list
jira issue view PROJ-123
jira open PROJ-123
```

## Tips
- Use JQL to tighten lists: `jira issue list --jql "project = PROJ AND status = 'In Progress'"`
- Chain filters with logical operators for precision.
