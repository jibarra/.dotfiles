#!/bin/bash
# Shows a macOS banner for Claude Code lifecycle events. Invoked by hooks
# in settings.json; the event name is passed as $1 and the hook JSON
# arrives on stdin.

input=$(cat)

case "$1" in
  stop)          body="Task complete" ;;
  subagent-stop) body="Subagent finished" ;;
  session-start) body="Session started" ;;
  notification)
    body=$(printf '%s' "$input" | jq -r '.message // empty' 2>/dev/null)
    [ -z "$body" ] && body="Waiting for input"
    ;;
  *) exit 0 ;;
esac

# Pass text as arguments so quotes/paths in the message can't break the AppleScript.
osascript -e 'on run {b, t}' -e 'display notification b with title t' -e 'end run' "$body" "Claude Code" >/dev/null 2>&1 &
exit 0
