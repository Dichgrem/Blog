+++
title = "Windows系列(0):系统安装与设置"
date = 2024-05-24

[taxonomies]
tags = ["Windows"]
+++

前言 由于厂商默认安装windows家庭版导致各种问题频发,这里对 widnows 安装做一个总结，以及附上我个人的windows配置。

<!-- more -->

## 总纲

安装Windows有两种情况:1.在一台全新的电脑上安装；2.想为现有的系统更换版本。本文主要介绍这两种情况。如果只想对现有的系统进行优化，推荐看下一篇的``"Windows系列(1):常用操作与配置"``.

**全新安装**
- 获得一个Windows的ISO镜像；
- 制作外部启动盘；
- 做好环境准备，备份数据；
- 引导外部启动盘安装系统；
- 激活系统；
- 进行安装后设置与优化；

**为现有系统更换版本**

- 做好环境准备，备份数据；
- 方法一：获得ISO镜像，并选择从``本地升级``或``外部升级``；
- 方法二：在设置中填写预安装密钥并切换系统；
- 激活系统；
- 进行安装后设置与优化；

**PS:**
> ``本地升级``：即为不需要外部启动盘，不动你的任何东西的无损安装；但需要一些前提条件；

> ``外部升级``：即为外部启动盘安装系统，可以格式化全盘全新安装；也可以保留数据安装，会将你的的数据放在C盘的``windows.old``文件夹。

> 数据安全：不管是本地还是外部升级，除非你格式化全盘重新安装，否则安装只会动C盘，其他分区的数据(如D盘等)不会触碰，可放心；

## 获取ISO镜像

不管你是哪一种情况，都推荐你先下载ISO镜像，因为ISO镜像方法是最通用,最常用的。


