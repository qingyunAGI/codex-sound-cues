---
name: codex-sound-cues
description: Install and manage distinct local Codex task status sounds on Windows, including active processing, decision requests, task completion, character-aware pet-click cues such as a cute magic deer laugh, and optional long-sitting reminder voice prompts. Use when the user wants Codex to play different sounds for work states, add pet click sound or optional web vibration behavior, add a sedentary break reminder voice, package or share Codex notification behavior, write bilingual Chinese-English skill documentation, test sound cues, or restore the previous Codex notification hook.
---

# Codex Sound Cues

## Overview

Install a Windows-only Codex sound cue setup with four states:

- `work`: active processing, currently a short motorcycle start cue.
- `decision`: user decision needed, currently a two-knock cue.
- `complete`: task complete, using the local Codex notification sound when available and a bundled fallback otherwise.
- `pet`: character-aware pet click cue. The current asset is a cute magic deer laugh with a small sparkling bell tail.
- `sedentary`: cute Chinese break reminder voice for long Codex work sessions; randomly selects one of two Jianying/CapCut voiceover exports.

Use bundled scripts instead of editing Codex config by hand.

## Features

- Use different sounds for different task states so the user can recognize Codex state without looking at the screen.
- Preserve the existing Codex completion notification by wrapping the previous `notify` hook instead of deleting it.
- Avoid redistributing the built-in Codex notification sound; call the local installed sound when available and fall back to a bundled synthetic cue.
- Include a pet click cue that can be wired into a desktop pet, tray widget, browser pet, or canvas pet.
- Keep pet sounds aligned to the pet character state. For a magic deer, prefer gentle laughter, soft chimes, and light magical sparkle instead of generic UI beeps.
- Include optional long-sitting reminder voice prompts. Keep the two Jianying/CapCut source MP3 files in `assets/voice-sources/` and use converted WAV files for reliable playback.
- Keep public documentation bilingual when sharing the skill: Chinese and English sections should sit in the same README with clear language switch links.
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

If the pet later has multiple states, create separate event sounds rather than reusing `pet` for every interaction. Good candidates: `pet-happy`, `pet-sleepy`, `pet-shy`, `pet-cast`, and `pet-alert`.

## Long-Sitting Reminder

Play a randomly selected cute Chinese reminder directly:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" sedentary
```

Start an optional local reminder loop, defaulting to 50 minutes:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\start-sedentary-reminder.ps1" -Minutes 50
```

Do not start the loop silently. Ask or tell the user before running a long-lived reminder process.

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
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" sedentary
```

## Restore

Run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\restore.ps1
```

The restore script picks the latest backup created by `install.ps1` and restores `config.toml` and `AGENTS.md`. It leaves copied sound files in place so reinstalling remains quick.
