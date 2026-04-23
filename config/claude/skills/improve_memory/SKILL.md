---
name: improve_memory
description: Bulk audit of a project's memory store — the spring-cleaning pass that Claude's reactive in-flow memory maintenance misses. Focuses on cross-memory deduplication, MEMORY.md index bloat, stalest entries nobody has touched in a while, and retroactive capture of feedback from past sessions that never got saved. Works across all memories, a type (user/feedback/project/reference), or a single file. Do NOT use for everyday save-this-memory asks — Claude handles those in-flow. Use when the user asks to clean up / prune memory, audit what Claude remembers, or capture signal from past sessions that wasn't saved.
---

# Improve memory

Audit the per-project memory store and propose changes. Do not delete or edit memory files without confirmation.

## Step 1: Pick the store, scope, and signal source

**Store.** Memory lives under `~/.claude/projects/<encoded-path>/memory/`, with an index at `MEMORY.md`. Ask which project's memory to audit if not specified. The encoded-path convention replaces `/` with `-` (e.g., `/Users/joseibarra/.dotfiles` → `-Users-joseibarra--dotfiles`).

**Scope within the store.** Ask unless stated:

- **All memories** — every file referenced by `MEMORY.md`.
- **A type** — e.g., just `user`, just `feedback`, just `project`, or just `reference`.
- **One memory file** — by name.

**Signal source.** Ask what to prioritize:

- **Cross-session (wide)** — up to ~200 sessions in the target project (`~/.claude/projects/<encoded-path>/*.jsonl`), or every session since a date the user names. Default for bulk audit and retroactive capture — the unique value of this skill is finding signal the in-flow maintenance missed over many sessions. Ask how far back; offer "all available." Stream file-by-file and tally signal (memory-worthy feedback that was never saved, memories that were touched and didn't get updated) rather than loading every transcript.
- **Cross-session (recent)** — last ~20 sessions / ~2 weeks. Fast pass when the user just wants to skim for drift.
- **Current session** — the session this skill was invoked in. Best for "this session showed a memory firing wrong" or "I just gave feedback that should be saved."
- **A specific past session** — by session ID. Useful when the user remembers a session where memory misfired or something should have been captured.

Default when the user is reacting to something that just happened: **current session**.

## Step 2: Inventory

Read `MEMORY.md` and every memory file in scope (from Step 1). For each file capture:

- `name`, `description`, `type` (user / feedback / project / reference)
- Body length
- Whether the index entry matches the file's description
- Any references to paths, files, functions, dates, or deadlines

## Step 3: Audit

Prioritize findings Claude's reactive memory maintenance *can't* catch — cross-memory patterns, index bloat, and slow-accumulating rot. Don't spend cycles on things the in-flow behavior already handles (checking a named file exists before acting on one specific memory, flagging a single out-of-date fact when it gets touched). Those will get handled naturally the next time that memory comes up.

Flag entries that match these patterns:

- **Stale by reference** — entry names a file, function, or flag. Grep/ls to confirm it still exists. If gone, mark for removal or rewrite.
- **Stale by date** — entry mentions a deadline, sprint, release, or quarter that has passed. Project-type memories especially.
- **Duplicates / near-duplicates** — two entries say roughly the same thing. Propose a merge, keep the clearer framing.
- **Low signal** — entries that are derivable from the code, CLAUDE.md, or git history. Per the memory doctrine, these shouldn't exist.
- **Missing structure** — feedback/project entries without the **Why:** and **How to apply:** lines. These age badly.
- **Index drift** — `MEMORY.md` entries whose hook sentence no longer matches the file's description.
- **Index bloat** — `MEMORY.md` over ~150 lines or any single entry over ~150 chars. The index is always loaded; keep it lean.

Also check for **missing memories** — feedback or project context in the sessions picked in Step 1 that never made it into a memory file. Propose these as additions.

**When scope is a single memory file (or a type):** go deep. Quote the entry, name the specific phrasing to change, and propose a full rewrite if warranted.

**When scope is all memories:** stay high-signal. Surface the worst offenders (stalest, most duplicated, biggest index-bloat contributors) instead of listing every nit.

## Step 4: Propose

Present findings in four buckets:

1. **Removals** — stale or low-signal entries. One-line justification each.
2. **Rewrites** — entries to keep but reshape (add Why/How, tighten body, fix index hook).
3. **Merges** — pairs to collapse. Show the target content.
4. **Additions** — new memories suggested by transcript signal.

For every proposal, show the diff against `MEMORY.md` *and* the individual memory file.

## Step 5: Wait

Do not apply edits or delete files. Ask which proposals to accept, then apply only those.

## Guardrails

- **Verify staleness before proposing removal.** A memory that references a missing file might be the signal that reminds me the file was deleted on purpose. Confirm with `git log -- <path>` before assuming stale = delete.
- **Keep the index tight.** Aggressive consolidation in `MEMORY.md` has higher leverage than anywhere else — it runs every session.
- **Don't promote every correction.** Only recurring or load-bearing feedback earns a memory file. One-offs belong in the conversation.
- **Preserve the type.** Don't convert a `feedback` memory into a `project` memory or vice versa — the types have different decay characteristics.
