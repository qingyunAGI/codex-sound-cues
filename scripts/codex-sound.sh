#!/usr/bin/env bash
set -uo pipefail

event="${1:-complete}"

case "$event" in
  work|work-cue|decision|complete|pet|sedentary|sedentary-start|sedentary-stop|greeting-install|greeting-open|greeting-open-force|test) ;;
  *)
    echo "Unknown event: $event" >&2
    exit 2
    ;;
esac

codex_root="$HOME/.codex"
sound_root="$codex_root/sounds"
state_root="$codex_root/state/codex-sound-cues"
pid_path="$state_root/sedentary-reminder.pid"

work_wav="$sound_root/codex-work-motorcycle-start.wav"
decision_wav="$sound_root/codex-decision-door-knock.wav"
complete_wav="$sound_root/codex-complete-fallback.wav"
pet_wav="$sound_root/codex-pet-click-cute.wav"
sedentary_wavs=(
  "$sound_root/codex-sedentary-cute-1.wav"
  "$sound_root/codex-sedentary-cute-2.wav"
)
greeting_wavs=(
  "$sound_root/codex-greeting-cute-1.wav"
  "$sound_root/codex-greeting-cute-2.wav"
)

play_beep() {
  printf '\a'
  sleep 0.12
}

play_wav() {
  local wav_path="$1"
  [ -f "$wav_path" ] || return 1

  if command -v afplay >/dev/null 2>&1; then
    afplay "$wav_path" >/dev/null 2>&1
    return $?
  fi

  return 1
}

play_random_wav() {
  local available=()
  local path

  for path in "$@"; do
    [ -f "$path" ] && available+=("$path")
  done

  [ "${#available[@]}" -gt 0 ] || return 1
  local index=$((RANDOM % ${#available[@]}))
  play_wav "${available[$index]}"
}

play_greeting_fallback() {
  play_beep
  sleep 0.08
  play_beep
}

pid_alive() {
  local pid="$1"
  [ -n "$pid" ] || return 1
  kill -0 "$pid" >/dev/null 2>&1
}

start_sedentary_reminder() {
  mkdir -p "$state_root"

  if [ -f "$pid_path" ]; then
    local existing_pid
    existing_pid="$(tr -d '[:space:]' < "$pid_path" 2>/dev/null || true)"
    if pid_alive "$existing_pid"; then
      return 0
    fi
  fi

  local reminder_script="$codex_root/scripts/start-sedentary-reminder.sh"
  if [ ! -f "$reminder_script" ]; then
    reminder_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/start-sedentary-reminder.sh"
  fi

  [ -f "$reminder_script" ] || return 0
  nohup bash "$reminder_script" --minutes 60 >/dev/null 2>&1 &
  echo "$!" > "$pid_path"
}

stop_sedentary_reminder() {
  [ -f "$pid_path" ] || return 0
  local existing_pid
  existing_pid="$(tr -d '[:space:]' < "$pid_path" 2>/dev/null || true)"
  if pid_alive "$existing_pid"; then
    kill "$existing_pid" >/dev/null 2>&1 || true
  fi
  rm -f "$pid_path"
}

case "$event" in
  work)
    bash "$0" greeting-open
    start_sedentary_reminder
    bash "$0" work-cue
    ;;
  work-cue)
    play_wav "$work_wav" || { play_beep; sleep 0.08; play_beep; }
    ;;
  decision)
    play_wav "$decision_wav" || { play_beep; sleep 0.26; play_beep; }
    ;;
  complete)
    play_wav "$complete_wav" || { play_beep; sleep 0.06; play_beep; }
    ;;
  pet)
    play_wav "$pet_wav" || { play_beep; sleep 0.06; play_beep; }
    ;;
  sedentary)
    play_random_wav "${sedentary_wavs[@]}" || play_greeting_fallback
    ;;
  greeting-install)
    play_random_wav "${greeting_wavs[@]}" || play_greeting_fallback
    ;;
  greeting-open)
    mkdir -p "$state_root"
    marker="$state_root/greeting-open-played.txt"
    [ -f "$marker" ] && exit 0
    play_wav "${greeting_wavs[1]}" || play_greeting_fallback
    date "+%Y-%m-%d %H:%M:%S" > "$marker"
    ;;
  greeting-open-force)
    play_wav "${greeting_wavs[1]}" || play_greeting_fallback
    ;;
  sedentary-start)
    start_sedentary_reminder
    ;;
  sedentary-stop)
    stop_sedentary_reminder
    ;;
  test)
    bash "$0" greeting-install
    sleep 0.65
    bash "$0" greeting-open-force
    sleep 0.65
    bash "$0" work-cue
    sleep 0.65
    bash "$0" decision
    sleep 0.65
    bash "$0" complete
    sleep 0.65
    bash "$0" pet
    sleep 0.65
    bash "$0" sedentary
    ;;
esac
