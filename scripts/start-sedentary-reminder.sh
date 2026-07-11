#!/usr/bin/env bash
set -euo pipefail

minutes=60
once=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --minutes|-m)
      minutes="${2:-}"
      shift 2
      ;;
    --once)
      once=1
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

case "$minutes" in
  ''|*[!0-9]*)
    echo "--minutes must be a number." >&2
    exit 2
    ;;
esac

if [ "$minutes" -lt 5 ] || [ "$minutes" -gt 240 ]; then
  echo "--minutes must be between 5 and 240." >&2
  exit 2
fi

sound_script="$HOME/.codex/scripts/codex-sound.sh"
if [ ! -f "$sound_script" ]; then
  sound_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/codex-sound.sh"
fi

if [ ! -f "$sound_script" ]; then
  echo "codex-sound.sh was not found. Install the skill first or run from the skill scripts folder." >&2
  exit 1
fi

reminder_count=0
while :; do
  sleep "$((minutes * 60))"
  reminder_count=$((reminder_count + 1))
  echo "Playing sedentary reminder #$reminder_count after $((minutes * reminder_count)) minutes."
  bash "$sound_script" sedentary
  [ "$once" -eq 0 ] || break
done
