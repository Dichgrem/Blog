+++
title = "综合工程:安卓刷机与root教程"
date = 2023-08-13

[taxonomies]
tags = ["综合工程"]
+++

前言 自安卓系统诞生以来，root 一直是玩机的必备过程。时至今日，在安卓定制系统日益完善的情况下，能 root 的机型越来越少，本文以小米手机为例，介绍 root 的具体方法。
<!-- more -->
## **一.什么是root**

这涉及安卓的权限系统。Andoird 系统是基于 Linux 内核的，Linux中的root用户为超级用户，``root 权限则为系统的最高权限``，与 Windows 的 system 权限相当（比 administer 还高）。日常使用中我们可以发现一般软件权限需要经过用户同意，即每次安装前出现的各种请求弹窗。我们看似可以做到许多事情，但有些地方比如安卓的根目录没有root就无法查看。

所谓 Root 也就是使手机获得超级管理员的权限，但是出于种种原因，厂商默认不提供超级管理员的权限，因此，``root的本质就是一个提权的过程``。

## **二.为什么要root**

1. 国内定制的安卓系统充满着云控，反诈以及各种广告，预装软件，这种系统实在为极客们所不容；而当我们具备了 root 权限后，就可以实现许多功能，例如屏蔽广告，虚拟定位，安装 Google 框架和软件，满血运行CPU，删除系统自带软件等等。

2. 某种意义上不能root的手机相当于只有使用权而无所有权，不能完全控制自己的数据。

3. 我可以不要但你厂商不能不给。

> 云控：一般指为了计划性报废而特地远程操控使用户的手机变的卡顿，加快换机；也有另一层含义：在UP主测试手机时调整设置使其跑分虚高而用户到手的手机分数远不如测试的时候的情况。

> 反诈：一般指厂商与网络安全部门合作的后门或漏洞，可以监控用户行为，例如某
“其他”品牌手机系统的webview级别的网址拦截；

> 广告：一般指系统自带的弹窗广告，自带系统应用中的广告和“负一屏”中的广告。

## **三.哪些机型可以root**

