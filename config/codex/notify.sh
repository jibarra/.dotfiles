#!/bin/bash
# Codex passes notification JSON as an argument; hooks send their JSON on stdin.
case "$1" in
  notify)         body="Task complete" ;;
  session-start)  body="Session started" ;;
  subagent-stop)  body="Subagent finished" ;;
  *) exit 0 ;;
esac

osascript -e 'on run {b, t}' -e 'display notification b with title t' -e 'end run' "$body" "Codex" >/dev/null 2>&1 &
exit 0
