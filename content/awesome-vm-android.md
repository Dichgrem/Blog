+++
title = "综合工程:linux搭建安卓虚拟机"
date = 2023-08-10

[taxonomies]
tags = ["综合工程"]
+++

前言 linux搭建安卓虚拟机有Waydroid，QEMU和Docker三种方案，各有不同。

<!-- more -->

# Waydroid

Waydroid是Anbox配合Halium技术开发的LXC Android容器，可在GNU/Linux系统执行Android APP。以下是Waydroid的特色功能：

- 开源
- 支持x86与ARM架构
- 与宿主机共用剪切板
- 直接使用电脑显卡硬件加速
- 內建GAPPS，可以使用Google Play
- 支持Magisk

> Waydroid执行时的Android系统资料放在``~/.local/share/waydroid/data/``，系统映像档位于``/var/lib/waydroid``，APP图示位于``~/.local/share/applications/``

## 安装前准备

目前Waydroid只支持Intel和AMD的显卡，对于 NVIDIA 显卡（除 Tegra 系列外），Waydroid 不支持硬件加速，推荐使用软件渲染或QEMU方案。

- Waydroid必须使用Wayland，用此命令检查当前系统是否为Wayland：
```
echo $XDG_SESSION_TYPE
```
若显示X11代表不是Wayland。GNOME和KDE可在登入画面切换至Wayland工作阶段。

- Waydroid要求Linux核心支持binder核心模组，但Arch Linux预设的linux核心並无开启此选项，因此需要从AUR安装binder_linux-dkms补齐。
```
paru -S  binder_linux-dkms
```
- 安装后载入binder核心模组
```
sudo modprobe binder-linux devices=binder,hwbinder,vndbinder
```
- 设定开机自动载入核心模组
```
echo "binder_linux" | sudo tee -a /etc/modules-load.d/binder_linux.conf

echo "options binder_linux devices=binder,hwbinder,vndbinder" | sudo tee -a /etc/modprobe.d/binder_linux.conf
```

## 安装Waydroid

- 安装以下软件包，让Linux与Waydroid共享剪切板
```
paru -S wl-clipboard xclip
paru -S python-pyclip
```

- 安装Waydroid
```
paru -S waydroid
```
- 初始化Waydroid，下载含有GAPPS的Android系统映像档
```
sudo waydroid init -s GAPPS -f
```
- 启动Waydroid容器服务
```
sudo systemctl start waydroid-container
```

## 常用命令

- 开机自动启动
```
sudo systemctl enable waydroid-container
```
- 点选应用列表的「Waydroid」图示开启主画面，或者使用命令：
```
waydroid show-full-ui
```
- 若Waydroid无法连上网路，开放UFW防火墙：
```
sudo ufw allow 53
sudo ufw allow 67
sudo ufw default allow FORWARD
sudo ufw reload
sudo systemctl restart waydroid-container
```
- 重启Waydroid
```
sudo systemctl restart waydroid-container
```

- 启动/停止Waydroid容器服务
```
sudo systemctl start waydroid-container
sudo systemctl stop waydroid-container
```
- 用命令开启Waydroid主画面
```
waydroid show-full-ui
```
- 查看系统错误讯息
```
waydroid log
sudo waydroid logcat
```

- 强制屏幕旋转

安装Rotation Control这类APP，即可强制调整Waydroid屏幕方向.

- 模拟Wifi

安装Package Manager，用於查看APP的软件包名称。

部份APP会要求开启Wifi才能上网，那么就如它所愿，开启fake wifi：
```
waydroid prop set persist.waydroid.fake_wifi "软件包名称"
```
例如给Fate/Go游戏开启模拟Wifi：
```
waydroid prop set persist.waydroid.fake_wifi "com.aniplex.fategrandorder"
```
- 模拟触控功能

安装Package Manager，用於查看APP的软件包名称。有些APP认不到鼠标点击，需要启用模拟触控(fake touch)：
```
waydroid prop set persist.waydroid.fake_touch "软件包名称"
```
例如给Fate/Go游戏开启模拟触控：
```
waydroid prop set persist.waydroid.fake_touch "com.aniplex.fategrandorder"
```
- 用命令安装APK
```
waydroid app install <APK档案路径>.apk
```
- 进入ADB Shell
```
sudo waydroid shell
```
- 开启多视窗模式

Waydroid的多视窗模式，看起来像Linux的原生应用。启动后按F11改回来。
```
waydroid prop set persist.waydroid.multi_windows true
sudo systemctl restart waydroid-container
```

## 将Waydroid注册为Google装置

