+++
title = "Linux-STM32开发环境部署"
date = 2025-07-20

[taxonomies]
tags = ["Linux"]
+++

前言 本文记录STM32命令行开发环境在Ubuntu上的部署，用以替代Windows上的RT-Thread-studio。RT-Thread同样是开源
软件，但目前似乎没有Nixos上的打包。
<!-- more -->

## 环境

在ubuntu24.04中安装这些包，包括连接工具，工具链和调试器等等。
```
sudo apt update
sudo apt install -y git python3 scons openocd stlink-tools gcc-arm-none-eabi gdb-multiarch
```

## 源码

使用Git拉取RT-Thread开源项目：
```
git clone https://github.com/RT-Thread/rt-thread.git
```

## 连接

使用USB连接开发板和开发PC，并使用lsusb查看是否连接成功：
```
lsusb
Bus 001 Device 004: ID 0483:374b STMicroelectronics ST-LINK/V2.1
```

如果你和我一样使用 qemu ，需要在libvirt中使用Add_hardware添加usb设备。

添加成功后可以使用这个命令来检测：

```
❯ st-info --probe
Found 1 stlink programmers
  version:    V2J35S26
  serial:     0671FF373654393143244522
  flash:      1048576 (pagesize: 16384)
  sram:       196608
  chipid:     0x413
  dev-type:   STM32F4x5_F4x7
```

## ENV工具

使用Git拉取RT-Thread配套的linux开发环境，并添加Shell变量。我使用的是fish，你也可以用其他的Shell，命令有所不同。
```
git clone https://github.com/RT-Thread/env.git ~/env
set -x PATH $PATH ~/env
fish_add_path ~/env
echo $PATH
type pkgs
```

## PKG工具

由于该项目大量使用Python，所以需要PKG包支持。首先我们修改这个文件的交叉工具链部分：

```
#修改 rtconfig.py 

# cross_tool provides the cross compiler
# EXEC_PATH is the compiler execute path, for example, CodeSourcery, Keil MDK, IAR
import os

if CROSS_TOOL == 'gcc':
    PLATFORM = 'gcc'
    if os.name == 'nt':
        # Windows 平台
        EXEC_PATH = r'C:\Users\XXYYZZ'
    else:
        # Linux / macOS 平台
        EXEC_PATH = '/usr/bin'

elif CROSS_TOOL == 'keil':
    PLATFORM = 'armclang'  # KEIL AC6
    # PLATFORM = 'armcc'   # KEIL AC5
    EXEC_PATH = r'C:/Keil_v5'

elif CROSS_TOOL == 'iar':
    PLATFORM = 'iccarm'
    EXEC_PATH = r'C:/Program Files (x86)/IAR Systems/Embedded Workbench 8.3'

elif CROSS_TOOL == 'llvm-arm':
    PLATFORM = 'llvm-arm'
    if os.name == 'nt':
        EXEC_PATH = r'D:\Progrem\LLVMEmbeddedToolchainForArm-17.0.1-Windows-x86_64\bin'
    else:
        EXEC_PATH = '/usr/bin'
```
随后可以使用PKG初始化并安装两个必要的包：

```
pkgs --update
pip install kconfiglib
pip install scons
```
## 编译

在完成以上设置之后我们可以开始编译。STM32使用scons编译系统，同样是menuconfig命令：
```
scons --menuconfig
```
修改配置并保存退出后即可开始编译，$(nproc)代表使用全部CPU线程来编译：
```
scons -j$(nproc)
```

## 烧入

编译成功后你应该会看到有一个rtthread.bin在目录下，这就是我们编译出来的系统！

在烧入之前，我们可以备份一下原来的系统：

```
st-flash read firmware_backup.bin 0x08000000 0x100001
```
随后使用如下命令烧入系统：
```
st-flash write rtthread.bin 0x08000000
```

## 串口

除了USB之外我们还可以使用串口连接：
```
sudo apt install picocom
picocom -b 115200 /dev/ttyACM0
version
```
可以使用``ctrl + A 然后 ctrl + x``退出。

---
**Done.**