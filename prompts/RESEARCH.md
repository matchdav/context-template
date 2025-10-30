# Research Prompt Template

## Purpose
This template provides a structured approach for conducting research within a development environment. It's designed to guide you through a systematic process of gathering, analyzing, and synthesizing information from various sources, including your local file system, project management tools, and the web.

---

## 1. Define the Research Question

**Objective:** To clearly and concisely define the research question.

*   **Initial Question:** [INSERT INITIAL, POSSIBLY VAGUE, RESEARCH QUESTION HERE]
*   **Clarified Question:** [REPHRASE THE QUESTION TO BE SPECIFIC, MEASURABLE, ACHIEVABLE, RELEVANT, AND TIME-BOUND (SMART), IF APPLICABLE]
*   **Key Information Needed:** [LIST THE SPECIFIC PIECES OF INFORMATION REQUIRED TO ANSWER THE CLARIFIED QUESTION]

---

## 2. Formulate a Research Plan

**Objective:** To outline the steps you'll take to answer the research question.

*   **Information Sources:** [LIST THE INFORMATION SOURCES YOU PLAN TO USE (E.G., FILE SYSTEM, VS CODE WORKSPACE, JIRA, GITHUB, WEB)]
*   **Keywords and Search Queries:** [LIST THE KEYWORDS AND SEARCH QUERIES YOU'LL USE FOR EACH INFORMATION SOURCE]
*   **Tools:** [LIST THE TOOLS YOU'LL USE (E.G., `grep`, `find`, `gh`, `jira`, WEB BROWSER)]
*   **Success Criteria:** [DEFINE WHAT A SUCCESSFUL OUTCOME FOR THIS RESEARCH LOOKS LIKE]

---

## 3. Execute the Research Plan

**Objective:** To systematically gather information from the identified sources.

### 3.1. Local File System Exploration

*   **Strategy:** [DESCRIBE YOUR STRATEGY FOR EXPLORING THE LOCAL FILE SYSTEM. WILL YOU USE `grep`, `find`, OR ANOTHER TOOL? WHAT DIRECTORIES WILL YOU FOCUS ON?]
*   **Commands and Queries:**
    ```bash
    # Example using grep
    grep -ri "your_keyword" /path/to/your/project

    # Example using find
    find /path/to/your/project -name "*.js" -print0 | xargs -0 grep "your_keyword"
    ```

### 3.2. Project Management and Version Control

*   **GitHub (`gh`):**
    *   **Strategy:** [DESCRIBE YOUR STRATEGY FOR SEARCHING GITHUB. WILL YOU LOOK AT ISSUES, PULL REQUESTS, OR CODE?]
    *   **Commands and Queries:**
        ```bash
        # Example: Search for issues with a specific keyword
        gh issue list --search "your_keyword in:title,body"

        # Example: Search for pull requests with a specific keyword
        gh pr list --search "your_keyword in:title,body"
        ```
*   **Jira (`jira`):**
    *   **Strategy:** [DESCRIBE YOUR STRATEGY FOR SEARCHING JIRA. WILL YOU LOOK AT STORIES, BUGS, OR EPICS?]
    *   **Commands and Queries:**
        ```bash
        # Example: Search for issues with a specific JQL query
        jira issue list --jql "text ~ '''your_keyword'''"
        ```

### 3.3. Web Search

*   **Strategy:** [DESCRIBE YOUR STRATEGY FOR SEARCHING THE WEB. WHAT SEARCH ENGINES WILL YOU USE? HOW WILL YOU EVALUATE THE CREDIBILITY OF SOURCES?]
*   **Search Queries:** [LIST THE SEARCH QUERIES YOU'LL USE]

---

## 4. Synthesize Findings

**Objective:** To organize and synthesize the gathered information into a coherent narrative.

*   **Key Findings:** [SUMMARIZE THE MOST IMPORTANT PIECES OF INFORMATION YOU FOUND]
*   **Connections and Relationships:** [IDENTIFY ANY CONNECTIONS OR RELATIONSHIPS BETWEEN DIFFERENT PIECES OF INFORMATION]
*   **Gaps in Knowledge:** [IDENTIFY ANY GAPS IN YOUR KNOWLEDGE THAT REQUIRE FURTHER RESEARCH]

---

## 5. Present the Answer

**Objective:** To present the answer to the research question in a clear, concise, and actionable format.

*   **Executive Summary:** [PROVIDE A BRIEF, HIGH-LEVEL SUMMARY OF THE ANSWER]
*   **Detailed Answer:** [PROVIDE A DETAILED, COMPREHENSIVE ANSWER TO THE RESEARCH QUESTION, SUPPORTED BY EVIDENCE FROM YOUR RESEARCH]
*   **Actionable Insights:** [PROVIDE ANY ACTIONABLE INSIGHTS OR RECOMMENDATIONS BASED ON YOUR RESEARCH]
*   **References:** [LIST ALL THE SOURCES YOU USED IN YOUR RESEARCH]