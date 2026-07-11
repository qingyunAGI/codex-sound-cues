#!/usr/bin/env bash
set +e

sound_script="$HOME/.codex/scripts/codex-sound.sh"
if [ -f "$sound_script" ]; then
  bash "$sound_script" complete >/dev/null 2>&1
fi

exit 0
