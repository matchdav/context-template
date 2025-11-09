# Organizational Context Boundaries and Security

## Overview

This document captures principles for scoping context, defining boundaries between projects, and enforcing security isolation in distributed, local-first context systems.

## Context Layering and Organizational Architecture

### Hierarchical Context Model

Every architectural component operates within nested contexts:

```
Environmental/Social Context
└── Organization Context
    └── Business Context
        └── IT Context
            └── Application/Project Context
                └── Workflow/Task Context
```

**Key Insight**: Context engineering systems must map their structure to this organizational hierarchy.

### Organizational Memory (OM) Theory

**Definition**: Organizational Memory is the structure that captures, organizes, retains, accesses, and enables the use of knowledge to support organizational goals.

**Implementation**: The context engineering system serves as the computer-based information infrastructure managing this memory.

**Components**:
- Retention of dataset details (filenames, sizes, creation times, identifiers)
- Structured metadata repository as central catalog
- Information about dataset origins and purposes
- Knowledge as protected organizational asset

**Key Insight**: Traditional OM models are often too complex or too general. A file-based, protocol-driven structure provides a concrete, actionable framework.

## Managing Multi-Project Boundaries

### Repository-Based Isolation

**Pattern**: Use Git repository structure for natural project boundaries.

**Structure**:
```
organization/
├── .github/                    # Organization-wide templates
├── context-template/           # Shared context patterns
├── project-alpha/              # Project 1
│   ├── .git/
│   ├── context/                # Project-specific context
│   └── src/
├── project-beta/               # Project 2
│   ├── .git/
│   ├── context/
│   └── src/
└── project-gamma/              # Project 3
    ├── .git/
    ├── context/
    └── src/
```

**Benefits**:
- One organization contains multiple repositories
- Each repository hosts multiple branches (versions)
- Fundamental isolation mechanism built-in
- Developers focus on dedicated branches
- No upstream/downstream impact until integration

### Coordination Patterns

**Pattern**: Designate central location for project artifacts while maintaining isolation.

**Coordination Mechanisms**:

1. **Public Interfaces**: Define clear contracts between applications
   - API specifications
   - Data structure definitions (copybooks)
   - Shared schemas
   - Communication protocols

2. **Shared Context Repository**: Central context patterns
   - Templates and examples
   - Shared protocols (PICKUP.md, HANDOFF.md)
   - Common definitions
   - Organization-wide conventions

3. **Metadata Repository**: Catalog for cross-project discovery
   - Project registry
   - Dataset catalog
   - Service directory
   - Documentation index

**Key Insight**: Balance isolation (for focus and independence) with coordination (for consistency and discoverability).

## Boundary Types and Mechanisms

### Complete Boundary Taxonomy

| Boundary Type | Definition/Scope | Context Mechanism | Architectural Relevance |
|---|---|---|---|
| **Organizational** | Legal entity, global strategy, multi-tenancy | Metadata Repository (Catalog) | Multi-tenancy rules, system-wide access policies |
| **Project/Application** | Specific software application or development effort | Repository/Branch Structure | Parallel work, localized context, traceable version history |
| **Workflow/Task** | Active task or session scope and state | Checkpoints, Structured Notes, Context Compaction | Mitigate AI context limits, reduce cognitive load for resumption |

### Organizational Boundary

**Purpose**: Governs the entire organization's context ecosystem.

**Components**:
- Multi-tenancy configuration
- Global access policies
- Organization-wide metadata
- Shared tooling and conventions

**Implementation**:
```json
{
  "organization": "acme-corp",
  "tenants": [
    {"id": "team-a", "projects": ["project-alpha"]},
    {"id": "team-b", "projects": ["project-beta", "project-gamma"]}
  ],
  "globalPolicies": {
    "dataRetention": "7 years",
    "encryptionRequired": true,
    "accessControlModel": "RBAC"
  }
}
```

### Project/Application Boundary

**Purpose**: Isolates work on specific applications or initiatives.

**Components**:
- Git repository
- Branch structure
- Project-specific context files
- Local configuration

**Implementation**:
- One repository per project
- Branches for features/environments
- `context/` directory for project context
- `context.json` linking to organization

### Workflow/Task Boundary

**Purpose**: Manages scope and state for active work.

**Components**:
- Task identifiers (ticket numbers)
- Context snapshots
- Progress tracking
- Handoff documents

**Implementation**:
```markdown
# Task: DXT-1234 - Implement user authentication

## Context Boundary
- Project: project-alpha
- Branch: feature/auth
- Start Commit: abc123
- Current Commit: def456

## State
- Status: In Progress
- Focus: OAuth integration
- Blockers: None

## Context Files
- docs/DXT-1234-handoff.md
- specs/authentication-spec.md
- architecture/auth-design.md
```

## Secure Multi-Tenancy in Distributed Systems

### The Security Challenge

**Problem**: Local-first model distributes data to clients, requiring robust distributed security.

**Multi-Tenant Context**: Multiple customers share the application, but data must be strictly isolated.

**Key Difference from Traditional Systems**: In centralized systems, the database enforces security. In local-first systems, the file boundary is decentralized, requiring security inversion.

