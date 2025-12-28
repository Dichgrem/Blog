+++
title = "Linux-优雅过渡"
date = 2023-06-20

[taxonomies]
tags = ["Linux"]
+++

前言 本文面向刚刚从Windows转向Linux的一般使用者和想在Linux上进行开发的开发者，主要说明其系统特点和使用须知。

<!-- more -->

## 0.启程

### 内核/发行版

Linux 是一种开源的类 UNIX 操作系统内核，广泛应用于各种设备，包括个人计算机、服务器、手机、嵌入式系统等。它由芬兰的 Linus Torvalds 于1991年开始开发，是一个自由、免费的操作系统。与 Windows 和 macOS 等操作系统不同，Linux 的源代码对所有人开放，任何人都可以查看、修改和重新分发。我们常常说的Linux，实际上是指各种发行版，比如Ubuntu，Arch Linux，Debian等等。

> Liunx可以用来玩游戏吗？
实际上著名的 Steam Deck 的系统就是基于Arch linux 的。对于个人使用而言，现在有不少原生支持linux 的游戏；也可以使用Wine来运行Windows下的游戏。


### Linux的主要构成

Linux操作系统主要由以下几个部分组成：

1. **内核**：操作系统的核心，负责管理系统资源。如Zen内核，LTS内核等。
2. **Shell**：命令行界面，用户通过它与系统交互，如Bash,Zsh等。
3. **图形用户界面（GUI）**：提供图形化操作界面，如GNOME、KDE、XFCE等。
4. **文件系统**：如ext4、Btrfs等，用于组织和管理磁盘上的文件。
5. **系统库**：为应用程序提供运行时支持。
6. **应用程序**：用户可以直接使用的软件，如文本编辑器、网页浏览器等。其中也有著名的GNU工具，如Vim,GCC等。

### 选择Linux发行版

从上文可以发现，选择Linux发行版实际上是在选择 **内核/包管理器/图形界面** 等组件的排列组合。其中最主要的因素是包管理器。

Linux有许多不同的发行版，但大致可以分为几个系：

**Debian系：**

- Debian：Debian以稳定性，安全性和轻量级著称，适合用于服务器和桌面环境。我们常说的Ubuntu就是基于Debian的发行版，注重用户友好性和易用性。它提供了多种桌面环境选择，以及许多现成的软件包。

- APT（Advanced Package Tool）是Debian系发行版的主要包管理器。它使用命令行工具如apt-get、aptitude等来管理软件包。

**Red Hat系：**
- Red Hat Enterprise Linux（RHEL）：RHEL是一款商业发行版，专注于企业级应用和支持。它提供了长期支持和专业技术支持服务，适用于企业级服务器和工作站。
- CentOS：CentOS是基于RHEL源代码编译而成的免费发行版，与RHEL兼容并提供类似的功能和性能。它也提供了长期支持版本和稳定性较高的特点。
- Fedora：Fedora是由Red Hat支持的社区驱动的发行版，注重提供最新的软件特性和技术。它适用于开发者和技术爱好者，提供了稳定的发布周期和丰富的软件包。
- YUM（Yellowdog Updater, Modified）是Red Hat系发行版的主要包管理器。最近的版本也开始采用DNF（Dandified YUM）。

**Arch系：**

- Arch Linux：Arch Linux是一个简洁、轻量级且灵活的发行版，注重简洁性和滚动更新。它采用“滚动发布”的方式，用户可以通过自定义安装来构建自己的系统，适合有一定Linux经验的用户。

- Pacman（Package Manager）是Arch Linux的主要包管理器。它使用简洁的命令来管理软件包，如pacman -S安装软件包、pacman -Syu更新系统等。

**Gentoo系：**

- Gentoo：Gentoo是一个源码驱动的发行版，用户可以通过源代码自定义编译软件包以满足自己的需求。它注重性能和灵活性，适合高级用户和技术爱好者。

- Portage是Gentoo的包管理器，它是一个源代码驱动的包管理器，允许用户从源代码构建和安装软件包。

