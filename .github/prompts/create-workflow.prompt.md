---
description: "Create a new GitHub Agentic Workflow for this repository"
mode: "agent"
tools: ["read", "edit", "execute", "search", "web"]
---

# Create a New Agentic Workflow

I need to create a new GitHub Agentic Workflow in `.github/workflows/`.

## Use Case
[Describe what you want the workflow to automate]

## Instructions
1. Use the agentic-workflows-builder agent knowledge to design the workflow
2. Create the workflow markdown file in `.github/workflows/` with proper frontmatter (triggers, permissions, safe-outputs, tools, network)
3. Follow security-first principles: read-only permissions, safe-outputs for writes
4. Use fuzzy scheduling for scheduled workflows
5. Compile with `gh aw compile` and verify 0 errors, 0 warnings
6. Document the workflow purpose in the `description:` frontmatter field

Reference: https://github.github.com/gh-aw/
