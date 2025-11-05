# Copilot Instructions

This document outlines the instructions for using GitHub Copilot within this repository.

## General Guidelines

*   **Context is Key:** Copilot works best when it has sufficient context. Ensure your cursor is in a logical place and that surrounding code provides clues about your intent.
*   **Iterative Refinement:** Don't expect Copilot to always generate perfect code on the first try. Use its suggestions as a starting point and refine them as needed.
*   **Review and Understand:** Always review the generated code carefully. Ensure it meets your requirements, is correct, and adheres to the project's coding standards.
*   **Be Specific:** The more specific your comments and code snippets are, the better Copilot's suggestions will be.
*   **Avoid Over-reliance:** Copilot is a tool to assist, not replace, your coding efforts. Maintain a strong understanding of the code you're writing.

## Specific Use Cases

### Generating New Functions/Methods

When creating a new function or method, start with a clear docstring or comment explaining its purpose, parameters, and expected return value.

**Example:**

```python
# Calculate the factorial of a given non-negative integer.
# Args:
#   n: An integer.
# Returns:
#   The factorial of n.
def factorial(n):
    <fill_in>
```

### Completing Existing Code

For completing existing lines or blocks of code, ensure the preceding lines provide enough context for Copilot to understand the desired logic.

**Example:**

```javascript
function greet(name) {
    console.log(`Hello, ${name}!`);
    <fill_in>
}
```

### Writing Tests

When writing tests, provide a clear description of what the test should verify.

**Example:**

```python
import unittest

class MyTests(unittest.TestCase):
    def test_addition(self):
        # Test that 1 + 1 equals 2
        <fill_in>
```

### Refactoring

When refactoring, you can often use comments to describe the desired change, and Copilot can help suggest the new structure.

**Example:**
