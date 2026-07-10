# Codex Sound Cues

`codex-sound-cues` is a shareable Codex skill for adding clear, distinct sound feedback to Codex on Windows.

It gives Codex different cues for different states:

- `work`: Codex is actively processing. Current sound: a short motorcycle start cue.
- `decision`: Codex needs the user to make a choice. Current sound: a gentle two-knock cue.
- `complete`: Codex has finished a task. It uses the locally installed Codex notification sound when available, with a bundled fallback sound when it is not.
- `pet`: a cute pet-click cue for desktop pet, browser pet, or canvas pet integrations.

## Key Features

- Distinct task-state sounds so the user can understand what Codex is doing without watching the screen.
- Reversible installation with timestamped backups of `config.toml` and `AGENTS.md`.
- Safe completion notification wrapping: the installer preserves the previous Codex `notify` command and calls it after playing the completion cue.
- No redistribution of the built-in Codex notification sound. The skill calls the local installed sound when present and ships only custom fallback assets.
- Pet interaction support through a cute click sound and optional Web Vibration API snippet.
- Windows-first PowerShell scripts with simple install, test, and restore commands.

## Install

From the skill folder:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

## Test

Play every cue:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\test-sounds.ps1
```

Play one installed cue:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" work
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" decision
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" complete
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" pet
```

## Pet Click And Vibration

For desktop or local integrations, call the `pet` event:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" pet
```

For a browser or canvas pet, add a click handler like this:

```js
petElement.addEventListener("click", () => {
  if ("vibrate" in navigator) navigator.vibrate([20, 30, 20]);
  new Audio("./assets/codex-pet-click-cute.wav").play();
});
```

Vibration depends on the runtime and hardware. Most Windows desktop apps do not expose a universal vibration API, so sound is the reliable default feedback.

## Restore

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\restore.ps1
```

The restore script restores the latest backups created by the installer. Copied sound files remain in `$HOME\.codex\sounds` so reinstalling stays quick.
