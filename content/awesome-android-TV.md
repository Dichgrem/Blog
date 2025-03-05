+++
title = "综合工程:Android TV 折腾小记"
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

X86还是Arm？两者之间各有优点，截止到今天各种Arm电视盒子已经非常成熟，价格便宜，也可以使用运营商的电视盒子进行刷机，性能并不会太弱；而X86平台往往价格偏贵，且解码性能和功能适配没有和电视生态联系紧密，因此建议首选Arm平台。



## 二.选择合适的系统

无论是运营商自带的电视盒子还是各种所谓的“无广告”电视盒子，往往都基于以下两种系统，且不要迷信所谓的“无广告”电视盒子，它们往往配置低下，性价比不高且还是有内置付费项目，甚至有一些根本没有做到去广告。

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

---
> Android-x86 的安装类似windows，需要命令行界面配置；Android TV安装类似 Android手机，通过刷分区或TWRP卡刷安装。

> Tosathony 制作的 Android TV x86 是一个由社区成员制作的定制化 Android TV 版本,针对 Android TV 的大屏界面 和 遥控器操作 进行特别优化,但某些硬件（如 Wi-Fi、GPU、音频设备等）的驱动可能不兼容或需要额外的配置。

**刷 Tosathony Android TV X86 准备工作**：

- 1.[Tosathony 制作的 Android TV x86 9.0](https://pan.baidu.com/s/17eDDrf4WzWVmrc9hLw-c_w?pwd=a728)

- 2.[Rufus 写盘工具](https://www.423down.com/10080.html)

- 3.[Android tv Remote 手机遥控器软件：](https://android-tv-remote-control.en.softonic.com/android)

- 4.[Tiny ADB 软件](https://androidmtk.com/tiny-adb-and-fastboot-tool#installer)

**一些可安装的软件**：

- [kodi](http://www.kodiplayer.cn/)

- [当贝市场](https://www.dangbei.com/apps/)

- [哔哩哔哩TV版](https://www.fenxm.com/104.html)

- [ATV Launcher](https://www.fenxm.com/592.html)


## 一、写盘，BIOS启动

1.使用 Rufus 将下载好的 ATV 镜像写入U盘。

2.将U盘插到目标主机上，并设置 BIOS-boot 优先启动，不同设备进入 BIOS 的按键不同，大部分是F2或者DEL；

## 二、开始安装

1.boot 成功后可以看到如下界面：

2.我们选择自动安装：

3.经过跑码后进入若干个选项，一路 yes 过去，文件系统选 ext4;

随后运行 ATV ，并拔出U盘；

## 三、进入Google界面

由于国内网络环境问题，导致一些界面无法进入，可使用如下方法或全局科学。

1.如果卡在 Google的logo 界面或者动画比较缓慢，或者重启后无法进入 ATV 界面，需要在``BIOS-Advanced-OS selection``中将其设置为Windows 8.X或者Android。

2.然后可以看到 PayPal 界面，这里使用可以 `Ctrl+Alt+F1` 进入命令行界面，随后输入

``pm disable com.tosanthony.tv.networkprovider #注意空格``

回车执行，随后按`Ctrl+Alt+F7或F8`回到图形界面。

3.下一步，我们可以看到自动更新界面，这里我们需要禁用它：

同样`Ctrl+Alt+F1` 进入命令行界面，随后输入

``pm disable com.google.android.tungsten.setupwraith #注意空格``

回车执行，随后按`Ctrl+Alt+F7或F8`回到图形界面。

4.此时会进入一个 WiFi 界面，如果你是使用网线直连就没有问题，或者用键盘连接家里的WiFi，作者因为工控机没有WiFi模块在这里卡了半天。

5.随后进入了 AndroidTV 的桌面。

## 四、安装软件并设置桌面启动

1.首先我们在设置中找到“设置”>“设备首选项”>“关于”，然后在“构建”上点击几次以解锁“开发人员”选项，随后开启USB调试开关。

2.随后在设置 > 设备首选项 > 关于 > 状态中找到并记下IP 地址，然后用Tiny ADB连接上去，这里使用命令``adb connect <IP 地址> ``，随后在ATV端授权连接；

3.接着使用命令adb install <path to android app.apk>将要安装的软件包上传，也可以将文件拖到命令提示符窗口上以复制其路径，回车确认。

**一些 ADB 常用命令**：

```
adb reboot #将重启 Android 设备。

adb reboot recovery #将设备重新启动到恢复模式。

adb push <local> <remote> #将文件从您的 PC 复制到您的 Android 设备。

adb shell wm density <dpi> #改变显示器的像素密度。

adb kill server #切断 PC 和 Android TV 之间的连接。
```
4.如果存在一些软件无法安装，可开启ARM兼容层，具体方法为在 `dl.android-x86.org/houdini/9_y/houdini.sfs` 中下载得到`houdini.sfs`，把文件名改成`houdini9_y.sfs`，随后拷贝进U盘，进入命令行界面，输入 `ls` 找到 storage 目录，输入 `cd storage` 进入你的U盘，输入 `ls` ，查看你拷贝的 `houdini9_y.sfs` 文件，并复制到该目录下。

```
cp houdini9_y.sfs /system/etc

enable_nativebridge

reboot
```
5.安装一些软件包后我们发现需要代替掉ATV自带的桌面，从而形成海报墙的效果，这和 linux 的桌面环境切换有异曲同工之处。注意：替换前需要已经安装完成其他桌面！！！！（比如 ATV Launcher ）我们使用以下命令禁用 google 默认的桌面。随后重启，即可看到ATV的海报墙。

``pm disable-user --user 0 com.google.android.tvlauncher ``

恢复原有桌面：

```
C:\Users\root>adb shell
generic_x86:/ $ su
generic_x86:/ # pm enable --user 0 com.google.android.tvlauncher
Package com.google.android.tvlauncher new state: enabled
```



## 后记

- [Android TV google 官方 TV 库](https://github.com/googlesamples/leanback-showcase)


- [智能电视，电视盒子开发 SDK](https://github.com/boxmate/tvframe)


- [选中框切换动画，适用于电视](https://github.com/EZJasonBoy/FocusChangeAnimation)


- [Android tv，盒子，投影仪 控件](https://github.com/FrozenFreeFall/Android-tv-widget)


- [TV 项目常用工具(焦点问题，适配问题等.)](https://github.com/genius158/TVProjectUtils)
