$ErrorActionPreference = "Stop"

$skillRoot = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$localScript = Join-Path $skillRoot "scripts\codex-sound.ps1"
$installedScript = Join-Path $HOME ".codex\scripts\codex-sound.ps1"

if (Test-Path -LiteralPath $installedScript) {
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $installedScript test
} else {
  $tempSoundDir = Join-Path $HOME ".codex\sounds"
  New-Item -ItemType Directory -Force -Path $tempSoundDir | Out-Null
  Copy-Item -Path (Join-Path $skillRoot "assets\*.wav") -Destination $tempSoundDir -Force
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $localScript test
}
