#!/bin/bash
# Plays a Warcraft notification sound for Claude Code lifecycle events.
# Invoked by hooks in settings.json; the event name is passed as $1.

SOUNDS="$HOME/.dotfiles/config/ai_coding_harness/sounds"

case "$1" in
  stop)          file="orc_work_complete.wav" ;;
  subagent-stop) file="peasant_jobs_done.wav" ;;
  session-start) file="orc_dabu.wav" ;;
  notification)
    # Notification fires for both permission prompts and idle input waits;
    # the message on stdin tells them apart.
    if grep -qi permission; then
      file="peasant_milord.wav"
    else
      file="ogre_huh_what.wav"
    fi
    ;;
  *) exit 0 ;;
esac

afplay "$SOUNDS/$file" >/dev/null 2>&1 &
exit 0
