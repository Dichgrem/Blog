+++
title = "乱七八糟:Windows开发环境搭建"
date = 2024-05-28

[taxonomies]
tags = ["乱七八糟","Windows"]
+++

前言 刚刚拿到windows的小伙伴可能对开发环境比较陌生，这里对常用的开发环境设置进行总结。

<!-- more -->

首先我们默认windows版本为win11 23H2 专业工作站版，可以查看[上一期博客](https://blog.dich.bid/windows-optimization/).

## 搭建WSL环境

适用于 Linux 的 Windows 子系统 (WSL) 可让开发人员直接在 Windows 上按原样运行 GNU/Linux 环境，例如 Ubuntu、OpenSUSE、Kali、Debian、Arch Linux 等，并直接在 Windows 上使用 Linux 应用程序、实用程序和 Bash 命令行工具，不用进行任何修改，也无需承担传统虚拟机或双启动设置的开销。

首先，我们需要在``控制面板->程序->启用或关闭Windows功能``，选中适用于Linux的Windows子系统和虚拟机平台，容器以及hyper-v，待安装完成后重启电脑。

然后，在``管理员模式下打开 PowerShell 或 Windows 命令提示符``，方法是右键单击并选择“以管理员身份运行”，输入以下命令，然后重启计算机。

```
wsl --install
```
此命令将启用运行 WSL 并安装 Linux 的 Ubuntu 发行版所需的功能。（可以更改此默认发行版）。

### 一些其他命令

**列出可用的 Linux 发行版**
```
wsl --list --online
```


**列出已安装的 Linux 发行版**
```
wsl --list --verbose
```

**更新 WSL**
```
wsl --update
```


**检查 WSL 状态**
```
wsl --status
```


**关闭**
```
wsl --shutdown
```

立即终止所有正在运行的发行版和 WSL 2 轻量级实用工具虚拟机。 在需要重启 WSL 2 虚拟机环境的情形下，例如更改内存使用限制或更改 .wslconfig 文件，可能必须使用此命令。


**导出分发版**
```
wsl --export <Distribution Name> <FileName>
```
将指定分发版的快照导出为新的分发文件。 默认为 tar 格式。 在标准输入中，文件名可以是 -。 选项包括：

--vhd：指定导出分发版应为 .vhdx 文件而不是 tar 文件（这仅在使用 WSL 2 的情况下受支持）

**导入分发版**

```
wsl --import <Distribution Name> <InstallLocation> <FileName>
```
导入指定的 tar 文件作为新的分发版。 在标准输入中，文件名可以是 -。 选项包括：

--vhd：指定导入分发版应为 .vhdx 文件而不是 tar 文件（这仅在使用 WSL 2 的情况下受支持）
--version <1/2>：指定将分发版导入为 WSL 1 还是 WSL 2 分发版

## 搭建虚拟机环境

这里以 VMware Workstation Pro v17.6.0 为例，该软件支持安装包括windows/linux/macos等多种虚拟机。

首先下载 [Vmware](https://www.423down.com/14542.html)，随后安装并[激活](https://www.ypojie.com/6066.html)，然后提前下载好所需系统的镜像，这里推荐[整合镜像站](https://help.mirrorz.org/)，并在Vmware中启动。


## 搭建Docker

在 Windows 上部署 Docker 的方法是先安装一个虚拟机，并在安装 Linux 系统的的虚拟机中运行 Docker。

我们需要先开启 Hyper-V ，方法和搭建WSL一样； 也可以通过命令来启用 Hyper-V ，请右键开始菜单并以管理员身份运行 PowerShell，执行以下命令：
```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```
然后安装Docker，这里提供了一个图形安装界面：[Docker Desktop](https://docs.docker.com/desktop/install/windows-install/)  

安装时，如果你想使用WSL作为后端，则可以勾选 ``Use WSL2 instead of Hyper-V``，随后可以登录docker账号并换源等等。

## 使用UniGetUI管理软件包

众所周知，windows下包管理向来是个老大难问题，各个软件包来源分散，难以统一更新，环境部署的包比较复杂，这里推荐使用[UniGetUI](https://github.com/marticliment/UniGetUI)来统一管理。（原名wingetUI）

- WingetUI 能够安装、更新和卸载 Winget（包括 Microsoft Store）、Scoop、Chocolatey、pip、npm 和 .NET Tool 中的软件包。
- WingetUI 还会检测您手动安装的应用程序是否可以更新！
它还可以升级和卸载以前安装的软件包 - 以及卸载内置的Windows应用程序！
- WingetUI 能够导入和导出您选择的软件包，以便您将来可以轻松安装它们。
- WingetUI 能够在安装前显示软件包相关信息（如许可证、SHA256 哈希值、主页等）。
- 有超过 14000 个可用软件包（如果启用 Winget、Scoop 和 Chocolatey）

## 使用IDE和代码编辑器

[Jetbrains](https://www.jetbrains.com.cn/ides/#choose-your-ide)向来是IDE中最知名的一款，功能丰富，界面美观，并具有多种语言支持；

[Visual Studio](https://visualstudio.microsoft.com/zh-hans/)VS是一个基本完整的开发工具集，它包括了整个软件生命周期中所需要的大部分工具，如UML工具、代码管控工具、集成开发环境(IDE)等等，可完美支持 C#、C++、Python、JavaScript、Node.js、Visual Basic、HTML 等流行的编程语言。

[VS Codium](https://github.com/VSCodium/vscodium)Visual Studio Code，也称为VS Code，是一款支持Linux，Windows和macOS的代码编辑器。它既能编辑简单文本，也能像集成开发环境（IDE）一样管理整个代码库。它还可以通过插件进行扩展，被广泛认为是一个可靠的文本编辑器，轻松打败其他编辑器,而VS Codium是一款开源的Vscode，去除了Trakcer和远程报告功能和可能侵犯你隐私的功能。

## 使用终端工具

在开发的时候我们常常遇到需要打开多个终端的情景，那么有没有一款工具可以将SSH/WSL/telnet/SFTP/串口通信一网打尽呢？

[MobaXterm](https://mobaxterm.mobatek.net/download.html)一款功能极其强大的远程连接工具，支持SSH、X11转发、串口通信等多种连接方式。它不仅可以用于远程连接Linux服务器，还可以模拟多个终端，实现多任务并行操作。此外，MobaXterm还提供了文件上传下载、终端模拟等实用功能。

[electerm](https://github.com/electerm/electerm)一款开源跨平台的SSH桌面终端管理软件中文版，Electerm 支持全平台 Linux，mac，win，它还可以帮助用户将其所有书签，主题和快速命令同步到 GitHub secret gist，它支持用户使用其文件管理器编辑远程文件，执行各种与终端相关的文件，同时还支持 SSH 和 SFTP 网络协议。

