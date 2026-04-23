---
name: code_review
description: Run a multi-reviewer panel (architecture, maintainability, edge case, performance, security, senior engineer, product manager, and Jose) on a set of code changes and return a consolidated, prioritized report. Jose's findings are weighted highest. Use when the user asks to code review changes, review a PR, review the current branch, or get a second opinion before merging.
---

# Code review panel

Invokes the `reviewer_orchestrator` agent to fan out to eight specialized reviewer agents in parallel and consolidate their findings into one report.

## Step 1: Resolve what "changes" means

Ask the user which set of changes to review if they didn't say. Offer these options explicitly:

1. **Uncommitted working tree** — everything dirty or staged in the current checkout.
2. **Current branch vs `main`** — the full diff of this branch since it diverged.
3. **A specific PR** — ask for the PR number (or URL).
4. **Specific files or paths** — ask for the list.

If the user said something like "review my changes" or "review this", propose the most likely interpretation based on context and confirm. Don't fan out to eight agents on the wrong diff.

If no arguments were passed, default to asking.

## Step 2: Assemble context

Once scope is clear, gather a context package before launching the orchestrator:

- **Diff content** — run the appropriate git command or `gh pr diff`.
- **Changed files list** — `git diff --name-only` or equivalent.
- **Branch name** — `git branch --show-current`.
- **Recent commit messages** — `git log -n 10 --oneline` for branch scope, or `git log main..HEAD --oneline` for branch vs main.
- **PR metadata** — if a PR was specified, `gh pr view <number>` for title, description, and any linked issues.
- **Linked issue identifier** — scan the branch name, commit messages, and PR description for patterns like `INS-123`, `PROJ-456`. Surface it so the product reviewer can pull it.

For large diffs, don't paste the whole thing into the orchestrator prompt — let the orchestrator and reviewers read files directly. Instead, summarize the scope (files changed, general nature of the change) and point them at the right command to run.

## Step 3: Launch the orchestrator

Use the Agent tool with `subagent_type: reviewer_orchestrator`. In the prompt, include:

- The resolved scope (e.g., "Review the diff from `git diff main...HEAD` on branch `jibarra/foo`")
- The context package from Step 2
- The linked issue identifier (if found)
- Any specific things the user asked the panel to focus on

Example invocation:

```
Agent({
  subagent_type: "reviewer_orchestrator",
  description: "Multi-reviewer panel on <branch>",
  prompt: "Review the changes on branch `<branch>` vs main. <N> files changed: <summary or list>. Linked issue: <ID or 'none found'>. Recent commits: <list>. Fan out to the eight reviewer agents in parallel and return a consolidated report."
})
```

## Step 4: Present the result

Relay the orchestrator's consolidated report back to the user. Don't re-summarize it — it's already the final output. Add one or two sentences of your own only if there's an obvious next step (e.g., "ready to start fixing the blocking issues?" or "want me to post this as a PR comment?").

## Guardrails

- **Don't re-run the panel automatically** if the user asks a follow-up question. Answer the question first; only re-run if the user asks for a fresh review.
- **Don't skip the clarification step** to save a round-trip. Eight agents on the wrong diff is worse than one extra question.
- **Don't substitute your own review** for the panel. The user asked for the panel specifically; give them the panel's output.
- **If the diff is empty** (nothing uncommitted, branch is up to date with main, PR has no changes), say so and stop — don't spawn reviewers on nothing.
