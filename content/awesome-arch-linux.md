+++
title = "综合工程:Arch-linux 安装与配置"
date = 2023-08-16

[taxonomies]
tags = ["综合工程"]
+++


前言 Arch linux是一个轻量、灵活、滚动更新的 Linux 发行版，衍生了诸多优秀的桌面端linux。其官方Wiki更是被称为技术界的“武林秘籍”；这里介绍其安装与使用。

<!-- more -->

## 安装

一般而言有以下几种安装方法：

- 原版 Arch linux 的命令行安装；
- 原版 Arch linux 的脚本安装；
- 第三方发行版的图形界面安装。

前两种方法较为繁琐，这里说明第三种方法：常见的Arch发行版有Garuda，Cachyos以及EndeavourOS等等。

- [Cachyos下载](https://cachyos.org/download/)
- [Garuda下载](https://garudalinux.org/editions)
- [EndeavourOS下载](https://endeavouros.com/)

安装方法同ubuntu一样，是基于Calamares的图形化界面安装。一般步骤为``选择语言（American English）--选择键盘/时区（默认/shanghai）--选择分区（xfs抹除全盘，可选全盘加密）--选择桌面环境（Gnome或KDE）--确认安装。``

## 安装软件

随后安装常用开源软件(KDE环境省略file和wayland)

```bash
# gui

paru -S floorp-bin keepassxc qemu-full virt-manager materialgram-bin legcord-bin onlyoffice-bin localsend-bin kazumi-bin foliate vlc krita qtscrcpy strawberry oculante obs-studio scx-manager daed

# tui

paru -S neovim yazi lazygit btop zellij termshark

# cli

paru -S alacritty fish fastfetch tealdeer expac fish-autopair fish-pure-prompt fisher onefetch starship atuin bat fzf fd ripgrep eza tree android-tools payload-dumper-go-bin nexttrace-bin syncthing aria2


# file

paru -S gvfs gvfs-mtp gvfs-afc gvfs-nfs nemo

# zip

paru -S peazip

# Type

paru -S fcitx5-configtool fcitx5-skin-material fcitx5-rime fcitx5-gtk

# Blog

paru -S zola npm pnpm just go

# ttf

paru -S ttf-jetbrains-mono-nerd ttf-sarasa-gothic-sc

# Wayland

paru -S hyprland waybar network-manager-applet swww wl-gammarelay-rs brightnessctl easyeffects wireplumber pipewire blueman bluez-utils wl-clipboard-rs wl-clip-persist swaync swayosd swappy grim wlogout hyprlock hyprpolkitagent

```
| 分类           | 软件列表                                             |
| ------------ | ------------------------------------------------ |
| **窗口管理器**    | hyprland                     |
| **状态栏** | waybar                              |
| **启动器** | wofi  |
| **网络**    | network-manager-applet     |
| **蓝牙**   | blueman   |
| **音频**     | pipewire, wireplumber            |
| **亮度**   | brightnessctl,  wl-gammarelay-rs |
| **剪贴板**       | wl-clipboard-rs,wl-clip-persist |
| **通知**       |swaync,swayosd                   |
| **截图**    | grim, swappy                 |
| **壁纸管理**     | swww                          |
| **Polkit 授权代理**  | hyprpolkitagent   |
| **锁屏/开始菜单**       | hyprlock, wlogout      |
| **文件管理**  | gvfs, gvfs-mtp, gvfs-afc, gvfs-nfs, nemo  |

安装完毕后我们开始配置输入法与字体：

输入法我们采用雾凇拼音，即前面我们安装的fcitx5系列软件包的一个输入方案，这里我们使用[自动部署脚本](https://github.com/Mark24Code/rime-auto-deploy)：

```bash
# step1: 克隆/下载 latest 最新的稳定版到本地
git clone --depth=1 https://github.com/Mark24Code/rime-auto-deploy.git --branch latest
# step2: 进入项目目录
cd rime-auto-deploy
# step3: 执行部署脚本
./installer.rb
```
选择部署fcitx5即可，随后在设置的Input Method中Add Input Method ，选择Rime，随后默认按Ctrl+Space即可切换中文。

字体的配置在[Linux之旅(七):系统与终端字体设置](https://blog.dich.bid/learn-linux-for-pc-7/)这一期说过，这里不再赘述。缺少的字体可以通过paru下载或者到[喵闪字库](https://www.miao3.cn/)下载ttf并安装。



## 图形美化

安装完毕后可以看到KDE的界面较为简陋，这里给出笔者的美化配置：

- 在设置中找到Colors&Themes，分别设置为：
```bash
- Color：Breeze Dark
- Application Style：Breeze
- Plasma Style：Sweet
- Window Decorations：Edna
- Icons：BeautySolar
- Cursors：Afterglow Cursors
- Splash Screen：None
```
- 随后设置壁纸，这里给出了笔者收藏的[壁纸](https://github.com/Dichgrem/wallpaper.git)。

- 设置完成后将Dock栏的Status全部隐藏，删除间隔与空隙，删除时间，更改Memu图标，随后固定常用软件到其上。

- 随后在Dock栏下新建一个空白栏，结构为数字时钟加两个空白，字体为JetBrains Mono，24小时ISO格式。最终效果如下：

![desktop](/images/desktop.png)

## 迁移数据

将需要的数据迁移到Home目录下，对笔者来说是用来同步的Data文件夹以及Git工作文件夹。随后Add to Places将其固定到侧边栏，开启隐藏文件可见，将View mode改为Detail。最终效果如下：

![file](/images/file.png)

## 设置软件

- 配置fastfetch显示效果
```
创建配置目录：mkdir -p ~/.config/fastfetch
创建配置文件：touch ~/.config/fastfetch/config.jsonc
编辑该文件以添加你的自定义选项
```
- 设置GFS：参考[乱七八糟:GFS项目考量笔记 ](https://blog.dich.bid/about-gfs/)。

- 设置Keepassxc/Vscodium/Electerm：导入备份好的配置文件。

- 设置Matrix/Telegram：登录并在另一台设备上验证。

- 设置浏览器：导入书签备份文件（有图标）；定制工具栏，下载扩展插件，包括：

```
Dark Reader（暗黑模式）
kiss-translator（翻译工具）
uBlock Origin（广告拦截）
ClearURLs（去跟踪链接）
KeePassXC-Browser（链接Keepass）
BookmarkHub（书签同步）
BewlyBewly（B站美化）
V2EX Polish（V站美化）
```

## 双系统添加Windows引导

如果Grub引导菜单中没有windows选项，可以通过以下方法添加：

- 安装 os-prober：首先确保系统中安装了 os-prober，这是一个用于检测其他操作系统的工具。
```bash
sudo pacman -S os-prober
sudo os-prober
```

- 打开 /etc/default/grub 文件进行编辑：
```bash
sudo nano /etc/default/grub
# 确保 GRUB_DISABLE_OS_PROBER 设置为 false
```

- 保存文件并退出编辑器后，运行以下命令更新 GRUB 配置：
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

或者``手动添加``：
```bash
nano /etc/grub.d/40_custom
```
```bash
#!/bin/sh
exec tail -n +3 $0
# This file provides an easy way to add custom menu entries.  Simply type the
# menu entries you want to add after this comment.  Be careful not to change
# the 'exec tail' line above.
menuentry "Windows 11 (Manual)" {
    insmod part_gpt
    insmod fat
    insmod chain
    set root='hd0,gpt1'
    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}
```

## 制服华硕VMD

华硕的BIOS有一个VMD选项，它的机制是这样的：如果你想安linux，得先关闭VMD；但如果你的windows是出厂自带的，没有重装过，那又得开启VMD，否则无法进入windows；这里记录在不关闭VMD的情况下如何让linux支持它：(以arch linux为例)


先使用这个命令查看磁盘：
```
> lsblk -f
  nvme1n1
  ├─nvme1n1p1  vfat   FAT32  SYSTEM   xxxx-xxxx
  ├─nvme1n1p2  ntfs          OS
  ├─nvme1n1p3  ntfs          新加卷
  ├─nvme1n1p4  ntfs          新加卷
  ├─nvme1n1p5  ntfs          新加卷
  ├─nvme1n1p6  ntfs          新加卷
  nvme0n1
  ├─nvme0n1p1
  ├─nvme0n1p2  ntfs 新加卷
  └─nvme0n1p3  xfs   xxxxxxxxxxxxxx
```
随后使用以下方法将VMD支持加入initramfs：
```
## 挂载linux根分区
mount /dev/nvme0n1p3 /mnt
## 创建boot目录
mkdir -p /mnt/boot
## 挂载EFI
mkdir -p /mnt/boot/EFI
mount /dev/nvme1n1p1 /mnt/boot/EFI
## Chroot进入已经安装的系统
arch-chroot /mnt
## 重新生成 initramfs
nano /etc/mkinitcpio.conf
MODULES=(vmd nvme)
mkinitcpio -P
## 退出重启
exit
reboot
```

## Arch中安装QEMU虚拟机

前面我们已经安装了Qemu高性能虚拟机平台和virt-manager用来管理虚拟机的图形界面，随后配置virt-manager并安装Ubuntu-server：

如果virt-manager报错无法找到Qemu，则：
- ​如果 libvirtd 服务未运行，virt-manager 将无法连接到虚拟化环境。​
```bash
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
```
- 用户权限问题：​​将当前用户添加到 libvirt 组，以获得必要的权限。​
```bash
sudo usermod -aG libvirt $(whoami)
```

- 虚拟网络未激活：​virt-manager 可能无法连接到默认的虚拟网络。​
```bash
sudo virsh net-start default
```
默认网络在系统启动时自动启动，可以执行：
```bash
sudo virsh net-autostart default
```
- 配置文件权限问题：​配置文件的权限设置可能导致访问问题。

```bash
sudo chown $(whoami):libvirt /var/run/libvirt/libvirt-sock
```
随后安装虚拟机，流程大概为``选择镜像和系统类型--设置CPU/内存--设置空间大小--编辑配置项--开启UEFI引导和3D加速``.

**开启3D加速：**

- NIC：
```xml
<graphics type="spice">
  <listen type="none"/>
  <image compression="off"/>
  <gl enable="yes" rendernode="/dev/dri/by-path/pci-0000:05:00.0-render"/>
</graphics>

```
- video virtio：
```xml
<video>
  <model type="virtio" heads="1" primary="yes">
    <acceleration accel3d="yes"/>
  </model>
  <alias name="video0"/>
  <address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x0"/>
</video>
```
安装完成后即可使用electerm进行SSH连接，如果无法连接，可以将Tun模式开启的"strict_route"关闭。

## 更改启动内核顺序
如果安装了多个linux内核，可以使用以下方法调整启动顺序：

- 使用以下命令查看内核名称：
```bash
ls /boot/vmlinuz*
```
- 在 /etc/default/grub 中添加或修改如下行：
```bash
GRUB_TOP_LEVEL="/boot/vmlinuz-linux-cachyos"
```
需要注意，这种方法会关闭 GRUB 的“记住上次启动项”的功能。

- 修改完 /etc/default/grub 后，记得重新生成 GRUB 配置文件：
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
**图形界面更改方法：**

可以使用grub-customizer来修改Grub，这里以ubuntu为例子：

- 添加PPA源并更新软件列表：
```bash
sudo add-apt-repository ppa:danielrichter2007/grub-customizer
sudo apt update
```
- 安装GRUB Customizer：
```bash
sudo apt install grub-customizer
```
随后在grub-customizer中将要默认启动的选项放在首位即可。

## 开机自启动

**设置Syncthing开机自启动**
```bash
sudo systemctl enable --now syncthing@<username>.service
```

**设置Aria2开机自启动**

```conf
[Unit]
Description=Aria2c - lightweight multi-protocol & multi-source command-line download utility
After=network.target

[Service]
User=dich
Group=dich
WorkingDirectory=/home/dich
Environment=HOME=/home/dich
Environment=USER=dich
ExecStart=/usr/bin/aria2c --conf-path=/home/dich/.config/aria2/aria2.conf
Restart=always
NoNewPrivileges=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

## 开启BBR

- 确保你的内核版本 >= 4.9：
```bash
uname -r
```
- 启用 BBR

你只需要设置两个 sysctl 参数即可：
```bash
sudo sysctl -w net.core.default_qdisc=fq
sudo sysctl -w net.ipv4.tcp_congestion_control=bbr
```
要让它们永久生效，把它们写入配置文件：
```bash
sudo nano /etc/sysctl.d/99-bbr.conf
```
加入以下内容：
```bash
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
```
然后重新加载配置：
```bash
sudo sysctl --system
```
- 验证 BBR 是否启用
```bash
sysctl net.ipv4.tcp_congestion_control
```
应该输出：
```bash
net.ipv4.tcp_congestion_control = bbr
```

## 性能模式切换
需要安装``power-profiles-daemon``
```bash
# 查看可用的电源配置文件（profiles）
powerprofilesctl list

# 查看当前正在使用的 profile
powerprofilesctl get

# 切换到“性能”模式
sudo powerprofilesctl set performance

# 切换到“平衡”模式
sudo powerprofilesctl set balanced

# 切换到“省电”模式
sudo powerprofilesctl set power-saver
```
## 其他性能优化

```bash
Profile‑sync‑daemon
将浏览器配置文件和缓存挂载到内存，退出时再写回磁盘：

sudo pacman -S profile-sync-daemon
systemctl --user enable --now psd.service

Systemd‑oomd
启用 systemd 自带的内存超载保护守护进程：

sudo pacman -S systemd-oomd
sudo systemctl enable --now systemd-oomd

Bpftune
加载 BPF 性能调优脚本（网络、I/O、调度等）：

sudo pacman -S bpftune
sudo systemctl enable --now bpftune

Ananicy‑Cpp
根据预设规则给游戏、多媒体和后台任务打优先级标签：

sudo pacman -S ananicy-cpp
sudo systemctl enable --now ananicy-cpp
```

## 常用命令

```bash
更新系统：sudo pacman -Syu

重新安装所有软件包：sudo pacman -Qq | sudo pacman -S -

Reset keyrings：

sudo rm -rf /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman-key --populate archlinux

移除数据库锁：sudo rm -f /var/lib/pacman/db.lck

清理软件包缓存：sudo pacman -Sc （或 -Scc 完全清空）

删除孤立软件包：sudo pacman -Rns $(pacman -Qtdq)

Install Gaming packages：sudo pacman -S steam wine lutris dxvk

排序镜像：

sudo pacman -S reflector
sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

更改 DNS 服务器：编辑 /etc/systemd/resolved.conf 中的 DNS=1.1.1.1 8.8.8.8，然后 sudo systemctl restart systemd-resolved
```


## 在Arch Linux上安装Docker

一般推荐在qemu虚拟机中安装，这里仅做示例：
```bash
sudo pacman -S docker
```

安装完成后，需要启动Docker服务，并设置为开机自启：
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

运行以下命令来验证Docker是否正常工作：
```bash
sudo docker run hello-world
```
默认情况下，只有root用户才能运行Docker命令。为了避免每次运行Docker命令时都需要使用sudo，可以将当前用户添加到docker组：
```bash
sudo usermod -aG docker $USER
```
之后，需要注销并重新登录，或者重启系统以使更改生效。

安装Docker Compose：
```bash
sudo pacman -S docker-compose
```
---
**Done.**





