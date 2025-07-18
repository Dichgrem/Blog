+++
title = "Linux之旅(1):构成与发行版"
date = 2023-07-20

[taxonomies]
tags = ["Linux"]
+++



前言 Linux 作为一款强大、灵活且免费的操作系统，吸引了越来越多的用户。然而，对于初学者来说，Linux 可能显得有些陌生，甚至有些令人望而生畏。本文旨在为那些刚踏入 Linux 世界的新手提供一份指南，帮助他们更好地了解、使用这个令人着迷的操作系统。我们将探讨Linux的基本概念，解释为何选择Linux，深入剖析其主要构成要素以及不同的发行版之间的差异。
<!-- more -->
## 一.什么是Linux？

Linux 是一种开源的类 UNIX 操作系统内核。它由芬兰的 Linus Torvalds 于1991年开始开发，是一个自由、免费的操作系统。Linux 内核是操作系统的核心，负责管理硬件资源，并提供各种系统服务。与 Windows 和 macOS 等操作系统不同，Linux 的源代码对所有人开放，任何人都可以查看、修改和重新分发。这使得 Linux 具有极高的自由度和可定制性，用户可以根据自己的需求和偏好来定制操作系统。Linux 广泛应用于各种设备，包括个人计算机、服务器、手机、嵌入式系统等，是一个功能强大且灵活多样的操作系统。


## 二.为什么要用Linux？

1. **开源免费**：Linux 是完全开源的，用户可以免费使用和修改源代码。

2. **稳定性和安全性**：Linux 系统以其稳定性和安全性而闻名，适合长时间运行的服务。

3. **灵活性和可定制性**：用户可以根据需要定制 Linux 系统。

4. **广泛的软件支持**：有大量的开源软件可供选择，满足不同需求。

> Liunx可以用来玩游戏吗？
实际上著名的 Steam Deck 的系统就是基于Arch linux 的。对于个人使用而言，现在有不少原生支持linux 的游戏；也可以使用Wine来运行Windows下的游戏。

>Linux上软件会不会太少？
参见 [常用跨平台开源软件](https://blog.dich.ink/open-source-software)一文，在社区的努力下如今软件生态已经非常丰富，你也可以使用如Flatpak等商店安装软件，或者直接使用Wine。如果有不得不在Windows下使用的软件，可以装双系统。
## 三.Linux的主要构成

Linux操作系统主要由以下几个部分组成：

1. **内核**：操作系统的核心，负责管理系统资源。如Zen内核，LTS内核等。

2. **Shell**：命令行界面，用户通过它与系统交互，如Bash,Zsh等。

3. **图形用户界面（GUI）**：提供图形化操作界面，如GNOME、KDE、XFCE等。

4. **文件系统**：如ext4、Btrfs等，用于组织和管理磁盘上的文件。

5. **系统库**：为应用程序提供运行时支持。

6. **应用程序**：用户可以直接使用的软件，如文本编辑器、网页浏览器等。其中也有著名的GNU工具，如Vim,GCC等。


## 四.选择Linux发行版

从上文可以发现，选择Linux发行版实际上是在选择 **内核/包管理器/图形界面** 等组件的排列组合。其中最主要的因素是包管理器。

Linux有许多不同的发行版，但大致可以分为几个系：


**Debian系：**
Debian：Debian以稳定性，安全性和轻量级著称，适合用于服务器和桌面环境。我们常说的Ubuntu就是基于Debian的发行版，注重用户友好性和易用性。它提供了多种桌面环境选择，以及许多现成的软件包。
```
APT（Advanced Package Tool）是Debian系发行版的主要包管理器。它使用命令行工具如apt-get、aptitude等来管理软件包。
```
**Red Hat系：**
- Red Hat Enterprise Linux（RHEL）：RHEL是一款商业发行版，专注于企业级应用和支持。它提供了长期支持和专业技术支持服务，适用于企业级服务器和工作站。
- CentOS：CentOS是基于RHEL源代码编译而成的免费发行版，与RHEL兼容并提供类似的功能和性能。它也提供了长期支持版本和稳定性较高的特点。
- Fedora：Fedora是由Red Hat支持的社区驱动的发行版，注重提供最新的软件特性和技术。它适用于开发者和技术爱好者，提供了稳定的发布周期和丰富的软件包。
```
YUM（Yellowdog Updater, Modified）是Red Hat系发行版的主要包管理器。最近的版本也开始采用DNF（Dandified YUM）。
```
**Arch系：**
Arch Linux：Arch Linux是一个简洁、轻量级且灵活的发行版，注重简洁性和滚动更新。它采用“滚动发布”的方式，用户可以通过自定义安装来构建自己的系统，适合有一定Linux经验的用户。
```
Pacman（Package Manager）是Arch Linux的主要包管理器。它使用简洁的命令来管理软件包，如pacman -S安装软件包、pacman -Syu更新系统等。
```
**Gentoo系：**
Gentoo：Gentoo是一个源码驱动的发行版，用户可以通过源代码自定义编译软件包以满足自己的需求。它注重性能和灵活性，适合高级用户和技术爱好者。
```
Portage是Gentoo的包管理器，它是一个源代码驱动的包管理器，允许用户从源代码构建和安装软件包。
```
除了以上列举的包管理器外，还有其他一些较为特殊的包管理器，如Slackware系的pkgtool、SUSE系的zypper等。

对于个人使用而言，我个人建议新手使用Ubuntu,有比较易用的界面和完善的资料参考；如果你是一个系统极客，可以使用Arch linux 或者 NixOS。

## 五.个人日常使用需要注意什么？

1. **学习命令行**：命令行是Linux的强大工具，学习基本命令可以提高效率。

2. **选择合适的发行版**：根据个人需求和技术水平选择适合的发行版。

3. **系统备份**：定期备份重要数据，以防意外丢失。

4. **软件管理**：了解如何安装、更新和卸载软件。

5. **安全设置**：设置强密码，定期更新系统以修复安全漏洞。

6. **社区参与**：Linux社区非常活跃，遇到问题可以寻求社区帮助。

7. **硬件兼容性**：检查你的硬件是否与选择的Linux发行版兼容。

8. **驱动程序**：确保你的硬件设备有可用的驱动程序，以避免兼容性问题。

