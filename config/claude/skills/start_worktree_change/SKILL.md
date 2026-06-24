---
name: start_worktree_change
description: Create a new branch under the jibarra/* naming scheme based on the latest main and set up a dedicated git worktree under .claude/worktrees/ to make coding changes in. Use when the user asks to start a new worktree change, kick off work in a worktree, or begin changes on a fresh branch.
---

# Start worktree change

Create a new branch with the naming scheme `jibarra/*` based on the latest main. Then create a worktree under .claude/worktrees/{worktree_name}. Use that worktree dir for coding changes.
