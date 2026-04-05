---
name: workflow-intake
description: Intake and routing skill for the unified academic workflow. Use before paper writing, revision, replication, or PPT production.
argument-hint: "[task summary]"
---

# Unified Workflow Intake

Run this before any major workflow.

## Intake Questions

Ask for the following, then classify the task:

1. Which task type applies?
   - `A` write a paper from scratch with `idea + data`
   - `B` revise an existing paper with prior draft, data, and code
   - `C` replicate an existing paper with source paper and data
   - `D` create a presentation / PPT
2. What is the target output?
   - working paper, submission draft, replication package, seminar slides, lecture slides
3. What assets already exist?
   - drafts, notes, bibliography, code, figures, tables, data
4. Are external data or major direction choices needed?
5. What should be treated as fixed vs flexible?

## Routing Output

Produce an intake summary with:

```markdown
# Workflow Intake Summary

## Task Type
- [A / B / C / D]

## Objective
- [Target output]

## Inputs
- idea:
- data:
- draft:
- code:
- bibliography:

## Fixed Constraints
- [Non-negotiables]

## Human Checkpoints
- [Decision 1]
- [Decision 2]

## Recommended Route
- empirical module: yes/no
- theory module: yes/no
- writing module: yes/no
- slide pipeline: yes/no
```

## Recommended Follow-up

- Task `A`: create a spec, bootstrap `projects/papers/[slug]/`, then start literature + empirical/theory planning
- Task `B`: snapshot current version, diagnose gaps, then revise by module
- Task `C`: create replication folder, run replication protocol, then decide whether to extend
- Task `D`: choose standalone slide project or derive from existing paper, then start slide pipeline
