---
name: plan-project-approach
description: Plan the high-level approach to a project before implementation — make requirements and assumptions explicit, weigh solution options against the current system's deficiencies, and surface risks and open questions. Produces an approach/framing doc, not line-level implementation steps. Use when the user asks to plan a project's approach, frame a project, scope how to tackle something, or think through high-level design before writing code.
---

# Plan project approach

Produce a high-level approach for a project: *what* we're building, *why*, and *which* solution — grounded in the current system's real shortcomings. This is framing, not implementation. Stay in natural language; do not drop to line-level code plans.

## Step 1: Confirm the project and desired outcome

Restate the goal in one or two sentences. If you can't — or the ask is vague — **stop and ask**. Acceptable inputs: a Linear ticket/doc, a description of the desired outcome, or a pointer to the problem area. Don't guess at intent.

## Step 2: Gather context

Search across sources in parallel so the plan is grounded in reality, not assumption — especially the current-system deficiencies.

- **Linear** — related issues/epics/docs (`list_issues`, `list_documents`, `search_documentation`).
- **GitHub** — prior PRs and history (`gh pr list --search`, `gh search code`).
- **Codebase** — `grep`/`find` for known symbols; the `Explore` agent for broad/open-ended searches.

Summarize findings, scaled to project size. Ask if anything is missing or wrong before drafting.

## Step 3: Make requirements and assumptions explicit, then ask

Separate what's *confirmed* from what you're *assuming*:
- **Requirements** — functional and non-functional. Write them down explicitly.
- **Assumptions** — anything taken as given; note what breaks if each is wrong.

Batch any open questions to the user. Don't fabricate requirements, constraints, or deficiencies — confirm in code or ask.

## Step 4: Draft the approach doc

Use the template. **Always include the core sections; omit any other section that doesn't apply** rather than padding it with "N/A".

```markdown
## Outcome / Goal
<What the world looks like when this is done — user/business result, not the technical approach. CORE.>

## Requirements
- **Functional:** <what it must do>
- **Non-functional:** <performance, scale, security, etc. — drop the bucket if empty>
CORE.

## Assumptions
<What we're treating as given, and what breaks if an assumption is wrong. CORE.>

## Current System & Deficiencies
<What exists today and where it falls short — the gaps this project closes. Omit if greenfield.>

## Solution Options
- **Option A — <name>:** approach, tradeoffs.
- **Option B — <name>:** approach, tradeoffs.

### Recommendation
<Which option and why. CORE — options + a pick are always present.>

## Risks
<What could go wrong and why, with mitigations where known. CORE.>

## Open Questions
<Unresolved decisions, each with an owner where possible. Omit if none.>

## Notes
<Optional: Success Criteria, Out of Scope, Dependencies / Sequencing. Omit if none.>
```

Writing rules:
- **Scale to the project.** A small effort gets a tight doc; a large one gets full coverage.
- **Explicit over implied.** Requirements and assumptions are the point — spell them out.
- **Tradeoffs, not just a verdict.** Show why the recommended option beat the alternatives.
- **Ground deficiencies in evidence.** Cite the code/data, or mark it as an open question.

## Step 5: Decide where it lives, then present

Ask where the artifact should go — there's no default:
- **Linear** doc or issue/epic (primary home for planning per the repo's documentation practice),
- **Repo markdown** under `ai_project_prompts/` or `doc/`, or
- **Inline** in the conversation only.

Present the draft, refine with the user, and **only create the artifact (Linear doc, file) with explicit confirmation.**

## Guardrails

- **Don't skip Step 1.** If you can't restate the project in one sentence, ask.
- **Don't fabricate** requirements, assumptions, or deficiencies — confirm in code/data or list them as open questions.
- **Keep it high-level.** This is framing; resist dropping into line-level implementation.
- **Omit, don't pad.** Drop sections that don't apply instead of filling them with "N/A".
- **Don't create the artifact without confirmation.** Drafting is not publishing.
