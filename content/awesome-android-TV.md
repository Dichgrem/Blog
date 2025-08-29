+++
title = "综合工程:Android-TV 折腾小记"
date = 2023-08-14

[taxonomies]
tags = ["综合工程"]
+++


前言 由于 AppleTV 的高昂的售价和普通电视盒子广告的泛滥，一台开源、多功能的原生安卓电视盒子逐渐成为智能家居的必备神器。出于对 IPTV、YouTube 和家庭影院等需求，以及对一面赏心悦目电视墙的期待，这里分享 Android TV （以下简称ATV）安装的一些要点。
<!-- more -->

## 零.要实现的目标

- 实现自己的设备(X86/Arm)上安装TV系统；
- 实现**无开机广告和内置广告**；
- 实现**海报墙效果**（矩形磁帖），或自定义安卓桌面启动器；
- 实现**影视番剧观看**，基于TVbox/Kodi/Kazumi；
- 实现**国内流媒体观看**，包括Bilibili，爱优腾等等；
- 实现**国外流媒体观看**，包括Netflix，YouTube，Disney+，Spotify等等；
- 实现**家庭影院**，Emby类软件自动刮削；
- 实现**IPTV**观看，采用自抓取源或者公共源；
- 实现**复古游戏**游玩，包括GBA/FC等等，基于RetroArch/PPSSPP/Emuelec,可以连接手柄；
- 实现**游戏主机串流**，包括PS/Xbox/Switch等等；



## 一.选择合适的平台

X86还是Arm？两者之间各有优点，截止到今天各种Arm电视盒子已经非常成熟，价格便宜，也可以使用运营商的电视盒子进行刷机，性能并不会太弱；而X86平台往往价格偏贵，且驱动不全，解码性能和功能适配没有和电视生态联系紧密，因此建议首选Arm平台.

本文以s905l3a盒子为示例，截止目前平均价格在60rmb左右，非常具有性价比。

| 项目      | 规格说明                                           |
| ------- | ---------------------------------------------- |
| CPU 架构  | 四核 ARM Cortex-A53 (64-bit)                     |
| 主频      | \~1.8 GHz                                      |
| 制程工艺    | 12 nm                                          |
| GPU     | Mali-G31 MP2，约 850 MHz，20.8 GFLOPS             |
| 视频解码    | H.265 4Kp75 (10-bit), H.264 4Kp30              |
| 视频编码    | H.264/H.265 1080p60                            |
| 最大显示输出  | 4K @ 75fps                                     |
| 内存支持    | 支持 DDR3, DDR4-2666, LPDDR4-3200；设备常见 2 GB DDR4 |
| 存储      | 常见 8 GB eMMC5.1                                |
| 接口支持    | USB2.0/3.0, HDMI 2.0b/2.1                      |
| 网络支持    | 千兆 MAC (常见盒子为 10/100), Wi-Fi, BT4.1/5.0        |
| 发布时间/制程 | Q3 2022，12 nm                                  |

> 如果预算充足，也可以选择s905x3，s905x4，以及rk3528等等芯片的盒子。如果有旧手机，也可以改装为电视盒子，比如骁龙865盒子，性能非常强大。

## 二.选择合适的系统

无论是运营商自带的电视盒子还是各种所谓的“无广告”电视盒子，往往都基于以下两种系统，且要小心一些所谓的“无广告”电视盒子或者外贸盒子，它们往往配置低，性价比不高且还是有内置付费项目，甚至有一些还会偷偷跑PCDN。因此，建议买到手之后自行刷写固件。

