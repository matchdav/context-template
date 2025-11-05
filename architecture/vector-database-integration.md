# Vector Database (VDB) Implementation (Template)

Here is a structured, five-phase plan to execute the implementation of a local Vector Database (VDB), with a strong focus on the Information Architecture (IA) needed to integrate local files with external systems (e.g. JIRA/GitHub/Rovo via MCP).

---

## 🏗️ Phase 1: VDB Setup and Tool Selection (IA Focus)

This is about setting the foundation and the rules of the game.

1.  **Select & Deploy the VDB:** Choose a VDB (e.g., **Chroma** for simplicity/local use, **Qdrant** for scalability) and deploy it (likely via Docker).
2.  **Define the Metadata Schema (IA):** This is the non-negotiable step. Every vector must be stored with rich metadata for filtering and signposting.
    * **Mandatory Fields:** `source_file` (full path), `doc_type` (`policy`, `prompt`, `journal`, `code`, `config`), `last_modified`, `repo_name` (from `context.json`).
    * **Crucial for RAG:** `heading` (the Markdown heading the chunk belongs to), `git_commit_hash` (for version control context).
3.  **Choose the Embedding Model:** Select a consistent model (e.g., OpenAI, Cohere, or an open-source Sentence Transformer). This model **must be used for both ingestion and querying.**

---

## 📝 Phase 2: Ingestion Pipeline Design (The ETL)

You need a pipeline that runs periodically, not just a one-time script. Frameworks like **LangChain** or **LlamaIndex** simplify this greatly.

1.  **Build the `context.json` Reader:** Write a script to first parse `context.json`. This script generates the list of all targets:
    * Local files (e.g., `constitution.md`, files in `architecture/`).
    * Linked local repos (paths in `repositories[*].localPath`).
    * Remote data sources (APIs for JIRA/GitHub/Rovo via MCP).
2.  **Implement Change Data Capture (CDC):** Design the ingestion script to **only process files that have changed** since the last run.
    * Check `last_modified` time of local files.
    * For linked repos, check the latest `git commit hash` for efficiency.
3.  **Setup Ingestion Framework:** Use an ingestion pipeline component (like LlamaIndex's `IngestionPipeline`) that handles: **Loading $\rightarrow$ Chunking $\rightarrow$ Embedding $\rightarrow$ Indexing.**

---

## ✂️ Phase 3: Chunking Strategy (Deep IA Execution)

This is the "meta-scheme" part, where you define the **meaningful unit of context** for each file type. Use **Recursive Chunking** as a default, with specific exceptions:

| Content Type | Chunking Strategy | Context Rationale |
| :--- | :--- | :--- |
| **Documentation** (`.md` files) | **Recursive Splitter** by Heading (`#`, `##`), then Paragraph, then Sentence. | Preserves semantic units (ideas, topics) for high-quality retrieval. |
| **Prompts/Templates** (`prompts/`, `templates/`) | **No Chunking / Full File** or **Split by Sections** (e.g., `<INSTRUCTIONS>`, `<CONTEXT>`). | These files are usually short and designed to be consumed as a whole unit of instruction. |
| **Code/Automation** (`.sh`, `.js`) | **Function/Class-Based Splitter.** | Ensures the entire logical unit (a function or method) is retrieved, not just a line of code. |
| **JSON/Config** (`context.json`) | **Split by Top-Level Object/Array Entry** (e.g., each object in the `repositories` array becomes a chunk). | Keeps the full definition of a single entity (like one repository or one service) together. |

---

## 🔄 Phase 4: Integration with External Context (MCP Bridge)

This phase connects your local VDB to the multi-repo/API context.

1.  **MCP Connector Logic:** Write specific "Connectors" (functions) that utilize the **MCP servers** to fetch remote data.
    * *Example:* A `JiraConnector` pulls tickets based on active status, converting the ticket description and comments into a single text document.
    * *Metadata:* Store `doc_type: jira_ticket`, `jira_id: JIRA-123`, and the JIRA status alongside the vector.
2.  **Unified Query Layer:** Design a function that runs when the agent is queried. This function must orchestrate two parallel searches:
    * **Search 1:** Query the **local VDB** using the query and metadata filters.
    * **Search 2:** Query the **MCP-linked APIs** (e.g., GitHub issues, Rovo docs) via the existing tooling.
    * **Combine & Re-rank:** Combine the results from both sources and use a re-ranking model (or simple logic) to present the most relevant context to the LLM.

---

## 📈 Phase 5: Testing and Validation

1.  **Retrieval Tests:** Create a set of "benchmark" questions that require combining knowledge across different files (e.g., "What is the priority for the `infra-scripts` repo as defined in the latest `progress.md`?").
2.  **Chunk Boundary Validation:** Manually inspect the chunks for a few key files (`constitution.md`, a long `journal/` entry) to ensure the chunking didn't break up critical ideas.
3.  **Agent Feedback Loop:** Monitor agent performance. If the agent frequently "hallucinates" or gives incomplete answers, it often means the **chunking is too big (too much irrelevant data)** or **too small (fragmented context)**, requiring a loop back to Phase 3.

This approach transforms the simple task of ingesting data into the complex, but powerful, process of **structuring knowledge for machine consumption**.

For a visual breakdown of the full RAG pipeline and its components (Ingestion/ETL), check out this video [Building a RAG Pipeline from Scratch](https://www.youtube.com/watch?v=MykcjWPJ6T4).
http://googleusercontent.com/youtube_content/1