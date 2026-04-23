---
name: improve_claude_md
description: Audit CLAUDE.md (global or a project's) against recent transcripts to find rules that should be added, consolidated, or removed. Can focus on a specific session when the user wants to encode something that just happened. Use when the user asks to improve CLAUDE.md, tune Claude's defaults, or review general session behavior.
---

# Improve CLAUDE.md

Audit a `CLAUDE.md` against signal from recent sessions and propose a concrete diff. Do not apply edits without confirmation.

## Step 1: Pick the target and signal source

Ask which CLAUDE.md to improve unless the user said:

1. **Global** — `~/.claude/CLAUDE.md` (symlink resolves into the dotfiles repo).
2. **Project** — the `CLAUDE.md` in the current working directory (or nearest ancestor).

If a project file exists and the user is in that repo, default to asking which one; global is the usual answer but don't assume.

Then ask what signal source to prioritize:

- **Cross-session (wide)** — up to the last ~200 sessions, or every session since a date the user names. Default target for CLAUDE.md work: rules earn their place by recurring across dozens of sessions, not just this week's. Ask the user how far back to reach; offer "all available" as an option. For **global** CLAUDE.md, sample across every project dir — the rule library is cross-repo, so the signal should be too.
- **Cross-session (recent)** — last ~20 sessions / ~2 weeks. Use when the user wants a fast pass focused on current workflows.
- **Current session** — the session this skill was invoked in. Best for "I just got frustrated / pleasantly surprised by something, capture it as a rule."
- **A specific past session** — by session ID or rough recall. Useful when the user remembers a session that went especially well or badly.

Defaults:
- Reacting to something that happened *now* → **current session**.
- Generic "improve my CLAUDE.md" ask → **cross-session (wide)**, ask the user for the window.

## Step 2: Gather signal

The richest signal for "what rule is missing" lives in the sessions picked in Step 1.

- Aggregate history: `~/.claude/history.jsonl`
- Per-project sessions: `~/.claude/projects/<encoded-path>/*.jsonl`
- Cross-project sampling for global CLAUDE.md: `~/.claude/projects/*/*.jsonl`

For wide cross-session scans, process sessions in batches rather than loading everything into context at once. Stream file-by-file, extract signals (corrections, surprises, drift) into a running tally, and discard the raw transcript. Report the tally, not the transcripts.

Look for:

- **Repeated corrections** — the user pushed back on the same behavior more than once ("stop doing X", "don't Y", "I told you before…"). These are the strongest candidates for new rules.
- **Surprises** — the user had to explain a convention that I should have known.
- **Drift from existing rules** — I violated a rule in CLAUDE.md despite it being loaded. Either the rule is unclear, too buried, or contradicted by another rule.
- **Friction patterns** — things that burned a turn unnecessarily (asking before safe edits, narrating internal thinking, redundant summaries).
- **Rules that never fire** — entries in CLAUDE.md that no session in the sample triggered. Candidates for removal or consolidation.

Don't quote transcript content back in the final report unless it's essential — cite the rule you'd add/change, not the evidence chain.

## Step 3: Propose a diff

Present, in this order:

1. **Additions** — proposed new bullets, with a one-line justification each.
2. **Edits** — existing bullets reworded for clarity or scope.
3. **Removals** — bullets that never fired or are dominated by another bullet.
4. **Consolidations** — pairs/groups that should merge.

Show the proposal as a unified diff against the current file. Keep the total net change small — CLAUDE.md is loaded every session and grows expensive fast. If the diff adds more than it removes, say so and justify.

## Step 4: Wait

Do not write the file. Ask the user which proposals to accept, then apply only those.

## Guardrails

- **One project at a time.** Don't mix global and project diffs in the same pass.
- **Don't invent rules from a single incident.** A rule earns its place by recurring or by being load-bearing (security, data loss). One-off corrections belong in memory, not CLAUDE.md.
- **Don't restate defaults.** If a rule is already in Claude's built-in behavior, don't add it — it's noise.
- **Preserve the user's voice.** Match the existing tone (terse, opinionated, second person).
