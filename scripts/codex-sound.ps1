param(
  [ValidateSet("work", "decision", "complete", "test")]
  [string]$Event = "complete"
)

$ErrorActionPreference = "SilentlyContinue"

function Invoke-CodexBeep {
  param([int]$Frequency, [int]$DurationMs)
  try { [Console]::Beep($Frequency, $DurationMs) } catch {}
}

function Invoke-CodexWav {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) { return $false }
  try {
    $player = New-Object System.Media.SoundPlayer $Path
    $player.Load()
    $player.PlaySync()
    return $true
  } catch {
    return $false
  }
}

$codexRoot = Join-Path $HOME ".codex"
$soundRoot = Join-Path $codexRoot "sounds"
$workWav = Join-Path $soundRoot "codex-work-motorcycle-start.wav"
$decisionWav = Join-Path $soundRoot "codex-decision-door-knock.wav"
$completeFallbackWav = Join-Path $soundRoot "codex-complete-fallback.wav"
$localCodexWav = "C:\Program Files\WindowsApps\OpenAI.Codex_26.707.3748.0_x64__2p2nqsd0c76g0\app\resources\codex-notification.wav"

switch ($Event) {
  "work" {
    $played = Invoke-CodexWav $workWav
    if (-not $played) {
      Invoke-CodexBeep 155 180
      Start-Sleep -Milliseconds 80
      Invoke-CodexBeep 220 260
    }
  }
  "decision" {
    $played = Invoke-CodexWav $decisionWav
    if (-not $played) {
      Invoke-CodexBeep 155 120
      Start-Sleep -Milliseconds 260
      Invoke-CodexBeep 155 140
    }
  }
  "complete" {
    $played = Invoke-CodexWav $localCodexWav
    if (-not $played) { $played = Invoke-CodexWav $completeFallbackWav }
    if (-not $played) {
      Invoke-CodexBeep 659 90
      Start-Sleep -Milliseconds 55
      Invoke-CodexBeep 784 90
      Start-Sleep -Milliseconds 55
      Invoke-CodexBeep 1046 160
    }
  }
  "test" {
    & $PSCommandPath work
    Start-Sleep -Milliseconds 650
    & $PSCommandPath decision
    Start-Sleep -Milliseconds 650
    & $PSCommandPath complete
  }
}
