$ErrorActionPreference = "Stop"

$skillRoot = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$codexRoot = Join-Path $HOME ".codex"
$scriptDir = Join-Path $codexRoot "scripts"
$soundDir = Join-Path $codexRoot "sounds"
$petRoot = Join-Path $codexRoot "pets"
$petSource = Join-Path $skillRoot "assets\pets\magic-deer"
$petDestination = Join-Path $petRoot "magic-deer"
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"

New-Item -ItemType Directory -Force -Path $scriptDir, $soundDir, $petRoot | Out-Null

$configPath = Join-Path $codexRoot "config.toml"
$agentsPath = Join-Path $codexRoot "AGENTS.md"

if (Test-Path -LiteralPath $configPath) {
  Copy-Item -LiteralPath $configPath -Destination "$configPath.bak-codex-sound-cues-$stamp" -Force
}
if (Test-Path -LiteralPath $agentsPath) {
  Copy-Item -LiteralPath $agentsPath -Destination "$agentsPath.bak-codex-sound-cues-$stamp" -Force
}

Copy-Item -LiteralPath (Join-Path $skillRoot "scripts\*.ps1") -Destination $scriptDir -Force
Copy-Item -LiteralPath (Join-Path $skillRoot "assets\*.wav") -Destination $soundDir -Force

if (Test-Path -LiteralPath $petSource) {
  if (Test-Path -LiteralPath $petDestination) {
    Copy-Item -LiteralPath $petDestination -Destination "$petDestination.bak-codex-sound-cues-$stamp" -Recurse -Force
  }
  New-Item -ItemType Directory -Force -Path $petDestination | Out-Null
  Copy-Item -Path (Join-Path $petSource "*") -Destination $petDestination -Recurse -Force
}

$previousNotify = $null
if (Test-Path -LiteralPath $configPath) {
  $configText = Get-Content -LiteralPath $configPath -Raw -Encoding UTF8
  $match = [regex]::Match($configText, '(?m)^notify\s*=\s*(\[[^\r\n]*\])\s*$')
  if ($match.Success) { $previousNotify = $match.Groups[1].Value }
}

$originalScript = Join-Path $scriptDir "codex-notify-original.ps1"
if ($previousNotify) {
  $items = @()
  foreach ($m in [regex]::Matches($previousNotify, '"((?:\\.|[^"\\])*)"')) {
    $items += ($m.Groups[1].Value -replace '\\"','"' -replace '\\\\','\')
  }

  if ($items.Count -gt 0 -and $items[0] -notmatch 'codex-notify-wrapper\.ps1') {
    $exe = $items[0].Replace("'", "''")
    $argsLiteral = (($items | Select-Object -Skip 1) | ForEach-Object { "'" + ($_.Replace("'", "''")) + "'" }) -join ", "
    @"
param(
  [Parameter(ValueFromRemainingArguments = `$true)]
  [string[]]`$NotifyArgs
)

`$ErrorActionPreference = "SilentlyContinue"
`$original = '$exe'
`$originalArgs = @($argsLiteral)
if (Test-Path -LiteralPath `$original) {
  & `$original @originalArgs
}
"@ | Set-Content -LiteralPath $originalScript -Encoding UTF8
  }
}

$wrapperPath = (Join-Path $scriptDir "codex-notify-wrapper.ps1").Replace('\', '\\')
$newNotify = 'notify = [ "powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "' + $wrapperPath + '", "turn-ended" ]'

if (Test-Path -LiteralPath $configPath) {
  $configText = Get-Content -LiteralPath $configPath -Raw -Encoding UTF8
  if ($configText -match '(?m)^notify\s*=') {
    $configText = [regex]::Replace($configText, '(?m)^notify\s*=.*$', $newNotify, 1)
  } else {
    $configText = $newNotify + [Environment]::NewLine + $configText
  }
  Set-Content -LiteralPath $configPath -Value $configText -Encoding UTF8
} else {
  Set-Content -LiteralPath $configPath -Value ($newNotify + [Environment]::NewLine) -Encoding UTF8
}

$guidance = @"

## Codex Sound Cues

- For substantial work, run `powershell.exe -NoProfile -ExecutionPolicy Bypass -File $HOME\.codex\scripts\codex-sound.ps1 work` when starting active processing.
- Before asking the user to make a decision, run `powershell.exe -NoProfile -ExecutionPolicy Bypass -File $HOME\.codex\scripts\codex-sound.ps1 decision`.
- For pet click integrations, run `powershell.exe -NoProfile -ExecutionPolicy Bypass -File $HOME\.codex\scripts\codex-sound.ps1 pet`.
- The Magic Deer animated pet is installed in `$HOME\.codex\pets\magic-deer`; select it from Codex custom pets after restarting Codex.
- For optional long-sitting reminders, run `powershell.exe -NoProfile -ExecutionPolicy Bypass -File $HOME\.codex\scripts\start-sedentary-reminder.ps1 -Minutes 50`.
- Completion sound is handled by the configured Codex `notify` hook.
"@

if (Test-Path -LiteralPath $agentsPath) {
  $agentsText = Get-Content -LiteralPath $agentsPath -Raw -Encoding UTF8
  if ($agentsText -notmatch '## Codex Sound Cues') {
    Add-Content -LiteralPath $agentsPath -Value $guidance -Encoding UTF8
  }
} else {
  Set-Content -LiteralPath $agentsPath -Value $guidance.TrimStart() -Encoding UTF8
}

Write-Output "Installed Codex Sound Cues."
if (Test-Path -LiteralPath $petSource) {
  Write-Output "Installed Magic Deer animated pet to $petDestination"
}
Write-Output "Backup stamp: $stamp"
Write-Output "Test with: powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$scriptDir\codex-sound.ps1`" test"
