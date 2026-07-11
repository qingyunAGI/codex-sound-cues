---
name: codex-sound-cues
description: Install and manage a Windows Codex companion system with distinct task status sounds, a Codex-compatible animated Magic Deer pet, character-aware pet-click cues, post-install greeting voices, first-session greeting behavior, and optional long-sitting reminder voice prompts. Use when the user wants different sounds for work states, an installable custom Codex pet, pet click sounds or optional web vibration behavior, install/open greetings, sedentary break reminders, shareable bilingual companion documentation, testing, or reversible restore.
---

# Codex Sound Cues

## Overview

Install a Windows Codex companion setup with seven audio states and an animated Magic Deer custom pet.

Magic Deer is a starry Codex desk companion: a small deer wearing a moon-and-star wizard hat, a star-lit cape, and a star wand. Treat it as a character companion, not a generic sound pack. Its sounds should make Codex work feel more recognizable, gentle, and accompanied.

- `work`: active processing, currently a short motorcycle start cue.
- `decision`: user decision needed, currently a two-knock cue.
- `complete`: task complete, using the local Codex notification sound when available and a bundled fallback otherwise.
- `pet`: character-aware pet click cue. The current asset is a cute magic deer laugh with a small sparkling bell tail.
- `sedentary`: cute Chinese break reminder voice for long Codex work sessions; randomly selects one of two Jianying/CapCut voiceover exports.
- `greeting-install`: post-install Magic Deer greeting; randomly selects one of two greeting voiceovers.
- `greeting-open`: first Codex work-session greeting after installation; always plays greeting voice 2 once and records local state.

Use bundled scripts instead of editing Codex config by hand.

## Features

- Use different sounds for different task states so the user can recognize Codex state without looking at the screen.
- Preserve the existing Codex completion notification by wrapping the previous `notify` hook instead of deleting it.
- Avoid redistributing the built-in Codex notification sound; call the local installed sound when available and fall back to a bundled synthetic cue.
- Include a pet click cue that can be wired into a desktop pet, tray widget, browser pet, or canvas pet.
- Install the Codex-compatible Magic Deer package from `assets/pets/magic-deer/` into `$HOME\.codex\pets\magic-deer`.
- Keep pet sounds aligned to the pet character state. For a magic deer, prefer gentle laughter, soft chimes, and light magical sparkle instead of generic UI beeps.
- Include optional long-sitting reminder voice prompts. Keep the two Jianying/CapCut source MP3 files in `assets/voice-sources/` and use converted WAV files for reliable playback.
- Include post-install greeting voice prompts. Keep the two Jianying/CapCut greeting source MP3 files in `assets/voice-sources/` and use converted WAV files for reliable playback.
- Play `greeting-install` at the end of `scripts/install.ps1`. Reset the `greeting-open` marker during installation so the next Codex work session can play greeting voice 2 once.
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

## Greeting Voice

Play a random post-install greeting:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" greeting-install
```

Play the first-session greeting after installation:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" greeting-open
```

`greeting-open` uses `codex-greeting-cute-2.wav` and writes `$HOME\.codex\state\codex-sound-cues\greeting-open-played.txt`. Use `greeting-open-force` only for testing because it does not write the marker.

## Install

From the skill folder:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

The installer:

- Copies assets into `$HOME\.codex\sounds`.
- Copies scripts into `$HOME\.codex\scripts`.
- Copies the Magic Deer `pet.json` and `spritesheet.webp` into `$HOME\.codex\pets\magic-deer` and backs up a same-named existing custom pet.
- Resets the first-session greeting marker and plays one random greeting voice at the end of installation.
- Backs up `$HOME\.codex\config.toml` and `$HOME\.codex\AGENTS.md`.
- Replaces the Codex `notify` hook with a wrapper that plays completion sound and then calls the previous notifier when possible.
- Adds global guidance so future Codex turns play `work` before substantial processing, `decision` before asking the user to choose, and `greeting-open` once at the beginning of the first work session after installation.

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
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" greeting-install
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" greeting-open-force
```

## Restore

Run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\restore.ps1
```

The restore script picks the latest backup created by `install.ps1` and restores `config.toml` and `AGENTS.md`. It leaves copied sound files in place so reinstalling remains quick.
