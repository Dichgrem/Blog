+++
title = "Windows系列(4):快捷键位与强化"
date = 2024-05-28

[taxonomies]
tags = ["Windows"]
+++

前言 本文记载windows下的常用快捷键与PowerShell强化配置.
<!-- more -->

## 浏览器快捷键

### 常用

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

### 历史

| 快捷键                  | 描述                       |
|-------------------------|----------------------------|
| Ctrl + H                | 历史侧栏                   |
| Ctrl + Shift + H        | 我的足迹窗口（历史）       |
| Ctrl + Shift + Del      | 清除最近历史记录           |

### 书签

| 快捷键                        | 描述                               |
|-------------------------------|------------------------------------|
| Ctrl + D                      | 将此页加为书签                     |
| Ctrl + I                      | 页面信息                           |
| Ctrl + Shift + O              | 显示全部书签（我的足迹窗口）       |
| Ctrl + B / Ctrl + Shift + B   | 书签侧栏 / 顶栏                    |

### 下载与插件

| 快捷键               | 描述           |
|----------------------|----------------|
| Ctrl + Shift + Y     | 下载           |
| Ctrl + Shift + A     | 附加组件 / 插件 |

### 控制台与开发

| 快捷键               | 描述             |
|----------------------|------------------|
| Ctrl + Shift + K     | Web 控制台       |
| Ctrl + Shift + C     | 查看器           |
| Shift + F7           | 样式编辑器       |
| Shift + F5           | 分析器           |
| Ctrl + Shift + E     | 网络             |
| Ctrl + U             | 页面源码         |
| Ctrl + Shift + J     | 浏览器控制台     |

### 标签页与界面

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

### 其他操作

| 快捷键             | 描述             |
|--------------------|------------------|
| Alt + Space        | KDE 搜索栏       |
| Alt + → / ←        | 前进 / 后退      |
| Alt + 数字键       | 选择标签页（1–8）|
| Alt + M            | 静音             |
| End                | 到达页尾         |
| Home               | 到达页首         |
| F6                 | 地址栏           |

## GNU Readline 常用快捷键

### 光标移动

* `Ctrl + A`：移动到行首
* `Ctrl + E`：移动到行尾
* `Ctrl + B`：向左移动一个字符
* `Ctrl + F`：向右移动一个字符
* `Alt + B`：向左移动一个单词
* `Alt + F`：向右移动一个单词

### 编辑文本

* `Ctrl + D`：删除光标处字符
* `Ctrl + H`：删除光标前字符（Backspace）
* `Ctrl + W`：删除光标前一个单词
* `Alt + D`：删除光标后一个单词
* `Ctrl + U`：删除光标到行首
* `Ctrl + K`：删除光标到行尾
* `Ctrl + Y`：粘贴最后删除的文本
* `Alt + Backspace`：删除前一个单词

### 历史记录

* `Ctrl + P`：上一条命令
* `Ctrl + N`：下一条命令
* `Ctrl + R`：反向搜索历史
* `Ctrl + S`：正向搜索历史（有些终端默认禁用）
* `Alt + <`：跳到历史最早
* `Alt + >`：跳到历史最新

### 控制命令

* `Ctrl + L`：清屏（等同 `clear`）
* `Ctrl + C`：终止当前命令
* `Ctrl + D`：EOF（退出 shell）
* `Ctrl + Z`：挂起当前进程
* `Ctrl + J`：执行命令（等同 Enter）

### 单词大小写

* `Alt + U`：将单词变为大写
* `Alt + L`：将单词变为小写
* `Alt + C`：首字母大写

### 交换 / 转置

* `Ctrl + T`：交换当前字符和前一个字符
* `Alt + T`：交换两个单词

### 补全

* `Tab`：自动补全
* `Alt + ?`：列出所有可能补全
* `Alt + *`：插入所有补全

### 参数引用

* `Alt + .`：插入上一条命令的最后一个参数
* `Alt + _`：同上

## Windows快捷键

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

### 虚拟桌面

* **Win + Ctrl + D**  
  新建虚拟桌面  

* **Win + Ctrl + ← / →**  
  在虚拟桌面之间切换  

* **Win + Ctrl + F4**  
  关闭当前虚拟桌面  

---

### 应用启动与系统

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

### 截图与录屏

* **Win + Shift + S**  
  截图（区域 / 窗口 / 全屏）  

* **Win + PrtSc**  
  全屏截图并自动保存  

* **Win + G**  
  打开 Xbox Game Bar，可用于屏幕录制  

---

### 常用编辑操作

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

## 启动器

有了窗口切换和关闭，还需要打开，这里推荐这两个：

* [Flow.Launcher](https://github.com/Flow-Launcher/Flow.Launcher)
* [ZeroLaunch-rs](https://github.com/ghost-him/ZeroLaunch-rs)

现在我们就可以使用``Win+Tab``切换窗口，使用``Alt+F4``关闭窗口，使用``Alt+Space``启动软件.

## Powershell强化

要达到类似Linux下``oh-myzsh+atuin+fzf+zoxide+starship``的效果，可以使用以下方法增强：

* 安装模块

```bash
winget install junegunn.fzf
fzf --version
winget install JanDeDobbeleer.OhMyPosh
oh-my-posh version
winget install ajeetdsouza.zoxide
zoxide --version
```

* 导入模块

```bash
Install-Module PSReadLine     -Scope CurrentUser -Force
Install-Module posh-git       -Scope CurrentUser -Force
Install-Module PSFzf      -Scope CurrentUser -Force
```

* 写入配置

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