Waydroid第一次开机可能会收到``Device is not Play Protect certified``的通知，无法登入Google账号。

用以下命令取得Waydroid的装置ID。该命令会印出一长串数字。
```
sudo waydroid shell

ANDROID_RUNTIME_ROOT=/apex/com.android.runtime ANDROID_DATA=/data ANDROID_TZDATA_ROOT=/apex/com.android.tzdata ANDROID_I18N_ROOT=/apex/com.android.i18n sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "select * from main where name = \"android_id\";"
```
开启装置注册页面，登入Google账号，输入装置ID注册，等个半小时应该就能登入Google账号了。如果还是不行就重新启动Waydroid容器服务：
```
sudo systemctl restart waydroid-container
```
现在可以安装APP了，Google Play和F-Droid会自动筛出適合x86架构的APP。

# QEMU/KVM

## 概述

Bliss OS 是基于 Android-x86 的开源系统，已更新至 Android 13，并内建 Google Play 商店，可直接运行 64 位 APK，无需额外转译器；在 Linux 上通过 QEMU/KVM + virglrenderer 实现 GPU 加速，使得在虚拟机中也能流畅体验手游。

## 为什么选择 Bliss OS？

- **版本更新快**：Bliss OS 最新测试版基于 Android 13，而 Android-x86 官方仅更新至 Android 9。
- **更完善的 ARM 转译**：采用 Google libndk，可兼容 64 位 ARM-v8a APK；相比仅支持 32 位 ARM-v7 的 liboudini，兼容性大幅提升。
- **丰富实用功能**：预装强制旋转、按键映射、游戏模式、模拟触控点击、KernelSU（难以检测的 root 权限）和 Gearlock 恢复环境等增强工具，提升桌面化体验。

## 环境准备

- **硬件要求**：CPU 要开启 ``VT-x/AMD-V``，并加载 KVM 内核模块；Intel 10 代及更新集成 GPU 可用，AMD 同理；闭源 Nvidia 驱动下 virglrenderer 不稳定，不建议使用硬件加速。
- **软件安装**：在宿主机上安装 QEMU (≥8.1.1)、Libvirt、Virt-Manager，并部署 virglrenderer (≥0.10.4) 以获得半虚拟化 3D 加速；Ubuntu 与 Arch 安装方法分别见官方文档。
- **性能调优**：可参考 Red Hat 虚拟化性能调优指南，启用 IOMMU、调整 CPU 调度与内存缓存策略，以提升 KVM 性能。

## 安装流程与分区
1. 从官方站点下载带 GApps 的 Bliss OS 15.x ISO 镜像，并在 Virt-Manager 中新建虚拟机，选择 ``Q35 芯片组、UEFI (OVMF)``。
2. 推荐分配 ≥8 GB RAM、4 核 CPU 及 ≥64 GB 虚拟硬盘，并勾选 OpenGL、VirtIO 显示卡 + 3D 加速。
3. 进入 Bliss OS 安装器，使用 GPT 分区表：
   - 首分区 512 MB，类型 EFI (`ef00`)，挂载点 `/mnt/efi`；
   - 次分区 全盘剩余空间格式化为 Ext4，用于系统安装。
4. 安装 GRUB、格式化分区后强制关机，移除 ISO 并重启，即可启动已启用 virglrenderer 加速的系统。

## 分辨率调整

- 启动时选择 “Debug QEMU/KVM VirGL” 进入 shell，通过 `blkid` 找到 EFI 分区（如 `/dev/sda1`），挂载后编辑 `/mnt/efi/boot/android.cfg`：
  - 在 `linux $kd/kernel` 行末添加 `video=1920x1080`；
  - 修改 `set gfxmode=` 为相应分辨率，保存并重启即可生效。
- 如需更灵活调整，可在系统内安装 SecondScreen 等第三方工具强制改分辨率。

## 系统使用技巧

- 默认启用 Boringdroid 桌面模式，底部常驻任务栏；可在设置里为特定应用强制全屏运行。
- 强制旋转：内置 Set Orientation 或使用更佳的 OHMAE Ryosuke 工具；屏幕录制推荐宿主机通过 OBS 采集 VM 窗口。
- 多窗口：开发者选项启用“自由形式窗口”；Root 需在 KernelSU 中对指定应用授权，Termux 可提供终端环境。
- ADB 调试：可通过无线 ADB 连接，并在 shell 中为 `com.android.shell` 授予 Root 权限。

## 手游实测

