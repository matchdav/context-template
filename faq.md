### Doesn't MCP already do this?

* See [this explanation](./mcp-vs-file-context.md)

### How does this template help with onboarding new team members?

*   The `constitution.md` and `README.md` provide a high-level overview of project principles and workflows.
*   The `prompts/` directory contains standardized protocols (e.g., `PICKUP.md`) that guide new members through common tasks.
*   The `architecture/` and `perspectives/` directories offer centralized documentation for project-specific knowledge.
*   The `daily-digest.md` provides an immediate snapshot of current work, helping new members quickly get up to speed.

### Can I use this with my existing project management tools (Jira, Asana, etc.)?

*   Yes! The `automations/daily-digest.sh` script is designed to be customized. You can modify it to pull data from your existing project management tools, GitHub Issues, or any other relevant sources to generate your daily digest.
*   The `context.json` file can also be used to store links and configurations for these external tools.

### Is this only for AI agents, or can human developers use it too?

*   This template is designed for *both* human developers and AI agents. The principles of clear context, systematic workflows, and automation benefit any team member.
*   For AI agents, it provides a structured, machine-readable way to understand project context and execute tasks. For humans, it offers a consistent and efficient way to work and collaborate.

### What if my project doesn't fit the "Morning Sync -> Pickup -> Do -> Handoff" rhythm?

*   The "Morning Sync -> Pickup -> Do -> Handoff" is a recommended core workflow, but the template is flexible.
*   You can customize `constitution.md` to define your team's specific workflows and principles.
*   You can create new protocols in `prompts/` for any unique processes your team follows. The key is to standardize and document your chosen workflows.

### How do I keep the `daily-digest.md` up-to-date automatically?

*   The `automations/daily-digest.sh` script is provided as an example. You can schedule this script to run periodically (e.g., via a cron job or a GitHub Action) to automatically update your `daily-digest.md` file.
*   Customize the script to fetch information from your specific tools and repositories.

### How can I ensure my agent always follow these rules?

*   The `copilot-instructions.md` file is designed to provide explicit directives to AI agents on how to interact with your workspace and follow established protocols.
*   By clearly defining expectations and referencing key documents (like `constitution.md` and the `prompts/` directory) within `copilot-instructions.md`, you guide the agent's behavior.
*   Regularly review and update `copilot-instructions.md` to reflect any changes in your team's workflows or priorities.
