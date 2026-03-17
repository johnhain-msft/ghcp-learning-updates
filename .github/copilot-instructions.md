# Repository Custom Instructions

## Project Context
This is a GitHub Copilot hackathon learning repository containing an interactive slide deck, agenda system, and supporting infrastructure. The site content lives in `site/` and is served via nginx in a Docker container.

## Coding Standards
- HTML: Use the existing CSS custom properties (variables) defined in hackathon.html — do not add inline colors
- Slide structure: Each slide is a `<section class="slide" data-section="..." data-title="...">` element
- Card layouts: Use `.card`, `.card-accent`, `.card-blue`, `.card-green`, `.card-orange` classes
- Section dividers: Use `class="slide section-slide"` with `<h1 class="section-title">`
- JSON: The agenda.json drives the schedule — edit it instead of hardcoding agenda content in HTML
- Bicep: Infrastructure files are in `infra/` using modular Bicep with `modules/` subdirectory
- Shell scripts: Use `set -euo pipefail` at the top of bash scripts

## File Organization
- `site/` — All content served by the web container (HTML, JSON, future images)
- `infra/` — Azure Bicep infrastructure-as-code
- `.github/agents/` — Custom Copilot agents for this repo
- `.github/skills/` — Copilot skills for this repo
- `.github/instructions/` — Path-specific Copilot instructions
- `.github/prompts/` — Reusable prompt templates
- `.github/workflows/` — Agentic workflows (gh-aw)

## When Adding New Slides
1. Add the `<section>` in `site/hackathon.html` within the correct section group
2. Use existing CSS classes — do not create new styles
3. If adding a new section, also add the section key to the `sectionNames` object in the JS
4. Speaker notes go in `<div class="slide-notes">` inside each slide

## When Modifying Infrastructure
- Always use the lowest-cost Azure SKUs appropriate for low traffic
- Container Apps uses Consumption tier with scale-to-zero
- ACR uses Basic SKU
- Run `gh aw compile` after modifying workflow frontmatter
