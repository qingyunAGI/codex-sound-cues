#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
installer="$repo_root/scripts/install-macos.sh"

if [ ! -f "$installer" ]; then
  echo "Installer not found: $installer" >&2
  exit 1
fi

bash "$installer"
