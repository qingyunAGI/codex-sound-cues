---
name: codex-sound-cues
description: Install and manage distinct local Codex task status sounds on Windows. Use when the user wants Codex to play different cues for active processing, decision requests, and task completion; package or share Codex sound notification behavior; test sound cues; or restore the previous Codex notification hook.
---

# Codex Sound Cues

## Overview

Install a Windows-only Codex sound cue setup with three states:

- `work`: active processing, currently a short motorcycle start cue.
- `decision`: user decision needed, currently a two-knock cue.
- `complete`: task complete, using the local Codex notification sound when available and a bundled fallback otherwise.

Use bundled scripts instead of editing Codex config by hand.

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
```

## Restore

Run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\restore.ps1
```

The restore script picks the latest backup created by `install.ps1` and restores `config.toml` and `AGENTS.md`. It leaves copied sound files in place so reinstalling remains quick.
