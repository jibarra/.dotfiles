---
name: improve_skills
description: Audit SKILL.md files under ~/.claude/skills for description quality, trigger clarity, overlap, and gaps. Works across all skills, a named subset, or a single skill — and can focus on a specific session where the skill was (or should have been) invoked. Use when the user asks to improve skills, tune skill triggers, critique a just-used skill, or find missing skills.
---

# Improve skills

Audit the user's skill library and propose changes. Do not edit SKILL.md files or create new ones without confirmation.

## Step 1: Pick scope

Ask unless the user said:

- **All skills** — every file under `~/.claude/skills/**/SKILL.md`.
- **A set** — e.g., "the improve_* skills", "the review-related skills". Resolve to explicit names before proceeding.
- **One skill** — by name.

And ask what signal source to prioritize:

- **Cross-session (wide)** — up to ~200 sessions across `~/.claude/projects/*/*.jsonl`, or every session since a date the user names. Default for "is this skill triggering right" or "find missing skills" — trigger patterns and missing-skill signal accumulate over many sessions. Ask how far back; offer "all available." Stream file-by-file and tally signal (fires, misfires, manual workflows that match an existing skill's domain) rather than loading every transcript.
- **Cross-session (recent)** — last ~20 sessions / ~2 weeks. Fast pass focused on current workflows.
- **Current session** — the session this skill was invoked in. Best for "I just used the skill, critique that run" or "this session shows a workflow that should be a skill."
- **A specific past session** — by session ID or by rough memory of the session. Useful when the user remembers a run where the skill fired wrong or didn't fire.

Default when the user just used a skill and is asking about it: **current session**, scoped to the skill(s) that ran.

## Step 2: Inventory

Read every skill in scope (from Step 1). For each, capture:

- `name`, `description`, file path
- Body length and structure
- Whether it references other skills, agents, or external tools

## Step 3: Audit each skill

The description is the match surface — it's what future-me sees when deciding whether to invoke. Bad descriptions are the most common skill defect.

Check each skill for:

- **Triggerability** — does the description say *when* to use it, not just *what* it does? Good descriptions include "Use when the user asks to…". Vague descriptions get skipped.
- **Scope clarity** — is the skill one concrete job, or a kitchen sink? Split if it's the latter.
- **Overlap** — do two skills claim the same trigger space? One will always lose.
- **Body hygiene** — is the body instructions to future-me, or a sales pitch? Cut marketing prose.
- **Stale references** — does the skill reference agents, paths, or tools that no longer exist? Grep to verify.
- **Frontmatter correctness** — `name` matches folder name, `description` under ~300 chars, no orphan fields.

## Step 4: Check invocation signal

Scope the scan to whatever the user picked in Step 1.

**For each skill invocation in the sampled transcripts, look at:**

1. **Whether it fired at the right moment.** Did the user's intent match the skill's description? If the skill fired late (after the user repeated themselves), its description is probably too narrow.
2. **Whether it followed its own instructions.** Skills are self-contained playbooks; if the session shows the skill short-circuiting steps or ignoring guardrails, the body needs tightening.
3. **Whether the result satisfied the user.** Follow-up corrections inside the same skill run are the loudest signal that something in the skill body is wrong.
4. **Whether a skill should have been invoked but wasn't.** Manual workflows that match an existing skill's domain = description is failing to trigger.

**When scope is a single skill (or a focused set):** go deep. Point at the specific bullet, line, or phrasing to change.

**When scope is all skills:** stay high-signal. Flag patterns — skills that never fire, skills invoked wrong, workflows done manually that have no skill yet.

## Step 5: Find missing skills

Using the same sampled transcripts, surface workflows I executed manually that should have been a skill:

- **Repeated multi-step flows** — same sequence of commands/tools across sessions. If I ran it three times, it's a skill candidate.
- **Workflows the user had to re-explain** — every re-explanation is a missing skill or a bad description on an existing one.
- **Cross-repo patterns** — work done in the same way across multiple project dirs.

Propose each missing skill with: proposed `name`, a draft `description`, and the evidence (which sessions, rough shape of the workflow). Don't draft the body yet — that's a second pass after the user confirms the skill is worth having.

## Step 6: Propose

Present findings in three buckets:

1. **Edits to existing skills** — show a unified diff per skill. Prioritize description fixes since those have the biggest triggering impact.
2. **Consolidations/removals** — pairs that should merge, skills that never fired.
3. **New skills** — name + description + evidence.

## Step 7: Wait

Do not apply edits or create files. Ask which proposals to accept, then apply only those.

## Guardrails

- **Descriptions are load-bearing.** Spend more time on them than on bodies. A great body behind a bad description is dead weight.
- **YAGNI on new skills.** A workflow earns a skill by recurring. Don't propose a skill for something done once.
- **Don't rewrite for style.** If a skill works and the body is clear, leave it alone. Churn here has real cost — every session reloads the description.
- **Verify references before touching.** If a skill points at an agent, `ls ~/.claude/agents/**` to confirm it exists before assuming the reference is stale.
