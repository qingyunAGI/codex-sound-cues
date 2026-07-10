param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$NotifyArgs
)

$ErrorActionPreference = "SilentlyContinue"

$soundScript = Join-Path $PSScriptRoot "codex-sound.ps1"
if (Test-Path -LiteralPath $soundScript) {
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $soundScript complete
}

$originalNotifier = Join-Path $PSScriptRoot "codex-notify-original.ps1"
if (Test-Path -LiteralPath $originalNotifier) {
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $originalNotifier @NotifyArgs
}
