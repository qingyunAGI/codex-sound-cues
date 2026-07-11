param(
  [ValidateSet("work", "work-cue", "decision", "complete", "pet", "sedentary", "sedentary-start", "sedentary-stop", "greeting-install", "greeting-open", "greeting-open-force", "test")]
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

function Invoke-CodexRandomWav {
  param([string[]]$Paths)
  $available = @($Paths | Where-Object { Test-Path -LiteralPath $_ })
  if ($available.Count -eq 0) { return $false }
  $selected = Get-Random -InputObject $available
  return (Invoke-CodexWav $selected)
}

function Invoke-CodexGreetingFallback {
  Invoke-CodexBeep 988 90
  Start-Sleep -Milliseconds 65
  Invoke-CodexBeep 1319 120
  Start-Sleep -Milliseconds 65
  Invoke-CodexBeep 1568 180
}

$codexRoot = Join-Path $HOME ".codex"
$soundRoot = Join-Path $codexRoot "sounds"
$stateRoot = Join-Path $codexRoot "state\codex-sound-cues"
$sedentaryReminderPidPath = Join-Path $stateRoot "sedentary-reminder.pid"
$workWav = Join-Path $soundRoot "codex-work-motorcycle-start.wav"
$decisionWav = Join-Path $soundRoot "codex-decision-door-knock.wav"
$completeFallbackWav = Join-Path $soundRoot "codex-complete-fallback.wav"
$petWav = Join-Path $soundRoot "codex-pet-click-cute.wav"
$sedentaryWavs = @(
  (Join-Path $soundRoot "codex-sedentary-cute-1.wav"),
  (Join-Path $soundRoot "codex-sedentary-cute-2.wav")
)
$greetingWavs = @(
  (Join-Path $soundRoot "codex-greeting-cute-1.wav"),
  (Join-Path $soundRoot "codex-greeting-cute-2.wav")
)
$localCodexWav = "C:\Program Files\WindowsApps\OpenAI.Codex_26.707.3748.0_x64__2p2nqsd0c76g0\app\resources\codex-notification.wav"

function Test-CodexProcessAlive {
  param([int]$ProcessId)
  try {
    Get-Process -Id $ProcessId -ErrorAction Stop | Out-Null
    return $true
  } catch {
    return $false
  }
}

function Start-CodexSedentaryReminder {
  New-Item -ItemType Directory -Force -Path $stateRoot | Out-Null
  if (Test-Path -LiteralPath $sedentaryReminderPidPath) {
    $pidText = Get-Content -LiteralPath $sedentaryReminderPidPath -Raw
    $existingPid = 0
    if ([int]::TryParse($pidText.Trim(), [ref]$existingPid) -and (Test-CodexProcessAlive $existingPid)) {
      return
    }
  }

  $reminderScript = Join-Path $PSScriptRoot "start-sedentary-reminder.ps1"
  if (-not (Test-Path -LiteralPath $reminderScript)) { return }

  $process = Start-Process -FilePath "powershell.exe" `
    -ArgumentList @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $reminderScript, "-Minutes", "60") `
    -WindowStyle Hidden `
    -PassThru
  if ($process -and $process.Id) {
    Set-Content -LiteralPath $sedentaryReminderPidPath -Value $process.Id -Encoding ASCII
  }
}

function Stop-CodexSedentaryReminder {
  if (-not (Test-Path -LiteralPath $sedentaryReminderPidPath)) { return }
  $pidText = Get-Content -LiteralPath $sedentaryReminderPidPath -Raw
  $existingPid = 0
  if ([int]::TryParse($pidText.Trim(), [ref]$existingPid) -and (Test-CodexProcessAlive $existingPid)) {
    Stop-Process -Id $existingPid -Force
  }
  Remove-Item -LiteralPath $sedentaryReminderPidPath -Force
}

switch ($Event) {
  "work" {
    & $PSCommandPath greeting-open
    Start-CodexSedentaryReminder
    & $PSCommandPath work-cue
  }
  "work-cue" {
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
  "pet" {
    $played = Invoke-CodexWav $petWav
    if (-not $played) {
      Invoke-CodexBeep 1046 90
      Start-Sleep -Milliseconds 60
      Invoke-CodexBeep 1397 150
    }
  }
  "sedentary" {
    $played = Invoke-CodexRandomWav $sedentaryWavs
    if (-not $played) {
      Invoke-CodexBeep 1046 100
      Start-Sleep -Milliseconds 80
      Invoke-CodexBeep 1319 120
      Start-Sleep -Milliseconds 80
      Invoke-CodexBeep 1046 180
    }
  }
  "greeting-install" {
    $played = Invoke-CodexRandomWav $greetingWavs
    if (-not $played) { Invoke-CodexGreetingFallback }
  }
  "greeting-open" {
    New-Item -ItemType Directory -Force -Path $stateRoot | Out-Null
    $marker = Join-Path $stateRoot "greeting-open-played.txt"
    if (Test-Path -LiteralPath $marker) { return }

    $played = Invoke-CodexWav $greetingWavs[1]
    if (-not $played) { Invoke-CodexGreetingFallback }
    Set-Content -LiteralPath $marker -Value (Get-Date -Format "yyyy-MM-dd HH:mm:ss") -Encoding ASCII
  }
  "greeting-open-force" {
    $played = Invoke-CodexWav $greetingWavs[1]
    if (-not $played) { Invoke-CodexGreetingFallback }
  }
  "sedentary-start" {
    Start-CodexSedentaryReminder
  }
  "sedentary-stop" {
    Stop-CodexSedentaryReminder
  }
  "test" {
    & $PSCommandPath greeting-install
    Start-Sleep -Milliseconds 650
    & $PSCommandPath greeting-open-force
    Start-Sleep -Milliseconds 650
    & $PSCommandPath work-cue
    Start-Sleep -Milliseconds 650
    & $PSCommandPath decision
    Start-Sleep -Milliseconds 650
    & $PSCommandPath complete
    Start-Sleep -Milliseconds 650
    & $PSCommandPath pet
    Start-Sleep -Milliseconds 650
    & $PSCommandPath sedentary
  }
}
