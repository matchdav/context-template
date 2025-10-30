# Agent Research Protocol

## Purpose
This prompt guides an AI agent through a structured research process to answer a given question, leveraging internal project knowledge, project management tools, and external web resources.

---

## 🎯 Quick Orientation

### The Research Question
**[INSERT RESEARCH QUESTION HERE]**

### Goal
To provide a comprehensive answer to the research question, including relevant context, findings, and actionable insights.

---

## 🔍 Research Process

### Step 1: Internal Knowledge Base Search (Workspace)

**Objective:** Leverage existing project documentation and code to find relevant information.

#### 1.1 Search Project `context` Repository
*   **Files to check:**
    [...insert list of files here]
*   **Command:**
    ```bash
    grep -ri "[KEYWORD_FROM_QUESTION]" ~/github/context/
    ```
    *Replace `[KEYWORD_FROM_QUESTION]` with relevant terms from the research question.*

#### 1.2 Search Project Codebases
*   **Relevant Repositories:**
        [...insert list of repos here]
*   **Command:**
    