$ErrorActionPreference = "Stop"

$codexRoot = Join-Path $HOME ".codex"
$configPath = Join-Path $codexRoot "config.toml"
$agentsPath = Join-Path $codexRoot "AGENTS.md"
$petRoot = Join-Path $codexRoot "pets"
$petDestination = Join-Path $petRoot "magic-deer"

$configBackup = Get-ChildItem -LiteralPath $codexRoot -Filter "config.toml.bak-codex-sound-cues-*" -ErrorAction SilentlyContinue |
  Sort-Object LastWriteTime -Descending |
  Select-Object -First 1
$agentsBackup = Get-ChildItem -LiteralPath $codexRoot -Filter "AGENTS.md.bak-codex-sound-cues-*" -ErrorAction SilentlyContinue |
  Sort-Object LastWriteTime -Descending |
  Select-Object -First 1

if ($configBackup) {
  Copy-Item -LiteralPath $configBackup.FullName -Destination $configPath -Force
  Write-Output "Restored config.toml from $($configBackup.Name)"
} else {
  Write-Output "No config.toml backup found."
}

if ($agentsBackup) {
  Copy-Item -LiteralPath $agentsBackup.FullName -Destination $agentsPath -Force
  Write-Output "Restored AGENTS.md from $($agentsBackup.Name)"
} else {
  Write-Output "No AGENTS.md backup found."
}

$petBackup = Get-ChildItem -LiteralPath $petRoot -Filter "magic-deer.bak-codex-sound-cues-*" -Directory -ErrorAction SilentlyContinue |
  Sort-Object LastWriteTime -Descending |
  Select-Object -First 1
if ($petBackup) {
  if (Test-Path -LiteralPath $petDestination) {
    Remove-Item -LiteralPath $petDestination -Recurse -Force
  }
  Copy-Item -LiteralPath $petBackup.FullName -Destination $petDestination -Recurse -Force
  Write-Output "Restored Magic Deer pet from $($petBackup.Name)"
} else {
  Write-Output "No previous Magic Deer pet backup found; the installed pet is left in place."
}
