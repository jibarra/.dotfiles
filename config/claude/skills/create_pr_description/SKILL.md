---
name: create_pr_description
description: Draft a concise, review-focused PR description (Why / What / Risk / Verification / optional Notes) for a set of changes. Resolves which changes to describe first, then asks for any missing context — the why, ticket/Slack links, proof links — instead of guessing. Use when the user asks to write or update a PR description, write a PR body, or describe a branch/PR for review.
---

# Create PR description

Write a short PR description that gives reviewers confidence in the things they *can't* see from the diff — why the change exists and how we know it works. The code already explains *what* changed; don't restate it.

## Step 1: Resolve which changes

Ask the user which changes the description should cover if they didn't say. Offer these explicitly:

1. **The PR on the current branch** — if one exists (`gh pr view` succeeds), this is the likely target. Propose it and confirm.
2. **This branch vs `main`** — the full diff since it diverged, for a PR that doesn't exist yet.
3. **A specific PR** — ask for the number or URL.
4. **Something else** — uncommitted changes, specific files/paths, a range of commits.

Don't guess. If a PR already exists on the branch, name it and confirm rather than silently assuming.

## Step 2: Gather context

Once scope is clear, pull everything that's already knowable before bothering the user:

- **Diff** — `gh pr diff <number>` or `git diff main...HEAD`.
- **Changed files** — `git diff --name-only main...HEAD`.
- **Branch name** — `git branch --show-current`.
- **Commit messages** — `git log main..HEAD --oneline` (often the clearest statement of intent).
- **Existing PR metadata** — if a PR exists, `gh pr view <number>` for title, current body, and linked issues. If the user is *updating* a description, start from what's there.
- **Linked issue** — scan the branch name, commits, and PR body for identifiers (e.g. `INS-123`, `PROJ-456`). If found, pull it from Linear (`mcp__linear-server__get_issue`) to source the *why*.

## Step 3: Identify gaps and ask the user

This is the important step. Read the diff and decide what you *don't* have enough confidence to write, then ask for it in one batch. Don't fabricate motivation or evidence.

Ask for:

- **The why** — if the ticket/PR/commits don't make the motivation obvious. What is this fixing or improving, and why now? Is there a ticket, Slack thread, incident, or doc to link?
- **Proof links for claims** — if the change *removes* a controller/endpoint/feature/code and the implied justification is "it's unused" or "it's safe," ask for the link that proves it (Datadog showing no traffic, logs, analytics). Never assert "unused" or "no impact" on your own.
- **Verification you can't see** — tests in the diff are visible; manual QA, prod metrics/logs to watch, and dashboards are not. Ask how it was verified beyond what the diff shows.
- **Risk** — if you can't tell what's risky from the diff, ask what the author is worried about (data migrations, hot paths, irreversible actions, blast radius).

Batch the questions. If context already answers everything, skip asking — but state what you inferred so the user can correct it.

## Step 4: Draft the description

Use the template below. **Omit any section that doesn't apply** — an absent section beats one filled with "N/A" or filler.

```markdown
## Why
<Motivation: what this fixes or improves, and why now. Link the ticket / Slack thread / incident / doc. This is the section reviewers need most — almost always include it.>

## What
<Only the few things a reviewer should know about the approach that aren't self-evident from the code. OMIT THIS SECTION ENTIRELY if the diff speaks for itself. Do not narrate the diff.>

## Risk
<What could go wrong and why. If genuinely low-risk, one line: "Low risk — <reason>".>

## Verification
- <Automated: which specs/tests cover this.>
- <Evidence: prod metrics/logs to watch, or proof links — e.g. a Datadog query showing the removed endpoint has zero traffic.>
- <Manual: steps performed, if any.>

## Notes
<Optional: follow-up steps, out-of-scope items, related PRs or references. Omit if none.>
```

Writing rules:
- **Short and concise.** Match length to the change — a one-line fix gets a two-line description.
- **Why and Verification carry the weight.** They're what reviewers can't derive from the code.
- **Don't pad the What.** If the code is self-explanatory, the What section should not exist.
- **Links over assertions.** "Unused (Datadog: <link>)" beats "unused." If the user can't supply proof, soften the claim or mark it unverified rather than stating it as fact.

## Step 5: Present and apply

Show the draft. Then offer to apply it — only with explicit confirmation:
- Existing PR → `gh pr edit <number> --body "..."`.
- No PR yet → offer to create it (`gh pr create`), but confirm title and base first.

Don't edit or create the PR without a clear go-ahead.

## Guardrails

- **Don't guess the why.** If the motivation isn't in the ticket/PR/commits, ask. A missing why is the most common reason a description fails its job.
- **Don't assert "unused" / "safe" / "no impact" without a link.** Ask for the proof; if there is none, soften the claim.
- **Omit, don't pad.** Drop sections that don't apply instead of filling them. Never narrate the diff in the What section.
- **Don't apply to the PR without confirmation.** Drafting is not publishing.
- **If the diff is empty** (nothing uncommitted, branch even with main, PR has no changes), say so and stop — there's nothing to describe.
