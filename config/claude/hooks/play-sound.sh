#!/bin/bash
# Plays a Warcraft sound and shows a macOS banner for Claude Code
# lifecycle events. Invoked by hooks in settings.json; the event name
# is passed as $1 and the hook JSON arrives on stdin.

SOUNDS="$HOME/.dotfiles/config/ai_coding_harness/sounds"
input=$(cat)

case "$1" in
  stop)          file="orc_work_complete.wav"; body="Task complete" ;;
  subagent-stop) file="peasant_jobs_done.wav"; body="Subagent finished" ;;
  session-start) file="orc_dabu.wav";          body="Session started" ;;
  notification)
    # notification_type is "permission_prompt" (needs permission) or
    # "idle_prompt" (waiting / a question Claude asked). Fall back to the
    # message text only if the type is absent.
    ntype=$(printf '%s' "$input" | jq -r '.notification_type // empty' 2>/dev/null)
    body=$(printf '%s' "$input" | jq -r '.message // empty' 2>/dev/null)
    [ -z "$body" ] && body="Waiting for input"
    if [ "$ntype" = "permission_prompt" ] || { [ -z "$ntype" ] && printf '%s' "$body" | grep -qi permission; }; then
      file="peasant_milord.wav"
    else
      file="ogre_huh_what.wav"
    fi
    ;;
  *) exit 0 ;;
esac

afplay "$SOUNDS/$file" >/dev/null 2>&1 &
# Pass text as arguments so quotes/paths in the message can't break the AppleScript.
osascript -e 'on run {b, t}' -e 'display notification b with title t' -e 'end run' "$body" "Claude Code" >/dev/null 2>&1 &
exit 0
