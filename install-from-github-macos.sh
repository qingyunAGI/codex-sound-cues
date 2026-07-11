#!/usr/bin/env bash
set -euo pipefail

repo_zip_url="https://github.com/qingyunAGI/codex-sound-cues/archive/refs/heads/main.zip"
work_root="$(mktemp -d "${TMPDIR:-/tmp}/codex-sound-cues.XXXXXX")"
zip_path="$work_root/codex-sound-cues.zip"
extract_root="$work_root/extract"

cleanup() {
  rm -rf "$work_root"
}
trap cleanup EXIT

mkdir -p "$extract_root"

echo "Downloading Magic Deer Codex Companion..."
curl -L --fail --show-error "$repo_zip_url" -o "$zip_path"

echo "Extracting installer..."
unzip -q "$zip_path" -d "$extract_root"

repo_root="$(find "$extract_root" -maxdepth 1 -type d -name 'codex-sound-cues-*' | head -n 1)"
if [ -z "${repo_root:-}" ] || [ ! -d "$repo_root" ]; then
  echo "Downloaded archive did not contain codex-sound-cues." >&2
  exit 1
fi

installer="$repo_root/scripts/install-macos.sh"
if [ ! -f "$installer" ]; then
  echo "Installer not found in downloaded archive: $installer" >&2
  exit 1
fi

echo "Installing Magic Deer Codex Companion..."
bash "$installer"

echo "Done. Restart Codex and select the Magic Deer custom pet if needed."
