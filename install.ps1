$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSCommandPath
$installer = Join-Path $repoRoot "scripts\install.ps1"

if (-not (Test-Path -LiteralPath $installer)) {
  throw "Installer not found: $installer"
}

& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $installer
