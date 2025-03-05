+++
title = "综合工程:ChromeBook研究记"
date = 2023-08-15

[taxonomies]
tags = ["综合工程"]
+++

前言 ChromeBook 作为国外一款定位为商务办公和学生入门的机器，其性能在2023年的当下似乎已经过时；在其退出中国市场后更是接近绝迹。不过，针对特殊需求下的部分机型在今天仍然极具性价比。
<!-- more -->

作为一个垃圾佬，作者常常去发掘二手平台的诸多“洋垃圾”；而就在某一天，一台名为 ASUS ChromeBook C302 的机器吸引了我的注意力，且看其配置：

此前作者一直认为 ChromeBook 只存在于 Google 的 Pixelbook 机型之上，就如同 Mircosoft的Surface Pro 一样；实际上，主流 OEM 厂商——美帝良心想、社会主义戴、惠普宏碁华硕三星等等—-都推出过 Chromebook。

但本次所说的这台 ASUS 的机器属实让我眼前一亮：质感上佳的银白色全金属外壳，360度可翻转的触摸屏，以及最大10小时的续航和仅仅1.15千克的重量，这简直是轻薄本和平板的完美结合！美中不足的是其接口较少，两个type-C、一个3.5mm耳机口和SD卡接口显得有些单薄；而在性能上，Intel m3-6y30和8+32G的组合只能说差强人意。

不过，作为触摸屏和翻转本的结合，用来当阅读器、上网本和视频播放器以及盖泡面上实用性极强，在亚马逊的 kindle 退出中国市场后阅读器市场群魔乱舞，高昂的售价和低配的机型遍地横行；而一般的平板生态和手机重复，价格不菲；如果没有游戏需求，ChromeBook 是不错的选择。

到祸啦家人们！我们看看其实际效果究竟如何？首先映入眼帘的是经典的 Chrome OS 界面，这里注意登录需要有Google的账号（Gmail邮箱），如果暂时没有可以用访客模式登录，在该模式下的一切操作不会保存在硬盘（似乎很好的保护了隐私）；而在登录谷歌后，可以看到其完善的生态，包括原生的 play 商店、Chrome 浏览器，Gmail 邮箱等等。

那么，ChromeBook 有哪些玩法呢？

## 一.进入开发者模式

我们假设你已经有了一个 Google 账号，并在往期的博客中部署了 openwrt，那么此时通过全局科学让 chromebook 联网，随后登录账号，此时我们完成了第一步；

随后拆开后盖，拧下主板上的 BIOS 写保护螺丝。注意在拆卸背板的时候，有两颗螺丝藏在上侧脚垫下，需要先用工具去除脚垫再拆卸这两颗螺丝；下侧的两个脚垫下没有螺丝。

随后打开背板，卸下图示位置（在蒙皮下）的大螺丝;

随后装回后盖，按住键盘上的Esc和“刷新”键不动，然后按下电源键。这样Chromebook会进入“恢复”模式;

然后同时按下键盘上的Ctrl键和D键;


按下Enter，系统重启：
这时会有一声“滴！”的BIOS提示音。


随后等待Chrome OS重置即可。


重置完成后看到如下界面，以后每次开机都要按Ctrl+D进入系统;


随后在设置-高级中可以看到开发者模式已打开，此时传到ChromeOS中的其他APP即可安装。

## 二.安装其他系统

如果你不喜欢 ChromeOS 或者需要 linux 环境，那么可以尝试安装其他系统，例如FydeOS,manjaro等。我们以crouton脚本为例（需要全局科学）：

这里是 crouton 项目的github地址``https://github.com/dnschneid/crouton``

由于我们已经进入开发者模式，这时打开chromeOS的浏览器，同时按住ctrl和alt和t，会打开一个命令行窗口。 输入命令 shell ，回车，之后会出现 linux 的真正命令行。随后安装 crouton,如果你是用 chromeOS 下载的 crouton，那么这个文件应该在~/Downloads目录下。 执行命令：

``sudo sh ~/Downloads/crouton -r list``

列出所有可以用的发行版版本。像ubuntu，debian，kali等等。 随后使用命令列出所有可以选择安装的组件：

``sudo sh crouton -t list``

这其中就包括各种桌面环境，gnome，kde，xface，lxde啥的。 我们选择最轻量的lxde：

``sh crouton -r stretch -t lxde``

随后设置用户名，密码等等。安装完成后，在chromeOS的linux shell里面输入命令：

``sudo startlxde``

就能启动 linux 了。

实际上，crouton 的原理，是基于 linux 下的一个软件， chroot

在linux系统中，它可以把linux系统的根目录（也就是 / ），切换到其它的目录。 crouton 利用这一点，将 chromeOS 的根目录切换到指定的安装了另一系统的文件。而且，会出现两个特性为：linux 可以享受到 chromeOS 的驱动支持，不用担心驱动问题，且使用的是 chromeOS 的系统内核。

由于该内核过于精简，会出现一些服务跑不了的情况，这时我们可以用第二种方法：刷 BIOS。我们进入 linux shell，插入一个空U盘，输入如下命令

```
cd

curl -LO mrchromebox.tech/firmware-util.sh

sudo install -Dt /usr/local/bin -m 755 firmware-util.sh

sudo firmware-util.sh
```

选择标注了“Full ROM”的选项，按照提示备份BIOS和刷入BIOS，随后 reboot，然后可以按正常的装系统流程（Rufus写入ISO启动）

注意：需要先删除 ChromeBook 的硬盘分区；仅支持UEFI启动，且 Windows 驱动不太完整。

## 后记

合适的设备总是相对而言的，只要符合需求即可，不必过多的追求工具的完美。