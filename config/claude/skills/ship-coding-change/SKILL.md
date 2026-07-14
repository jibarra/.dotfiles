---
name: ship-coding-change
description: End-to-end workflow to ship an AI-driven coding change — plan it, create a worktree, implement it autonomously via the coding-implementer subagent, review it, and open a draft PR. Sequences plan-coding-changes, start-worktree-change, code-review-panel, and finish-worktree-change. Use when the user asks to ship or drive a coding change end to end, or take a change from idea to draft PR.
---

# Ship coding change

Drive a single coding change from idea to draft PR by sequencing the existing skills. This skill is a **thin orchestrator that runs on the main thread** — it owns the phase transitions and the user gates; the real work lives in the skills and the subagent it invokes.

The pipeline handles **one change per run**: one plan, one worktree, one branch, one draft PR.

## Step 1: Plan (gate)

Invoke the `plan-coding-changes` skill. **Do not proceed until the user has approved the reconciled plan and scope.**

The approved plan is the contract handed to the autonomous implementer in Step 3. It should already be **split into an ordered sequence of atomic, commit-sized steps** — the planner produces this breakdown. Because that implementer runs in a subagent and **cannot ask questions mid-run**, every open question must be resolved here. Capture from the plan: the ordered steps, the file-by-file changes, the test strategy, and the acceptance criteria.

## Step 2: Start the worktree

Invoke the `start-worktree-change` skill to create the `jibarra/*` branch and worktree under `.ai_coding_agent/worktrees/<name>` off the latest main. Note the **worktree path** and **branch name** — you hand both to the implementer next.

## Step 3: Implement autonomously

Spawn the `coding-implementer` subagent (the `Task` tool in opencode, the `Agent` tool in Claude Code). The prompt must include:

- The approved plan from Step 1
- The worktree path and branch from Step 2
- The acceptance criteria
- The test command (`bin/rspec <paths>` for Ruby per AGENTS.md/CLAUDE.md; otherwise infer and state it)

The implementer takes the plan's **ordered atomic steps** and implements them one at a time — implement a step, run its tests, commit, repeat — until every step is done. It returns `DONE` or `BLOCKED`:

- **DONE** → continue to Step 4. The branch now holds one or more atomic commits.
- **BLOCKED** → bring the blocker to the user, get the decision, then re-invoke the implementer with the answer. If the scope itself changed, return to Step 1. Don't resolve scope questions yourself.

## Step 4: Review (on by default, skippable)

By default, invoke the `code-review-panel` skill on the worktree diff before publishing. For genuinely trivial changes, offer to skip it.

Only **Blocking** findings are auto-fixed. Everything else is deferred, not dropped:

- **Blocking findings** → loop back to Step 3, handing the implementer *only the Blocking findings* to fix, then re-review. Repeat until a review pass returns no Blocking findings.
- **Should-fix and Nits** → do **not** fix them. Carry them forward verbatim.
- **Clean** → continue.

**Retain the full consolidated report** from the final review pass — Step 6 replays every finding to the user, so nothing may be silently discarded.

## Step 5: Finish — push + draft PR

Invoke the `finish-worktree-change` skill. The branch already carries the implementer's atomic commits, so this mostly pushes them (its commit gate still catches any stray uncommitted work), opens a **draft** PR using `create-pr-description` for the body, and offers worktree cleanup.

## Step 6: Report every review finding

If Step 4 ran, close out by presenting the user a single summary of **all** review findings from the final panel — across every tier — each tagged with its disposition:

- **Blocking** — fixed during Step 4's loop.
- **Should-fix** — deferred, not addressed. List each with its location and the reviewer's suggested fix.
- **Nits** — deferred. List each briefly.

This is the punch list of what was consciously left unaddressed, so the user can decide whether to open follow-ups. Do not filter, condense away, or drop any finding — importance decided what got *fixed*, not what gets *shown*.

## Guardrails

- **Fix only what's Blocking; show everything.** Blocking findings are the only ones the implementer fixes automatically. Should-fix and Nits are never auto-fixed and never silently dropped — they always reach the user in the Step 6 summary.
- **The plan gate is load-bearing.** The implementer can't ask questions — settle every decision in Step 1. If you're tempted to let the implementer "figure it out," stop and plan instead.
- **Commit incrementally.** The plan is pre-split into atomic steps; the implementer commits each one as it goes — implement, commit, implement, commit — rather than deferring everything to one commit at the end.
- **Don't skip user gates to chain faster.** Scope approval (Step 1), commit and push, and PR creation stay confirmed. Speed comes from automating the work *between* gates, not from removing them.
- **Carry context forward explicitly.** Pass the approved plan and worktree path into the implementer; pass review findings back into it. The subagent does not share your context.
- **Loop, don't force.** On `BLOCKED` or blocking review findings, return to the right earlier step — never push through with a broken or unreviewed change.
- **One change per run.** Don't batch unrelated changes into a single pipeline.