在 2023 年的今天，能 root 的机型还是比较少。[各品牌手机root情况汇总](https://github.com/KHwang9883/MobileModels/blob/master/misc/bootloader-kernel-source.md)


| 品牌 / 机型        | BL 解锁情况     | 等待时长    | 支持回锁 | Root/越狱 能力                |
|-------------------|----------------|-------------|----------|-----------------------------|
| OnePlus           | ✅ 支持         | 秒解          | ✅ 支持   | ✅ 容易 root                  |
| Google (Pixel)    | ✅ 支持         | 秒解        | ✅ 支持   | ✅ 容易 root                  |
| Nothing Phone     | ℹ️ 社区支持     | —           | —        | ✅ 社区方法多                 |
| Motorola          | ✅ 支持         | 官方发解锁码 |  ⚠️ 部分| ✅ 社区方法多
| Xiaomi/Redmi/POCO | ⚠️ 支持         | ~7–14 天    | ⏹ 部分   | ✅ 可 root（需等待）          |
| Lenovo            | ✅ 支持         | 秒解        | ⚠️ 部分   | ✅ 容易 root                  |
| Sony              | ⚠️ 支持         | —           | ⚠️ 部分   | ✅ 海外版易 root              |
| OPPO / Realme     | ⚠️ 支持         | —           | —        | ❌ 部分型号难 root           |
| Vivo / iQOO       | ⚠️ 支持         | —           | —        | ❌ 部分型号难 root           |
| Huawei            | ❌ 不支持       | —           | —        | ❌ 基本不可 root            |
| Honor             | ❌ 不支持       | —           | —        | ⚠️ 少数型号有社区支持       |
| ASUS              | ❌ 不支持       | —           | ❌       | ❌ 不可 root                 |
| Black Shark       | ❌ 不支持       | —           | —        | ❌ 不可 root                 |
| LG                | ❌ 不支持       | —           | ✅ 支持   | ⚠️ 旧机型可能可 root        |
| Meizu             | ❌ 不支持       | —           | —        | ⚠️ 部分机型有 root 方法     |
| Samsung           | ⚠️ 支持         | —           | —        | ❌ 解锁后 Knox 熔断，Pay 功能被禁用|
| Apple iPhone      | ❌ 不支持       | —           | —        | ✅ iPhone 10 前可越狱       |

``刷机有风险，root 需谨慎``！刷机前要了解相应的厂商，考虑保修和变砖的问题！



## **四.确定你要刷的系统**

可以选择``官方原版，官改版，海外版和类原生版``。官方原版镜像一般用来救砖;官改版在一些方面例如性能更为强大;海外版本如EEA（欧盟版）为符合法规对隐私保护更好且广告更少；而类原生版是在AOSP的基础上进行简单修改，最为纯净原生。

需要注意这些rom的搜索往往使用的海外名，得先搜索你所对应机型的海外名称/代号。

- [Android原生项目大全](https://mi.fiime.cn/Android)

- [小米各机型 MIUI 历史版本分类索引](https://miuiver.com/)

> 需要注意的是刷类原生系统较之其他系统可能会有如下问题；如果你只需要root，推荐使用原厂系统。

- 解锁BL之后Tee假死，无法使用指纹付款；
- 由于原厂相机驱动不开源，相机变的模糊；
- 部分机型无法快充；
- 12306无法使用前置人脸识别；
- 5G可能无法使用；

## **五.如何root**

首先我们要了解安卓系统的分区和启动。安卓的分区包括:

- ``recovery 分区``，类似PC端的PE环境，手机上的恢复出厂设置即为从 recovery 恢复；

- ``cache 分区``，保存系统最常访问的数据和应用程序。 擦除这个分区，不会影响个人数据，只是删除了这个分区中已经保存的缓存内容；

- ``boot 分区``，类似PC端的MBR分区，用来引导系统启动，擦除后手机会卡在开机 logo 的界面；

- ``system 分区``，包括操作系统与软件，vendor 定制文件与库文件等等，擦除后会卡在开机的动画界面；

- ``data 分区``，存放用户数据和系统设置，擦除后不影响系统的运行。

> 除了以上5大分区外，手机启动阶段还存在名为 bootloader 的程序，通常位于设备的专用引导区域（如boot ROM或firmware分区的一部分），与 PC 端的 BIOS 类似，被称为 fastboot 模式，厂商一般会将其锁定，要刷机的话必须解开它。

> 早些年间，存在大量一键 root，kingroot 之类的软件，可以直接刷写 root 包，获得 root 权限，但成功率不高，且有植入木马之嫌。

因此，现在**主流的刷机步骤**为


- ``备份手机数据``,即备份Data分区(可使用Neobackup或系统自带),字库/基带/官方固件,桌面样式截图以及该机器的官方原厂包；

- 打开机器上的``允许USB调试``;

- ``解开 bootloader``，俗称解BL锁. [BL锁原理参考](https://telegra.ph/BL%E9%94%81%E7%9A%84%E5%8E%9F%E7%90%86%E6%98%AF%E4%BB%80%E4%B9%88-05-29)

- 下载要刷的第三方系统包和原厂系统包并提取以上两个包中的 boot.img 和 recovery.img 文件;

- 将机器与PC等设备连接,并``进入 bootloader``;

- ``刷入第三方 recovery``，比如大名鼎鼎的 TWRP,或者对应新系统的recovery.img；

- 进入 recovery 模式，清空原系统数据并刷入新系统Zip包,随后重启,即可进入新系统。

**主流的root步骤**:

- Magisk:在recovery中``刷入 Magisk ``(面具)zip包，随后重启进入桌面,安装 Magisk(apk),在其中选择直接安装；
- Apatch:安装apk软件并修补提取出来的boot.img,随后在fastboot模式中``fastboot flash boot apatch_patched-boot.img``，重启即可。
- KernelSU:修补init_boot.img或者刷入GKI内核修补，若官方无支持需要自行编译GKI内核。

**常用root方案**

- [Magisk](https://jesse205.github.io/MagiskChineseDocument/)
- [Kitsune Mask](https://jesse205.github.io/MagiskChineseDocument/delta/main.html)
- [KernelSU](https://kernelsu.org/zh_CN/)
- [KernelSU Next](https://rifsxd.github.io/KernelSU-Next/zh/index.html)
- [APatch](https://apatch.dev/zh_CN/)

## **六.前置知识**

### **adb 命令**

| 命令 | 说明 |
|------|------|
| `adb devices` | 列出 adb 设备 |
| `adb reboot` | 重启设备 |
| `adb reboot bootloader` | 重启到 fastboot 模式 |
| `adb reboot recovery` | 重启到 recovery 模式 |
| `adb reboot edl` | 重启到 edl 模式 |
| `adb sideload <要刷写的文件路径>` | 刷写模块，如 Magisk |

**使用adb备份分区**

```
adb shell ls -l /dev/block/bootdevice/by-name
```
可以看到有很多分区，例如这些

```
...
lrwxrwxrwx 1 root root   15 1970-12-24 11:30 frp -> /dev/block/sda5
lrwxrwxrwx 1 root root   16 1970-12-24 11:30 fsc -> /dev/block/sdf13
lrwxrwxrwx 1 root root   16 1970-12-24 11:30 fsg -> /dev/block/sdf12
lrwxrwxrwx 1 root root   15 1970-12-24 11:30 hyp_a -> /dev/block/sde5
lrwxrwxrwx 1 root root   16 1970-12-24 11:30 hyp_b -> /dev/block/sde40
...
```
随后使用root备份分区到手机上

```
adb root

adb shell "dd if=/dev/block/sda2 of=/sdcard/partition_backup/persist.img"
```
然后可以上传到PC端

```
adb pull /sdcard/partition_backup/ ./backup/
```

### **fastboot 命令**

| 命令 | 说明 |
|------|------|
| `fastboot devices` | 列出 fastboot 设备 |
| `fastboot reboot` | 重启设备 |
| `fastboot reboot-bootloader` | 重启到 fastboot 模式 |
| `fastboot flash <分区名称> <镜像文件名>` | 刷写分区 |
| `fastboot oem reboot-<模式名称>` | 重启到相应模式 |
| `fastboot oem device-info` | 查看解锁状态 |

## **七.具体操作流程**

> 以 Poco F2 这款手机为例，

1. 首先我们进入手机设置界面，进入“我的设备”，在“全部参数”中找到“ MIUI 版本”，连续点击后开启开发者模式，随后在“更多设置”中开启 USB 调试， USB安装 功能。

2. 然后我们进入[小米官网](https://www.miui.com/unlock/download.html) ，下载官方解锁工具，需要登陆小米账号并等待7天，随后即可解锁。

3. 解锁完成后在[MiFirm网](https://mifirm.net/downloadtwrp/148) 中下载对应的 TWRP 版本。

4. 随后用数据线连接手机，用其中的一键刷写刷入 TWRP；随后下载你要刷的系统的 rom 包，下载时注意一并下载 boot.img 文件，作为 Magisk 的修补用。然后下载 [Magisk](https://magisk.me/zip/) 包，与 rom 一起存入TF卡或者U盘中。

>注意，由于本机型为新型[**AB分区**](https://www.jianshu.com/p/b2726b304801)因此如果刷机失败，需要下载原厂包用以恢复AB分区，否则无法启动和安装rom。

5. 进入 recovery 模式，首先我们``清除Data、Cache两个分区``，俗称“双清”，随后在高级清除选项中``清除 Data、Cache、Dalvik Cache 和 System 分区``，俗称“四清”。

6. 清除完成后即可开始刷机。将 TF 卡或者U盘插入手机，在“安装”中选择 rom 包，右滑确认刷机；随后如法炮制，刷入 magisk.zip 包，不然会卡在开机 logo 界面，俗称“卡米”。

7. 刷完之后重启，则会进入安装界面。**注意：如果刷的是海外版的包，千万不能联网安装，否则会失败且变为国内版。**

8. 此刻我们将下载好的 boot.img 文件复制到手机上，打开 Magisk 软件，在其中选择修补一个文件，选中 boot.img，修复完成后可以看到超级用户一栏可以使用了，说明 root 完成。

> 以一加（oneplus）为例：


1. 打开开发者模式并开启USB调试，连接到提前装好ADB/Fastboot驱动的电脑；

2. 随后进入fastboot模式（adb reboot bootloader），执行`fastboot oem unlock`或者`fastboot flashing unlock`，查看`fastboot oem device-info`，若为`Device unlocked: true`表示已成功解锁。

3. 随后刷入新系统的recovery.img,使用命令`fastboot flash recovery xxx.img`；四清操作可以用`fastboot erase data / fastboot erase cache / fastboot erase system / fastboot erase metadata` 代替。


4. 随后进入新系统的recovery，使用命令`fastboot reboot recovery`，在其中`adb sideload xxx.zip`,即为刷入新系统的全量包。

5. 随后 `adb reboot` 即可进入新系统。

> 如果你不想安装TWRP也可以直接安装要刷的系统的recovery，一般放在系统zip包的中，如果没有则需要手动解包payload.bin，可以安装payload-dumper-go并在解压出来的系统文件夹中使用``payload-dumper-go payload.bin``，随后会将所有.img后缀的文件放在文件夹中。

## **八.Root后的模块安装**

在 Root 管理器中安装 Zygisk-Lsposed 模块,即可使用 Lsposed，在 Lsposed 中可以安装 HMA, Amarok ，QAuxiliary 模块，并配合 MMRL 等软件等等。

> 免 Root 的平替方法,目前这一套流程也很成熟了:利用 ADB 权限的 Shizuku;利用 Device Owner 权限的 Dhizuku等等。

> 常用模块

- [LSPosed](https://github.com/mywalkb/LSPosed_mod)
- [NoHello](https://github.com/MhmRdd/NoHello)
- [WAHideBootloader](https://github.com/thelordalex/WAHideBootloader)
- [ZygiskNext](https://github.com/Dr-TSNG/ZygiskNext)
- [Zygisk-Assistant](https://github.com/snake-4/Zygisk-Assistant)


## **附录**

### 系统变迁表
| 厂商              | 系统 / 子品牌                                               | 演变历史及时间点                                                                                                                                    |
| --------------- | ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------- |
| **Xiaomi**      | MIUI → 澎湃OS（HyperOS / Surge OS）                        | 2010 年推出 MIUI，2023 年 10 月 17 日官方宣布替代 MIUI 的 HyperOS（中文名“澎湃OS”），2023 年 10 月 26 日随 Xiaomi 14 系列一起发布，2024 年起全面替代 MIUI |
| **Huawei**      | EMUI → HarmonyOS                                       | 2012 年采用 EMUI，2021 年宣布推出基于微内核的鸿蒙 HarmonyOS，新机逐步切换。                                                                                          |
| **OPPO**        | ColorOS                                                | 2013 年推出 ColorOS，2020 年对版本号体系调整至与 Android 主版本同步（例如从 7 跳到 11），之后持续 UI 与功能迭代。 |                                                              |
| **Realme**      | Realme UI                                              | 2019 年从 ColorOS 分支出 Realme UI，此后持续独立更新、优化（未查到主要时间节点）。                                                                                       |
| **Vivo / iQOO** | Funtouch OS → OriginOS (+ Ocean/Pux 系列)                | 2012 年左右推出 Funtouch OS，2020 年推出 OriginOS；后续版本如 OriginOS Ocean、Pux 迭代 UI 核心。                                                                 |
| **OnePlus**     | HydrogenOS (中国) → OxygenOS (海外) → 合并后 OP OS？           | 2014 年中国区发布 HydrogenOS，2015 年海外推 OxygenOS；2021 年底与 OPPO 合并，代码库统一（国内使用 ColorOS，全球继续用 OxygenOS），但官方未明确推出 "OP OS" 这一新名。                        |
| **Samsung**     | TouchWiz → Samsung Experience → One UI (+ One UI Core) | 2009 年推出 TouchWiz，2016 年改名为 Samsung Experience，2018 年重塑为 One UI，2020 年开始细化为标准与精简版 One UI Core。                                       |
| **Asus**        | ZenUI                                                  | 2014 年推出 ZenUI，后续多年持续在视觉与功能上迭代。                                                                                                     |
| **Motorola**    | MotoBlur → My UX                                       | 2009 年推出 MotoBlur，2020 年推出基于原生 Android 的 My UX。                                                                                  |
| **Sony**        | Xperia UI                                              | 自 Xperia 系列以来，Sony 一直使用 Xperia UI，接近原生 Android，逐步做微调。                                                                               |

### 固件包中实际文件

| 文件名                                                      | 说明与功能                                                                                   |
| -------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| **abl.img**                                              | Android Boot Loader（第二阶段引导加载器），负责从 XBL 启动 Android kernel。     |
| **aop.img / aop\_config.img**                            | Always-On Processor：负责处理低功耗任务，辅助系统唤醒等操作。Config 存配置。                                     |
| **bluetooth.img**                                        | 蓝牙固件，负责设备蓝牙功能的驱动与协议栈加载。                                                                 |
| **boot.img / init\_boot.img**                            | 启动分区：包含 kernel（init\_boot 从 Android 13+ 将 ramdisk 拆出）|
| **cpucp.img / cpucp\_dtb.img**                           | CPU Control Processor：处理内核 CPU 调度或控制器，DTB 部分存设备树信息。                                     |
| **devcfg.img**                                           | Device Configuration：设备硬件配置，例如 I/O 设置等参数。                                               |
| **dsp.img**                                              | Digital Signal Processor 固件，处理音频等信号处理任务。                                                |
| **dtbo.img**                                             | 设备树覆盖层（Device Tree Blob Overlay），定义硬件特定参数。                              |
| **engineering\_cdt.img**                                 | 工程测试用 partition，常含硬件校正或测试数据。                                                            |
| **featenabler.img**                                      | Feature Enabler：启用或关闭厂商定制功能或隐藏功能的标记配置区。                                                 |
| **imagefv.img**                                          | Image Feature Version：存储镜像版本控制或签名校验信息。                                                  |
| **hyp.img**                                              | Hypervisor：虚拟化层固件，用于安全隔离或多系统调度。                                                         |
| **keymaster.img**                                        | 安全模块 Keymaster：处理加密密钥、安全认证等功能。                                                          |
| **modem.img**                                            | 基带固件，控制数据通信（LTE/5G/Wi-Fi/Bluetooth）等。                                    |
| **odm.img**                                              | OEM 驱动与功能，硬件相关组件：摄像头、传感器等逻辑支持层。                                                         |
| **oplus\_sec.img / oplusstanvbk.img**                    | 厂商定制安全配置或分区（OnePlus 专用）。                                                                |
| **product.img**                                          | OEM 或 carrier 定制应用和配置，Android 9+ 新增分区               |
| **qupfw\.img**                                           | Qualcomm UFS（或其他闪存）媒体驱动固件，通常用于闪存控制器。                                                    |
| **recovery.img**                                         | Recovery 启动镜像，用于刷机、恢复环境。                                                                |
| **shrm.img**                                             | Secure Hardware Resource Management：安全资源管理模块。                                           |
| **splash.img**                                           | 启动动画或厂商 Logo 展示图片。                                                                      |
| **system.img / system\_ext.img / system\_dlkm.img**      | 系统分区：包含 Android 框架、扩展库（dlkm 存模块）                      |
| **tz.img**                                               | TrustZone 安全环境固件（QSEE / TEE）。                                                           |
| **uefi.img / uefisecapp.img**                            | UEFI 启动环境及安全应用层，用于兼容启动和安全验证。                                                            |
| **vbmeta.img / vbmeta\_system.img / vbmeta\_vendor.img** | Verified Boot 签名校验 metadata，确保完整性安全。                  |
| **vendor.img / vendor\_boot.img / vendor\_dlkm.img**     | 厂商驱动层及扩展，vendor\_boot 是引导层，dlkm 是模块。                  |
| **xbl.img / xbl\_config.img / xbl\_ramdump.img**         | Qualcomm XBL（eXtensible Boot Loader）引导，加载 ABL 等；ramdump 用于调试。                           |


## **参考**
 
 - [lineageos镜像](https://download.lineageos.org/devices/lmi/builds)
 - [lineageos教程](https://wiki.lineageos.org/devices/lmi/install/variant1/)
 - [机型介绍](https://wiki.lineageos.org/devices/lmi/variant2/)
 - [XDA-没有声音的问题解决](https://xdaforums.com/t/no-sound-issue-can-u-help.4479225/)
 - [XDA-更换内核](https://xdaforums.com/t/kernel-overclocked-no-gravity-2023-08-28-protonclang.4531497/)
