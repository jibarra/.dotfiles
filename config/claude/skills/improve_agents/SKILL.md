---
name: improve_agents
description: Audit agent definitions under ~/.claude/agents for scope clarity, tool allowlist minimality, model choice, and invocation patterns. Works across all agents, a named subset, or a single agent — and can focus on a specific session where the agent just ran. Use when the user asks to improve agents, tune when agents get invoked, critique a just-finished agent run, or find missing agents.
---

# Improve agents

Audit the user's agent library and propose changes. Do not edit agent files or create new ones without confirmation.

## Step 1: Pick scope

Ask unless the user said:

- **All agents** — every file under `~/.claude/agents/**/*.md`.
- **A set** — e.g., "the reviewer panel", "the voice reviewers". Resolve to explicit names before proceeding.
- **One agent** — by name.

And ask what signal source to prioritize:

- **Cross-session (wide)** — up to ~200 sessions across `~/.claude/projects/*/*.jsonl`, or every session since a date the user names. Default for "is this agent still pulling its weight" or "find missing agents" — agent quality is judged across dozens of runs, not this week's. Ask how far back; offer "all available." Stream file-by-file and tally signal (invocations, accepts, rejects, redone work) rather than loading every transcript.
- **Cross-session (recent)** — last ~20 sessions / ~2 weeks. Fast pass focused on current workflows.
- **Current session** — the session this skill was invoked in. Best for "I just ran the agent, critique that run." The session transcript lives at `~/.claude/projects/<encoded-cwd>/<session-id>.jsonl`.
- **A specific past session** — by session ID or by "the one where I reviewed PR #123". Useful when the user remembers a run that went wrong.

Default when the user just finished an agent run and is asking about it: **current session**, scoped to the agent(s) that ran.

## Step 2: Inventory

Read every agent in scope (from Step 1). For each, capture:

- `name`, `description`, file path
- Tool allowlist (if declared)
- Model (if declared)
- Body length, persona vs procedure, any references to other agents or skills

## Step 3: Audit each agent

Agents have a different match surface from skills — the main agent decides when to spawn one based on the description *and* the task description string. Check:

- **Role clarity** — does the agent have one job? If the description mixes "reviews X *and* refactors Y", split.
- **Invocation trigger** — does the description include "Use when…" or an equivalent cue? If not, the main agent will default to `general-purpose`.
- **Tool allowlist** — is it minimal? An Explore-style agent shouldn't have Write. A reviewer shouldn't need Edit. Over-broad allowlists let agents do the wrong thing.
- **Model choice** — if a model is pinned, is it right for the job? Cheap/fast for mechanical tasks; Opus for judgment-heavy reviewers.
- **Persona consistency** — for "voice" agents (like `jose_reviewer`), is the first-person framing maintained throughout?
- **Panel coherence** — for agents used together (e.g., reviewers in `code_review`), do they overlap or leave gaps?
- **Stale references** — agents referencing other agents, skills, or tools that no longer exist.

## Step 4: Check invocation signal

Scope the scan to whatever the user picked in Step 1.

**For each agent invocation in the sampled transcripts, look at four things:**

1. **The prompt the agent received.** Was it self-contained, with enough context to act? Or did it force the agent to guess? (Prompt quality is a main-agent problem, but if the *same* agent keeps getting bad prompts, its description isn't steering callers correctly.)
2. **The agent's returned result.** Did it actually deliver what the description promised? Was the output structured, or rambling? Did it hedge instead of committing?
3. **What the main agent did with the result.** Accepted it, partially used it, or re-did the work? Re-doing is the loudest signal that the agent isn't pulling its weight.
4. **Whether an agent should have been invoked but wasn't.** If the session shows research-heavy or parallelizable work done directly when a specialized agent exists, flag it.

**When scope is a single agent (or a focused set):** go deep. Quote the exchange if needed, name specific weaknesses in the agent's output, and propose surgical edits to its body or description.

**When scope is all agents:** stay high-signal. Flag patterns — agents that never fire, agents invoked wrong, repeated ad-hoc `general-purpose` prompts that should have been a specialized agent. Don't drown the user in per-agent minutiae.

**Common findings across scopes:**

- **Agents that never fire** — defined but not invoked. Candidates for removal or description rewrite.
- **Agents invoked wrong** — triggered for work they aren't suited to, or skipped when they should have fired. Usually a description problem.
- **Manual work that should have been an agent** — research-heavy or parallelizable work done directly. Candidate for a new agent.
- **Repeated ad-hoc `general-purpose` prompts** — same shape of task delegated to a generic agent multiple times. That's a missing specialized agent.

## Step 5: Propose

Present findings in three buckets:

1. **Edits to existing agents** — unified diffs. Prioritize description and tool-allowlist fixes.
2. **Consolidations/removals** — overlapping agents, dead agents.
3. **New agents** — name, description, proposed tool allowlist, model recommendation, and evidence from transcripts.

## Step 6: Wait

Do not apply edits or create files. Ask which proposals to accept, then apply only those.

## Guardrails

- **Don't propose an agent for a one-off.** Agents earn their keep by being invoked repeatedly.
- **Minimize tool allowlists.** Broad allowlists are a silent security/safety problem — an agent that doesn't need Edit shouldn't have it.
- **Voice agents need a real perspective.** A "senior engineer" agent that restates defaults is worse than no agent. If you can't write a sharp persona, drop the voice framing and make it a procedural agent.
- **Don't duplicate a skill.** If the workflow can live as a SKILL.md invoking existing agents, prefer that over a new bespoke agent.
