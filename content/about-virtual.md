+++
title = "乱七八糟:虚拟化常用设置与操作"
date = 2024-08-16

[taxonomies]
tags = ["乱七八糟"]
+++

前言 本文记录常用虚拟化平台的使用与操作，包括Vmware，Hypr-v，QEMU等等。
<!-- more -->

# 一.Vmware

## 下载

Vmware最新版本对个人已经免费，不需要再寻找激活码；

由于博通官网下载Vmware需要登录账号，这里给出第三方下载站链接：[techspot](https://www.techspot.com/downloads/189-vmware-workstation-for-windows.html)

## 安装ubuntu虚拟机

**前期准备**

* 下载 Ubuntu ISO 镜像
* 确保你的主机支持虚拟化（Intel VT-x / AMD-V），并在 BIOS/UEFI 中启用

**开始安装**

1. 启动 VMware → 选择 “Create a New Virtual Machine” 或 “新建虚拟机”。
2. 在安装来源 (Installer source) 页选择 “Installer disc image file (ISO)” → 浏览并选中你下载的 Ubuntu ISO 文件。
3. 在“Guest OS Family / 来宾操作系统类型”中选择 **Linux**。
4. 在 OS 版本中选择 “Ubuntu 64-bit” 或者 “Other Linux 64-bit”（如果没有明确 Ubuntu 选项）。
5. 给虚拟机起一个名字，例如 “Ubuntu-VM”。
6. 指定存放虚拟机文件 (.vmx, .vmdk 等) 的文件夹位置。默认位置在``C:\Users\<你的用户名>\Documents\Virtual Machines\<虚拟机名称>\``下.
7. 在磁盘设置部分设置虚拟磁盘大小，推荐 **25-40 GB**。选择把虚拟磁盘存为一个文件或拆分为多个文件，这两种方式各有优劣（一个文件通常略快些）。
8. 自定义硬件设置

| 硬件          | 推荐配置 / 注意事项                              |
| ----------- | ---------------------------------------- |
| CPU 核心数     | 2 或更多                                    |
| 内存          | 至少 4 GB，若要流畅用 GNOME 桌面建议 8 GB            |
| 显示适配        | 开启 3D 加速（如果 VMware 支持）                   |
| 硬盘控制器类型     | 通常 VMware 默认就行，SATA/SCSI，一般 Ubuntu 支持都不错 |
| 网卡          | 使用 NAT 或桥接，根据是否要虚拟机直接在局域网中可访问来定  |

9. 启动虚拟机并选择“Install Ubuntu”。
10. 安装 VMware Tools 或 Open-VM-Tools

安装这些工具能增强体验，例如鼠标整合、屏幕分辨率自动调整、剪贴板共享等等。

Ubuntu 的方式通常是用 `open-vm-tools` 包：

```bash
sudo apt update
sudo apt install open-vm-tools-desktop
sudo reboot
```

### FAQ

* 屏幕分辨率不能拉大／全屏：安装 open-vm-tools + open-vm-tools-desktop；开启 3D 支持；在虚拟机设置里提升视频内存。
* 虚拟机启动慢：给虚拟机分配更多 RAM／CPU；关闭不必要的服务；确保主机虚拟化支持开启。
* 无法挂载 ISO 或虚拟光驱：检查虚拟机设置里 CD/DVD 光驱是否连接；ISO 文件是否损坏。
* 时间不对同步差：安装 VMware 工具通常能解决时间同步；也可手动配置 NTP 服务。
* 网络不通：检查虚拟机网卡类型；如果用 NAT，看主机网络；如果用桥接，看是否有权限或防火墙问题。

## 二.Hyper-V

Hyper-V 是微软内建的虚拟化平台（native hypervisor）。开启后，它会占用硬件虚拟化特性（Intel VT-x / AMD-V），这可能会和 VMware、VirtualBox 等第三方虚拟化软件冲突。

## 开启 Hyper-V

* PowerShell（以管理员权限运行）：

```bash
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

* DISM（部署映像服务和管理工具）：

```bash
DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
```

* Windows 功能 GUI 操作：
在``控制面板 → 程序和功能 → 启用或关闭 Windows 功能``中勾选 “Hyper-V”、 “Hyper-V 平台”、 “Hyper-V 管理工具” 等相关项目，然后按提示操作。

## 关闭 Hyper-V

* PowerShell（管理员权限）：

```bash
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
```

* DISM：

```bash
DISM /Online /Disable-Feature:Microsoft-Hyper-V
```

* 用 bcdedit 修改启动配置，使系统启动时不加载 Hypervisor（Hyper-V 的虚拟化内核）但保留功能安装：

```bash
bcdedit /set hypervisorlaunchtype off
```

若要恢复加载，则：

```bash
bcdedit /set hypervisorlaunchtype auto
```

* Windows 功能 GUI 中，取消勾选 Hyper-V 相应项。

## 使用方法

下面是几个典型的场景和命令：

1. **给 VMware 或 VirtualBox 使用环境临时关闭 Hyper-V**

```bash
bcdedit /set hypervisorlaunchtype off
```

然后重启 Windows，就能让这些软件正常启动虚拟机。要还原 Hyper-V，改为 `auto` 或 `on`:

```bash
bcdedit /set hypervisorlaunchtype auto
```

2. **从命令行完全关闭 Hyper-V 功能**

```bash
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
```

或者用 DISM：

```bash
DISM /Online /Disable-Feature:Microsoft-Hyper-V
```

3. **检查当前 Hyper-V 是否正在运行**

* 用 `msinfo32.exe`（系统信息）看 “Hyper-V Requirements” 部分，或者在命令提示符／PowerShell 用 `systeminfo` 查看是否显示 “Hypervisor has been detected” 之类信息。

4. **用 GUI 控制 Windows 功能开关**

* 打开 `控制面板 → 程序 → 启用或关闭 Windows 功能`
* 勾选 “Hyper-V” 及 Hyper-V 平台 / 虚拟机平台等
* 点击确定，重启即可。

## FAQ

* Windows 家庭版（Home）通常不提供完整的 Hyper-V 功能 GUI，但系统中某些虚拟化基于安全的功能（例如 VBS、Core Isolation / Memory Integrity）依然可能启用，这样也会表现为“Hyper-V 在运行”，建议更换到专业工作站版本。
* 部分软件（如 Android 模拟器、BlueStacks 等）在检测到 Hyper-V 存在时性能可能受影响，关闭后可能解决问题。比如Steam游戏，安卓模拟器，HCL等等。

## 三.QEMU

## 备份

QEMU安装的系统默认在此位置下，可以使用Root用户将其复制到其他位置并备份：

```bash
[root@dos:/var/lib/libvirt/images]ls
ubuntu24.04-2.qcow2
```

## 格式转换

QEMU默认使用qcow2格式，几乎可以转换为所有其他虚拟机格式；我们可以使用`qemu-img`（QEMU 提供的镜像管理工具）来创建、转换、检查、调整虚拟机磁盘镜像。

**基本语法**：

```bash
qemu-img [command] [options] filename
```

**镜像格式转换命令大全**

`qemu-img convert -f <源格式> -O <目标格式> <源文件> <目标文件>`

**常见虚拟机平台格式**：

| 平台/软件             | 格式       | 示例扩展名            |
| ----------------- | -------- | ---------------- |
| QEMU/KVM          | qcow2    | `.qcow2`         |
| VirtualBox        | vdi      | `.vdi`           |
| VMware            | vmdk     | `.vmdk`          |
| Microsoft Hyper-V | vhd/vhdx | `.vhd` / `.vhdx` |
| Xen               | raw      | `.img`           |

* ``raw ↔ qcow2``

```bash
# raw → qcow2
qemu-img convert -f raw -O qcow2 disk.img disk.qcow2

# qcow2 → raw
qemu-img convert -f qcow2 -O raw disk.qcow2 disk.img
```

* ``qcow2 ↔ vdi (VirtualBox)``

```bash
# qcow2 → vdi
qemu-img convert -f qcow2 -O vdi disk.qcow2 disk.vdi

# vdi → qcow2
qemu-img convert -f vdi -O qcow2 disk.vdi disk.qcow2
```

* ``qcow2 ↔ vmdk (VMware)``

```bash
# qcow2 → vmdk
qemu-img convert -f qcow2 -O vmdk disk.qcow2 disk.vmdk

# vmdk → qcow2
qemu-img convert -f vmdk -O qcow2 disk.vmdk disk.qcow2
```

* ``qcow2 ↔ vhd/vhdx (Hyper-V)``

```bash
# qcow2 → vhdx
qemu-img convert -f qcow2 -O vhdx disk.qcow2 disk.vhdx

# vhdx → qcow2
qemu-img convert -f vhdx -O qcow2 disk.vhdx disk.qcow2
```

* ``raw ↔ vdi/vmdk/vhdx``

```bash
# raw → vdi
qemu-img convert -f raw -O vdi disk.img disk.vdi

# raw → vmdk
qemu-img convert -f raw -O vmdk disk.img disk.vmdk

# raw → vhdx
qemu-img convert -f raw -O vhdx disk.img disk.vhdx
```

## 扩展

1. 扩展大小

```text
virsh domblklist <虚拟机名字>
Target   Source
vda      /var/lib/libvirt/images/ubuntu-24-04.qcow2

qemu-img resize /var/lib/libvirt/images/ubuntu-24-04.qcow2 +20G
```

2. 查看磁盘情况：

```bash
lsblk
```

3. 如果是单分区系统（ext4）：

* 安装工具：

```bash
sudo nix-env -iA nixos.cloud-utils # 提供 growpart
```

* 扩展分区：

```bash
sudo growpart /dev/vda 1
```

* 扩展文件系统：

ext4：

```bash
sudo resize2fs /dev/vda1
```

xfs：

```bash
sudo xfs_growfs /
```

## 压缩

有时候我们需要备份QEMU的镜像，但是镜像大小非常庞大，可以对其进行压缩。

首先在虚拟机里（以Ubuntu为例）执行：

```bash
sudo apt clean
sudo rm -rf /var/log/*log /var/log/journal/*  # 清理日志
```

然后填充空闲空间：

```bash
sudo dd if=/dev/zero of=/zero.fill bs=1M || true
sudo sync
sudo rm -f /zero.fill
```

随后关闭虚拟机，在宿主机上使用 `qemu-img` 压缩：

```bash
qemu-img convert -O qcow2 ubuntu24.04-2.qcow2 ubuntu24.04-2-compressed.qcow2
```

可选：加上 `-c` 开启压缩：

```bash
qemu-img convert -O qcow2 -c ubuntu24.04-2.qcow2 ubuntu24.04-2-compressed.qcow2
```

> **不要直接删除原始文件**，先确认新文件能正常启动。如果你的 qcow2 镜像是直接被写满了（比如里面确实存了很多真实数据），那即使压缩也不会小太多。如果镜像内部用了 LVM，还可以在 LVM 里使用sudo fstrim -av进行fstrim.

下面帮你自然续写一节 **WSL2**，风格和你前面保持一致，直接可粘：

---

## 四.WSL2

WSL（Windows Subsystem for Linux）是微软提供的 Linux 子系统，其中 **WSL2** 使用真正的 Linux 内核（基于轻量级虚拟机），相比 WSL1 兼容性和性能更好。

它本质上是 **Hyper-V 的一个轻量封装**，但使用体验更接近“原生 Linux”。

## 安装

### 一键安装（推荐）

在 Windows 10 2004+ / Windows 11 中，直接：

```bash
wsl --install
```

默认会安装：

* WSL2
* Ubuntu 发行版

安装完成后重启即可。

## 基本使用

### 查看已安装发行版

```bash
wsl -l -v
```

示例输出：

```text
  NAME      STATE           VERSION
* Ubuntu    Running         2
```

---

### 启动 / 进入系统

```bash
wsl
# 或指定发行版
wsl -d Ubuntu
```

---

### 关闭 WSL

```bash
wsl --shutdown
```

## 文件系统

WSL2 有两套文件系统：

### 1. Linux 内部（推荐开发使用）

路径：

```bash
/home/<user>
```

优点：

* 性能好
* 支持完整 Linux 权限

---

### 2. Windows 挂载目录

路径：

```bash
/mnt/c
/mnt/d
```

示例：

```bash
cd /mnt/c/Users/yourname/Desktop
```

⚠️ 注意：

* 在 `/mnt/*` 下进行大量 IO（如编译项目）会明显变慢
* 建议代码放在 Linux 文件系统中

---

### Windows 访问 WSL 文件

在资源管理器地址栏输入：

```text
\\wsl$\Ubuntu\
```

---

## 网络

WSL2 使用 NAT 网络（类似虚拟机）：

* Windows → WSL：可以通过 `localhost`
* WSL → Windows：也可以直接访问 `localhost`

例如在 WSL 中启动服务：

```bash
python -m http.server 8000
```

Windows 浏览器访问：

```text
http://localhost:8000
```

---

## 与 Hyper-V 的关系

WSL2 依赖：

* Hyper-V
* Virtual Machine Platform

这意味着：

* **WSL2 开启时，本质上 Hyper-V 已经在运行**
* VMware / VirtualBox 可能会变慢（或使用兼容模式）

如果你需要完全关闭：

```bash
bcdedit /set hypervisorlaunchtype off
```

⚠️ 会导致 WSL2 无法使用（只能退回 WSL1）

---

**Done.**
