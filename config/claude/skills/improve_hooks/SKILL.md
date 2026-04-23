---
name: improve_hooks
description: Audit hooks in settings.json and propose new hooks based on repeated manual steps, lint/test omissions, or safety gaps. Works across all hooks, a named subset, or a single hook — and can focus on a specific session where a hook fired (or should have fired). Use when the user asks to improve hooks, think through new hooks, critique a specific hook firing, or tune automated behavior around tool calls.
---

# Improve hooks

Audit the user's Claude Code hooks and proactively propose new ones. Do not edit `settings.json` directly — this skill is an analyst, not a configurator. For applying approved changes, invoke the `update-config` skill.

## Step 1: Pick scope

Ask unless the user said:

- **All hooks** — every entry in `~/.claude/settings.json` (global) plus any `.claude/settings.json` / `.claude/settings.local.json` in the current repo.
- **A set** — e.g., "the PostToolUse hooks", "the Ruby hooks". Resolve to explicit matchers/names before proceeding.
- **One hook** — by event + matcher, or by the script path it invokes.

And ask what signal source to prioritize:

- **Cross-session (wide)** — up to ~200 sessions across `~/.claude/projects/*/*.jsonl`, or every session since a date the user names. Default for "find new hook candidates" or "audit existing hooks' real-world behavior" — repeated manual steps and missed automations only show up clearly over many sessions. Ask how far back; offer "all available." Stream file-by-file and tally signal (repeated manual steps after a tool call, dangerous commands the user intervened on, conventions the user had to re-enforce) rather than loading every transcript.
- **Cross-session (recent)** — last ~20 sessions / ~2 weeks. Fast pass focused on current workflows.
- **Current session** — the session this skill was invoked in. Best for "that hook just misbehaved" or "I just did X manually three times, make it a hook."
- **A specific past session** — by session ID. Useful when the user remembers a run where a hook fired wrong, failed silently, or should have fired and didn't.

Default when the user is reacting to a specific hook firing: **current session**, scoped to the hook in question.

## Step 2: Inventory existing hooks

Read:

- `~/.claude/settings.json` (global)
- `.claude/settings.json` and `.claude/settings.local.json` in the current repo, if present
- Every script referenced by a hook (typically under `~/.claude/hooks/`)

For each hook, capture: event (`PreToolUse`, `PostToolUse`, `Stop`, `UserPromptSubmit`, etc.), matcher, command path, and what the script actually does.

## Step 3: Audit existing hooks

Check for:

- **Dead matchers** — the matcher regex doesn't match any tool the user actually uses.
- **Silent failures** — the hook script can fail without surfacing (no `set -e`, swallowed stderr). Hooks that fail silently are worse than no hook.
- **Scope drift** — a `PostToolUse` hook on `Edit` that assumes Ruby files but doesn't filter by extension.
- **Slow hooks** — anything synchronous and expensive on the hot path (every Edit, every prompt). Flag for async or narrower matcher.
- **Overlap** — multiple hooks doing similar things on the same event.
- **Stale paths** — hook command points at a script that no longer exists.

## Step 4: Find candidate new hooks

This is the main value of the skill. Using the signal source picked in Step 1, look for automation opportunities, then think broadly about hooks that'd address the user's stated preferences and common failure modes.

**Signals that suggest a hook:**

- **Repeated manual step after a tool call** — e.g., I ran tests after every edit, or formatted files after every write. If it happened 3+ times, it's a `PostToolUse` candidate.
- **Safety interventions** — the user stopped me from running a dangerous command. That's a `PreToolUse` candidate.
- **Missed convention** — the user reminded me of a rule that a hook could enforce mechanically (e.g., `bin/rspec` vs `rspec`, or `jibarra/*` branch naming).
- **End-of-session omissions** — things I forgot to do before wrapping up. Candidates for `Stop` hooks.

**Candidate hook categories worth considering by default:**

- **Post-edit lint/format** per language (Ruby via RuboCop, TS/JS via Biome/Prettier, Python via Ruff). Existing `lint-ruby-files.sh` is one example.
- **Post-edit test runner** — run the matching spec for the edited file. Per CLAUDE.md, Ruby uses `bin/rspec`.
- **Pre-bash guardrails** — block destructive commands unless confirmed (`rm -rf`, `git push --force`, `git reset --hard`, dropping DB tables).
- **Pre-commit-style checks** — block `git commit` if there are leftover debug statements, large files, or `.env` content staged.
- **Branch-name enforcement** — on `git checkout -b`, require `jibarra/*` prefix.
- **Stop-hook summary/notifier** — surface the run's outcome on stop (desktop notification, or append to a daily log).
- **UserPromptSubmit tagging** — inject the current git branch / dirty state into the prompt so I always know working-tree status.
- **Notification** — surface long-running background tasks when they complete.

For each candidate, sketch: event type, matcher, a one-paragraph description of what the script does, and the evidence from transcripts. Do not write the script yet.

## Step 5: Propose

Present findings in three buckets:

1. **Edits to existing hooks** — concrete changes with rationale.
2. **Removals** — dead or redundant hooks.
3. **New hooks** — ordered by expected payoff (most friction eliminated first). Each entry: event, matcher, description, evidence, estimated effort.

## Step 6: Wait

Do not edit `settings.json` or create hook scripts. Once the user picks which proposals to act on, hand off to `update-config` for the settings changes, and write the scripts under `~/.claude/hooks/` as a separate step.

## Guardrails

- **Hooks run on every matching event — make them fast.** Propose async or background patterns for anything expensive.
- **Fail loud, not silent.** Scripts should exit non-zero and print a useful message. A hook that fails quietly is a bug generator.
- **`PreToolUse` blocks are user-visible friction.** Only propose them when the intervention is worth the interruption.
- **Don't propose a hook for a one-off.** Same bar as skills — recurring or load-bearing only.
- **Scope to the right config file.** Global (`~/.claude/settings.json`) for cross-repo conventions; project (`.claude/settings.json`) for repo-specific rules; local (`.claude/settings.local.json`) for personal overrides not committed.
