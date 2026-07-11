---
name: codex-sound-cues
description: Install and manage a Windows or macOS Codex companion system with distinct task status sounds, a Codex-compatible animated Magic Deer pet, character-aware pet-click cues, post-install greeting voices, first-session greeting behavior, and optional long-sitting reminder voice prompts. Use when the user wants different sounds for work states, an installable custom Codex pet, pet click sounds or optional web vibration behavior, install/open greetings, sedentary break reminders, shareable bilingual companion documentation, testing, cross-platform install commands, or reversible restore.
---

# Codex Sound Cues

## Overview

Install a Codex companion setup with seven audio states and an animated Magic Deer custom pet. Windows uses PowerShell and `System.Media.SoundPlayer`; macOS uses Bash and `afplay`.

Magic Deer is a starry Codex desk companion: a small deer wearing a moon-and-star wizard hat, a star-lit cape, and a star wand. Treat it as a character companion, not a generic sound pack.

- `work`: active processing. It calls `greeting-open` first, starts the hourly sedentary reminder loop if needed, then plays the short motorcycle start cue.
- `decision`: user decision needed, currently a two-knock cue.
- `complete`: task complete. Windows tries the local Codex notification sound and then a bundled fallback; macOS uses the bundled completion cue.
- `pet`: character-aware pet click cue. The current asset is a cute magic deer laugh with a small sparkling bell tail.
- `sedentary`: cute Chinese break reminder voice; randomly selects one of two Jianying/CapCut voiceover exports.
- `greeting-install`: post-install Magic Deer greeting; randomly selects one of two greeting voiceovers.
- `greeting-open`: first Codex work-session greeting after installation; always plays greeting voice 2 once, records local state, and is triggered before the first `work` cue.

Use bundled scripts instead of editing Codex config by hand.

## Install

One-link GitHub install:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/qingyunAGI/codex-sound-cues/main/install-from-github.ps1 | iex"
```

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/qingyunAGI/codex-sound-cues/main/install-from-github-macos.sh)"
```

Local install from the skill folder:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

```bash
bash ./scripts/install-macos.sh
```

The installer:

- Copies assets into `~/.codex/sounds`.
- Copies scripts into `~/.codex/scripts`.
- Copies the Magic Deer `pet.json` and `spritesheet.webp` into `~/.codex/pets/magic-deer` and backs up a same-named existing custom pet.
- Resets the first-session greeting marker and plays one random greeting voice at the end of installation.
- Backs up `~/.codex/config.toml` and `~/.codex/AGENTS.md`.
- Connects completion sound through the Codex `notify` hook.
- Adds global guidance so future Codex turns play `work` before substantial processing, `decision` before asking the user to choose, and `greeting-open` once at the beginning of the first work session after installation.

## Test

Play all cues once:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\test-sounds.ps1
```

```bash
bash "$HOME/.codex/scripts/codex-sound.sh" test
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

```bash
bash "$HOME/.codex/scripts/codex-sound.sh" work
bash "$HOME/.codex/scripts/codex-sound.sh" decision
bash "$HOME/.codex/scripts/codex-sound.sh" complete
bash "$HOME/.codex/scripts/codex-sound.sh" pet
bash "$HOME/.codex/scripts/codex-sound.sh" sedentary
bash "$HOME/.codex/scripts/codex-sound.sh" greeting-install
bash "$HOME/.codex/scripts/codex-sound.sh" greeting-open-force
```

## Pet Click And Vibration

For a local script integration, call:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" pet
```

```bash
bash "$HOME/.codex/scripts/codex-sound.sh" pet
```

For a web pet or canvas pet, trigger a short vibration where supported:

```js
petElement.addEventListener("click", () => {
  if ("vibrate" in navigator) navigator.vibrate([20, 30, 20]);
  new Audio("./assets/codex-pet-click-cute.wav").play();
});
```

Desktop apps generally do not have a universal vibration API. Treat vibration as a web/mobile enhancement and use the pet sound as the default desktop feedback.

## Long-Sitting Reminder

The `work` event automatically starts a local reminder loop, defaulting to 60 minutes. This creates random reminders after 1 hour, 2 hours, 3 hours, and every continued hour.

Start or stop it manually:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" sedentary-start
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" sedentary-stop
```

```bash
bash "$HOME/.codex/scripts/codex-sound.sh" sedentary-start
bash "$HOME/.codex/scripts/codex-sound.sh" sedentary-stop
```

## Greeting Voice

Play a random post-install greeting:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" greeting-install
```

```bash
bash "$HOME/.codex/scripts/codex-sound.sh" greeting-install
```

`greeting-open` uses `codex-greeting-cute-2.wav` and writes `~/.codex/state/codex-sound-cues/greeting-open-played.txt`. Use `greeting-open-force` only for testing because it does not write the marker.

## Restore

Run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\restore.ps1
```

```bash
bash "$HOME/.codex/scripts/restore-macos.sh"
```

The restore scripts pick the latest backup created by the installer and restore `config.toml`, `AGENTS.md`, and the previous same-named Magic Deer pet when a pet backup exists. They leave copied sound files in place so reinstalling remains quick.