### Identity and Authorization Flow

**Pattern**: Authenticated identity must flow through entire request chain.

**Flow**:
1. User authenticates with identity provider
2. Identity token flows through request
3. Downstream orchestrator receives identity
4. Identity mapped to tenant
5. Tenant context enforces data access

**Implementation Example**:
```javascript
// Authentication middleware
async function authenticate(request) {
  const token = request.headers.authorization;
  const identity = await verifyToken(token);
  const tenant = await mapUserToTenant(identity.userId);
  
  request.context = {
    userId: identity.userId,
    tenantId: tenant.id,
    permissions: tenant.permissions
  };
}

// Data access layer
async function retrieveContext(query, requestContext) {
  // Enforce tenant boundary
  const tenantScope = {
    tenantId: requestContext.tenantId
  };
  
  // Only retrieve tenant-scoped data
  const results = await database.query(query, tenantScope);
  
  // Filter by user permissions
  return results.filter(item => 
    hasPermission(requestContext.permissions, item)
  );
}
```

### Mandatory Isolation Requirements

**Principles**:
1. **Tenant data isolation**: Prevent unauthorized access or manipulation
2. **Security and privacy guidelines**: Adhere to regulatory requirements
3. **Audit logging**: Track all data access for compliance
4. **Least privilege**: Grant minimum necessary permissions

### Security Inversion for Local-First

**Traditional Centralized RAG**:
- Central database enforces security (row-level security)
- API filtering as secondary defense
- Single enforcement point

**Local-First Distributed RAG**:
- Files decentralized to clients
- Cannot rely solely on central orchestrator
- Security built around file ownership and permissions

**New Security Model Requirements**:

1. **Verifiable Identity Linked to File Ownership**
   ```bash
   # File ownership
   -rw------- 1 user1 team-a project-alpha/context/decisions.md
   -rw-r----- 1 user2 team-a project-alpha/context/specs.md
   -rw------- 1 user3 team-b project-beta/context/architecture.md
   ```

2. **Tenant-Aware Retrieval**
   ```javascript
   async function retrieveForUser(query, userId) {
     const tenant = await getTenantForUser(userId);
     const files = await getAccessibleFiles(userId, tenant);
     const chunks = await search(query, files);
     return filterByPermissions(chunks, userId);
   }
   ```

3. **Authorization-Based Filtering**
   - Rigorous authorization rules filter context chunks
   - Custom security trimming in API layer
   - Only authorized data used as grounding context
   - Access logs maintained for auditing

### Implementation Checklist

- [ ] Identity provider integration
- [ ] User-to-tenant mapping
- [ ] File ownership and permissions
- [ ] Tenant-scoped retrieval queries
- [ ] Permission-based filtering
- [ ] Access audit logging
- [ ] Security trimming in API
- [ ] Regular permission reviews

## Practical Guidelines

### For System Architects

1. **Design boundaries from the start**
   - Define tenant isolation strategy
   - Plan repository structure
   - Map organizational hierarchy to context structure

2. **Implement security inversion**
   - Build identity into file access
   - Design tenant-aware retrieval
   - Plan audit logging early

3. **Balance isolation and coordination**
   - Define clear interfaces between projects
   - Establish shared conventions
   - Maintain central catalog for discovery

### For Operations Teams

1. **Enforce boundary integrity**
   - Regular permission audits
   - Monitor cross-boundary access attempts
   - Validate tenant isolation

2. **Maintain metadata catalog**
   - Keep project registry current
   - Document dataset purposes
   - Track data lineage

3. **Audit and monitor**
   - Log all data access
   - Alert on suspicious patterns
   - Regular compliance reviews

### For Development Teams

1. **Respect project boundaries**
   - Keep context within project repository
   - Use shared context for common patterns only
   - Document cross-project dependencies

2. **Follow security patterns**
   - Never hard-code credentials
   - Use environment variables for tenant configuration
   - Test with multiple tenant contexts

3. **Maintain clear interfaces**
   - Document public APIs
   - Version shared schemas
   - Communicate breaking changes

## Anti-Patterns to Avoid

1. **Boundary Violation**: Accessing data across tenant boundaries
2. **Security Bypassing**: Circumventing authorization checks
3. **Context Leakage**: Sharing context between isolated projects
4. **Centralized Single Point of Failure**: Relying on single database for security
5. **Implicit Permissions**: Assuming access without verification
6. **Missing Audit Trails**: No logging of data access

## Measuring Success

### Security Metrics

- **Authorization Failures**: Blocked unauthorized access attempts
- **Audit Log Completeness**: % of actions logged
- **Permission Review Cadence**: Frequency of access reviews
- **Isolation Violations**: Cross-boundary access incidents

### Organizational Metrics

- **Context Discovery Time**: Time to find relevant context
- **Cross-Project Reuse**: Usage of shared patterns
- **Onboarding Time**: Time for new projects to adopt patterns
- **Boundary Clarity**: Developer understanding of isolation

## References

This document synthesizes research on:
- Organizational memory theory
- Multi-tenant security patterns
- Distributed access control
- Git repository architecture
- Identity and authorization flows

---

*Last updated: 2025-01-09*
