param(
  [ValidateRange(5, 240)]
  [int]$Minutes = 50,
  [switch]$Once
)

$ErrorActionPreference = "Stop"

$soundScript = Join-Path $HOME ".codex\scripts\codex-sound.ps1"
if (-not (Test-Path -LiteralPath $soundScript)) {
  $soundScript = Join-Path (Split-Path -Parent $PSCommandPath) "codex-sound.ps1"
}

if (-not (Test-Path -LiteralPath $soundScript)) {
  throw "codex-sound.ps1 was not found. Install the skill first or run from the skill scripts folder."
}

do {
  Start-Sleep -Seconds ($Minutes * 60)
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $soundScript sedentary
} while (-not $Once)
