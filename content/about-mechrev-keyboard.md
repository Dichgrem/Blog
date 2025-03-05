+++
title = "乱七八糟:机械革命键盘失灵拯救记"
date = 2023-09-04

[taxonomies]
tags = ["乱七八糟"]
+++

前言 机械革命作为一款极高性价比的笔记本，其优惠的力度和问题不断的故障让玩家们爱恨交织；作者在其上安装 Linux 时遇到了键盘失灵的问题，为了避免更多人踩坑，故写本文。
<!-- more -->
## 一.故障情况

作者在一台锐龙平台的笔记本上安装 Debian 时，先在虚拟机中尝试安装，没有发现异常；随后在实体机安装时发现 liveCD 中键盘不可用，无法设置密码和主机名，在连接外接键盘后安装完成，却发现Fn快捷键仍然可用。

## 二.具体思路

根据机革一贯的“特性”，作者猜测是因为 BIOS 或者 ACPI 出现了故障，随后在翻阅论坛时发现是由于锐龙笔记本键盘中断描述与其他键盘不同：其为边缘敏 感、低电平有效的；而蛟龙16K机器键盘实际是边缘敏感、高电平有效（Edge ActiveHigh）。结合 linux 的特性，读取到边缘敏感、低电平有效的中断时，会认为 BIOS 有Bug，会直接当成边缘敏感、高电平有效进行处理。因此，键盘就没有了响应。

## 三.解决方法

既然是高低电平表述的错误，那么我们只需建立DSDT 表副本，将其修改，然后让它优先启动，从而让键盘配置正常；另外还存在 BIOS 修复，内核编译的方法，比较复杂，这里不做说明。
```
首先建立一个DSDT文件夹：
sudo su
mkdir -p /home/dsdt

随后将系统的DSDT表读取到里面，并安装acpica-tools：
cat /sys/firmware/acpi/tables/DSDT > dsdt.dat
apt install acpica-tools
iasl -d dsdt.dat

进入vim编辑DSDT表，没有vim的先安装一个：
apt install vim
vim dsdt.dsl

搜索并替换 Device(PS2K) 下面的
IRQ (Edge, ActiveLow, Shared, ) 
为
IRQ (Edge, ActiveHigh, Shared, ) 

vim搜索的方法为在命令模式下按下“/”，键入搜索字符并回车即可，按“n”跳转到下一处，“N”跳转到前一处，按: wq保存：

随后搜索DefinitionBlock，将其步进值增加一（十六进制），即更改
DefinitionBlock ("", "DSDT", 2, "ALASKA", "A M I", 0x01072009)
为
DefinitionBlock ("", "DSDT", 2, "ALASKA", "A M I", 0x0107200A)

关闭DSDT，并设置其优先启动
iasl dsdt.dsl
mkdir -p kernel/firmware/acpi
cp dsdt.aml kernel/firmware/acpi/
find kernel | cpio -H newc --create > acpi_override
cp acpi_override /boot/acpi_override
echo "GRUB_EARLY_INITRD_LINUX_CUSTOM=\"acpi_override\"" >>/etc/default/grub

更新并重启：

sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo grub-install /dev/sdX
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub

update-grub2
reboot
```              

不出意外，重启后键盘即可使用，若系统不同将 apt 替换即可。

## 四.其他问题

对于Redmi 或 Lenovo刚发布的AMD R7 6800H机型：
- WIFI没有驱动 - （螃蟹卡 8852be）。
- 蓝牙没有驱动 - (螃蟹卡 8852be)。
- 开启窗口特效后，kwin_x11进程CPU占用飙升。
- 电源管理，无论怎么调，笔记本都发热很严重。

### 修复wifi驱动

```
# 内核小于5.18的
git clone https://github.com/HRex39/rtl8852be.git
# 内核大于等于5.18的
git clone https://github.com/HRex39/rtl8852be.git -b dev

cd rtl8852be
make -j8
sudo make install
sudo modprobe 8852be
```

### 修复蓝牙驱动

```
# 内核=5.15
git clone https://github.com/HRex39/rtl8852be_bt.git -b 5.15
# 内核=5.18
git clone https://github.com/HRex39/rtl8852be_bt.git -b 5.18

cd rtl8852be_bt
make -j8
sudo make install
```

