$ErrorActionPreference = "Stop"

$repoZipUrl = "https://github.com/qingyunAGI/codex-sound-cues/archive/refs/heads/main.zip"
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$workRoot = Join-Path $env:TEMP "codex-sound-cues-$stamp"
$zipPath = Join-Path $workRoot "codex-sound-cues.zip"
$extractRoot = Join-Path $workRoot "extract"

New-Item -ItemType Directory -Force -Path $workRoot, $extractRoot | Out-Null

Write-Output "Downloading Magic Deer Codex Companion..."
Invoke-WebRequest -Uri $repoZipUrl -OutFile $zipPath -UseBasicParsing

Write-Output "Extracting installer..."
Expand-Archive -LiteralPath $zipPath -DestinationPath $extractRoot -Force

$repoRoot = Get-ChildItem -LiteralPath $extractRoot -Directory |
  Where-Object { $_.Name -like "codex-sound-cues-*" } |
  Select-Object -First 1

if (-not $repoRoot) {
  throw "Downloaded archive did not contain codex-sound-cues."
}

$installer = Join-Path $repoRoot.FullName "scripts\install.ps1"
if (-not (Test-Path -LiteralPath $installer)) {
  throw "Installer not found in downloaded archive: $installer"
}

Write-Output "Installing Magic Deer Codex Companion..."
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $installer

Write-Output "Done. Restart Codex and select the Magic Deer custom pet if needed."
