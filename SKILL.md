---
name: codex-sound-cues
description: Install and manage distinct local Codex task status sounds on Windows, including active processing, decision requests, task completion, and cute pet-click cues. Use when the user wants Codex to play different sounds for work states, add a pet click sound or optional web vibration behavior, package or share Codex notification behavior, test sound cues, or restore the previous Codex notification hook.
---

# Codex Sound Cues

## Overview

Install a Windows-only Codex sound cue setup with four states:

- `work`: active processing, currently a short motorcycle start cue.
- `decision`: user decision needed, currently a two-knock cue.
- `complete`: task complete, using the local Codex notification sound when available and a bundled fallback otherwise.
- `pet`: cute pet click cue for desktop pet or web pet integrations.

Use bundled scripts instead of editing Codex config by hand.

## Features

- Use different sounds for different task states so the user can recognize Codex state without looking at the screen.
- Preserve the existing Codex completion notification by wrapping the previous `notify` hook instead of deleting it.
- Avoid redistributing the built-in Codex notification sound; call the local installed sound when available and fall back to a bundled synthetic cue.
- Include a pet click cue that can be wired into a desktop pet, tray widget, browser pet, or canvas pet.
- Keep changes reversible through timestamped backups and `scripts/restore.ps1`.

## Pet Click And Vibration

For a local script integration, call:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" pet
```

For a web pet or canvas pet, trigger a short vibration where supported:

```js
petElement.addEventListener("click", () => {
  if ("vibrate" in navigator) navigator.vibrate([20, 30, 20]);
  new Audio("./assets/codex-pet-click-cute.wav").play();
});
```

Windows desktop apps generally do not have a universal vibration API. Treat vibration as a web/mobile enhancement and use the pet sound as the default desktop feedback.

## Install

From the skill folder:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

The installer:

- Copies assets into `$HOME\.codex\sounds`.
- Copies scripts into `$HOME\.codex\scripts`.
- Backs up `$HOME\.codex\config.toml` and `$HOME\.codex\AGENTS.md`.
- Replaces the Codex `notify` hook with a wrapper that plays completion sound and then calls the previous notifier when possible.
- Adds global guidance so future Codex turns play `work` before substantial processing and `decision` before asking the user to choose.

## Test

Play all cues once:

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

## Restore

Run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\restore.ps1
```

The restore script picks the latest backup created by `install.ps1` and restores `config.toml` and `AGENTS.md`. It leaves copied sound files in place so reinstalling remains quick.
