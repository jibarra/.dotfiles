#!/usr/bin/env bash
set -eo pipefail

# Stop hook: nudges the user to run a specific /improve_* skill when signals
# in the current session cross a threshold. Designed to fire at most once per
# session regardless of how many assistant turns happen.

input=$(cat)

session_id=$(printf '%s' "$input" | jq -r '.session_id // empty')
transcript_path=$(printf '%s' "$input" | jq -r '.transcript_path // empty')
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')

cache_dir="$HOME/.claude/cache/improve_nudge"
mkdir -p "$cache_dir"
marker="$cache_dir/${session_id:-unknown}"
if [[ -f "$marker" ]]; then
  exit 0
fi

CORRECTION_THRESHOLD=3
MEMORY_LINE_THRESHOLD=200

correction_patterns='stop (doing|that|narrating|summarizing)|don'"'"'t (do|be|keep|narrate|summarize)|i (told|said) you|i already (said|told)|no not that'

corrections=0
if [[ -n "$transcript_path" && -f "$transcript_path" ]]; then
  corrections=$(jq -r '
    select(.type == "user") |
    (.message.content // empty) |
    if type == "string" then .
    elif type == "array" then (.[]? | select(.type == "text") | .text // empty)
    else empty end
  ' "$transcript_path" 2>/dev/null \
    | grep -icE "$correction_patterns" \
    || true)
fi

memory_lines=0
if [[ -n "$cwd" ]]; then
  encoded=${cwd//\//-}
  memory_md="$HOME/.claude/projects/$encoded/memory/MEMORY.md"
  if [[ -f "$memory_md" ]]; then
    memory_lines=$(wc -l < "$memory_md" | tr -d ' ')
  fi
fi

nudges=()
if (( corrections >= CORRECTION_THRESHOLD )); then
  nudges+=("Session had $corrections corrections — consider /improve_claude_md (current session) to encode them as rules.")
fi
if (( memory_lines > MEMORY_LINE_THRESHOLD )); then
  nudges+=("MEMORY.md is $memory_lines lines — consider /improve_memory to prune.")
fi

if (( ${#nudges[@]} > 0 )); then
  printf '%s\n' "${nudges[@]}"
  touch "$marker"
fi

exit 0
