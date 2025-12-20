+++
title = "Linux-STM32开发环境部署"
date = 2025-07-20

[taxonomies]
tags = ["Linux"]
+++

前言 本文以星火一号开发板为例记录STM32命令行开发环境在Linux上的部署，用以替代Windows上的RT-Thread-studio。RT-Thread开源，但RT-Thread-studio不是开源
软件。
<!-- more -->

# Windows方案

> 该方案使用``scons+gcc-arm-none-eabi+openocd``,可以和Vscode等等配合使用.

## 拉取源码

```bash
https://github.com/Dichgrem/sdk-bsp-stm32f407-spark-template.git
```

## 安装依赖

- 安装 Scons 构建工具

```
pip install scons
```
- 安装 gcc-arm-none-eabi 工具链

在[官网](https://developer.arm.com/downloads/-/gnu-rm) 下载``gcc-arm-none-eabi-10.3-2021.10-win32.exe``,安装后使用以下命令设置环境变量

```powershell
$env:RTT_EXEC_PATH="C:\Program Files (x86)\GNU Arm Embedded Toolchain\10 2021.10\bin"
```

```powershell
$path = [Environment]::GetEnvironmentVariable("Path", "Machine")
[Environment]::SetEnvironmentVariable(
  "Path",
  "$path;C:\Program Files (x86)\GNU Arm Embedded Toolchain\10 2021.10\bin",
  "Machine"
)
```

- 安装 openocd 调试/烧录工具

```bash
scoop install openocd
openocd --version
```

- 安装串口调试工具（可选，也可以用其他串口工具）

```bash
pip install pyserial
```

## 编译固件

进入项目目录并在``projects``下使用scons编译固件,编译结果为``rt-thread.bin``和``rt-thread-elf``

```bash
sdk-bsp-stm32f407-spark
❯ cd ./projects/03_driver_als_ps

sdk-bsp-stm32f407-spark/projects/03_driver_als_ps studyvia C v14.3.0-gcc  via ❄️  impure (nix-shell-env)
❯ scons
scons: Reading SConscript files ...
scons: done reading SConscript files.
scons: Building targets ...
scons: building associated VariantDir targets: build
......
CC build/kernel/components/drivers/i2c/i2c-bit-ops.o
LINK rt-thread.elf
arm-none-eabi-objcopy -O binary rt-thread.elf rtthread.bin
arm-none-eabi-size rt-thread.elf
   text	   data	    bss	    dec	    hex	filename
  87128	    964	   4252	  92344	  168b8	rt-thread.elf
scons: done building targets.
```

## 烧入测试

使用``openocd``指定开发板对应的cfg并烧入，起始地址为``0x08000000``

```bash
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg -c "program rtthread.bin 0x08000000 verify reset exit"
```

## 串口连接

烧入完成后我们可以使用``pyserial``的这个命令连接到串口，退出使用``Ctrl+]``退出

```bash
python -m serial.tools.miniterm COM3 115200
```

> 注意Windows上和开发板连接的串口可能是COM3,COM4等等，需要和实际的相符，可以在设备管理器中查看.


# Ubuntu 方案

## 拉取源码

```bash
https://github.com/Dichgrem/sdk-bsp-stm32f407-spark-template.git
```

## 安装依赖

```bash
sudo apt update
sudo apt install -y git python3 scons openocd stlink-tools gcc-arm-none-eabi gdb-multiarch
```

## 编译固件

```bash
scons -j$(nproc)
```

## 测试连接

使用USB线连接开发板和开发PC，并使用lsusb命令查看是否出现：
```bash
lsusb
Bus 001 Device 004: ID 0483:374b STMicroelectronics ST-LINK/V2.1
```

添加成功后可以使用这个命令来检测是否连接成功：

```bash
❯ st-info --probe
Found 1 stlink programmers
  version:    V2J35S26
  serial:     0671FF373654393143244522
  flash:      1048576 (pagesize: 16384)
  sram:       196608
  chipid:     0x413
  dev-type:   STM32F4x5_F4x7
```

> 如果你将Ubuntu安装在QEMU等虚拟机中 ，需要在libvirt中使用Add_hardware添加usb设备。

## 烧入测试

编译成功后你应该会看到有一个rtthread.bin在目录下，这就是我们编译出来的系统！

在烧入之前，我们可以备份一下原来的系统：

```bash
st-flash read firmware_backup.bin 0x08000000 0x100001
```
随后使用如下命令烧入系统：
```bash
st-flash write rtthread.bin 0x08000000
```

## 串口连接

除了USB之外我们还可以使用串口连接：
```bash
sudo apt install picocom
picocom -b 115200 /dev/ttyACM0
```
可以使用``ctrl + A 然后 ctrl + x``退出。


---

# 其他Tips

- 使用Cmake编译

通过官方文档可以得知除了scons外还可以使用Cmake来编译.

首先找到编译器的路径，并export，我这里是Nixos的路径，如果你使用其他发行版注意修改：

```bash
❯ which arm-none-eabi-gcc
/nix/store/v9p5md3d4aaqwc9i9hlaxkl7nawd9vrc-gcc-arm-embedded-14.3.rel1/bin/arm-none-eabi-gcc
export RTT_EXEC_PATH=/nix/store/v9p5md3d4aaqwc9i9hlaxkl7nawd9vrc-gcc-arm-embedded-14.3.rel1/bin
export RTT_CC=gcc
```

随后使用指令``scons --target=cmake``：
```bash
❯ scons --target=cmake

scons: Reading SConscript files ...
Newlib version:4.5.0
Update setting files for CMakeLists.txt...
Done!
scons: done reading SConscript files.
scons: Building targets ...
scons: building associated VariantDir targets: build
CC build/applications/main.o
LINK rt-thread.elf
arm-none-eabi-objcopy -O binary rt-thread.elf rtthread.bin
arm-none-eabi-size rt-thread.elf
scons: done building targets.
```
可以看到生成CmakeLists.txt成功，随后开始构建：

