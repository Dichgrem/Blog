+++
title = "综合工程:Arch从入门到入土"
date = 2023-08-16

[taxonomies]
tags = ["综合工程"]
+++


前言 Arch linux是一个轻量、灵活、滚动更新的 Linux 发行版，衍生了诸多优秀的桌面端linux。其官方Wiki更是被称为技术界的“武林秘籍”；
但由于该Wiki的中文版比较陈旧，安装教程不太清楚，故先以虚拟机安装Arch为例实际操作一番。

<!-- more -->

***

准备工作：需要
- 虚拟机环境,这里推荐使用VMware Workstation Pro.

- ISO镜像

VM学习版：https://www.ahhhhfs.com/33472/

官方镜像： https://geo.mirror.pkgbuild.com/iso/2023.08.01/

***

## **一、新建虚拟机**
1.打开VM，文件—新建虚拟机—典型—下一步，对于硬盘要求建议至少20G，作为后续分区使用；CPU及内存根据实际需求分配，一般取半数。
注意：完成后需先在编辑虚拟机设置—选项中设置引导为UEFI，否则会导致奇怪的Boot问题。

2.开启此虚拟机，随后进入界面，回车，跑码后进入tty1。


## **二、联网并分区**
1.使用 **dhcpcd** 命令获取IP地址，由于虚拟机使用NAT故联网容易。如果在实体机安装，使用网线或无线连接，命令为：``nmcli dev wifi connect “wifi名称” password “密码”``

2.使用 **ping www.baidu.com** 命令检查是否联网，若出现ttl,time=xx ms等数据说明成功，随后再 **Ctrl+C** 停止命令运行，~~避免百度被DDOS攻击死掉。~~

3.使用 **timedatectl set-ntp true** 命令更新系统时间，该命令无输出，正所谓无事发生就是最好的。

4.使用 **fdisk -l** 命令查看系统分区，由于虚拟机的存在只会显示一块硬盘。

5.接下来是Arch安装中较难的一部分，以20G硬盘空间为例，我们需要划分出512MB的引导分区，15G的根分区以及5G左右的交换分区。由于纯命令行分区比较繁琐，这里使用 **cfdisk** 命令打开分区工具。



回车选择gpt类型，可以看到如下界面：


使用左右方向键移动至**New**,新建一个分区，大小为**512MB**,回车确认，并移动至**type**将其类型改为**EFI system**，随后如法炮制，建立根分区（类型为linux filesystem）和交换分区（linux swap）。
注意：上诉操作完成后需在**Write**中选择**yes**,否则无法保存分区，随后**quit**回到命令行。


6.分区结束后分别对其进行格式化，命令为
```
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap -f /dev/sda3
```
注意不同分区类型与格式所用命令不同。
7.格式完成后进行挂载，使用如下命令：
```
swapon /dev/sda3
mount /dev/sda2 /mnt
mkdir /dev/sda2 /mnt/home
ls /mnt
mkdir /mnt/boot
mkdir /mnt/boot/EFI
mount /dev/sda1 /mnt/boot/EFI
ls /mnt
```
完成后即可开始组件下载。

* * *

## **三、安装基本组件**
1.使用大名鼎鼎的**vim**编辑器，将下载镜像源改为国内，提高下载速度**vim /etc/pacman.d/mirrorlist**


推荐使用清华源，在首行中改为如下命令：

```
Server = http://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
```
随后**ESC**，**: wq** 保存退出。

2.安装基本包，使用命令
```
pacstrap /mnt base base-devel linux linux-firmware dhcpcd
```
一路回车下载。

3.生成**fstab**文件 ，使用命令
```
genfstab -U /mnt > /mnt/etc/fstab
```
自动挂载分区，并用**cat /mnt/etc/fstab**观察分区情况。
4.使用**arch-chroot /mnt**命令切换至系统环境下，此时可以设置时区，语言和主机名（hostname）。
设置上海为系统时区：
```
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```
设置主机名： **vim /etc/hostname**，写入任意你想要的名字。随后在**vim /etc/hosts**中输入如下内容，将**name**改为主机名。
```
127.0.0.1 localhost
::1 localhost
127.0.1.1 name.localdomain name
```
设置语言：使用**vim /etc/locale.gen**命令去掉 **en_US.UTF-8 UTF-8** 以及 **zh_CN.UTF-8 UTF-8** 行前的注释符号，并用**locale-gen**生成新locale，用**echo 'LANG=en_US.UTF-8' > /etc/locale.conf**命令确认输出。


