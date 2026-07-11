# Codex Sound Cues / Codex 状态提示音

[中文说明](#中文说明) | [English](#english)

![魔法小鹿 Codex 伴侣展示海报](./assets/poster/magic-deer-companion-poster.png)

## 一键安装 / One-Link Install

这个仓库包含完整的魔法小鹿 Codex 伴侣系统：动态宠物、状态提示音、点击互动音、安装问候音、首次工作问候音和久坐提醒语音。

动态宠物安装包在这里：

- `assets/pets/magic-deer/pet.json`
- `assets/pets/magic-deer/spritesheet.webp`

### Windows PowerShell

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/qingyunAGI/codex-sound-cues/main/install-from-github.ps1 | iex"
```

### macOS Terminal

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/qingyunAGI/codex-sound-cues/main/install-from-github-macos.sh)"
```

安装后重启 Codex，并在自定义宠物里选择“魔法小鹿 / Magic Deer”。安装器会复制动态宠物到 `~/.codex/pets/magic-deer`，复制提示音到 `~/.codex/sounds`，并接入 Codex 的完成通知、工作提示和首次问候逻辑。

---

## 中文说明

`codex-sound-cues` 是一个可分享的 Codex skill，用来给 Codex 和桌面宠物交互增加清晰、可辨识、可回滚的声音反馈。

## 魔法小鹿 Codex Pet

魔法小鹿是一只给 Codex 使用的星月小鹿宠物。

它戴着蓝紫色的星月魔法帽，披着小小的星光披风，手里拿着星星法杖。它像刚从夜空边缘跑下来，也像一个悄悄守在桌边的小助手，陪你写代码、整理想法、等待任务跑完。

AI 工具越来越多以后，工作很容易变成一串提示、等待和切换。魔法小鹿的设计目标，是让不同 Codex 状态有不同性格：

- `work`：Codex 正在处理任务。安装后的第一次工作会话会先播放第 2 条小鹿问候，再播放短促的轻踩油门启动声，并自动启动久坐提醒循环。
- `decision`：Codex 需要用户做决策。当前声音是两下轻敲门，像秘书提醒你看一眼。
- `complete`：Codex 已完成任务。Windows 会优先尝试本机 Codex 通知音，macOS 使用仓库内完成音。
- `pet`：宠物点击互动。当前声音是贴合“魔法小鹿”的可爱轻笑，带一点闪光铃声尾巴。
- `sedentary`：久坐提醒语音。连续工作 1 小时、2 小时、3 小时以及之后每小时，随机播放一条小鹿休息提醒。
- `greeting-install`：安装完成后播放的问候音，随机使用两条问候配音之一。
- `greeting-open`：安装后的第一次 Codex 工作会话问候，固定使用第 2 条问候配音，只播放一次。

### 特点

- **跨平台安装**：支持 Windows PowerShell 和 macOS Terminal。
- **状态清晰**：不同声音对应不同工作状态，不用一直盯着屏幕。
- **角色一致**：宠物点击音不是普通按钮音，而是贴合魔法小鹿形象的反馈。
- **完整动态宠物**：仓库包含可直接安装的 Magic Deer Codex 动态宠物包。
- **久坐提醒**：`work` 会自动启动小时级提醒循环，帮助长时间伏案工作的用户休息一下。
- **安装问候**：安装完成后随机问候；第一次进入 Codex 工作会话时再用第 2 条声音问候一次。
- **安全可回滚**：安装器会备份 `~/.codex/config.toml`、`~/.codex/AGENTS.md` 和已有同名宠物。
- **不打包 Codex 内置音频**：仓库不重新分发 Codex 自带通知音。

### 本地安装

Windows：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

macOS：

```bash
bash ./scripts/install-macos.sh
```

安装器会：

- 复制音频资源到 `~/.codex/sounds`
- 复制脚本到 `~/.codex/scripts`
- 复制动态宠物到 `~/.codex/pets/magic-deer`
- 重置首次会话问候标记
- 备份 Codex 配置和全局说明文件
- 接入 Codex 的 `notify` 钩子
- 安装完成时播放一条魔法小鹿问候音

### 测试

Windows 播放全部提示音：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\test-sounds.ps1
```

macOS 播放全部提示音：

```bash
bash "$HOME/.codex/scripts/codex-sound.sh" test
```

macOS 单独播放某一种：

```bash
bash "$HOME/.codex/scripts/codex-sound.sh" work
bash "$HOME/.codex/scripts/codex-sound.sh" decision
bash "$HOME/.codex/scripts/codex-sound.sh" complete
bash "$HOME/.codex/scripts/codex-sound.sh" pet
bash "$HOME/.codex/scripts/codex-sound.sh" sedentary
bash "$HOME/.codex/scripts/codex-sound.sh" greeting-install
bash "$HOME/.codex/scripts/codex-sound.sh" greeting-open
```

停止自动久坐提醒：

```bash
bash "$HOME/.codex/scripts/codex-sound.sh" sedentary-stop
```

### 宠物点击与震动

当前共享的动态宠物角色：

![魔法小鹿 Codex 宠物](./assets/pets/magic-deer-codex-pet/magic-deer-codex-pet.png)

- 可安装包：`assets/pets/magic-deer/pet.json` 和 `assets/pets/magic-deer/spritesheet.webp`
- 动态状态：待机、挥手、跳跃、等待、专注、左右奔跑、失败反馈
- 点击反馈：桌面端调用 `pet` 声音；网页或 Canvas 宠物可同时使用 Web Vibration API

浏览器宠物或 Canvas 宠物可以这样接入点击反馈：

```js
petElement.addEventListener("click", () => {
  if ("vibrate" in navigator) navigator.vibrate([20, 30, 20]);
  new Audio("./assets/codex-pet-click-cute.wav").play();
});
```

### 恢复

Windows：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\restore.ps1
```

macOS：

```bash
bash "$HOME/.codex/scripts/restore-macos.sh"
```

恢复脚本会还原安装时生成的最新备份。复制到 `~/.codex/sounds` 的音频文件会保留，方便之后重新安装。

---

## English

`codex-sound-cues` is a shareable Codex skill that adds clear, recognizable, and reversible sound feedback to Codex and pet interactions.

## Magic Deer Codex Pet

Magic Deer is a starry little deer companion for Codex.

It wears a blue-purple moon-and-star wizard hat, a small star-lit cape, and carries a star wand. It is designed as a gentle desk companion for coding, thinking, waiting, and returning to finished Codex work.

The goal is not just to add more sounds. Each cue represents a different Codex state:

- `work`: active processing. On the first work session after installation, it plays Magic Deer greeting voice 2, then the short motorcycle start cue, then starts the hourly break-reminder loop.
- `decision`: user decision needed. Current sound: a gentle two-knock cue.
- `complete`: task complete. Windows tries the local Codex notification sound first; macOS uses the bundled completion cue.
- `pet`: character-aware pet click cue, tuned as a cute magic deer laugh with a soft sparkle tail.
- `sedentary`: long-sitting reminder voice, randomly selected after 1 hour, 2 hours, 3 hours, and every continued hour.
- `greeting-install`: post-install Magic Deer greeting, randomly selecting one of two greeting voices.
- `greeting-open`: first Codex work-session greeting after installation, always using greeting voice 2 and recording local state to avoid repeats.

### Features

- **Cross-platform install**: supports Windows PowerShell and macOS Terminal.
- **Clear states**: different sounds map to different Codex states.
- **Character-aware feedback**: the pet click sound is designed for a cute magical deer, not a generic button beep.
- **Complete animated pet**: includes an installable Magic Deer Codex pet package.
- **Break reminder**: `work` starts an hourly reminder loop for long desk sessions.
- **Install greeting**: Magic Deer greets the user after installation and once again on the first Codex work session.
- **Reversible setup**: installers back up `~/.codex/config.toml`, `~/.codex/AGENTS.md`, and any same-named existing Magic Deer pet.
- **No redistribution of built-in Codex audio**: the repository does not package the native Codex notification sound.

### Install

Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

macOS:

```bash
bash ./scripts/install-macos.sh
```

The installer:

- Copies audio assets into `~/.codex/sounds`
- Copies scripts into `~/.codex/scripts`
- Copies the animated pet into `~/.codex/pets/magic-deer`
- Resets the first-session greeting marker
- Backs up Codex config and global instruction files
- Connects completion sound through the Codex `notify` hook
- Plays one random Magic Deer greeting at the end

### Test

Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\test-sounds.ps1
```

macOS:

```bash
bash "$HOME/.codex/scripts/codex-sound.sh" test
```

Play one macOS cue:

```bash
bash "$HOME/.codex/scripts/codex-sound.sh" work
bash "$HOME/.codex/scripts/codex-sound.sh" decision
bash "$HOME/.codex/scripts/codex-sound.sh" complete
bash "$HOME/.codex/scripts/codex-sound.sh" pet
bash "$HOME/.codex/scripts/codex-sound.sh" sedentary
bash "$HOME/.codex/scripts/codex-sound.sh" greeting-install
bash "$HOME/.codex/scripts/codex-sound.sh" greeting-open
```

Stop the automatic reminder loop:

```bash
bash "$HOME/.codex/scripts/codex-sound.sh" sedentary-stop
```

### Pet Click And Vibration

Current shared animated pet:

![Magic Deer Codex Pet](./assets/pets/magic-deer-codex-pet/magic-deer-codex-pet.png)

- Installable package: `assets/pets/magic-deer/pet.json` and `assets/pets/magic-deer/spritesheet.webp`
- Animated states: idle, wave, jump, wait, review, both running directions, and failure feedback
- Interaction link: desktop integrations call the `pet` cue; web or canvas pets can also use the Web Vibration API

```js
petElement.addEventListener("click", () => {
  if ("vibrate" in navigator) navigator.vibrate([20, 30, 20]);
  new Audio("./assets/codex-pet-click-cute.wav").play();
});
```

### Restore

Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\restore.ps1
```

macOS:

```bash
bash "$HOME/.codex/scripts/restore-macos.sh"
```

The restore script restores the latest backups created by the installer. Sound files copied into `~/.codex/sounds` are left in place so reinstalling remains quick.