```bash
❯ cd ./build       
❯ cmake ..  
CMake Warning (dev) at CMakeLists.txt:43:
  Syntax Warning in cmake code at column 100

  Argument not separated from preceding token by whitespace.
This warning is for project developers.  Use -Wno-dev to suppress it.

-- The C compiler identification is GNU 14.3.1
-- The CXX compiler identification is GNU 14.3.1
-- The ASM compiler identification is GNU
-- Found assembler: /nix/store/v9p5md3d4aaqwc9i9hlaxkl7nawd9vrc-gcc-arm-embedded-14.3.rel1/bin/arm-none-eabi-gcc
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /nix/store/v9p5md3d4aaqwc9i9hlaxkl7nawd9vrc-gcc-arm-embedded-14.3.rel1/bin/arm-none-eabi-gcc - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /nix/store/v9p5md3d4aaqwc9i9hlaxkl7nawd9vrc-gcc-arm-embedded-14.3.rel1/bin/arm-none-eabi-g++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done (0.4s)
-- Generating done (0.0s)
-- Build files have been written to: /home/dich/Git/sdk-bsp-stm32f407-spark/projects/02_basic_ir/build
```
使用``make``命令编译：

```bash
❯ make   
[  1%] Building C object CMakeFiles/rtthread.elf.dir/applications/main.c.obj
[  2%] Building C object CMakeFiles/rtthread.elf.dir/home/dich/Git/sdk-bsp-stm32f407-spark/rt-thread/components/libc/compilers/common/cctype.c.obj
[  3%] Building C object CMakeFiles/rtthread.elf.dir/home/dich/Git/sdk-bsp-stm32f407-spark/rt-thread/components/libc/compilers/common/cstdio.c.obj
......
[ 97%] Building C object CMakeFiles/rtthread.elf.dir/home/dich/Git/sdk-bsp-stm32f407-spark/libraries/STM32F4xx_HAL/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim.c.obj
[ 98%] Building C object CMakeFiles/rtthread.elf.dir/home/dich/Git/sdk-bsp-stm32f407-spark/libraries/STM32F4xx_HAL/CMSIS/Device/ST/STM32F4xx/Source/Templates/system_stm32f4xx.c.obj
[100%] Linking C executable rtthread.elf
   text    data     bss     dec     hex filename
  98516    1468    8400  108384   1a760 rtthread.elf
[100%] Built target rtthread.elf
```


- Nixos

虽然Nixos上没有RT-Thread-studio这个包，但是可以用flake.nix很方便的搭建一个开发环境：

```nix
{
  description = "STM32 && RT-Thread development environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
      pkgs = import nixpkgs { inherit self system; };
    });
  in
  {
    devShells = forEachSupportedSystem ({ pkgs }: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          python312
          scons
          openocd
          stlink
          stlink-tool
          gcc-arm-embedded
          picocom
          renode-bin
        ];
      };
    });
  };
}
```

- 使用Renode

如果没有真实的开发版，可以使用Renode来进行仿真模拟：

```bash
# 启动renode
renode

# 创建机器
(monitor) mach create

# 加载STM32F407平台
(monitor) machine LoadPlatformDescription @platforms/boards/stm32f4_discovery.repl

# 加载你的固件
(monitor) sysbus LoadELF @/你的路径/rtthread.elf

# 打开串口窗口（finsh会显示在这里）
(monitor) showAnalyzer sysbus.usart1

# 启动仿真
(monitor) start
```

> Renode 常用命令大全

```bash
# 机器管理
mach add "名称"                 # 创建新机器（指定名称）
mach create                     # 创建新机器（自动命名）
mach set "名称"                 # 切换到指定机器
mach set 0                      # 切换到编号0的机器
mach rem "名称"                 # 删除机器
mach clear                      # 清除当前选择
mach                            # 显示帮助信息
emulation                       # 查看仿真信息

# 仿真控制
start                           # 启动仿真
pause                           # 暂停仿真
quit                            # 退出Renode

# 帮助
help                            # 显示帮助
help 命令名                     # 查看特定命令帮助

# 加载固件
sysbus LoadELF @/path/to/firmware.elf          # 加载ELF文件
sysbus LoadBinary @/path/to/firmware.bin 0x8000000  # 加载BIN到指定地址

# 重置
sysbus Reset                    # 重置系统总线
machine Reset                   # 重置整个机器

# 读取内存
sysbus ReadByte 0x20000000      # 读1字节
sysbus ReadWord 0x20000000      # 读2字节
sysbus ReadDoubleWord 0x20000000 # 读4字节

# 写入内存
sysbus WriteByte 0x20000000 0xFF
sysbus WriteWord 0x20000000 0x1234
sysbus WriteDoubleWord 0x20000000 0x12345678

# 查看内存区域
sysbus FindSymbolAt 0x08000000  # 查找地址对应的符号

# 查看GPIO端口
sysbus.gpioPortA

# 设置GPIO状态
sysbus.gpioPortA.0 Set true     # 设置PA0为高
sysbus.gpioPortA.0 Set false    # 设置PA0为低
sysbus.gpioPortA.0 Toggle       # 切换PA0状态

# 读取GPIO状态
sysbus.gpioPortA.0 State

# 使用GDB调试
(monitor) machine StartGdbServer 3333
# 另一个终端
arm-none-eabi-gdb firmware.elf
(gdb) target remote :3333
(gdb) load
(gdb) b main
(gdb) c
```

---
**Done.**