除了以上列举的包管理器外，还有其他一些较为特殊的包管理器，如Slackware系的pkgtool、SUSE系的zypper等。

对于个人使用而言，我个人建议新手使用Ubuntu,有比较易用的界面和完善的资料参考；如果你是一个系统极客，可以使用Arch linux 或者 NixOS。

## 1.初探FHS

李华是一个从WindowsXP时代一直使用到Win11的微软“老资历”用户，这一天，他下定决心要学会使用Linux！于是他按照网上CSDN的教程，在VMware中安装了大名鼎鼎的Ubuntu系统！但很快他发现，为什么系统里面``没有C盘和D盘``，只有一个神秘的``/``和一堆奇怪的英文？

在 Windows 的世界里，存储设备是用字母区分的，比如``C: D: E:``等等。但Linux 不给磁盘分字母，它采用的是一种叫做 ``FHS（Filesystem Hierarchy Standard，文件系统层次结构标准``） 的方式来组织系统。在 FHS 的世界里，整个系统就像一棵树：

- 树根是 /（根目录）
- 所有磁盘、分区、U盘、设备都会被“挂载（mount）”到这棵树的某个枝丫上

因此对于Linux而言，文件系统是这样的：

```bash
/      — 根
/home  — 用户家目录
/root  — 超级用户的家
/bin   — 基础命令/二进制文件
/sbin  — 管理命令
/usr   — 大多数程序和资源
/lib   — 库文件
/etc   — 配置文件
/var   — 日志、缓存、变化的数据
/tmp   — 临时文件
/dev   — 设备文件
/media — 自动挂载U盘
/mnt   — 手动挂载点
/opt   — 第三方软件
/boot  — 系统启动文件
/proc  — 虚拟进程信息
/sys   — 虚拟硬件信息
/run   — 系统运行状态
```
其中Home目录类似Windows上的``C:\Users\你的名字``，里面有``桌面/文档/下载/图片/音乐/视频/``，是不是非常眼熟？

可以看出，Linux下是不用专门分出系统盘和数据盘的，某种意义上解决了Windows的C盘空间不足红色爆满的问题。

> 小知识：为什么Windows上是“\”而Linux是“/”？ Unix 在1970年代就使用“/”，诞生于 1980 年代的 MS-DOS 本来也是用“/”的！但后来微软加入了命令行参数（如 /help），和路径冲突了。为了区分选项和路径，微软紧急决定：“/” 用来当选项前缀（至今仍如此：dir /a），文件路径改用“\”，于是 Windows 专门和全世界不一样。

> 并非所有Linux发行版都遵守FHS，比如Nixos.

理解了FHS，下一步就是，要如何安装软件呢？

## 2.包管理器与ELF

在windows中，当我们想要安装某个软件的时候，第一时间就是去寻找``EXE安装包``，而后点击安装-确定，软件就出现在桌面了！但李华很快发现，他将下载的EXE文件放在Ubuntu的桌面并点击，显示无法运行？

这是因为Linux下不使用Windows的PE格式，而是用ELF格式；这并不是说李华得手动一个个下载ELF并点击运行，实际上Linux上使用的是名为``包管理器``的方法。

在Ubuntu的界面中李华看到了一个名为``终端``的应用，输入``apt install neofetch``，就安装成功...不，暂时还没有成功,再次输入``sudo apt install neofetch``,就成功安装了neofetch这个软件，随后我们输入``neofetch``，可以看到系统的一些信息：

