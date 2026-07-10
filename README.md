# Codex Sound Cues / Codex 状态提示音

[中文说明](#中文说明) | [English](#english)

---

## 中文说明

`codex-sound-cues` 是一个可分享的 Codex skill，用来给 Codex 和宠物交互增加清晰、可辨识、可回滚的声音反馈。

它的核心设计不是“多放几个音效”，而是让不同状态有不同性格：

- `work`：Codex 正在处理任务。当前声音是短促的摩托车启动声，像进入工作状态。
- `decision`：Codex 需要用户做决策。当前声音是两下轻敲门，像秘书提醒你看一眼。
- `complete`：Codex 已完成任务。优先使用本机 Codex 自带通知音；如果找不到，则使用仓库内的自制 fallback 完成音。
- `pet`：宠物点击互动。当前声音为“小鹿魔法宠物”的可爱轻笑音，带一点闪光铃声尾巴，适合鼠标点到宠物时播放。
- `sedentary`：久坐提醒语音。当前使用两条剪映导出的可爱童声 MP3 配音源，并内置对应的稳定 WAV 运行文件，触发时随机播放其中一条。

### 特点

- **状态清晰**：不同声音对应不同工作状态，不用一直盯着屏幕。
- **角色一致**：宠物点击音不是普通按钮音，而是贴合“小鹿 / 魔法小鹿”形象的轻笑反馈。
- **宠物可分享**：仓库包含魔法小鹿 Codex 宠物的静态角色源图和角色资料，可作为后续动画宠物包的视觉源。
- **久坐提醒**：内置两条中文撒娇式休息提醒，可在长时间 Codex 伏案工作后随机播放。
- **安全可回滚**：安装脚本会备份 `$HOME\.codex\config.toml` 和 `$HOME\.codex\AGENTS.md`。
- **不破坏原通知**：完成音通过包装 Codex 原有 `notify` 钩子实现，会尽量保留原通知逻辑。
- **不分发 Codex 内置音频**：仓库不会直接打包 Codex 自带通知音，只在安装者本机存在时调用。
- **宠物互动可扩展**：支持桌面宠物、浏览器宠物、Canvas 宠物等场景。
- **震动边界明确**：网页或移动环境可用 Web Vibration API；普通 Windows 桌面应用没有稳定通用的震动接口，默认以声音作为可靠反馈。

### 安装

在 skill 文件夹中运行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

安装脚本会：

- 复制音频资源到 `$HOME\.codex\sounds`
- 复制脚本到 `$HOME\.codex\scripts`
- 备份 Codex 配置和全局说明文件
- 将完成通知接入 Codex 的 `notify` 钩子
- 在全局规则中加入 `work` / `decision` / `pet` / `sedentary` 的使用说明

### 测试

播放全部提示音：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\test-sounds.ps1
```

单独播放某一种：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" work
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" decision
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" complete
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" pet
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" sedentary
```

### 宠物点击与震动

当前分享的宠物角色：

![魔法小鹿 Codex 宠物](./assets/pets/magic-deer-codex-pet/magic-deer-codex-pet.png)

- 角色资料：`assets/pets/magic-deer-codex-pet/pet-profile.json`
- 资产类型：静态角色源图，不是完整动画 spritesheet。
- 后续扩展：可以基于这张源图继续生成完整 Codex 动画宠物包。

桌面或本地脚本集成时，调用 `pet` 事件：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" pet
```

浏览器宠物或 Canvas 宠物可以这样接入点击反馈：

```js
petElement.addEventListener("click", () => {
  if ("vibrate" in navigator) navigator.vibrate([20, 30, 20]);
  new Audio("./assets/codex-pet-click-cute.wav").play();
});
```

建议把 `pet` 音效理解成“角色状态反馈”：如果宠物后续有开心、困倦、撒娇、害羞、施法等状态，可以继续扩展为不同事件音，而不是所有交互都用同一个按钮音。

### 久坐提醒语音

久坐提醒已作为 `sedentary` 事件加入。当前包含两条剪映配音源：

- `assets/voice-sources/magic-deer-sedentary-1.mp3`
- `assets/voice-sources/magic-deer-sedentary-2.mp3`

安装后会使用对应的 WAV 运行文件：

- `codex-sedentary-cute-1.wav`
- `codex-sedentary-cute-2.wav`

直接播放时会随机选一条：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" sedentary
```

启动一个可选的本地久坐提醒循环，默认 50 分钟提醒一次：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\start-sedentary-reminder.ps1" -Minutes 50
```

这个循环不会自动后台安装，需要用户明确启动；停止时关闭对应终端即可。

### 恢复

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\restore.ps1
```

恢复脚本会还原安装时生成的最新备份。复制到 `$HOME\.codex\sounds` 的音频文件会保留，方便之后重新安装。

---

## English

`codex-sound-cues` is a shareable Codex skill that adds clear, recognizable, and reversible sound feedback to Codex and pet interactions.

The design goal is not just “more sounds.” Each cue carries a different state and personality:

- `work`: Codex is actively processing. Current sound: a short motorcycle start cue, like entering work mode.
- `decision`: Codex needs the user to make a choice. Current sound: a gentle two-knock cue, like a secretary knocking at the door.
- `complete`: Codex has finished a task. It uses the locally installed Codex notification sound when available, with a bundled fallback when it is not.
- `pet`: pet click interaction. Current sound: a cute “magic deer” laugh with a soft sparkling bell tail, designed for mouse clicks on a deer-like magical pet.
- `sedentary`: long-sitting reminder voice. It uses two cute childlike MP3 voiceover sources exported from Jianying/CapCut and randomly plays one converted WAV runtime asset each time.

### Features

- **Clear states**: different sounds map to different Codex states, so users do not need to watch the screen constantly.
- **Character-aware pet feedback**: the pet click sound is not a generic button beep; it is tuned for a cute magical deer character.
- **Shareable pet asset**: the repository includes the Magic Deer Codex Pet static character reference and profile metadata as a source for future animated pet packaging.
- **Break reminder**: includes two cute Chinese voice prompts for long Codex work sessions, selected randomly at runtime.
- **Reversible setup**: the installer backs up `$HOME\.codex\config.toml` and `$HOME\.codex\AGENTS.md`.
- **Preserves existing notifications**: completion sound wraps the existing Codex `notify` hook and tries to keep the previous notification behavior.
- **No redistribution of built-in Codex audio**: the repository does not package the native Codex notification sound. It calls the local installed sound when present.
- **Expandable pet interactions**: suitable for desktop pets, browser pets, canvas pets, and similar companion UI.
- **Honest vibration boundary**: Web or mobile contexts can use the Web Vibration API; normal Windows desktop apps do not have a stable universal vibration API, so sound is the reliable default.

### Install

Run this from the skill folder:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

The installer:

- Copies audio assets into `$HOME\.codex\sounds`
- Copies scripts into `$HOME\.codex\scripts`
- Backs up Codex config and global instruction files
- Connects completion sound through the Codex `notify` hook
- Adds global guidance for using `work`, `decision`, `pet`, and `sedentary` cues

### Test

Play every cue:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\test-sounds.ps1
```

Play one cue:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" work
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" decision
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" complete
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" pet
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" sedentary
```

### Pet Click And Vibration

Current shared pet character:

![Magic Deer Codex Pet](./assets/pets/magic-deer-codex-pet/magic-deer-codex-pet.png)

- Profile: `assets/pets/magic-deer-codex-pet/pet-profile.json`
- Asset type: static character reference, not a full animated spritesheet.
- Future extension: use this source image to generate a full Codex animated pet package.

For desktop or local integrations, call the `pet` event:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" pet
```

For browser or canvas pets, wire click feedback like this:

```js
petElement.addEventListener("click", () => {
  if ("vibrate" in navigator) navigator.vibrate([20, 30, 20]);
  new Audio("./assets/codex-pet-click-cute.wav").play();
});
```

Treat `pet` as character-state feedback: if the pet later gains states like happy, sleepy, shy, cuddly, or casting magic, those can become separate event sounds instead of using one generic click beep.

### Sedentary Reminder Voice

The sedentary reminder voice is available as the `sedentary` event. It includes two Jianying/CapCut MP3 voiceover sources:

- `assets/voice-sources/magic-deer-sedentary-1.mp3`
- `assets/voice-sources/magic-deer-sedentary-2.mp3`

The installed runtime uses converted WAV files:

- `codex-sedentary-cute-1.wav`
- `codex-sedentary-cute-2.wav`

Play it directly. One voice is selected randomly:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" sedentary
```

Start an optional local reminder loop, defaulting to one reminder every 50 minutes:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\start-sedentary-reminder.ps1" -Minutes 50
```

This loop is not installed silently in the background. Start it explicitly and close its terminal to stop it.

### Restore

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\restore.ps1
```

The restore script restores the latest backups created by the installer. Sound files copied into `$HOME\.codex\sounds` are left in place so reinstalling remains quick.
