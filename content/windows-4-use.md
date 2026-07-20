+++
title = "Windows系列(4): 命令行工具链与效率增强"
date = 2024-05-28

[taxonomies]
tags = ["Windows"]
+++

前言 本篇介绍 Windows Terminal、PowerShell、winget/scoop、gsudo/Core Utils/psmux/rmux，以及启动器与常用快捷键。

<!-- more -->

## Windows Terminal

**[Windows Terminal](https://github.com/microsoft/terminal)**，微软开源，Win11 默认终端。把 cmd、PowerShell、WSL 塞进同一个标签页窗口里。

- `Ctrl+Shift+T` 新建标签，`Alt+Shift+D` 分屏
- GPU 渲染（DirectWrite），支持 Nerd Font、emoji、Unicode
- acrylic 半透明、背景图、配色方案，`settings.json` 或 GUI 设置
- `Ctrl+Shift+P` 命令面板，`Ctrl+,` 打开设置
- Quake 模式（从屏幕顶部下拉）
- 内置 Cascadia Code 等宽字体，支持连字

## PowerShell

Windows 预装 PowerShell 5.1，终端输入 `$PSVersionTable` 可看版本。

5.1 基于 .NET Framework 4.x，仅 Windows，2016 年发布，不再加新功能。**PowerShell 7** 是 2018 年开源后的继任者，基于 .NET 8，跨平台。

| 特性 | 5.1 | 7 |
|------|:-:|:-:|
| 引擎 | .NET Framework 4.x | .NET 8 |
| 平台 | 仅 Windows | Windows / Linux / macOS |
| 默认编码 | UTF-16 LE (BOM) | UTF-8 (NoBOM) |
| 三元运算 `a ? b : c` | ❌ | ✅ |
| null 合并 `??` / `??=` | ❌ | ✅ |
| 管道链 `&&` / `\|` | ❌ | ✅ |
| `ForEach-Object -Parallel` | ❌ | ✅ |
| `Get-Error` | ❌ | ✅ |
| SSH 远程 | 需额外配置 | 内置 |
| 性能 | 基线 | 提升明显（.NET 运行时改进） |
| 旧模块兼容 | 原生 | WindowsCompatibility 层 |

1. **编码**——5.1 默认 UTF-16 LE BOM，跟 Linux 交互（重定向、管道）容易乱码；7 默认 UTF-8。
2. **管道链**——`./build.ps1 && ./deploy.ps1` 这种 bash 写法 5.1 不支持，7 原生支持。
3. **并行**——`1..10 | ForEach-Object -Parallel { $_ * 2 }` 5.1 没有，7 有。
4. **三元和 null 合并**——`$result = $value ?? "default"` 在 5.1 要写成 `if ($null -eq $value) { ... }`。

我的用法是 PS7 作日常 Shell，5.1 留着跑那些只认旧版的老模块。

### 安装与配置

要达到类似 Linux 下 ``oh-myzsh+atuin+fzf+zoxide+starship`` 的效果：

* 安装 PS7

```bash
winget install Microsoft.PowerShell
```

* 装 Nerd Font

前往 `https://www.nerdfonts.com/font-downloads` 下载后全选 ttf 并给所有用户安装。

* 装 CLI 工具

```bash
winget install junegunn.fzf
winget install ajeetdsouza.zoxide
winget install Starship.Starship
```

* 导入模块

```bash
Install-Module PSReadLine -Scope CurrentUser -Force
Install-Module posh-git -Scope CurrentUser -Force
Install-Module PSFzf -Scope CurrentUser -Force
```

* 写 `$PROFILE`

```bash
notepad $PROFILE
```

写入：

```bash
# UTF-8
chcp 65001 > $null
[Console]::InputEncoding  = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$OutputEncoding = [System.Text.UTF8Encoding]::new($false)

# PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView

# posh-git
Import-Module posh-git

# PSFzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider Ctrl+t -PSReadlineChordReverseHistory Ctrl+r

# zoxide
Invoke-Expression (& { zoxide init powershell | Out-String })

# Starship
Invoke-Expression (&starship init powershell)

# Bash 风格快捷键
Set-PSReadLineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Set-PSReadLineKeyHandler -Key Ctrl+e -Function EndOfLine
Set-PSReadLineKeyHandler -Key Ctrl+u -Function BackwardDeleteLine
Set-PSReadLineKeyHandler -Key Ctrl+k -Function ForwardDeleteLine
```

新开一个 PowerShell，能看到 Git 分支提示、`Ctrl+R` fzf 历史搜索、右方向键透明补全。

## Winget / Scoop

**winget**（Windows Package Manager），微软官方，随 App Installer 组件预装在 Win10 1809+ 和 Win11 中。`msstore` 源走 Microsoft Store 验证，`winget` 源走 [winget-pkgs](https://github.com/microsoft/winget-pkgs) 社区仓库，共 5000+ 软件包。

```bash
winget search <关键词>     # 搜索
winget install <包名>      # 安装
winget upgrade             # 查看可更新
winget upgrade --all       # 全部升级
winget uninstall <包名>    # 卸载
winget list                # 已安装列表
```

> winget 覆盖面广，GUI/CLI 都能装。缺点：部分包要 UAC 弹窗，安装路径在 `Program Files`，不能自定义。

**scoop**，社区维护，装到 `~/scoop/` 下，不需要管理员权限。

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
```

scoop 用 bucket 分类管理软件源：

| bucket | 内容 |
|--------|------|
| `main` | 知名开源 CLI/GUI 工具（git, 7zip, python 等） |
| `extras` | GUI 软件（vscode, firefox, obsidian 等） |
| `versions` | 多版本共存（python27, openjdk11 等） |
| `nerd-fonts` | Nerd Font 字体集合 |
| `java` | 各版本 JDK |

```bash
scoop bucket add extras          # 添加 bucket
scoop install <包名>              # 安装
scoop update *                   # 更新全部
scoop status                     # 查看可更新
scoop cleanup *                  # 清理旧版本
```

> scoop 装用户目录，换机拷贝 `~/scoop/` 即可迁移。

## 命令行工具

### gsudo

**[gsudo](https://github.com/gerardog/gsudo)**——Windows 上的 sudo，命令行里临时提权用。

```powershell
winget install gerardog.gsudo

gsudo notepad C:\Windows\System32\drivers\etc\hosts   # 提权跑一条命令
gsudo                                                   # 提权开新 Shell
```

支持 PowerShell、cmd、WSL，管道传递、凭证缓存。注册为 `sudo` 别名后用法和 Linux 差不多。

### Core Utils

Linux 下 `cp`、`mv`、`rm`、`ls`、`grep` 这些命令，cmd/PowerShell 里名字不同。几个途径：

1. **Git for Windows** 自带 Git Bash，打包了一套 MSYS2 编译的 GNU 工具链，装了 Git 就有；
2. **[uutils/coreutils](https://github.com/uutils/coreutils)**——Rust 重写的 GNU Core Utils，跨平台，winget/scoop 安装：

```bash
winget install uutils.coreutils
scoop install uutils-coreutils
```

装完 PowerShell 里就能直接用 `cp`、`grep`、`ls`。

### psmux / rmux

- **[psmux](https://github.com/psmux/psmux)**（3k+ stars）——Rust 实现的 Windows 原生 tmux 替代品。支持 PowerShell、cmd 和 Windows Terminal，提供会话管理、窗格分割、插件系统（[psmux-plugins](https://github.com/psmux/psmux-plugins)），可通过 scoop 安装。
- **[rmux](https://github.com/Helvesec/rmux)**（2.4k+ stars）——跨平台的通用多路复用框架，同样基于 Rust。提供可编程 SDK，允许从代码驱动任意 CLI / TUI 应用。

## 启动器

**Flow.Launcher**——[GitHub](https://github.com/Flow-Launcher/Flow.Launcher)，`Alt+Space` 呼出，搜应用、文件、目录。内置计算器、网页搜索、系统命令，有 Everything 插件。

**ZeroLaunch-rs**——[GitHub](https://github.com/ghost-him/ZeroLaunch-rs)，Rust 写的轻量启动器，启动快、内存小。

**Everything**——[voidtools.com](https://www.voidtools.com/)，读 NTFS MFT 做毫秒级全盘文件搜索。Windows 自带搜索跟它没法比。

**AutoHotkey**——[autohotkey.com](https://www.autohotkey.com/)，键盘脚本引擎，改键、宏、文本展开都行。目前用 v2，v1 停更。常用：CapsLock 映射 Ctrl，窗口置顶快捷键，输 `` @\ `` 自动展开为邮箱。

```bash
winget install Flow.Launcher.Flow.Launcher
winget install voidtools.Everything
winget install AutoHotkey.AutoHotkey
```

## 快捷键速查

### 浏览器

| 快捷键               | 描述             |
|----------------------|------------------|
| Ctrl + A             | 全选             |
| Ctrl + C             | 复制             |
| Ctrl + X             | 剪切             |
| Ctrl + V             | 粘贴             |
| Ctrl + F             | 查找             |
| Ctrl + Q             | 退出             |
| Ctrl + T             | 新建标签页       |
| Ctrl + W             | 关闭标签页       |
| Ctrl + N             | 新建窗口         |
| Ctrl + Shift + P     | 新建隐私浏览窗口 |

##### 历史

| 快捷键                  | 描述                       |
|-------------------------|----------------------------|
| Ctrl + H                | 历史侧栏                   |
| Ctrl + Shift + H        | 我的足迹窗口（历史）       |
| Ctrl + Shift + Del      | 清除最近历史记录           |

##### 书签

| 快捷键                        | 描述                               |
|-------------------------------|------------------------------------|
| Ctrl + D                      | 将此页加为书签                     |
| Ctrl + I                      | 页面信息                           |
| Ctrl + Shift + O              | 显示全部书签（我的足迹窗口）       |
| Ctrl + B / Ctrl + Shift + B   | 书签侧栏 / 顶栏                    |

##### 下载与插件

| 快捷键               | 描述           |
|----------------------|----------------|
| Ctrl + Shift + Y     | 下载           |
| Ctrl + Shift + A     | 附加组件 / 插件 |

##### 控制台与开发

| 快捷键               | 描述             |
|----------------------|------------------|
| Ctrl + Shift + K     | Web 控制台       |
| Ctrl + Shift + C     | 查看器           |
| Shift + F7           | 样式编辑器       |
| Shift + F5           | 分析器           |
| Ctrl + Shift + E     | 网络             |
| Ctrl + U             | 页面源码         |
| Ctrl + Shift + J     | 浏览器控制台     |

##### 标签页与界面

| 快捷键                        | 描述                     |
|-------------------------------|--------------------------|
| Ctrl + S                      | 界面保存                 |
| Ctrl + +                      | 放大                     |
| Ctrl + -                      | 缩小                     |
| Ctrl + 0                      | 重置缩放                 |
| Ctrl + K / J                  | 搜索                     |
| Ctrl + Home / End             | 到文件头 / 尾            |
| Ctrl + Page Up                | 切换到左边标签页         |
| Ctrl + Page Down              | 切换到右边标签页         |
| Ctrl + Shift + Page Up        | 当前标签页左移           |
| Ctrl + Shift + Page Down      | 当前标签页右移           |

##### 其他

| 快捷键             | 描述             |
|--------------------|------------------|
| Alt + Space        | KDE 搜索栏       |
| Alt + → / ←        | 前进 / 后退      |
| Alt + 数字键       | 选择标签页（1–8）|
| Alt + M            | 静音             |
| End                | 到达页尾         |
| Home               | 到达页首         |
| F6                 | 地址栏           |

### GNU Readline

##### 光标移动

* `Ctrl + A`：移动到行首
* `Ctrl + E`：移动到行尾
* `Ctrl + B`：向左移动一个字符
* `Ctrl + F`：向右移动一个字符
* `Alt + B`：向左移动一个单词
* `Alt + F`：向右移动一个单词

##### 编辑文本

* `Ctrl + D`：删除光标处字符
* `Ctrl + H`：删除光标前字符（Backspace）
* `Ctrl + W`：删除光标前一个单词
* `Alt + D`：删除光标后一个单词
* `Ctrl + U`：删除光标到行首
* `Ctrl + K`：删除光标到行尾
* `Ctrl + Y`：粘贴最后删除的文本
* `Alt + Backspace`：删除前一个单词

##### 历史记录

* `Ctrl + P`：上一条命令
* `Ctrl + N`：下一条命令
* `Ctrl + R`：反向搜索历史
* `Ctrl + S`：正向搜索历史（有些终端默认禁用）
* `Alt + <`：跳到历史最早
* `Alt + >`：跳到历史最新

##### 控制命令

* `Ctrl + L`：清屏（等同 `clear`）
* `Ctrl + C`：终止当前命令
* `Ctrl + D`：EOF（退出 shell）
* `Ctrl + Z`：挂起当前进程
* `Ctrl + J`：执行命令（等同 Enter）

##### 单词大小写

* `Alt + U`：将单词变为大写
* `Alt + L`：将单词变为小写
* `Alt + C`：首字母大写

##### 交换 / 转置

* `Ctrl + T`：交换当前字符和前一个字符
* `Alt + T`：交换两个单词

##### 补全

* `Tab`：自动补全
* `Alt + ?`：列出所有可能补全
* `Alt + *`：插入所有补全

##### 参数引用

* `Alt + .`：插入上一条命令的最后一个参数
* `Alt + _`：同上

### Windows

高效使用 Windows 的第一步，就是**减少鼠标依赖**。  
Windows 自身已经内置了大量非常实用的快捷键，只是很多人并没有系统地使用过。

* **Alt + Tab**  
  在**已打开的窗口之间切换**（经典快捷键）

* **Win + Tab**  
  打开**任务视图**，可查看所有窗口与虚拟桌面  

* **Alt + F4**  
  关闭当前窗口  

> 在桌面下使用时可弹出关机 / 重启菜单

* **Win + D**  
  显示桌面 / 恢复窗口  

* **Win + ↑ / ↓ / ← / →**  
  窗口最大化 / 最小化 / 左右分屏  

* **Win + Shift + ← / →**  
  将当前窗口移动到另一个显示器  

---

##### 虚拟桌面

* **Win + Ctrl + D**  
  新建虚拟桌面  

* **Win + Ctrl + ← / →**  
  在虚拟桌面之间切换  

* **Win + Ctrl + F4**  
  关闭当前虚拟桌面  

---

##### 应用启动与系统

* **Win**  
  打开开始菜单，直接输入搜索应用  

* **Win + R**  
  打开“运行”窗口  

* **Win + E**  
  打开资源管理器  

* **Win + I**  
  打开系统设置  

* **Win + L**  
  锁屏  

---

##### 截图与录屏

* **Win + Shift + S**  
  截图（区域 / 窗口 / 全屏）  

* **Win + PrtSc**  
  全屏截图并自动保存  

* **Win + G**  
  打开 Xbox Game Bar，可用于屏幕录制  

---

##### 常用编辑操作

* **Ctrl + C / V / X**  
  复制 / 粘贴 / 剪切  

* **Ctrl + Z / Y**  
  撤销 / 重做  

* **Ctrl + A**  
  全选  

* **Ctrl + S**  
  保存  

* **Ctrl + F**  
  查找  

* **Ctrl + Shift + Esc**  
  直接打开任务管理器  

---

**Done.**
