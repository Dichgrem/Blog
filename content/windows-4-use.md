+++
title = "Windows系列(4):高效操作与强化"
date = 2024-05-28

[taxonomies]
tags = ["Windows"]
+++

前言 本文记载windows下的常用快捷键与PowerShell强化配置.
<!-- more -->

## 快捷键

高效使用 Windows 的第一步，就是**减少鼠标依赖**。  
Windows 自身已经内置了大量非常实用的快捷键，只是很多人并没有系统地使用过。

- **Alt + Tab**  
  在**已打开的窗口之间切换**（经典快捷键）

- **Win + Tab**  
  打开**任务视图**，可查看所有窗口与虚拟桌面  

- **Alt + F4**  
  关闭当前窗口  

> 在桌面下使用时可弹出关机 / 重启菜单

- **Win + D**  
  显示桌面 / 恢复窗口  

- **Win + ↑ / ↓ / ← / →**  
  窗口最大化 / 最小化 / 左右分屏  

- **Win + Shift + ← / →**  
  将当前窗口移动到另一个显示器  

---

### 虚拟桌面

- **Win + Ctrl + D**  
  新建虚拟桌面  

- **Win + Ctrl + ← / →**  
  在虚拟桌面之间切换  

- **Win + Ctrl + F4**  
  关闭当前虚拟桌面  

---

### 应用启动与系统

- **Win**  
  打开开始菜单，直接输入搜索应用  

- **Win + R**  
  打开“运行”窗口  

- **Win + E**  
  打开资源管理器  

- **Win + I**  
  打开系统设置  

- **Win + L**  
  锁屏  

---

### 截图与录屏

- **Win + Shift + S**  
  截图（区域 / 窗口 / 全屏）  

- **Win + PrtSc**  
  全屏截图并自动保存  

- **Win + G**  
  打开 Xbox Game Bar，可用于屏幕录制  

---

### 常用编辑操作

- **Ctrl + C / V / X**  
  复制 / 粘贴 / 剪切  

- **Ctrl + Z / Y**  
  撤销 / 重做  

- **Ctrl + A**  
  全选  

- **Ctrl + S**  
  保存  

- **Ctrl + F**  
  查找  

- **Ctrl + Shift + Esc**  
  直接打开任务管理器  


## 启动器

有了窗口切换和关闭，还需要打开，这里推荐这两个：
- [Flow.Launcher](https://github.com/Flow-Launcher/Flow.Launcher)
- [ZeroLaunch-rs](https://github.com/ghost-him/ZeroLaunch-rs)

现在我们就可以使用``Win+Tab``切换窗口，使用``Alt+F4``关闭窗口，使用``Alt+Space``启动软件.

## Powershell强化

要达到类似Linux下``oh-myzsh+atuin+fzf+zoxide+starship``的效果，可以使用以下方法增强：

- 安装模块
```bash
winget install junegunn.fzf
fzf --version
winget install JanDeDobbeleer.OhMyPosh
oh-my-posh version
winget install ajeetdsouza.zoxide
zoxide --version
```

- 导入模块
```bash
Install-Module PSReadLine     -Scope CurrentUser -Force
Install-Module posh-git       -Scope CurrentUser -Force
Install-Module PSFzf      -Scope CurrentUser -Force
```

- 写入配置

首先执行这个命令：
```bash
notepad $PROFILE
```

在打开的窗口中写入：

```bash
# ---------- PSReadLine ----------
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView

# ---------- Git ----------
Import-Module posh-git

# ---------- fzf ----------
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# ---------- zoxide ----------
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# ---------- oh-my-posh ----------

oh-my-posh init pwsh | Invoke-Expression

# ---------- Bash-style line editing ----------

# Ctrl+A → 行首
Set-PSReadLineKeyHandler -Key Ctrl+a -Function BeginningOfLine
# Ctrl+E → 行尾
Set-PSReadLineKeyHandler -Key Ctrl+e -Function EndOfLine
# Ctrl+U → 删除从光标到行首
Set-PSReadLineKeyHandler -Key Ctrl+u -Function BackwardDeleteLine
# Ctrl+K → 删除从光标到行尾
Set-PSReadLineKeyHandler -Key Ctrl+k -Function ForwardDeleteLine
```
随后新开启一个PowerShell，可以看到有Git提示，ctrl+R唤起历史，右方向键透明补全的效果.

---
**Done.**