### 修复kwin_x11显卡未驱动

首先去amd官网下载最新的linux-amd驱动：

````
https://www.amd.com/zh-hans/support/linux-drivers // 22.20 for Ubuntu 20.04.5 HWE
````

修改Deepin为ubuntu

````
sudo vim /etc/os-release // ID=Deepin => ID=ubuntu

sudo apt install ./amdgpu-install_22.20.50200-1_all.deb

sudo vim /etc/apt/sources.list.d/amdgpu.list // focal => bionic

sudo apt update

sudo amdgpu-install --no-dkms

sudo apt install inxi clinfo
````

安装成功以后，用inxi查看下：

`inxi -G`

````
Graphics:  Device-1: AMD Rembrandt driver: amdgpu v: kernel 
           Display: x11 server: X.Org 1.20.11 driver: amdgpu,ati unloaded: fbdev,modesetting,vesa 
           resolution: 1920x1080~60Hz 
           OpenGL: renderer: AMD YELLOW_CARP (LLVM 14.0.1 DRM 3.42 5.15.34-amd64-desktop) 
           v: 4.6 Mesa 22.1.0-devel
````

最后还原最初的修改：

````
sudo vim /etc/os-release // ID=ubuntu => ID=Deepin
sudo apt purge amdgpu-install
````

看下效果图：

````
➜  ~ glxinfo -B
name of display: :0
display: :0  screen: 0
direct rendering: Yes
Extended renderer info (GLX_MESA_query_renderer):
    Vendor: AMD (0x1002)
    Device: AMD YELLOW_CARP (LLVM 14.0.1, DRM 3.42, 5.15.34-amd64-desktop) (0x1681)
    Version: 22.1.0
    Accelerated: yes
    Video memory: 2048MB
    Unified memory: no
    Preferred profile: core (0x1)
    Max core profile version: 4.6
    Max compat profile version: 4.6
    Max GLES1 profile version: 1.1
    Max GLES[23] profile version: 3.2
Memory info (GL_ATI_meminfo):
    VBO free memory - total: 1388 MB, largest block: 1388 MB
    VBO free aux. memory - total: 3047 MB, largest block: 3047 MB
    Texture free memory - total: 1388 MB, largest block: 1388 MB
    Texture free aux. memory - total: 3047 MB, largest block: 3047 MB
    Renderbuffer free memory - total: 1388 MB, largest block: 1388 MB
    Renderbuffer free aux. memory - total: 3047 MB, largest block: 3047 MB
Memory info (GL_NVX_gpu_memory_info):
    Dedicated video memory: 2048 MB
    Total available memory: 5120 MB
    Currently available dedicated video memory: 1388 MB
OpenGL vendor string: AMD
OpenGL renderer string: AMD YELLOW_CARP (LLVM 14.0.1, DRM 3.42, 5.15.34-amd64-desktop)
OpenGL core profile version string: 4.6 (Core Profile) Mesa 22.1.0-devel
OpenGL core profile shading language version string: 4.60
OpenGL core profile context flags: (none)
OpenGL core profile profile mask: core profile

OpenGL version string: 4.6 (Compatibility Profile) Mesa 22.1.0-devel
OpenGL shading language version string: 4.60
OpenGL context flags: (none)
OpenGL profile mask: compatibility profile

OpenGL ES profile version string: OpenGL ES 3.2 Mesa 22.1.0-devel
OpenGL ES profile shading language version string: OpenGL ES GLSL ES 3.20
````

### 手动管理电源，避免CPU过度使用而发热

安装下面的三方电源管理工具 `Boost Changer`，选择 `Performance`策略即可

````
wget https://github.com/nbebaw/boostchanger/releases/download/v4.4.0/boostchanger_4.4.0_amd64.deb
````
## 参考

[https://zhuanlan.zhihu.com/p/530643928](https://zhuanlan.zhihu.com/p/530643928)

[https://github.com/HRex39/rtl8852be](https://github.com/HRex39/rtl8852be)

[https://github.com/HRex39/rtl8852be_bt](https://github.com/HRex39/rtl8852be_bt)

[https://bbs.deepin.org/post/241607](https://bbs.deepin.org/post/241607)