```bash
❯ neofetch
            .-/+oossssoo+/-.               dich@uos
        `:+ssssssssssssssssss+:`           --------
      -+ssssssssssssssssssyyssss+-         OS: Ubuntu 24.04.3 LTS x86_64
    .ossssssssssssssssssdMMMNysssso.       Host: KVM/QEMU (Standard PC (Q35 + ICH9, 2009) pc-q35-10.0)
   /ssssssssssshdmmNNmmyNMMMMhssssss/      Kernel: 6.14.0-35-generic
  +ssssssssshmydMMMMMMMNddddyssssssss+     Uptime: 2 mins
 /sssssssshNMMMyhhyyyyhmNMMMNhssssssss/    Packages: 2522 (dpkg), 12 (snap)
.ssssssssdMMMNhsssssssssshNMMMdssssssss.   Shell: zsh 5.9
+sssshhhyNMMNyssssssssssssyNMMMysssssss+   Resolution: 1280x800
ossyNMMMNyMMhsssssssssssssshmmmhssssssso   Terminal: /dev/pts/0
ossyNMMMNyMMhsssssssssssssshmmmhssssssso   GPU: 00:01.0 Red Hat, Inc. Virtio 1.0 GPU
+sssshhhyNMMNyssssssssssssyNMMMysssssss+   Memory: 1126MiB / 13976MiB
.ssssssssdMMMNhsssssssssshNMMMdssssssss.   
 /sssssssshNMMMyhhyyyyhdNMMMNhssssssss/
  +sssssssssdmydMMMMMMMMddddyssssssss+
   /ssssssssssshdmNNNNmyNMMMMhssssss/
    .ossssssssssssssssssdMMMNysssso.
      -+sssssssssssssssssyyyssss+-
        `:+ssssssssssssssssss+:`
            .-/+oossssoo+/-.
```

可见，在Linux上安装软件其实比Windows的简单，只需一行命令，包管理器会从``源``下载软件包，并进行解压，``处理依赖项/动态链接/环境变量``等等；这并非代表不安全，Linux上大部分是开源软件；关于开源软件，日后我们再进行说明。那么，如何知道安装需要的命令呢？

我们可以从Ubuntu的软件源``https://packages.ubuntu.com/``上搜索软件包的名字，输入关键字（如 firefox、python、vlc），它会列出：

- 软件包的准确名字
- 所属版本（如 24.04、22.04）
- 依赖关系
- 下载链接（如果你想手工装）

或者使用``apt search 包名``；如果apt没有某个包，还可以使用``AppImage / Flatpak / Snap``等等管理器来下载。

> 包管理器常用命令

| 功能           | apt（Ubuntu/Debian）                          | paru/pacman（Arch/Manjaro）        | 说明                           |
| ------------ | ------------------------------------------- | -------------------------------- | ---------------------------- |
| 更新软件包索引      | `sudo apt update`                           | `sudo paru -Sy`                  | 先更新仓库信息                      |
| 升级已安装的软件     | `sudo apt upgrade`                          | `sudo paru -Syu`                 | 升级所有已安装的软件（包含系统更新）           |
| 安装软件包        | `sudo apt install <package>`                | `sudo paru -S <package>`         | 安装指定软件                       |
| 移除软件包（保留配置）  | `sudo apt remove <package>`                 | `sudo paru -R <package>`         | 删除软件包，但保留配置文件                |
| 完全删除软件包（含配置） | `sudo apt purge <package>`                  | `sudo paru -Rns <package>`       | 删除软件包及依赖、配置文件                |
| 搜索软件包        | `apt search <package>`                      | `paru -Ss <package>`             | 查找仓库中的软件包                    |
| 查看已安装软件      | `apt list --installed`                      | `paru -Q`                        | 列出系统已安装软件                    |
| 查看软件信息       | `apt show <package>`                        | `paru -Si <package>`             | 显示软件包详细信息                    |
| 自动清理无用依赖     | `sudo apt autoremove`                       | `sudo paru -Rns $(pacman -Qdtq)` | 删除不再需要的依赖包                   |
| 清理下载缓存       | `sudo apt clean`                            | `sudo paru -Sc`                  | 删除已下载的软件包缓存                  |
| 升级单个软件包      | `sudo apt install --only-upgrade <package>` | `sudo paru -S <package>`         | 仅升级指定软件                      |