- 官方镜像:从[微软官网](https://www.microsoft.com/en-us/software-download/windows11)下载镜像或[MAS镜像站](https://massgrave.dev/genuine-installation-media)下载。

- Dichos镜像，是笔者个人制作的镜像，参考[乱七八糟:Windows封装与全自动安装](https://blog.dich.bid/windows-4-auto/)；

**PS:**
> 镜像大小从1G~8G左右不等，因为有的不知道哪来的镜像里面版本不全，我们要下载的是包括所有主流版本的ISO，即为里面包括家庭版教育版专业版等等。如果你从其他地方下载ISO镜像，里面可能会捆绑流氓软件甚至有病毒。

> 我们要使用的是``23H2专业工作站版本``，性能最强，功能最全面，适合日常使用和开发；笔记本自带的往往是24H2家庭中文版，bug多功能少，不建议使用。

> 以上说的是功能版本，还有大版本的区别，目前暂时用不上，详细可以看本系列第三篇``Windows系列(3):分类与激活``.

## 制作启动盘

在远古年代你可能看过电脑城老板使用Ghost安装系统，近一点的使用诸如“大白菜”，“老毛桃”以及各种PE安装系统，这是比较旧式的方法。

本文推荐使用Ventoy启动盘+windows镜像的方法安装Windows，好处在于：

- Ventoy开源；
- 不必每次安装都格式化U盘，比如刷了某某PE整个盘就不能放数据，刷其他系统前需要格式化；
- 兼容性好，可以放各种ISO到里面并直接启动，包括Windows/Linux等等；
- 其他详见[乱七八糟:Ventoy战斗盘部署](https://blog.dich.bid/about-ventoy/)

### 制作流程

- 首先``在官网下载``[Ventoy](https://www.ventoy.net/cn/download.html)
- 随后在``language``中改为中文显示，可以看到左上角有``配置选项``
- 将分区类型设置为``GPT``，开启安全启动支持；
- 将``分区格式``设置为NTFS；
- 随后在``分区设置``中进行分区，选择在``磁盘后保留一段空间``，这里的空间将不被分区，即为空闲空间，可以稍后建立分区当作普通的文件存储盘；
- Ventoy分区则会使用``U盘总容量-保留空间-ventoy保留分区``的空间新建一个盘，这里可以放``ISO、WIM、IMG、VHD(x)、EFI``等等
- 随后``选择磁盘``并开始安装,过一会儿即可安装完成。
- 安装完成后可以看到一个新分区，把我们的ISO镜像放在里面即可。
- 随后下载[HotPE](https://github.com/VirtualHotBar/HotPEToolBox)，也放在里面。

## 环境准备&数据备份

不管你使用哪种方法都建议做好这一步骤：

- 关闭Bitlocker；(防止磁盘访问受阻)
- 关闭安全启动；(防止本地升级失败)
- 关闭Intel VMD(如果有)；(防止磁盘识别不到)
- 确保C盘有足够的空间(9GB+);
- 备份好数据以防万一，以及如果原厂系统有驱动安装包也备份起来。

`关闭Bitclocker`：打开设置，进入隐私与安全→ 设备加密,将其状态切换为关闭。系统会弹窗提示确认，点击关闭，系统将开始解密。解密过程中需要比较久的时间，解密完成后即可成功。

`关闭安全启动和Intel VMD`:查找你的笔记本的BIOS 进入键，一般为F2；在开机的时候一直按按按BIOS 进入键,即可进入BIOS/UEFI。在其中查找安全启动(Secure Boot)和Intel VMD(如果有)并将它们关闭(disable),随后按保存退出键(一般为F10或F12)。

`确保C盘有足够的空间`:重新进入BIOS，在其中的引导选项中选择USB设备(你的启动盘的设备名)，将其调到第一个，然后保存退出；重新启动，这时候就会进入Ventoy的界面，可以看到我们放进去的两个ISO，我们直接选择HotPE进入并使用里面的Diskgenius，把其他盘的空间分给C盘一点点，使其有至少9GB可以使用。

## 安装系统

- 全新安装：进入BIOS选择Ventoy启动并选择Windows的ISO镜像，一路安装过去；
- 更换版本外部升级：同上，记得选择保留当前数据，会保留C盘旧数据到Windows.old文件夹；
- 更换版本本地升级：不用进BIOS，直接在文件管理器中打开ISO镜像并点击setup.exe,同样选择保留数据；
- 更换版本预安装密钥：获得一个专业工作站版本的预安装密钥并在设置里面切换密钥，直接升级系统;

**PS:**
> 无论你用什么方法都建议先备份好数据!!!

> 无损升级是有前提条件的!!!除了前面说的环境准备，还需要ISO镜像比原来的系统更新，比如23H2的镜像往往就不能无损更新24H2的系统，只能选择外部升级；

> 如果你选择预安装密钥的方法往往比较容易无损升级，但这样就不能使用Dichos的优化，需要手动优化。

## 激活系统

如果你没有购买正版Windows，上文安装的系统可以使用[MAS脚本](https://github.com/massgravel/Microsoft-Activation-Scripts)或者[HEU_KMS工具](https://github.com/zbezj/HEU_KMS_Activator)来激活.


## 安装后优化

> 如果你使用Dichos,可以直接跳到**三.驱动级**开始.

#### **一.设备级:**

- 关闭 BIOS 安全启动,快速启动
- 解锁 BitLocker
- 删除 OEM 分区，恢复简洁的设备分区


#### **二.系统级:**

- 家庭版升级为专业工作站版
- 将用户名改为非中文
- 退出云端账号,杀死家庭组策略
- 激活 Windows 与 MS office
- 停止自动更新并恢复单级菜单

> 常用的优化软件:

- [Dism++](https://github.com/Chuyu-Team/Dism-Multi-language)
- [Winutil](https://github.com/ChrisTitusTech/winutil)
- [Optimizer](https://github.com/hellzerg/optimizer)

#### **三.驱动级:**

驱动的安装没有集成在Dichos中，而是作为手动安装的一部分避免出错。如自带系统有驱动包，先进系统拿出然后再安装新系统；一般来说，包括:

- 主板驱动和CPU驱动；
- 显卡驱动（独显/核显）；
- Wifi网卡驱动和蓝牙驱动；
- 声卡驱动;
- 硬盘驱动（较少见）；
- Fn快捷键驱动（厂商自带）；
- 笔记本自带的其他某某中心/管家（不建议使用）

而根据来源，又可以分为``公版/通用驱动``和``笔记本厂商特调/专用驱动``，一般而言装公版驱动即可，保持通用性；如果你是重度游戏玩家则可以考虑特调驱动。

**常用驱动下载网站**：

| 分类   | 名称     | 下载 |
|--------|----------|------|
| 综合   | 驱动天空 | [链接](https://www.drvsky.com/) |
| 厂商   | 吾空     | [链接](http://www.wooking.com.cn/drives) |
| 厂商   | 华硕     | [链接](https://www.asus.com.cn/support/download-center/) |
| 厂商   | 联想     | [链接](https://newsupport.lenovo.com.cn/driveDownloads_index.html) |
| 三大件 | AMD      | [链接](https://www.amd.com/en/support/download/drivers.html) |
| 三大件 | Intel    | [链接](https://www.intel.cn/content/www/cn/zh/support/detect.html) |
| 三大件 | NVIDIA   | [链接](https://www.nvidia.cn/geforce/drivers/) |


#### **四.软件级:**

- 删除自带牛马以及不必要的管家类软件.

``使用开源软件!``

- **AI**: [GPT4All](https://github.com/nomic-ai/gpt4all)
- **截图**: [ShareX](https://github.com/ShareX/ShareX)
- **绘画**: [Krita](https://github.com/KDE/krita)
- **办公**: [Microsoft Office](https://github.com/YerongAI/Office-Tool)
- **PDF**: [Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF)
- **游戏**: [Steam](https://store.steampowered.com/)
- **抓包**: [Wireshark](https://www.wireshark.org/download.html)
- **启动器**: [Flow.Launcher](https://github.com/Flow-Launcher/Flow.Launcher)
- **输入法**: [Rime](https://rime.im/download/)
- **浏览器**: [Floorp](https://github.com/Floorp-Projects/Floorp) / [Chrome](https://dl.google.com/tag/s/installdataindex/update2/installers/ChromeStandaloneSetup64.exe)
- **编辑器**: [VSCodium](https://github.com/VSCodium/vscodium)
- **虚拟机**: Hyper‑V
- **科学上网**: [GFS](https://github.com/GUI-for-Cores/GUI.for.SingBox)
- **书籍阅读**: [Readest](https://github.com/readest/readest)
- **内网互传**: [LocalSend](https://github.com/localsend/localsend)
- **文件同步**: [Syncthing](https://github.com/syncthing/syncthing)
- **屏幕录制**: [OBS Studio](https://github.com/obsproject/obs-studio)
- **手机投屏**: [QtScrcpy](https://github.com/barry-ran/QtScrcpy)
- **包管理**: [UniGetUI](https://github.com/marticliment/UniGetUI)
- **软件卸载**: [Geek Uninstaller](https://geekuninstaller.com/download)
- **显示器亮度**: [Twinkle Tray](https://github.com/xanderfrangos/twinkle-tray)
- **系统工具**: [Dism++](https://github.com/Chuyu-Team/Dism-Multi-language) / [NTLite](https://www.ntlite.com/)
- **综合工具**: [图吧工具箱](https://www.tbtool.cn/)
- **文件搜索**: [Everything](https://www.voidtools.com/zh-cn/)
- **磁盘工具**: [DiskGenius](https://www.diskgenius.cn/)
- **密码管理器**: [KeePassXC](https://github.com/keepassxreboot/keepassxc)
- **终端/SSH**: [Electerm](https://github.com/electerm/electerm)

> Rime输入法在Windows端叫小狼毫，输入方案用的是[雾凇拼音](https://github.com/iDvel/rime-ice?tab=readme-ov-file) ，在``获取更多输入方案``中命令行输入``iDvel/rime-ice:others/recipes/full``安装。

#### **五.设置级**

- 设置简洁高效的浏览器
- 优化桌面布局与任务栏布局
- 关闭不必要的开机自启软件
- 关闭 Windows Defender 等烦人的通知


#### **六.测试级(可选)**

- 查看PC型号与配置是否相同
- 屏幕坏点/喇叭/蓝牙检测
- 查看硬盘健康度与使用时间
- AIDA64稳定性测试/Diskinfo硬盘测试
- 单烤/双烤机测试
- 网络测速

**常用测试软件**

[CPU-Z](https://www.cpuid.com/softwares/cpu-z.html)
[GPU-Z](https://www.techpowerup.com/download/)
[AIDA64](https://www.aida64.com/downloads)
[Diskinfo](https://crystalmark.info/en/)
[Furmark](https://www.geeks3d.com/furmark/)
[Afterburner](https://www.msi.com/Landing/afterburner/graphics-cards)

---
**Done.**
