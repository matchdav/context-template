## `context` vs. MCP: A Comparison for Agents

This document compares the `context` directory to the Model Context Protocol (MCP) from the perspective of an AI agent.

### MCP (Model Context Protocol)

*   **Purpose:** A standardized protocol for AI models to interact with external tools and data sources. It's a low-level, universal interface.
*   **Analogy:** A "USB-C for AI" or a driver. It provides a generic way to connect to and control "peripherals" (tools, data).
*   **Agent Interaction:** An agent would use MCP to *discover* what tools are available and *how* to use them. It would provide the agent with function signatures, and data schemas, but not the *reasoning* or *workflows* for using them. The agent would need to learn or be taught the higher-level workflows.
*   **Structure:** A formal, machine-readable specification. It defines the "how" but not the "what" or "why".

### The `context` Directory

*   **Purpose:** A high-level, human- and agent-readable collection of project-specific information, workflows, and perspectives. It's a curated knowledge base.
*   **Analogy:** A "central nervous system" or a "project constitution". It provides the "what", "why", and "how" for a *specific* development ecosystem.
*   **Agent Interaction:** An agent uses the `context` directory to understand the *rules of engagement* for a project. It's not just about what tools are available, but how they fit into the larger picture. The agent would read files like `GEMINI.md` for high-level directives, `prompts/` for specific workflow instructions (e.g., `PICKUP.md`, `HANDOFF.md`), and `architecture/` to understand the system's design. The `daily-digest.md` provides the immediate "what's happening now" context.
*   **Structure:** A collection of markdown files, scripts, and configuration. It's a mix of human-readable documentation and machine-executable automation.

### Comparison

| Feature | MCP (Model Context Protocol) | `context` Directory |
| :--- | :--- | :--- |
| **Abstraction Level** | Low-level protocol | High-level knowledge base |
| **Focus** | *How* to interact with tools (the "API") | *What* to do and *why* (the "workflows") |
| **Scope** | Universal, project-agnostic | Specific to a project or ecosystem |
| **Analogy** | USB-C port, driver | Central nervous system, project constitution |
| **Agent's Question** | "What can I do?" | "What should I do?" |

### Summary

MCP and the `context` directory are complementary. MCP provides the low-level "plumbing" for an agent to interact with its environment, while the `context` directory provides the high-level "brains" and "conscience" to guide the agent's actions within a specific project.

An agent would use MCP to understand the *syntax* of the available tools, but it would use the `context` directory to understand the *semantics* and *pragmatics* of how to use those tools effectively and appropriately within the project's established conventions.

In short:

*   **MCP is the *how*.**
*   **`context` is the *what* and *why*.**
