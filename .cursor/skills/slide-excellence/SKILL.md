---
name: slide-excellence
description: Run the full SantAnna-style slide review stack on a presentation.
argument-hint: "[presentation path]"
---

# Slide Excellence

Run the presentation through:
- `slide-auditor`
- `pedagogy-reviewer`
- `proofreader`
- `tikz-reviewer` if diagrams are used
- `quarto-critic` if Quarto is involved

Return one consolidated list of critical, major, and minor issues.
