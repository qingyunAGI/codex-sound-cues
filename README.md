# Codex Sound Cues / Codex 状态提示音

[中文说明](#中文说明) | [English](#english)

---

## 中文说明

`codex-sound-cues` 是一个可分享的 Codex skill，用来给 Codex 和宠物交互增加清晰、可辨识、可回滚的声音反馈。

## 魔法小鹿 Codex Pet

魔法小鹿是一只给 Codex 使用的星月小鹿宠物。

它戴着蓝紫色的星月魔法帽，披着小小的星光披风，手里拿着星星法杖。它看起来像刚从夜空边缘跑下来，也像一个悄悄守在桌边的小助手，陪你写代码、整理想法、等任务跑完。

AI 工具越来越多以后，工作很容易变成一串紧绷的提示、等待和切换。创作魔法小鹿的初衷，是希望它像一个有一点魔法感的小陪伴：在 Codex 开始处理时给你一个进入状态的声音，在需要你做决定时轻轻敲门，在完成时提醒你可以回来看一眼；当你坐太久时，它也会用软软的声音提醒你起来走动一下。

愿它陪你在一段段专注工作里，少一点机械感，多一点星光和松弛。

它的核心设计不是“多放几个音效”，而是让不同状态有不同性格：

- `work`：Codex 正在处理任务。安装后的第一次工作会话会先播放第 2 条小鹿问候，再播放短促的摩托车启动声，并自动启动 1 小时久坐提醒循环。
- `decision`：Codex 需要用户做决策。当前声音是两下轻敲门，像秘书提醒你看一眼。
- `complete`：Codex 已完成任务。优先使用本机 Codex 自带通知音；如果找不到，则使用仓库内的自制 fallback 完成音。
- `pet`：宠物点击互动。当前声音为“小鹿魔法宠物”的可爱轻笑音，带一点闪光铃声尾巴，适合鼠标点到宠物时播放。
- `sedentary`：久坐提醒语音。当前使用两条剪映导出的可爱童声 MP3 配音源，并内置对应的稳定 WAV 运行文件，触发时随机播放其中一条。
- `greeting-install`：安装好魔法小鹿后播放的问候声，会在两条打招呼配音里随机选一条。
- `greeting-open`：安装后的第一次 Codex 工作会话问候，固定使用第 2 条打招呼配音，并用本地状态文件避免重复播放；它会在 `work` 事件前置触发。

### 特点

- **状态清晰**：不同声音对应不同工作状态，不用一直盯着屏幕。
- **角色一致**：宠物点击音不是普通按钮音，而是贴合“小鹿 / 魔法小鹿”形象的轻笑反馈。
- **完整动态宠物**：仓库包含可直接安装的魔法小鹿 Codex 动态宠物包，带待机、挥手、跳跃、专注、等待、奔跑和失败反馈等状态。
- **久坐提醒**：内置两条中文撒娇式休息提醒；进入 `work` 后会自动启动小时级提醒，连续工作 1 小时、2 小时、3 小时及之后每小时随机播放。
- **安装问候**：魔法小鹿安装完成后会随机问候，第一次进入 Codex 工作会话时再用第 2 条声音打招呼一次。
- **安全可回滚**：安装脚本会备份 `$HOME\.codex\config.toml`、`$HOME\.codex\AGENTS.md`，以及已有的同名小鹿宠物。
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
- 复制完整动态小鹿宠物到 `$HOME\.codex\pets\magic-deer`
- 重置首次会话问候标记，并在安装结束时随机播放一条小鹿问候
- 备份 Codex 配置和全局说明文件
- 将完成通知接入 Codex 的 `notify` 钩子
- 在全局规则中加入 `work` / `decision` / `pet` / `sedentary` / `greeting-open` 的使用说明

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
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" greeting-install
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" greeting-open
```

### 安装后问候

问候声音有两个事件：

- `greeting-install`：安装脚本在结束时自动播放，随机使用两条问候配音之一。
- `greeting-open`：安装后的第一次 Codex 工作会话播放，固定使用第 2 条问候配音；`work` 事件会先调用它，再播放处理中的提示音。播放后会写入 `$HOME\.codex\state\codex-sound-cues\greeting-open-played.txt`，避免每次打开都重复打招呼。

两条剪映配音源保存在：

- `assets/voice-sources/magic-deer-greeting-1.mp3`
- `assets/voice-sources/magic-deer-greeting-2.mp3`

安装后使用对应的 WAV 运行文件：

- `codex-greeting-cute-1.wav`
- `codex-greeting-cute-2.wav`

### 宠物点击与震动

当前分享的动态宠物角色：

![魔法小鹿 Codex 宠物](./assets/pets/magic-deer-codex-pet/magic-deer-codex-pet.png)

- 可安装包：`assets/pets/magic-deer/pet.json` 与 `assets/pets/magic-deer/spritesheet.webp`
- 动态状态：待机、挥手、跳跃、等待、专注、左右奔跑、失败反馈。
- 互动联动：点击反馈使用 `pet` 声音；久坐时随机播放两句小鹿语音。
- 安装后重启 Codex，并在自定义宠物中选择“魔法小鹿”。

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

进入 `work` 后会自动启动一个本地久坐提醒循环，默认 60 分钟提醒一次；也就是连续工作 1 小时、2 小时、3 小时以及之后每小时都会随机播放一条小鹿久坐提醒。也可以手动启动：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\start-sedentary-reminder.ps1" -Minutes 60
```

停止自动久坐提醒：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" sedentary-stop
```

### 恢复

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\restore.ps1
```

恢复脚本会还原安装时生成的最新备份。复制到 `$HOME\.codex\sounds` 的音频文件会保留，方便之后重新安装。

---

## English

`codex-sound-cues` is a shareable Codex skill that adds clear, recognizable, and reversible sound feedback to Codex and pet interactions.

## Magic Deer Codex Pet

Magic Deer is a starry little deer pet for Codex.

It wears a blue-purple moon-and-star wizard hat, a tiny star-lit cape, and carries a star wand. It feels like it has just stepped down from the edge of the night sky, then quietly settled beside the desk to keep you company while you code, think, wait, and return to finished work.

As AI tools multiply, work can start to feel like a tight loop of prompts, waiting, context switches, and decisions. Magic Deer was created as a small magical companion for that rhythm: it gives Codex a recognizable sound when work starts, knocks gently when a decision is needed, reminds you when a task is complete, and uses soft voice prompts when it is time to stand up and move.

May it bring a little less machinery and a little more starlight into focused Codex work.

The design goal is not just “more sounds.” Each cue carries a different state and personality:

- `work`: Codex is actively processing. On the first work session after installation, it plays Magic Deer greeting voice 2 before the short motorcycle start cue, then starts the hourly sedentary reminder loop.
- `decision`: Codex needs the user to make a choice. Current sound: a gentle two-knock cue, like a secretary knocking at the door.
- `complete`: Codex has finished a task. It uses the locally installed Codex notification sound when available, with a bundled fallback when it is not.
- `pet`: pet click interaction. Current sound: a cute “magic deer” laugh with a soft sparkling bell tail, designed for mouse clicks on a deer-like magical pet.
- `sedentary`: long-sitting reminder voice. It uses two cute childlike MP3 voiceover sources exported from Jianying/CapCut and randomly plays one converted WAV runtime asset each time.
- `greeting-install`: Magic Deer greeting played after installation, randomly selecting one of the two greeting voices.
- `greeting-open`: first Codex work-session greeting after installation, always using greeting voice 2 and recording local state to avoid repeats; it is triggered before the `work` cue.

### Features

- **Clear states**: different sounds map to different Codex states, so users do not need to watch the screen constantly.
- **Character-aware pet feedback**: the pet click sound is not a generic button beep; it is tuned for a cute magical deer character.
- **Complete animated pet**: the repository includes an installable Magic Deer Codex pet package with idle, wave, jump, focus, wait, run, and failure-feedback states.
- **Break reminder**: includes two cute Chinese voice prompts; `work` starts an hourly reminder loop, randomly reminding after 1 hour, 2 hours, 3 hours, and every continued hour.
- **Install greeting**: Magic Deer greets the user randomly after installation, then uses voice 2 once on the first Codex work session.
- **Reversible setup**: the installer backs up `$HOME\.codex\config.toml`, `$HOME\.codex\AGENTS.md`, and any same-named existing deer pet.
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
- Copies the complete animated pet into `$HOME\.codex\pets\magic-deer`
- Resets the first-session greeting marker and plays one random Magic Deer greeting at the end of installation
- Backs up Codex config and global instruction files
- Connects completion sound through the Codex `notify` hook
- Adds global guidance for using `work`, `decision`, `pet`, `sedentary`, and `greeting-open` cues

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
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" greeting-install
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" greeting-open
```

### Post-Install Greeting

There are two greeting events:

- `greeting-install`: played automatically at the end of installation, randomly selecting one of the two greeting voice files.
- `greeting-open`: played on the first Codex work session after installation, always using greeting voice 2. The `work` event calls it before playing the active-work cue. It writes `$HOME\.codex\state\codex-sound-cues\greeting-open-played.txt` after playback so it does not repeat every time.

The two Jianying/CapCut source MP3 files are kept in:

- `assets/voice-sources/magic-deer-greeting-1.mp3`
- `assets/voice-sources/magic-deer-greeting-2.mp3`

The installed runtime uses converted WAV files:

- `codex-greeting-cute-1.wav`
- `codex-greeting-cute-2.wav`

### Pet Click And Vibration

Current shared animated pet:

![Magic Deer Codex Pet](./assets/pets/magic-deer-codex-pet/magic-deer-codex-pet.png)

- Installable package: `assets/pets/magic-deer/pet.json` and `assets/pets/magic-deer/spritesheet.webp`
- Animated states: idle, wave, jump, wait, review, both running directions, and failure feedback.
- Interaction link: click feedback uses the `pet` cue; long-sitting reminders randomly play one of the two deer voice prompts.
- Restart Codex after installation and choose “Magic Deer” from custom pets.

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

The `work` event automatically starts a local reminder loop, defaulting to one reminder every 60 minutes. This means Magic Deer randomly reminds the user after 1 hour, 2 hours, 3 hours, and every continued hour of focused work. It can also be started manually:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\start-sedentary-reminder.ps1" -Minutes 60
```

Stop the automatic reminder loop:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOME\.codex\scripts\codex-sound.ps1" sedentary-stop
```

### Restore

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\restore.ps1
```

The restore script restores the latest backups created by the installer. Sound files copied into `$HOME\.codex\sounds` are left in place so reinstalling remains quick.
