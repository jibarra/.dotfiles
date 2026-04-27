---
name: plan_coding_changes
description: Default planning workflow for any code change. Confirm what's being changed, gather context across Linear/GitHub/codebase, produce a reconciled plan, then implement. Use for every code change — small, large, or in-between.
---

# Plan coding changes

Plan before writing code. Always. Even small changes go through this — the steps just take seconds when the scope is tiny.

## Step 1: Make sure you know what's being changed

Before doing anything else, confirm you understand the request. If the ask is vague, ambiguous, or you can't restate it back in one sentence — **stop and ask the user** to clarify. Acceptable forms of clarification:

- A description of the desired behavior or outcome.
- A link to a Linear ticket, doc, PR, Slack thread, or other resource.
- An example of input/output, or a pointer to the offending code.

Don't guess at intent. A 30-second clarification beats a 30-minute plan against the wrong target.

## Step 2: Gather context

Search across available sources to understand the problem. Run searches in parallel where possible.

- **Linear** — existing issues, related work, blockers, design docs
  - `mcp__linear-server__list_issues` (filter by query/team/state)
  - `mcp__linear-server__list_documents` / `mcp__linear-server__search_documentation`
- **GitHub** — related PRs, prior code, history
  - `gh pr list --search "<term>"`, `gh search prs "<term>"`
  - `gh search code "<term>"` for cross-repo code search
- **Codebase** — `grep`/`find` via Bash for known symbols; the `Explore` agent for broad/open-ended searches (3+ queries)
- **Datadog** (only if the work is observability/incident-related)
  - `mcp__datadog-mcp__search_datadog_logs`, `search_datadog_monitors`, etc.

Summarize findings for the user. Scale the summary to the size of the change:
- **Trivial change** — a few lines is enough ("Found the function at `app/foo.rb:42`, no related Linear issues, no recent PRs touching it").
- **Larger change** — no cap. Cover everything that matters: prior work, related systems, constraints, open questions.

Ask if anything is missing or wrong before moving on.

## Step 3: Find or create the Linear issue

- Search Linear for an existing issue first. If one exists, link it.
- If none turns up, **ask the user before creating one** — they may have an existing ticket they forgot to link, or may not want a ticket for this work at all. Surface what you searched for so they can correct the search if you missed it.
- Only after confirmation, create the issue with a tight description (2–3 sentences).
- Don't transition state (e.g. to In Progress) without explicit confirmation.

## Step 4: Confirm scope with the user

Before producing any plan, confirm:
- What exactly are we building?
- What's the acceptance criteria?
- Any dependencies, merge order, or hard deadlines?

**STOP here if the user hasn't confirmed scope.** Don't guess.

## Step 5: Dual-track planning (Claude + Plan agent)

Once scope is confirmed, generate two independent plans in parallel and reconcile them.

In a **single message**, do both:
- Enter plan mode (`EnterPlanMode`) and draft Claude's plan in this session.
- Spawn the `Plan` agent in parallel via `Agent({ subagent_type: "Plan", ... })`, passing the same scope summary, working directory, and any constraints from Step 4.

When both plans return, compare them:
- Where they agree → strong signal, lock it in.
- Where they disagree → surface the disagreement to the user with the tradeoff each plan made. Don't silently pick one.

## Step 6: Present the reconciled plan

Present the merged plan to the user. Wait for green light before implementing. Call `ExitPlanMode` once approved.

## Guardrails

- **Always run this flow**, even for one-line changes. The cost is small; the cost of skipping context is not.
- **Don't skip Step 1.** If you can't restate the request in one sentence, ask.
- **Don't skip Step 4.** A multi-agent plan against the wrong scope is wasted effort.
- **Don't create or transition Linear issues** without explicit confirmation — even when no existing issue surfaces in search.
- **Don't substitute your own opinion** when the two plans diverge — surface the disagreement to the user.
