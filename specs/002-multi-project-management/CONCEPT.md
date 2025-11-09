# Concept: Project vs Repository vs Context Repository

## Current Understanding

### Repository (Code Repository)
- A **repository** is a code repository (e.g., `main-app`, `infra-scripts`)
- These are the actual codebases that contain source code
- Listed in `context.json` under `repositories[]`
- Example: `https://github.com/myorg/main-app`

### Context Repository
- A **context repository** is an instance of this template
- Contains: `context.json`, `docs/`, `architecture/`, `prompts/`, etc.
- Acts as a knowledge base that links to multiple code repositories
- Example: This repository itself (`context-template`)

### Project (Refined Definition)
- A **project** is an **organizational boundary** or **context scope** that includes:
  - One context repository instance (the knowledge base)
  - A subset of code repositories (linked via `context.json`)
  - Shared configuration, workflows, and documentation
  - A specific focus or "zoom level" for work

**Key Insight**: Projects are about **organizational structure** and **context boundaries**, not necessarily isolated environments. The same repository can appear in multiple projects with different focus/context.

## Conceptual Model

### Example 1: Personal vs Company Projects
```
Personal Project (All my personal repos)
├── context-repo-personal/
│   ├── context.json         # Links to: my-blog, my-side-project, my-tools
│   ├── docs/
│   └── daily-digest.md
└── [personal code repositories]

Company Project (All company repos)
├── context-repo-company/
│   ├── context.json         # Links to: main-app, backend-api, infra-scripts, etc.
│   ├── docs/
│   └── daily-digest.md
└── [company code repositories]
```

### Example 2: Division-Level Projects
```
UI Division Project
├── context-repo-ui/
│   ├── context.json         # Links to: frontend-app, design-system, ui-components
│   ├── docs/                 # UI-specific architecture, patterns
│   └── daily-digest.md       # UI team tickets, PRs
└── [UI-related repositories]

DevOps Division Project
├── context-repo-devops/
│   ├── context.json         # Links to: infra-scripts, deployment-tools, monitoring
│   ├── docs/                 # Infrastructure docs, runbooks
│   └── daily-digest.md       # DevOps team tickets, PRs
└── [DevOps-related repositories]
```

### Example 3: Product/Initiative Projects
```
Product X Project
├── context-repo-product-x/
│   ├── context.json         # Links to: product-x-frontend, product-x-api, product-x-mobile
│   ├── docs/                 # Product-specific architecture, decisions
│   └── daily-digest.md       # Product X tickets, PRs
└── [Product X repositories]

Product Y Project
├── context-repo-product-y/
│   ├── context.json         # Links to: product-y-frontend, product-y-api
│   ├── docs/
│   └── daily-digest.md
└── [Product Y repositories]
```

### Example 4: Overlapping Repositories
```
Note: The same repository can appear in multiple projects with different context

infra-scripts/ appears in:
├── Company Project (all repos)
├── DevOps Division Project (infra focus)
└── Product X Project (product-specific infra)
```

## Key Characteristics (Based on User Examples)

### 1. Project = Context Repository Instance
- Each context repository instance IS a "project"
- Switching projects = switching context repository directories
- One-to-one mapping: one project = one context repository

### 2. Projects Define Organizational Boundaries
- **Company-level**: All company repositories
- **Division-level**: UI division, DevOps division, etc.
- **Product-level**: Product X, Product Y, etc.
- **Personal-level**: All personal repositories
- **Initiative-level**: Specific initiatives or focus areas

### 3. Repositories Can Belong to Multiple Projects
- A repository can appear in multiple projects' `context.json`
- Different projects provide different context/focus for the same repository
- Example: `infra-scripts` appears in Company project, DevOps project, and Product X project

### 4. Projects Enable Context Switching
- Switch between different organizational scopes
- Different "zoom levels" or focus areas
- Different teams, different priorities, different documentation

### 5. Optional: Isolated Environments
- Projects CAN have isolated environments (Docker, workspaces)
- But this is optional, not required
- Core definition is about organizational boundaries, not technical isolation

## Refined Definition

A **Project** is:
- A **context repository instance** (the knowledge base)
- That links to a **subset of code repositories** (via `context.json`)
- With a specific **organizational boundary** or **scope of work**
- With **shared configuration**, **workflows**, and **documentation**

**Key Characteristics:**
- Each project has its own `context.json` that links to its repositories
- Projects define organizational boundaries (company, division, product, personal, etc.)
- You can switch between projects to change your focus/scope
- The same repository can appear in multiple projects with different context
- Projects can have relationships (e.g., Division project is part of Company project)
- Optional: Projects can have isolated environments (Docker, workspaces) but this is not required

## Real-World Use Cases (From User Examples)

### Use Case 1: Personal vs Company Projects
```
Personal Project
├── context-repo-personal/
│   └── context.json → [my-blog, my-side-project, my-tools]
│   └── daily-digest.md → Personal tickets, PRs
└── [personal code repositories]

Company Project (Cloud-hosted)
├── context-repo-company/
│   └── context.json → [all company repositories]
│   └── daily-digest.md → Company-wide tickets, PRs
└── [company code repositories]
```

### Use Case 2: Division-Level Projects
```
UI Division Project
├── context-repo-ui/
│   └── context.json → [frontend-app, design-system, ui-components]
│   └── docs/ → UI-specific architecture, design patterns
│   └── daily-digest.md → UI team tickets, PRs
└── [UI-related repositories]

DevOps Division Project
├── context-repo-devops/
│   └── context.json → [infra-scripts, deployment-tools, monitoring]
│   └── docs/ → Infrastructure docs, runbooks
│   └── daily-digest.md → DevOps team tickets, PRs
└── [DevOps-related repositories]
```

### Use Case 3: Different Focus/Zoom Levels
```
Company Project (All repos, high-level view)
├── context-repo-company/
│   └── context.json → [all 50+ company repositories]
│   └── daily-digest.md → Company-wide summary
└── [all repositories]

Product X Project (Focused view)
├── context-repo-product-x/
│   └── context.json → [product-x-frontend, product-x-api, product-x-mobile]
│   └── docs/ → Product-specific architecture, decisions
│   └── daily-digest.md → Product X tickets, PRs
└── [Product X repositories only]
```

### Use Case 4: Staff Context Switching
```
Staff member switches between:
├── Company Project → See all company work
├── Division Project → Focus on their division
└── Product Project → Focus on specific product

Same repositories, different context and focus
```

## Final Definition (Aligned with User Examples)

**Project** = **Context Repository Instance** with an **Organizational Boundary**

**Key Points:**
1. Each context repository instance is a "project"
2. Projects define organizational boundaries (company, division, product, personal, etc.)
3. Projects can have different "zoom levels" or focus areas
4. The same repository can appear in multiple projects with different context
5. Switching projects = switching organizational scope/focus
6. Optional: Projects can have isolated environments (Docker, workspaces)

**Implementation:**
- `context switch company` = `cd ~/context-repos/company && export CONTEXT_DIR=~/context-repos/company`
- Each project has its own `context.json` linking to its subset of repositories
- Projects are isolated by directory structure
- Projects can have relationships (e.g., Division project is part of Company project)

**This aligns with:**
- Personal project managing all personal repos
- Company project (cloud-hosted) managing all company repos
- Division projects (UI, DevOps) with focused scope
- Product projects with specific focus
- Staff switching between different project contexts
