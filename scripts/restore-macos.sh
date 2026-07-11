#!/usr/bin/env bash
set -euo pipefail

codex_root="$HOME/.codex"
config_path="$codex_root/config.toml"
agents_path="$codex_root/AGENTS.md"
pet_root="$codex_root/pets"
pet_destination="$pet_root/magic-deer"
sound_script="$codex_root/scripts/codex-sound.sh"

if [ -f "$sound_script" ]; then
  bash "$sound_script" sedentary-stop >/dev/null 2>&1 || true
fi

latest_backup() {
  local pattern="$1"
  find "$codex_root" -maxdepth 1 -name "$pattern" -type f 2>/dev/null | sort | tail -n 1
}

config_backup="$(latest_backup 'config.toml.bak-codex-sound-cues-*')"
agents_backup="$(latest_backup 'AGENTS.md.bak-codex-sound-cues-*')"

if [ -n "$config_backup" ]; then
  cp -p "$config_backup" "$config_path"
  echo "Restored config.toml from $(basename "$config_backup")"
else
  echo "No config.toml backup found."
fi

if [ -n "$agents_backup" ]; then
  cp -p "$agents_backup" "$agents_path"
  echo "Restored AGENTS.md from $(basename "$agents_backup")"
else
  echo "No AGENTS.md backup found."
fi

pet_backup="$(find "$pet_root" -maxdepth 1 -name 'magic-deer.bak-codex-sound-cues-*' -type d 2>/dev/null | sort | tail -n 1)"
if [ -n "$pet_backup" ]; then
  rm -rf "$pet_destination"
  cp -R "$pet_backup" "$pet_destination"
  echo "Restored Magic Deer pet from $(basename "$pet_backup")"
else
  echo "No previous Magic Deer pet backup found; the installed pet is left in place."
fi
