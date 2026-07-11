#!/usr/bin/env bash
set -euo pipefail

skill_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex_root="$HOME/.codex"
script_dir="$codex_root/scripts"
sound_dir="$codex_root/sounds"
state_dir="$codex_root/state/codex-sound-cues"
pet_root="$codex_root/pets"
pet_source="$skill_root/assets/pets/magic-deer"
pet_destination="$pet_root/magic-deer"
stamp="$(date "+%Y%m%d-%H%M%S")"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "Warning: this installer targets macOS and uses afplay for audio playback." >&2
fi

if ! command -v afplay >/dev/null 2>&1; then
  echo "Warning: afplay was not found. Files will be installed, but sound playback may not work." >&2
fi

mkdir -p "$script_dir" "$sound_dir" "$state_dir" "$pet_root"

config_path="$codex_root/config.toml"
agents_path="$codex_root/AGENTS.md"

if [ -f "$config_path" ]; then
  cp -p "$config_path" "$config_path.bak-codex-sound-cues-$stamp"
  grep -E '^[[:space:]]*notify[[:space:]]*=' "$config_path" | head -n 1 > "$state_dir/original-notify-line.toml" || true
fi

if [ -f "$agents_path" ]; then
  cp -p "$agents_path" "$agents_path.bak-codex-sound-cues-$stamp"
fi

cp "$skill_root"/scripts/*.sh "$script_dir"/
chmod +x "$script_dir"/*.sh
cp "$skill_root"/assets/*.wav "$sound_dir"/

rm -f "$state_dir/greeting-open-played.txt"
date "+%Y-%m-%d %H:%M:%S" > "$state_dir/installed-at.txt"

if [ -d "$pet_source" ]; then
  if [ -d "$pet_destination" ]; then
    cp -R "$pet_destination" "$pet_destination.bak-codex-sound-cues-$stamp"
  fi
  rm -rf "$pet_destination"
  mkdir -p "$pet_destination"
  cp -R "$pet_source"/. "$pet_destination"/
fi

toml_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

wrapper_path="$(toml_escape "$script_dir/codex-notify-wrapper.sh")"
new_notify="notify = [ \"bash\", \"$wrapper_path\", \"turn-ended\" ]"

if [ -f "$config_path" ]; then
  tmp_config="$(mktemp)"
  awk -v new_notify="$new_notify" '
    BEGIN { replaced = 0 }
    /^[[:space:]]*notify[[:space:]]*=/ {
      if (!replaced) {
        print new_notify
        replaced = 1
      }
      next
    }
    { print }
    END {
      if (!replaced) {
        print new_notify
      }
    }
  ' "$config_path" > "$tmp_config"
  mv "$tmp_config" "$config_path"
else
  printf '%s\n' "$new_notify" > "$config_path"
fi

guidance_file="$(mktemp)"
cat > "$guidance_file" <<'EOF'
## Codex Sound Cues

- For substantial work on macOS, run `bash "$HOME/.codex/scripts/codex-sound.sh" work` when starting active processing.
- The `work` event plays the first-session Magic Deer greeting before the work cue when it has not been played yet, then starts the hourly sedentary reminder loop if it is not already running.
- Before asking the user to make a decision, run `bash "$HOME/.codex/scripts/codex-sound.sh" decision`.
- For pet click integrations, run `bash "$HOME/.codex/scripts/codex-sound.sh" pet`.
- The Magic Deer animated pet is installed in `$HOME/.codex/pets/magic-deer`; select it from Codex custom pets after restarting Codex.
- After installation, the installer plays `greeting-install`, randomly selecting one of the two Magic Deer greeting voices.
- At the beginning of the first Codex work session after installation, `work` automatically calls `greeting-open`; it plays the second Magic Deer greeting once and records a local marker.
- Long-sitting reminders are started automatically by `work`; they randomly remind after 1 hour, 2 hours, 3 hours, and every continued hour. Stop them with `bash "$HOME/.codex/scripts/codex-sound.sh" sedentary-stop`.
- Completion sound is handled by the configured Codex `notify` hook.
EOF

if [ -f "$agents_path" ]; then
  tmp_agents="$(mktemp)"
  awk -v repl_file="$guidance_file" '
    BEGIN {
      while ((getline line < repl_file) > 0) {
        repl = repl line ORS
      }
      skipping = 0
      replaced = 0
    }
    /^## Codex Sound Cues[[:space:]]*$/ {
      if (!replaced) {
        printf "%s", repl
        replaced = 1
      }
      skipping = 1
      next
    }
    skipping && /^## / {
      skipping = 0
    }
    !skipping {
      print
    }
    END {
      if (!replaced) {
        print ""
        printf "%s", repl
      }
    }
  ' "$agents_path" > "$tmp_agents"
  mv "$tmp_agents" "$agents_path"
else
  cp "$guidance_file" "$agents_path"
fi
rm -f "$guidance_file"

echo "Installed Codex Sound Cues for macOS."
if [ -d "$pet_source" ]; then
  echo "Installed Magic Deer animated pet to $pet_destination"
fi

installed_sound_script="$script_dir/codex-sound.sh"
if [ -f "$installed_sound_script" ]; then
  echo "Playing Magic Deer install greeting..."
  bash "$installed_sound_script" greeting-install || true
fi

echo "Backup stamp: $stamp"
echo "Test with: bash \"$script_dir/codex-sound.sh\" test"
