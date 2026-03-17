---
applyTo: "site/**/*.html"
---

# HTML Slide Deck Instructions

When editing slide deck HTML files:

- Follow the existing slide structure with `<section class="slide">` elements
- Use `data-section` to group slides into navigation sections
- Use `data-title` for the slide name shown in tooltips
- Use card-based layouts: `.card`, `.card-accent`, `.card-blue`, `.card-green`, `.card-orange`
- Use `.slide-title` for the main heading and `.slide-subtitle` for secondary text
- Section dividers use `class="slide section-slide"` with `<h1 class="section-title">`
- Keep slide content concise — use bullet points and cards, not paragraphs
- Add speaker notes in `<div class="slide-notes">` inside each section
- Reference existing CSS variables: `--accent`, `--accent-blue`, `--success`, `--code-orange`, `--text`, `--text-muted`
- Do not add new CSS classes or inline styles unless absolutely necessary
