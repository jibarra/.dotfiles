---
name: finish_worktree_change
description: Finish a worktree change: push the branch, open or update its PR (chaining create_pr_description for the body), then optionally remove the worktree. The completion counterpart to start_worktree_change. Use when the user asks to finish a worktree, open a PR for the current branch, or wrap up and clean up a worktree.
---

# Finish worktree change

Complete a change started by `start_worktree_change`: push the branch, open or update its PR (using `create_pr_description` for the body), then optionally remove the worktree.

## Step 1: Confirm what's being finished

Identify the branch and worktree to finish. Ground it with `git status` and `git branch --show-current`; if it's not obvious from the current directory, ask. Confirm:

- The branch (expected `jibarra/*`).
- The worktree path (under `.ai_coding_agent/worktrees/`).

## Step 2: Pre-flight checks

Before pushing, make sure the change is in a finishable state:

- **Uncommitted work** — if `git status` shows uncommitted changes, stop and ask whether to commit them first. Don't commit without confirmation.
- **Empty diff** — if the branch has no commits beyond main (`git log main..HEAD --oneline` is empty), there's nothing to open a PR for. Say so and stop.
- **Behind main** — note if the branch is behind `origin/main`. Offer to rebase/merge only if the user wants it; don't silently rewrite history.

## Step 3: Push the branch

Push with upstream tracking (plain `git push` is enough if the branch already tracks a remote):

```
git push -u origin <branch>
```

Surface any rejection (e.g. non-fast-forward) instead of resolving it for them. Never `--force` without explicit confirmation.

## Step 4: Open or update the PR

Check whether a PR already exists for the branch:

```
gh pr view --json number,url,state
```

- **Exists** — this is an update. Offer to refresh the description (Step 5) and report the URL.
- **None** — generate the body (Step 5), then create the PR (always as a draft) only after confirming title and base:

```
gh pr create --draft --base main --head <branch> --title "<title>" --body "<body>"
```

## Step 5: Generate the PR body

Invoke the `create_pr_description` skill to draft the Why / What / Risk / Verification body for this branch's diff, and use its output as the `--body`. Don't hand-roll a description here — that skill owns the format and the gap-finding questions.

## Step 6: Offer worktree cleanup

Only after the PR exists, offer to remove the worktree. Cleanup is opt-in — confirm first.

- You **cannot** remove the worktree you're currently standing in. If the current directory is the worktree, `cd` back to the main checkout first.
- Remove with:

```
git worktree remove .ai_coding_agent/worktrees/<name>
```

- If git refuses because the worktree has untracked or modified files, report it and ask before using `--force`.
- Leave the branch intact — the open PR depends on it.

## Guardrails

- **Never force-push or hard-reset without explicit confirmation.** Surface rejections and let the user decide.
- **Always open the PR as a draft** (`--draft`). The user marks it ready for review themselves.
- **Don't create the PR without confirming** title and base. Drafting a body is not opening a PR.
- **Don't commit uncommitted work silently.** Ask first.
- **Cleanup is opt-in and last.** Only after the PR is open, only with confirmation, and never the worktree you're standing in.
- **Don't delete the branch.** The open PR depends on it.