> AppImage：可直接运行，像“可携带版 EXE”;Flatpak：沙盒化、现代、安全;Snap：由 Ubuntu 官方主推;第三方仓库 PPA：常见于开发版软件...

> 如果你使用其他Linux发行版，也有对应的包管理器。比如Arch的Pacman/Paru，Fedora 的 dnf，openSUSE 的 zypper，NixOS 的 nix...

> 实际上Windows上也是有包管理的，比如 Windows 10/11 内置的 winget（Windows Package Manager），choco（Chocolatey），scoop...由于历史原因不为大部分人所熟悉.可以使用这个项目[UniGetUI](https://github.com/marticliment/UniGetUI)在Windows上方便的进行包管理.

## 3.权限系统/Sudo/Root

还记得前面我们使用的``sudo apt install xxx``吗？为什么不加上sudo就无法运行呢？这其实和Linux的权限系统有关.在Windows中有些无法直接运行的软件，需要右键单击并选择``以管理员权限运行``.这表示某个操作会修改系统，需要管理员（Administrator）的允许。Linux 也有类似的概念，但名字不一样，Linux 的管理员叫：``root``.

在Linux中，普通用户（如你的账户）只能管理自己的文件、自己的程序
，而root 用户能管理整个系统、安装软件、删除系统文件、修改配置；所以，日常使用的时候不是“管理员账号”，而是一个安全的普通用户。`sudo`（super user do）就是：“请允许我**暂时**以 root 的身份执行这一条命令。”

为什么不用 root 账号直接登录呢？因为 root 太强大了：

- 可以删掉任何文件
- 可以覆盖系统配置
- 可以误操作把系统搞到无法启动

所以日常使用 root 类似于：“天天坐在一个自带核弹按钮的办公桌前”。这就是为什么 Linux 默认让你用普通用户，然后用 `sudo` 临时提升权限。

当李华学会使用 `sudo` 后，他又开始好奇：

> “为什么有些文件我能读，有些不能？
> 为什么有些文件能执行，有些却提示权限不够？”

Linux 的权限可以简单理解为``UGO+RWX``.

- UGO由用户（User）/ 用户组（Group）/ 其他人（Others）构成，每个文件都有 Owner（所有者）和 Group（用户组）。

- RWX权限分为 **r 读 / w 写 / x 执行**，并以类似 `-rwxr-x---` 的形式展示（文件类型 + Owner 权限 + Group 权限 + Others 权限）。

- **用户组（Group）** 是“权限相同的用户集合”，如：`sudo` 组能用 sudo，`audio` 组能访问音频，`video` 组能用 GPU，`docker` 组能管理容器。Linux 通过把用户加入不同组来决定他们能操作什么。

- **chmod** 用于修改权限：`chmod +x a.sh`（所有人加执行权限），`chmod u+x`（给 Owner 加执行权限），`chmod g-w`（去掉 Group 写权限），`chmod o-r`（禁掉 Others 读权限）。数字模式如 `755`、`644` 表示 r/w/x 的数字和（``r=4, w=2, x=1``）：例如 `755` = Owner(rwx) / Group(r-x) / Others(r-x)。

比如创建一个新用户，可以使用``sudo adduser <用户名>``，授予这个用户sudo权限可以使用``sudo usermod -aG sudo <用户名>``.

## 4.命令行

看到这里，李华发觉Linux很多操作都是命令行式的，在终端里面操作的，但李华不知道有那些命令可以使用，于是李华找了一些网站，并尝试了一些常用的命令：

- Linux命令查询：[linux-command](https://wangchujiang.com/linux-command/hot.html)
- Linux常用命令表：[Quick Reference](https://wangchujiang.com/reference/docs/linux-command.html)

```bash
❯ date
Sun Nov 16 09:16:15 PM +08 2025
❯ uname -a
Linux dos 6.17.7-cachyos #1-NixOS SMP PREEMPT_DYNAMIC Sun Nov  2 13:18:05 UTC 2025 x86_64 GNU/Linux
❯ uptime
 21:16:23  up   4:54,  0 users,  load average: 0.79, 0.74, 0.70
❯ ls
Data   Desktop   Documents   Downloads   Git   go   Picback   Pictures
❯ cd ./Downloads
~/Downloads
```

李华很好奇：这些 `ls`、`cd`、`uname`、`date` 等命令究竟来自哪里？它们是 Linux 内置的吗？其实，Linux 里的命令大致可以分为三类：**Shell 内建命令、外部二进制程序、BusyBox 提供的工具**。

- 一些命令是由 Shell 自己实现的，例如`cd` `echo` `pwd` `export` `alias` `history`这些命令不需要执行外部程序，由 Shell 本身的代码直接完成。可以用下面的方式判断命令是否是内建的：

```bash
type cd
# cd is a shell builtin
```

- 大多数常用命令是独立的可执行文件，例如 `/usr/bin/ls`、`/usr/bin/date`，它们通常来自一个叫 **coreutils（GNU Core Utilities）** 的软件集合。可以用 `which` 查看一个命令的真实位置：

```bash
which ls
# /usr/bin/ls
```
这类命令本质上是：ELF 可执行文件/被内核加载/在用户空间运行

- 在一些精简 Linux（例如 Alpine、OpenWrt中），命令不来自 GNU coreutils，而来自一个叫 **BusyBox** 的单程序。BusyBox 只一个二进制文件，但内部包含了上百个命令，这种方式体积小，适用于嵌入式设备。

```bash
/bin/busybox ls
/bin/busybox cp
/bin/busybox tar
```

## 5.Shell/Terminal/TTY

随着李华在系统中的探索，李华发现常常遇到诸如``Terminal，Console，bash,zsh,shell,tty``等概念，这些概念常常被混淆，似乎都和命令行相关，但又不太清楚它们之间是什么关系？

### 终端和控制台

终端，英文叫做 terminal ,通常简称为 term；控制台，英文叫做 console。

要明白这两者的关系，还得从最初的计算机说起。当时的计算机价格昂贵，一台计算机一般是由多个人同时使用的。在这种情况下一台计算机需要连接上许多套键盘和显示器来供多个人使用。在以前专门有这种可以连上一台电脑的设备，只有显示器和键盘，还有简单的处理电路，本身不具有处理计算机信息的能力，他是负责连接到一台正常的计算机上（通常是通过串口） ，然后登陆计算机，并对该计算机进行操作。当然，那时候的计算机操作系统都是多任务多用户的操作系统。这样一台``只有显示器和键盘能够通过串口连接到计算机的设备就叫做终端``。

而控制台又是什么回事呢？其概念来自于管风琴的控制台。顾名思义，控制台就是一个直接控制设备的台面（一个面板，上面有很多控制按钮）。 在计算机里，把那套``直接连接在电脑上的键盘和显示器就叫做控制台``。

终端是通过串口连接上的，不是计算机本身就有的设备，而控制台是计算机本身就有的设备，一个计算机只有一个控制台。计算机启动的时候，所有的信息都会显示到控制台上，而不会显示到终端上。也就是说，``控制台是计算机的基本设备，而终端是附加设备``。 当然，由于控制台也有终端一样的功能，控制台有时候也被模糊的统称为终端。

以上是控制台和终端的历史遗留区别。现在由于计算机硬件越来越便宜，终端和控制台的概念也慢慢演化了。``终端和控制台由硬件的概念，演化成了软件的概念``。

### 内核与外壳

内核（ Kernel ）和外壳（ Shell ）是 linux 的两个主要部分。Kernel 是操作系统的核心，系统的文件管理、进程管理、内存管理、设备管理这些功能，都是由 Kernel 提供的。

用户和操作系统内核交流需要一个工具，那么这个工具就是 Shell。

什么是 Shell？在 Linux 中，最常见的 Shell 形式有命令行界面命令行界面和图形界面两种。并不是打开的那个终端窗口就是 Shell，如Alacritty、Gnome-Terminal、xterm 、kitty等程序，它们不是 Shell，而它们里面``运行的 Bash、Zsh、fish 等命令行解释器程序，才是 Shell``。

那``Alacritty、Gnome-Terminal、xtermxterm``是什么？

它们是``终端模拟器``。

前面提到过，在远古时代，终端和控制台都是有实体的。控制台直接和计算机在一起，你可以通过控制台控制计算机。终端通过数据线和计算机连接，终端也提供一个键盘和一个屏幕，你可以通过键盘向计算机下达指令，然后通过屏幕观察输出。

但是现在的计算机组成和以前不一样了，一般一台电脑都是自带键盘和屏幕，很少再外接终端设备。

所以 Linux 提供了另外一个更高级的功能，那就是虚拟终端。那就是在一台电脑上，通过软件的模拟，好像有好几个终端连接在这台计算机上一样。

``现在说的终端，比如 linux 中的虚拟终端，都是软件的概念``。虚拟终端称之为 tty，tty 是电传打字机电传打字机 Teletypewriter 的缩写，在带显示屏的视频终端出现之前，tty是最流行的终端设备。每一个 tty 都有一个编号，在/dev目录下有相应的设备文件。其中/dev/tty1到/dev/tty7可以通过 Ctrl+Alt+F1 到 Ctrl+Alt+F7 进行切换，也可以通过 chvt 命令进行切换，就好比是以前多人公用的计算机中的六个终端设备，这就是为什么这个叫“虚拟终端”的原因。

> 如果你现在使用linux，可以使用Ctrl+Alt+F2切换到TTY界面！


## 6.DE/WM/Wayland/X11

在 Windows 上，图形界面是系统密不可分的一部分。但李华发现，他安装的 Ubuntu 界面叫 GNOME，而他同学安装的 Mint 界面却是 Cinnamon，而且他听说还有 KDE、XFCE 等等，这让他感到困惑。

在 Linux 中，``图形界面是可以高度定制和替换的``。它主要由以下几个核心组件构成：

- 桌面环境（Desktop Environment, DE）

**桌面环境（DE）** 是一整套完整的、提供图形化操作体验的软件集合。它包括了：
```
窗口管理器（Window Manager, WM）：负责绘制窗口边框、最大化/最小化按钮、控制窗口的移动和堆叠。
文件管理器：如 Nautilus (GNOME)、Dolphin (KDE)。
面板/任务栏：提供应用启动器、系统托盘、时钟等。
显示管理器（Display Manager, DM）：负责登录界面（如 GDM, LightDM）。
一系列配套应用：如文本编辑器、图片查看器等。
```
- 窗口管理器（Window Manager, WM）

**窗口管理器（WM）** 是 DE 的核心组件之一，但也可以独立运行。如果你不需要一个完整的桌面环境（如文件管理器、面板等），只想要管理窗口的显示和布局，就可以只安装一个 WM。

| 常见 DE                            | 常见 WM                                          |
| -------------------------------- | ---------------------------------------------- |
| [KDE](https://docs.kde.org/)     | [i3](https://i3wm.org/)                        |
| [Xfce](https://docs.xfce.org/)   | [niri](https://github.com/YaLTeR/niri)         |
| [Gnome](https://help.gnome.org/) | [qtile](https://github.com/qtile/qtile/)       |
| —                                | [bspwm](https://github.com/baskerville/bspwm)  |
| —                                | [Hyprland](https://github.com/hyprwm/Hyprland) |
| —                                | [awesomewm](https://awesomewm.org/)            |


### 图形协议：X11 与 Wayland

无论是 DE 还是 WM，它们都需要一套机制来告诉应用程序“在哪里绘制一个按钮”、“如何响应鼠标点击”等。这就是 **图形显示协议**。

* **X Window System（X11/Xorg）：** 历史悠久、功能强大但结构复杂的图形协议，已经使用了几十年。它的设计初衷是网络透明——理论上你可以在一台机器上运行程序，并在另一台机器上显示其图形界面。
* **Wayland：** X11 的现代替代品。它设计更简洁、安全性更高、性能更好，尤其是在高分屏和混合刷新率显示器上。目前 GNOME 和 KDE 都在积极转向 Wayland。

> 对于新手，建议直接使用主流发行版的默认 DE（如 Ubuntu 的 GNOME 或 CachyOS 的 KDE），它们都提供了完整的用户体验。如果你是开发者或极客，可以尝试平铺式 WM，并关注 Wayland 的发展。


## 7.XDG

李华在折腾 GNOME 桌面时，发现很多配置文件夹都藏在 `~/.config` 下，而缓存文件在 `~/.cache`，下载的应用数据却在 `~/.local/share`。他发现这比 Windows 时代全部扔在 `C:\Users\username\AppData` 里规范多了！

这套规范就是 **XDG 基础目录规范（XDG Base Directory Specification）**，它是 Freedesktop.org（一个致力于桌面环境互操作性的组织）推广的一项标准。

XDG 规范的核心思想是将用户的文件按照用途分离，而不是像 Windows 那样把所有数据都塞进一个 `AppData` 文件夹。

| 环境变量/目录 | 默认路径（若未设置）             | 用途                                                     |
| :---------- | :----------------------------- | :----------------------------------------------------- |
| `$XDG_CONFIG_HOME` | `~/.config`                    | 存放**用户配置文件**（Configuration files）。                    |
| `$XDG_CACHE_HOME`  | `~/.cache`                     | 存放**非关键的缓存文件**（Cache files），可以随时删除。          |
| `$XDG_DATA_HOME`   | `~/.local/share`               | 存放**应用程序生成的用户数据**（Data files），如游戏存档、下载的图标等。 |
| `$XDG_RUNTIME_DIR` | 通常是 `/run/user/$(id -u)` | 存放**运行时文件**，生命周期与用户登录会话一致，重启或注销后消失。     |

通过遵守 XDG 规范，可以带来很多好处：

- **清理更方便：** 想清理缓存？直接删除 `$XDG_CACHE_HOME` 下的文件即可，不会误删配置。
- **备份更清晰：** 只需要备份 `$XDG_CONFIG_HOME` 就可以保留所有应用程序的配置。
- **兼容性更好：** 不同 Linux 发行版和桌面环境下的应用程序都能遵循一致的目录结构。

## 8.DEV（面向开发者）

对于想在 Linux 上进行开发的李华来说，Linux 简直是为开发而生的系统。由于其开源、类 UNIX 的特性，它在软件开发领域拥有巨大的优势。

Linux 默认提供了强大的 GNU 工具链：

* **GCC/Clang：** 编译 C/C++ 等语言。
* **Make/CMake：** 构建自动化工具。
* **Git：** 版本控制的行业标准，Linux 对其支持极佳。
* **Bash/Zsh/Shell Scripting：** 强大的命令行脚本能力，用于自动化运维。
* **Docker/Podman：** 容器化技术在 Linux 上天然且高效。

在 Windows 上，安装 Python 或 Node.js 往往需要下载安装包并手动设置环境变量，管理多版本很麻烦。在 Linux 上，这变得非常优雅：

* **包管理器：** 可以直接通过 `apt` 或 `pacman` 安装主流编程语言及其依赖。
* **版本管理器：** 开发者通常会使用专门的工具来隔离和管理不同项目的语言版本，例如：
* **Python：** `pyenv`
* **Node.js：** `nvm`
* **Go：** `gvm`
* **Ruby：** `rvm` / `rbenv`

Linux 的内核天然支持 **Cgroups** 和 **Namespaces**，这是 **Docker** 和 **Kubernetes** 等容器化技术的基础。

* **Docker：** 在 Linux 上运行 Docker 几乎没有性能损耗，是开发、测试和部署微服务的理想平台。
* **KVM/QEMU：** 内置的高性能虚拟化技术，相比 Windows 的 Hyper-V 或 VMware，性能更好更通用。

---
**Done.**
