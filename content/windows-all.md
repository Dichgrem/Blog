+++
title = "乱七八糟:Windows配置与开发环境"
date = 2024-05-31

[taxonomies]
tags = ["乱七八糟","Windows"]
+++

前言 总结我个人使用的windows日常配置与开发环境。
<!-- more -->

## 安装

- 从官方安装，参考[乱七八糟:Windows优化流程 ](https://blog.dich.bid/windows-optimization/)；
- 从Dichos安装，参考[乱七八糟:Windows封装与全自动安装](https://blog.dich.bid/windows-iso/)；

> 二者都基于专业工作站版本，区别在于Dichos通过预应答文件和封装完成了许多设置与优化。

> Windows最新版本往往Bug比较多，推荐用上一版本；如最新版本为24H2，则推荐使用23H2.

## 驱动

驱动的安装没有集成在Dichos中，而是作为手动安装的一部分避免出错。一般来说，包括:

- 主板驱动和CPU驱动；
- 显卡驱动（独显/核显）；
- Wifi网卡驱动和蓝牙驱动；
- 声卡驱动;
- 硬盘驱动（较少见）；
- Fn快捷键驱动（厂商自带）；
- 笔记本自带的其他某某中心/管家（不建议使用）

而根据来源，又可以分为``公版/通用驱动``和``笔记本厂商特调/专用驱动``，一般而言装公版驱动即可，保持通用性；如果你是重度游戏玩家则可以考虑特调驱动。

**常用驱动下载网站**：

| 分类   | 名称     | 下载 |
|--------|----------|------|
| 综合   | 驱动天空 | [链接](https://www.drvsky.com/) |
| 厂商   | 吾空     | [链接](http://www.wooking.com.cn/drives) |
| 厂商   | 华硕     | [链接](https://www.asus.com.cn/support/download-center/) |
| 厂商   | 联想     | [链接](https://newsupport.lenovo.com.cn/driveDownloads_index.html) |
| 三大件 | AMD      | [链接](https://www.amd.com/en/support/download/drivers.html) |
| 三大件 | Intel    | [链接](https://www.intel.cn/content/www/cn/zh/support/detect.html) |
| 三大件 | NVIDIA   | [链接](https://www.nvidia.cn/geforce/drivers/) |


## 软件

- **AI**: [GPT4All](https://github.com/nomic-ai/gpt4all)
- **截图**: [ShareX](https://github.com/ShareX/ShareX)
- **绘画**: [Krita](https://github.com/KDE/krita)
- **办公**: [Microsoft Office](https://github.com/YerongAI/Office-Tool)
- **PDF**: [Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF)
- **游戏**: [Steam](https://store.steampowered.com/)
- **抓包**: [Wireshark](https://www.wireshark.org/download.html)
- **启动器**: [Flow.Launcher](https://github.com/Flow-Launcher/Flow.Launcher)
- **输入法**: [Rime](https://rime.im/download/)
- **浏览器**: [Floorp](https://github.com/Floorp-Projects/Floorp) / [Chrome](https://www.google.com/chrome/)
- **编辑器**: [VSCodium](https://github.com/VSCodium/vscodium)
- **虚拟机**: Hyper‑V
- **科学上网**: [GFS](https://github.com/GUI-for-Cores/GUI.for.SingBox)
- **书籍阅读**: [Readest](https://github.com/readest/readest)
- **内网互传**: [LocalSend](https://github.com/localsend/localsend)
- **文件同步**: [Syncthing](https://github.com/syncthing/syncthing)
- **屏幕录制**: [OBS Studio](https://github.com/obsproject/obs-studio)
- **手机投屏**: [QtScrcpy](https://github.com/barry-ran/QtScrcpy)
- **包管理**: [UniGetUI](https://github.com/marticliment/UniGetUI)
- **软件卸载**: [Geek Uninstaller](https://geekuninstaller.com/download)
- **显示器亮度**: [Twinkle Tray](https://github.com/xanderfrangos/twinkle-tray)
- **系统工具**: [Dism++](https://github.com/Chuyu-Team/Dism-Multi-language) / [NTLite](https://www.ntlite.com/)
- **综合工具**: [图吧工具箱](https://www.tbtool.cn/)
- **文件搜索**: [Everything](https://www.voidtools.com/zh-cn/)
- **磁盘工具**: [DiskGenius](https://www.diskgenius.cn/)
- **密码管理器**: [KeePassXC](https://github.com/keepassxreboot/keepassxc)
- **终端/SSH**: [Electerm](https://github.com/electerm/electerm)


> 这里说一下Rime输入法在Windows端叫小狼毫，输入方案用的是[雾凇拼音](https://github.com/iDvel/rime-ice?tab=readme-ov-file) ，在``获取更多输入方案``中命令行输入``iDvel/rime-ice:others/recipes/full``安装。

> 传统意义上的三大件包括浏览器，编辑器以及密码管理器。

## 开发环境

### 搭建虚拟机环境

- Hyper-V

在 BIOS 中找到类似``Intel VT-x”、“AMD-V”或“Virtualization Technology``的选项，确保它是“Enabled”（启用）。随后按下 Win + S，输入“打开或关闭 Windows 功能”，在弹出的窗口中，找到 Hyper-V并启用，重启后即可出现。

- VMware

首先下载 [Vmware](https://www.423down.com/14542.html)，随后安装并[激活](https://www.ypojie.com/6066.html)，然后提前下载好所需系统的镜像，这里推荐[整合镜像站](https://help.mirrorz.org/)，并在Vmware中启动。

- Virtulbox

直接到[官网](https://www.virtualbox.org/wiki/Downloads)下载并安装。

- WSL

在``控制面板->程序->启用或关闭Windows功能``，选中适用于Linux的Windows子系统和虚拟机平台，待安装完成后重启电脑。

然后，在``管理员模式下打开 PowerShell 或 Windows 命令提示符``，方法是右键单击并选择“以管理员身份运行”，输入以下命令，然后重启计算机。

```
wsl --install
```
此命令将启用运行 WSL 并安装 Linux 的 Ubuntu 发行版所需的功能。（可以更改此默认发行版）。


> 使用 qemu-img 进行各种虚拟机格式转换

- qcow2 转 vmdk（VMware）
```
qemu-img convert -f qcow2 -O vmdk input.qcow2 output.vmdk
```
- qcow2 转 vdi（VirtualBox）
```
qemu-img convert -f qcow2 -O vdi input.qcow2 output.vdi
```
- qcow2 转 vhdx（新版 Hyper-V）

目前 qemu-img 不能直接输出 vhdx，但你可以先转成 vhd，再用微软工具（如 Convert-VHD）转换为 vhdx：
```
Convert-VHD -Path "output.vhd" -DestinationPath "output.vhdx" -VHDType Dynamic
```
- vhd转vhdx
在 PowerShell 中执行以下命令：​
```
Convert-VHD -Path "C:\路径\源文件.vhd" -DestinationPath "C:\路径\目标文件.vhdx" -VHDType Dynamic

# -Path：​指定原始 VHD 文件的路径。​
# -DestinationPath：​指定转换后 VHDX 文件的保存路径。​
# -VHDType：​指定磁盘类型，可选值为 Fixed（固定大小）或 Dynamic（动态扩展）。​
```
请确保虚拟机已关闭，并且 PowerShell 以管理员权限运行。

### 使用UniGetUI管理软件包

众所周知，windows下包管理向来是个老大难问题，各个软件包来源分散，难以统一更新，环境部署的包比较复杂，这里推荐使用[UniGetUI](https://github.com/marticliment/UniGetUI)来统一管理。（原名wingetUI）

- WingetUI 能够安装、更新和卸载 Winget（包括 Microsoft Store）、Scoop、Chocolatey、pip、npm 和 .NET Tool 中的软件包。
- WingetUI 还会检测您手动安装的应用程序是否可以更新！
它还可以升级和卸载以前安装的软件包 - 以及卸载内置的Windows应用程序！
- WingetUI 能够导入和导出您选择的软件包，以便您将来可以轻松安装它们。
- WingetUI 能够在安装前显示软件包相关信息（如许可证、SHA256 哈希值、主页等）。
- 有超过 14000 个可用软件包（如果启用 Winget、Scoop 和 Chocolatey）

### 使用IDE和代码编辑器

[Jetbrains](https://www.jetbrains.com.cn/ides/#choose-your-ide)向来是IDE中最知名的一款，功能丰富，界面美观，并具有多种语言支持；

[Visual Studio](https://visualstudio.microsoft.com/zh-hans/)VS是一个基本完整的开发工具集，它包括了整个软件生命周期中所需要的大部分工具，如UML工具、代码管控工具、集成开发环境(IDE)等等，可完美支持 C#、C++、Python、JavaScript、Node.js、Visual Basic、HTML 等流行的编程语言。

[VS Codium](https://github.com/VSCodium/vscodium)Visual Studio Code，也称为VS Code，是一款支持Linux，Windows和macOS的代码编辑器。它既能编辑简单文本，也能像集成开发环境（IDE）一样管理整个代码库。它还可以通过插件进行扩展，被广泛认为是一个可靠的文本编辑器，轻松打败其他编辑器,而VS Codium是一款开源的Vscode，去除了Trakcer和远程报告功能和可能侵犯你隐私的功能。

> Vscode SSH 连接

使用``Open Remote - SSH``插件，需要创建.ssh文件夹；Windows中在``C://users//username//``路径下。

随后使用插件新建一个连接，如：
```
Host myserver
    HostName 192.168.1.100
    User your_username
```
### 使用终端工具

在开发的时候我们常常遇到需要打开多个终端的情景，那么有没有一款工具可以将SSH/WSL/telnet/SFTP/串口通信一网打尽呢？

[MobaXterm](https://mobaxterm.mobatek.net/download.html)一款功能极其强大的远程连接工具，支持SSH、X11转发、串口通信等多种连接方式。它不仅可以用于远程连接Linux服务器，还可以模拟多个终端，实现多任务并行操作。此外，MobaXterm还提供了文件上传下载、终端模拟等实用功能。

[electerm](https://github.com/electerm/electerm)一款开源跨平台的SSH桌面终端管理软件中文版，Electerm 支持全平台 Linux，mac，win，它还可以帮助用户将其所有书签，主题和快速命令同步到 GitHub secret gist，它支持用户使用其文件管理器编辑远程文件，执行各种与终端相关的文件，同时还支持 SSH 和 SFTP 网络协议。

---
**Done.**