| 特性               | **Android-x86**                                          | **Android TV**                                            |
|--------------------|---------------------------------------------------------|----------------------------------------------------------|
| **目标用户**        | 面向 PC 用户，将 Android 运行在 x86/x86_64 设备上。        | 面向电视和机顶盒用户，优化用于遥控器或语音操作。             |
| **适配设备**        | 传统 PC、笔记本、平板电脑等 x86 架构设备。                 | 智能电视、电视盒子等 ARM 或特定芯片架构设备。               |
| **界面设计**        | 和标准 Android 类似，为触摸屏和鼠标键盘优化。               | 专为大屏设计，使用 Leanback UI，适配遥控器操作。             |
| **Google 服务**     | 默认不包含 Google 服务，需要用户手动安装。                  | 官方版本内置 Google 服务（例如 Play Store、Assistant）。    |
| **开机启动器**      | 使用标准 Android 桌面启动器（Launcher3）。                  | 使用电视优化的启动器（Leanback Launcher）。                |
| **架构支持**        | 专注于 **x86/x86_64**，但支持 ARM 仿真（通过 Houdini）。    | 主要支持 **ARM/ARM64** 架构，有限支持 x86。                |
| **硬件支持**        | 需要额外优化，部分硬件（如 GPU 驱动）可能无法正常工作。       | 深度集成硬件，默认支持电视硬件（如 HDMI CEC、音频输出）。    |
| **应用市场**        | 默认不内置 Google Play，需要手动安装 Aurora Store 等替代方案。| 默认集成 Google Play 商店，提供大屏优化的应用程序。          |
| **遥控器支持**      | 不适配遥控器，主要使用鼠标键盘操作。                        | 专为遥控器优化，支持按键导航和语音输入。                    |
| **开源贡献**        | 由社区维护，支持各种自定义和实验功能。                       | 由 Google 官方主导，OEM 厂商提供硬件优化支持。              |

> Android-x86 的安装类似windows；Android TV安装类似 Android手机，通过刷分区或TWRP卡刷安装。

> Tosathony 制作的 Android TV x86 是一个由社区成员制作的定制化 Android TV 版本,针对 Android TV 的大屏界面 和 遥控器操作 进行特别优化,但某些硬件（如 Wi-Fi、GPU、音频设备等）的驱动可能不兼容或需要额外的配置,本文不再说明Android TV x86的安装与使用。