4.设置root密码：使用**passwd**命令，设置并重复密码。
5.安装微码：根据硬件选择命令：
**pacman -S intel-ucode # Intel
pacman -S amd-ucode # AMD**
6.安装引导程序：
```
pacman -S grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH
```
生成配置文件：
```
grub-mkconfig -o /boot/grub/grub.cfg
```
7.退出并重启虚拟机：
```
exit # 退回安装环境
umount -R /mnt # 卸载新分区
reboot # 重启
```
若成功进入登录界面即为成功，可使用**neofetch**命令打印系统信息。


***
## **四、安装图形界面**
为便于在虚拟机中操作，我们可以安装KDE-plasma，Xfce等桌面环境。
1.使用**dhcpcd**获得地址。

2.新建普通用户**useradd -m -G wheel username** （替换username为你的用户名）并设置密码**passwd username** 。

3.配置Sudo,使用**pacman -S sudo**安装并在**ln -s /usr/bin/vim /usr/bin/vi/visudo** 中删除 **%wheel ALL=(ALL)ALL** 前的注释符。

4.reboot后开始安装驱动。由于~~NVIDIA fuck you~~ 众所周知的原因，独显驱动比较难以安装，建议先只上核显。


以此为例，若为AMD核显，命令为
```
sudo pacman -S xf86-video-amdgpu
```
OpenGL和mesa:
```
sudo pacman -S mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver mesa-vdpau
sudo pacman -S opencl-mesa lib32-vulkan-radeon lib32-mesa
```

5.使用命令
```
pacman -S plasma-meta konsole dolphin
```
安装KDE组件。
6.开启sddm守护进程：
```
systemctl enable sddm
systemctl start sddm
```
7.reboot后进入桌面环境，安装完成。


> 添加Windows引导
```
安装 os-prober：首先确保系统中安装了 os-prober，这是一个用于检测其他操作系统的工具。

sudo pacman -S os-prober

sudo os-prober

更新 GRUB 配置：更新 GRUB 的配置文件，使其包含检测到的 Windows 引导项。

sudo grub-mkconfig -o /boot/grub/grub.cfg

如果GRUB 配置中 GRUB_DISABLE_OS_PROBER=true ，会禁止 os-prober 在 grub-mkconfig 运行时检测其他可引导的分区或系统。

打开 /etc/default/grub 文件进行编辑：

sudo nano /etc/default/grub

确保以下设置处于如下状态，即 GRUB_DISABLE_OS_PROBER 设置为 false：

GRUB_DISABLE_OS_PROBER=false

如果该行不存在，可以手动添加或者修改为上述内容。

保存文件并退出编辑器后，运行以下命令更新 GRUB 配置：

sudo grub-mkconfig -o /boot/grub/grub.cfg
```
## Arch中安装QEMU虚拟机

使用Qemu在arch上面搭建Ubuntu-server虚拟机，需要在Virt-Manager中开启3D加速：
- NIC：
```
<graphics type="spice">
  <listen type="none"/>
  <image compression="off"/>
  <gl enable="yes" rendernode="/dev/dri/by-path/pci-0000:05:00.0-render"/>
</graphics>

```
- video virtio：
```
<video>
  <model type="virtio" heads="1" primary="yes">
    <acceleration accel3d="yes"/>
  </model>
  <alias name="video0"/>
  <address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x0"/>
</video>
```
随后使用electerm进行SSH连接，如果无法连接，可以将Tun模式开启的"strict_route"关闭。

## **后记**

设备的多样导致安装中可能会出现一些奇怪的问题，需要自行搜索学习，以不断提高技术水平。





