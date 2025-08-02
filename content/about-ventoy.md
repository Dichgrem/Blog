+++
title = "乱七八糟:Ventoy战斗盘部署"
date = 2025-02-14

[taxonomies]
tags = ["乱七八糟"]
+++

前言 ​Ventoy 是一款开源免费的多系统启动盘制作工具，这里说明其主要功能的制作流程。

<!-- more -->

### 介绍

​Ventoy 是一款开源免费的多系统启动盘制作工具，旨在简化操作系统的安装过程。​与传统的启动盘制作方法不同，Ventoy 允许用户将多个操作系统的镜像文件``如 ISO、WIM、IMG、VHD(x)、EFI 等``直接复制到 U 盘，无需反复格式化或使用专门的工具写入镜像。

![ventoy](https://www.ventoy.net/static/img/screen/screen_uefi_cn.png?v=4)


## 目标

> PE启动盘 / ISO系统安装盘 / Win-to-go / Linux-to-go / 文件存储 五功能合一

## 制作流程

- 首先``在官网下载``[Ventoy](https://www.ventoy.net/cn/download.html)
- 随后在``language``中改为中文显示，可以看到左上角有``配置选项``
- 将分区类型设置为``GPT``，开启安全启动支持；
- 将``分区格式``设置为NTFS；
- 随后在``分区设置``中进行分区，选择在``磁盘后保留一段空间``，这里的空间将不被分区，即为空闲空间，可以当作普通的文件存储盘；
- Ventoy分区则会使用``U盘总容量-保留空间-ventoy保留分区``的空间新建一个盘，这里可以放``ISO、WIM、IMG、VHD(x)、EFI``等等
- 随后``选择磁盘``并开始安装；
- 制作完成后即可使用 ``BIOS Legacy``模式 或 ``UEFI`` 模式启动。

> 注意不可在PE环境下安装Ventoy！

## 文件存储盘

使用``DiskGenius``或其他磁盘工具，可以看到刚刚制作的磁盘有两个分区：ventoy保留分区(有文件)和Ventoy分区(无文件)以及一个空闲空间。

将空闲空间``格式化并新建磁盘``，随后会出现一个新的可用盘，``可以用这个盘进行存储``。

## PE启动盘制作

将PE的ISO文件放入Ventoy分区即可。常用PE:

- [微PE](https://www.wepe.com.cn/download.html)
- [HotPE](https://github.com/VirtualHotBar/HotPEToolBox)

## ISO系统安装盘

将要安装的系统的ISO镜像放入Ventoy分区即可。常用系统:

- [Ubuntu](https://ubuntu.com/download)
- [Debian-DVD](https://cdimage.debian.org/debian-cd/)
- [Windows](https://massgrave.dev/genuine-installation-media)

## Win-to-go

Ventoy 使用名为ventoy_vhdboot插件来支持直接启动 VHD(x) 文件(Win7以上).支持 Legacy BIOS 和 UEFI 模式。``支持固定大小以及动态扩展类型``的 VHD/VHDX 格式。

从下面任意一个链接中下载``ventoy_vhdboot.img``文件即可（几个链接中的文件都是一样的）。

- [Github](https://github.com/ventoy/vhdiso/releases)
- [蓝奏云/密码7my4](https://ventoy.lanzoub.com/b01dlxuaj) 

把下载后的文件放在U盘第1个分区（就是放ISO文件的分区）的 ventoy 目录下（默认没有这个目录，``需手动创建，注意大小写``），即 /ventoy/ventoy_vhdboot.img 就可以了。

随后将vhd或vhdx后缀的Windows虚拟机镜像放入其中即可出现在启动栏。

> 可以使用[Virtualbox](https://www.virtualbox.org/)创建Windows虚拟机并将镜像复制到ventoy中。

## Linux-to-go

Ventoy 使用``plugin_vtoyboot``插件来支持在物理机上直接启动安装了 Linux系统的 vdisk 文件 （vhd/vdi/raw 等）。这种模式的优点有：

- 系统是在真实物理机上运行，并不是在虚拟机里运行，``没有性能损失``。
- 同一个 vhd/vdi 文件``既可以在 Legacy BIOS 模式下启动，也可以在 UEFI 模式``下启动。
- Linux系统``无需独占一个磁盘或者分区``，相当于把一个完整的Linux系统放在一个文件里。 比如，你的主系统是 C 盘里的 Windows 系统，你可以在D盘里放一些
- Deepin、UOS、Ubuntu、Arch 等系统的 VHD 文件，想启动哪个选哪个，不用了就把对应的 VHD 文件删除即可。

支持的 vdisk 格式:

- ``固定大小的 vhd`` （注意只能是vhd, 不支持vhdx）
- ``固定大小的 vdi``
- ``Raw Disk 镜像``格式

### 安装 Linux 系统到 vdisk

VirtualBox中创建固定大小的 vhd/vdi，注意``只支持静态大小的，不支持动态扩展类型的``。然后把支持的 Linux 系统安装到 vhd/vdi 中即可。

注意：

- ``虚拟硬盘必须是全新创建的``，不能使用之前用过的。
- 新版本的 VirtualBox 在创建虚拟机时不要选择操作系统ISO文件，等创建完虚拟机之后再添加ISO文件进行安装。
- 安装系统时，VirtualBox ``必须设置为 UEFI 模式``！
- 注意，系统安装完之后``不能对虚拟机创建快照``，否则会导致 vdi/vhd 无法识别。

有一些系统安装完之后还需要再额外安装一个 grub 的包才可以，否则最终的 vhd/vdi 文件只能在 UEFI 模式下启动，无法在 Legacy BIOS 模式下启动。对于这种，在前面表格最后的 "备注" 一栏有说明，没有特殊说明的就不需要。详见[Linux vDisk 文件启动插件](https://www.ventoy.net/cn/plugin_vtoyboot.html)


### 在系统下执行 vtoyboot 脚本


- 安装完成并启动到 Linux 系统中之后，执行 vtoyboot 脚本。这一步是为了在系统中做一些处理，以支持Ventoy启动。

- vtoyboot 是配套 Ventoy 开发的一个项目，单独发布。从 https://github.com/ventoy/vtoyboot/releases 下载压缩包即可。

- 下载到 Linux 系统中，解压，然后以root权限执行里面的脚本 sudo bash vtoyboot.sh 脚本执行完之后，使用 poweroff 命令关机。

- 注意 vtoyboot 会经常更新以支持更多的 Linux 版本以及修复 BUG，所以请使用最新版本。

> 如果是对内核、驱动进行了升级、或者类似于通过 dnf update 命令进行了系统的大升级之后， 建议再重新执行一次 vtoyboot 脚本，防止下次重启之后vDisk文件无法启动。

随后拷贝到U盘，改后缀名为 .vtoy 然后用 Ventoy 启动即可。

---
**Done.**