刷写固件可以买一个“刷机神器”（HDMI短接器）和一个双公头的USB线，即可使用[usb-burning-tool](https://androidmtk.com/download-amlogic-usb-burning-tool)来进行刷机，推荐使用2.2.4版本.

## 三.安装软件

安装软件有很多方法，可以使用U盘将apk安装包拷入，也可以使用localsend将apk安装包通过内网传输过去。这里介绍一种通过ADB安装软件的方法。

- 首先我们在设置中找到“设置”>“设备首选项”>“关于”，然后在“构建”上点击几次以解锁``开发者模式``，随后开启USB调试开关。

- 随后在设置 > 设备首选项 > 关于 > 状态中找到并记下IP 地址，然后用ADB连接上去，这里使用命令``adb connect <IP 地址>:<端口> ``，随后在ATV端授权连接，例如：

```
❯ adb connect 192.168.1.666:9527

connected to 192.168.1.666:9527

❯ adb devices

xxxxxxxxx sideload
```

- 接着使用命令``adb install <path to android app.apk>``将要安装的软件包上传，也可以将文件拖到命令提示符窗口上以复制其路径，回车确认。

**一些 ADB 常用命令**：

```
adb reboot #将重启 Android 设备。

adb reboot recovery #将设备重新启动到恢复模式。

adb push <local> <remote> #将文件从您的 PC 复制到您的 Android 设备。

adb shell wm density <dpi> #改变显示器的像素密度。

adb kill server #切断 PC 和 Android TV 之间的连接。
```

**要安装的软件**

- [TVBox](https://github.com/o0HalfLife0o/TVBoxOSC/releases/tag/20250706-1456):前猫影视，可自行添加源，包括电影电视剧等等，选择 armeabi-generic-java.apk

- [PPSSPP](https://www.ppsspp.org/download/):PSP模拟器，支持高清修复游戏，选择 APK for Android

- [BBLL](https://github.com/xiaye13579/BBLL):第三方开源哔哩哔哩客户端，适配TV界面，不需要额外VIP

- [酷9TV](https://www.right.com.cn/FORUM/thread-8437225-1-1.html):经典IPTV播放器，功能丰富，可导入IPTV源使用

- [VLC](http://www.videolan.org/vlc/download-android.html):老牌开源音视频播放器，支持远程和串流功能

- [Kodi](https://github.com/xbmc/xbmc):开源的跨平台多功能媒体播放器和数字媒体娱乐中心，非常强大

- [TV-Bro](https://github.com/truefedex/tv-bro):适用与安卓TV的浏览器，经过了遥控器优化设计，可以作为网页播放器

- [MaterialFiles](https://github.com/zhanghai/MaterialFiles):又名质感文件，优秀的开源文件管理器

- [Localsend](https://github.com/localsend/localsend):经典内网互传工具，可以通过它传输apk安装包或者视频到TV上

- [ATV Launcher](https://www.fenxm.com/592.html):平铺风格的安卓启动器，可以形成海报墙效果

> 注意s905l3a为32位架构，需要下载带armv7a的软件


## 四.设置ATV桌面

安装所需的软件包后我们可以删除自带的牛马软件或者不需要的软件，比如我们要安装ATV，就可以删除当贝桌面。

1. ADB连接：连接到ADB成功后我们使用``adb shell``进入shell，随后使用命令``pm list packages``列出所有软件包；

```
pm list packages -s 列出系统软件包
pm list packages -3 列出第三方软件包
```
2. 获取包名：对于暂时无法确定包名的软件，可以先打开，再使用

```
adb shell dumpsys activity activities | grep mResumedActivity
```

获取当前前台应用的包名,随后再禁用或者删除.

3. 删除软件：可以先使用

```
pm disable-user --user 0 com.dangbei1.tvlauncher
```

禁用软件，确认没有问题之后再用

```
pm uninstall -k --user 0 com.dangbei1.tvlauncher
```

删除；

4. 备份软件：对于想要备份的软件，可以使用1和2中的方法获取软件包名，然后使用例如以下命令：

```
adb shell pm path org.videolan.vlc

package:/data/app/~~hY2Y0_PdaDlasfVwkUNcoQ==/org.videolan.vlc-WnNhCJLQUJdZYYzUxzBNBA==/base.apk
```
获取到安装路径，随后将apk包拿走就可以：

```
adb pull /data/app/~~hY2Y0_PdaDlasfVwkUNcoQ==/org.videolan.vlc-WnNhCJLQUJdZYYzUxzBNBA==/base.apk ./Downloads/
```

5. 备份分区：如果你想要修改当前系统的img，可以用adb提取并导出 

```
# 确定分区对应关系
ls -l /dev/block
ls -l /dev/block/platform
cat /proc/mounts


# 导出到 /sdcard/
dd if=/dev/block/boot of=/sdcard/boot.img
dd if=/dev/block/recovery of=/sdcard/recovery.img
dd if=/dev/block/system of=/sdcard/system.img
dd if=/dev/block/vendor of=/sdcard/vendor.img
dd if=/dev/block/product of=/sdcard/product.img
dd if=/dev/block/odm of=/sdcard/odm.img

# 拉去到PC
adb pull /sdcard/boot.img
adb pull /sdcard/recovery.img
adb pull /sdcard/system.img
adb pull /sdcard/vendor.img
adb pull /sdcard/product.img
adb pull /sdcard/odm.img
```
5. 修改桌面：可以进入安卓原生设置里面将默认主屏幕应用改为ATV，代替掉自带的桌面,并使用

```
adb shell pm disable-user --user 0 com.google.android.tvlauncher
adb shell pm disable-user --user 0 com.google.android.tungsten.setupwraith
```
命令禁用原来的默认桌面。随后重启盒子即可看到海报墙效果，如果ATV桌面没有开机自启动，可以使用Launch on Boot工具。

**最终效果**：

![s905-atv](/images/s905-atv.webp)


## 后记

- [Android TV google 官方 TV 库](https://github.com/googlesamples/leanback-showcase)

- [智能电视，电视盒子开发 SDK](https://github.com/boxmate/tvframe)

- [选中框切换动画，适用于电视](https://github.com/EZJasonBoy/FocusChangeAnimation)

- [Android tv，盒子，投影仪 控件](https://github.com/FrozenFreeFall/Android-tv-widget)

- [TV 项目常用工具(焦点问题，适配问题等.)](https://github.com/genius158/TVProjectUtils)

- [e900v22c项目与讨论组文档](https://github.com/Calmact/e900v22c)
