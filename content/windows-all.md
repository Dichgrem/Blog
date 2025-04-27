+++
title = "乱七八糟:Windows安装与环境配置"
date = 2024-05-26

[taxonomies]
tags = ["乱七八糟","Windows"]
+++

前言 由于厂商默认安装windows家庭版导致各种问题频发,这里对 widnows 安装做一个总结，以及附上我个人的windows配置。

<!-- more -->

> 从官方安装:从[微软官网](https://www.microsoft.com/en-us/software-download/windows11)下载镜像或[MAS镜像站](https://massgrave.dev/genuine-installation-media)下载。


> 从Dichos安装，参考[乱七八糟:Windows封装与全自动安装](https://blog.dich.bid/windows-iso/)；

> 二者都基于专业工作站版本，区别在于Dichos通过预应答文件和封装完成了许多设置与优化。Windows最新版本往往Bug比较多，推荐用上一版本；如最新版本为24H2，则推荐使用23H2.

**大版本分类**
| 分类             | 消费者版（Consumer）                             | 商务版（Business）                                | 物联网版（IoT）                                   | 长期服务版（LTSC）                                  |
|------------------|--------------------------------------------------|---------------------------------------------------|---------------------------------------------------|-----------------------------------------------------|
| **目标用户**     | 家庭用户、个人消费者                             | 企业、机构、教育用户                              | 嵌入式设备、工业控制、POS、医疗设备等             | 关键任务系统、长期稳定运行的设备                    |
| **主要版本**     | Windows Home、Home Single Language、Education    | Windows Professional、Enterprise、Education       | Windows IoT Core、IoT Enterprise、IoT Enterprise LTSC | Windows Enterprise LTSC、IoT Enterprise LTSC        |
| **预装应用**     | 包含 Microsoft Store、娱乐和社交类应用           | 精简部分消费类应用，保留企业管理工具              | 极度精简，移除大部分消费类应用                    | 移除 Microsoft Store、Cortana 等非必要功能         |
| **更新策略**     | 定期推送功能和安全更新                           | 可由企业控制更新策略，支持延迟功能更新            | 可选择常规更新或 LTSC 版本，更新策略灵活           | 仅推送安全补丁和关键修复，无新功能更新             |
| **支持周期**     | 通常为 18 个月                                   | 通常为 18～30 个月，取决于版本和配置              | IoT Enterprise LTSC 支持周期可达 10～15 年         | 通常为 5 年主流支持 + 5 年扩展支持，共 10 年        |
| **授权方式**     | 零售授权，需在线激活                             | 批量许可（Volume Licensing）、OEM 授权            | OEM 授权，适用于特定硬件设备                      | 批量许可，适用于特定行业和关键任务设备             |
| **适用场景**     | 日常办公、娱乐、学习                             | 企业办公、教育机构、专业工作站                    | 工业自动化、零售终端、医疗设备等嵌入式系统         | 医疗设备、金融终端、工业控制系统等需长期稳定运行的环境 |

> 安装完成后的优化:

## **一.设备级:**

- 关闭 BIOS 安全启动,快速启动
- 解锁 BitLocker
- 删除 OEM 分区，恢复简洁的设备分区


## **二.系统级:**

- 家庭版升级为专业工作站版
- 将用户名改为非中文
- 退出云端账号,杀死家庭组策略
- 激活 Windows 与 MS office
- 停止自动更新并恢复单级菜单


## **三.驱动级:**

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


## **四.软件级:**

- 删除自带牛马以及不必要的管家类软件.

## 软件

- **AI**: [GPT4All](https://github.com/nomic-ai/gpt4all)
- **截图**: [ShareX](https://github.com/ShareX/ShareX)
- **绘画**: [Krita](https://github.com/KDE/krita)
- **办公**: [Microsoft Office](https://github.com/YerongAI/Office-Tool)
- **PDF**: [Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF)
- **游戏**: [Steam](https://store.steampowered.com/)
- **抓包**: [Wireshark](https://www.wireshark.org/download.html)
- **启动器**: [Flow.Launcher](https://github.com/Flow-Launcher/Flow.Launcher)
- **输入法**: [Rime](https://rime.im/download/)
- **浏览器**: [Floorp](https://github.com/Floorp-Projects/Floorp) / [Chrome](https://www.google.com/chrome/)
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

> 这里说一下Rime输入法在Windows端叫小狼毫，输入方案用的是[雾凇拼音](https://github.com/iDvel/rime-ice?tab=readme-ov-file) ，在``获取更多输入方案``中命令行输入``iDvel/rime-ice:others/recipes/full``安装。

> 传统意义上的三大件包括浏览器，编辑器以及密码管理器。


## **五.设置级**

- 设置简洁高效的浏览器
- 优化桌面布局与任务栏布局
- 关闭开机自启软件
- 关闭 Windows Defender 等烦人的通知


## **六.测试级(可选)**

- 查看PC型号与配置是否相同
- 测试GPU/CPU/硬盘速率与使用时间
- 屏幕坏点/喇叭/蓝牙检测
- 网络测速

---

## 开发环境

### 搭建虚拟机环境

- Hyper-V

在 BIOS 中找到类似``Intel VT-x”、“AMD-V”或“Virtualization Technology``的选项，确保它是“Enabled”（启用）。随后按下 Win + S，输入“打开或关闭 Windows 功能”，在弹出的窗口中，找到 Hyper-V并启用，重启后即可出现。

- VMware

首先下载 [Vmware](https://www.423down.com/14542.html)，随后安装并[激活](https://www.ypojie.com/6066.html)，然后提前下载好所需系统的镜像，这里推荐[整合镜像站](https://help.mirrorz.org/)，并在Vmware中启动。

- Virtulbox

直接到[官网](https://www.virtualbox.org/wiki/Downloads)下载并安装。

- WSL

在``控制面板->程序->启用或关闭Windows功能``，选中适用于Linux的Windows子系统和虚拟机平台，待安装完成后重启电脑。

然后，在``管理员模式下打开 PowerShell 或 Windows 命令提示符``，方法是右键单击并选择“以管理员身份运行”，输入以下命令，然后重启计算机。

```
wsl --install
```
此命令将启用运行 WSL 并安装 Linux 的 Ubuntu 发行版所需的功能。（可以更改此默认发行版）。


> 使用 qemu-img 进行各种虚拟机格式转换

- qcow2 转 vmdk（VMware）
```
qemu-img convert -f qcow2 -O vmdk input.qcow2 output.vmdk
```
- qcow2 转 vdi（VirtualBox）
```
qemu-img convert -f qcow2 -O vdi input.qcow2 output.vdi
```
- qcow2 转 vhdx（新版 Hyper-V）

目前 qemu-img 不能直接输出 vhdx，但你可以先转成 vhd，再用微软工具（如 Convert-VHD）转换为 vhdx：
```
Convert-VHD -Path "output.vhd" -DestinationPath "output.vhdx" -VHDType Dynamic
```
- vmdk转vhdx
```
qemu-img convert -f vmdk -O vhdx input.vmdk output.vhdx
```
- vhd转vhdx
在 PowerShell 中执行以下命令：​
```
Convert-VHD -Path "C:\路径\源文件.vhd" -DestinationPath "C:\路径\目标文件.vhdx" -VHDType Dynamic

# -Path：​指定原始 VHD 文件的路径。​
# -DestinationPath：​指定转换后 VHDX 文件的保存路径。​
# -VHDType：​指定磁盘类型，可选值为 Fixed（固定大小）或 Dynamic（动态扩展）。​
```
请确保虚拟机已关闭，并且 PowerShell 以管理员权限运行。


> Vscode SSH 连接

使用``Open Remote - SSH``插件，需要创建.ssh文件夹；Windows中在``C://users//username//``路径下。

随后使用插件新建一个连接，如：
```
Host myserver
    HostName 192.168.1.100
    User your_username
```

---
**Done.**