- 优先安装原生 x86 版游戏，减少 ARM 转译开销；多游戏如《水果忍者》、《Temple Run 2》均能流畅运行。
- 部分大型游戏（如《原神》）因 virglrenderer 不稳定在着色器编译时易崩溃；《幻塔》可正常进入并游玩。
- 若触控事件不响应，可启用 “Force Mouse Click as touch” 强制映射鼠标点击，但会导致滚轮失效；开启“游戏模式”可屏蔽通知并悬浮截屏。

# Docker

## 概述
ReDroid（Remote-Android）是一款开源的容器化 Android 解决方案，支持在 x86 主机通过 Docker、Podman 或 Kubernetes 启动多实例 Android 系统，并提供 GPU 加速与多架构（arm64/amd64）支持，适用于云端游戏、自动化测试、虚拟手机等场景。本文从环境准备、部署配置、日常使用及进阶定制等方面，逐步讲解如何在 Linux 主机上用 Docker 容器运行并优化 ReDroid，使其能够流畅运行 ARM 架构的手游。

## 什么是 ReDroid？

- **项目简介**：ReDroid 即 Remote-Android，是一个多架构、GPU 加速的“Android In Cloud”（AIC）方案，可在任何具备必要内核特性（如 binderfs）的 Linux 主机上部署 Android 容器。
- **版本支持**：活跃维护 Android 11–15 多个版本的镜像，并提供丰富的文档与社区支持。
- **应用场景**：适用于云游戏、自动化测试、连续集成中的 UI 测试、远程开发等多种场景。

## 环境与依赖

- **内核模块**：宿主机需开启 `binderfs`、`ashmem` 等内核模块，部分发行版可能需安装 `redroid-modules`。
- **GPU 加速**：推荐使用 Intel/AMD 集成 GPU，避免闭源 NVIDIA 驱动下的不稳定性；也可在云端 GPU 实例上部署。
- **软件需求**：安装 Docker / Docker Compose（或 Podman）、ADB（Android Debug Bridge）和 Scrcpy，用于容器管理与远程调试、画面传输。
- **硬件配置**：8 GB 及以上内存、四核及以上 CPU、至少 20 GB 存储；若运行高负载游戏，推荐更高配置并开启 GPU 硬件加速。

## 部署与配置

1. **创建目录与编写 Compose 文件**  
   ```bash
   mkdir ~/redroid && cd ~/redroid
   vim docker-compose.yml
   ```
2. **示例 `docker-compose.yml`**  
   ```yaml
   version: '3.8'
   services:
     redroid:
       image: redroid/redroid:11.0.0_gapps
       stdin_open: true
       tty: true
       privileged: true
       ports:
         - "127.0.0.1:5555:5555"
       volumes:
         - ./redroid-11-data:/data
       command:
         - androidboot.redroid_width=720
         - androidboot.redroid_height=1280
         - androidboot.redroid_dpi=320
         - androidboot.redroid_fps=60
         - androidboot.redroid_gpu_mode=host
         - ro.product.cpu.abilist0=x86_64,arm64-v8a,x86,armeabi-v7a,armeabi
         - ro.enable.native.bridge.exec=1
         - ro.dalvik.vm.native.bridge=libndk_translation.so
   ```
3. **启动容器**  
   ```bash
   sudo docker compose up -d
   ```

## 日常使用

- **ADB 连接与屏幕镜像**  
  ```bash
  adb connect localhost:5555
  scrcpy -s localhost:5555 --audio-codec=aac
  ```
- **安装 APK**：  
  - 使用 `adb install your_app.apk`  
  - 或在 Scrcpy 界面中拖拽 APK 文件进行安装
- **停止与重启**：  
  ```bash
  sudo docker compose down
  sudo docker compose up -d
  ```
- **数据持久化**：所有数据保存在 `~/redroid/redroid-11-data`，可备份或运行多实例。

## 高级操作与安全建议

- **Google Play 验证**：首次登录 Play Store 需获取设备 ID 并在 Google 控制台注册后重启容器。
- **3D 加速检测**：通过 AIDA64 等应用验证 GPU 加速是否生效。
- **网络安全**：只绑定本地回环地址监听 ADB 端口；如需外网访问，务必配置防火墙规则，避免安全风险。

## 定制镜像与 GApps

- **安装 GApps**：下载 OpenGApps x86_64 Android 11 Pico 包，将其中 APK 拷贝到自建镜像的 `system` 目录，再在容器内推送并授权。
- **自定义 libndk**：从 Android Studio 模拟器提取 Google 官方 ARM 翻译库（libndk），在 Dockerfile 中加入到基于 `redroid:13.0.0-latest` 的自定义镜像，提升兼容性与性能。


---
**Done.**