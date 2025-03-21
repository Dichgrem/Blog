+++
title = "综合工程:360T7刷ImmortalWrt"
date = 2024-09-24

[taxonomies]
tags = ["综合工程"]
+++

前言 上周花了四天成功的将一台 360T7 AX3000 路由器刷成ImmortalWrt系统，并用上了无线校园网，其中之艰辛前所未见。。。

<!-- more -->

## 序章

这一切都得从9月17日我在闲鱼上看到一台360T7说起：正值中秋假期，早上吃完饭看了看闲鱼，突然发现同城有一台仅售60元的360T7路由器，距离我3.4公里——要知道360T7可是AX3000的Wi-Fi6路由器，信号强劲，买60性价比简直无敌。正好缺一个路由器，准备前往购买——

> 错误一：没有事先详细了解这款机型的情况，以为刷OP非常容易

于是说干就干，坐上地铁飞驰到达，卖家发了一个开机视频，一切正常，拿上路由器就回学校;

## 初见端倪

等到下午1点，准备开干。这款机型没有SSH权限和USB口，我提前准备好了ttl模块（CH341）以及杜邦线，现在准备拆机并进行串口调试;
首先是极其结实的外壳，里面有8处卡扣，非常容易损坏;好在笔者手法过硬，没有出现各教程中卡扣裂开的情形。但刚刚打开外壳的一瞬间我就发现事情的不对：``主板上四个圆形串口是有焊锡的``，这下可如何是好？

> 错误二：大力出奇迹把串口撬开

这时候我想到焊锡并不结实，直接用小刀或针刮开即可，于是经过半小时四条杜邦线已经顺利的接上串口，电脑的COM3口也成功访问到;然而离谱的事情发生了：``COM3口没有任何跑码数据显示，一片空白``，这下坏事了。到底是怎么回事呢？有以下几种可能：

- CPU天生不跑码（极其罕见，需要换CPU）
- COM口的波比特率错误（96000？115200？）
- 串口连接错误（RTX，TDX，GND的顺序？）
- 接触不良（得上电烙铁）

经过排除变量，前三条已经确认无误，那么，接触不良该怎么办呢？于是我在外卖平台``买了一个电烙铁``，此时已经下午6点...

## 成为电焊高手

此时，我的另一位好友抗性面包（以下简称K老师）出现了，并打算和我一起``将杜邦线焊接到串口上``。然而，并不熟悉的操作让我们险象环生：首先是焊锡不容易成形，加上了助焊剂松香又出现一大堆烟雾，宿舍一时间烟雾缭绕（ 随即我们将电焊枪开到了400度，在成功焊上一个点之后我将焊枪放在了鼠标垫上。。。

> 错误三：没有焊枪架

于是``鼠标垫被烫出一个大洞``。。。不过好在经过焊接，ttl跑码界面已经成功出现，此时似乎离成功只有一步之遥——

## 噩梦的开始

于是我和K老师大喜，直接找了一个教程，发现这个型号得降级安装，于是``安装了github上名为360t7-upgrade的一个bin包``，然后问题就大了：现在系统连不上了😨😨😨

> 错误四：看都不看就刷进来历不明的包

## 希望与绝望

此时K老师和我有点麻，运气这么好让我们刷到不匹配的包，随后发现``360T7有数个版本，手上的这个版本是Nand闪存``，所以现有的包不能适用。。此时我想到可以通过原厂固件刷回来救，但问题来了：我没有备份这个机型的固件

> 错误五:没有提前备份这个机型的固件

难道只能上编程器救砖？

经过仔细研究，发现``mtk的芯片可以使用名为mtk_boot的工具进入类似fastboot的界面救砖``，而360T7正是用的mtk7981芯片。又经过艰难的一番操作，终于刷入了一个可以使用的Uboot;但这个Uboot又出现了可怕😨的问题：``系统无限循环，报错 bad_block ！！！``而我们此时并不知道分区表的偏移量，无法进行操作。

这是怎么回事？难道内存已经坏块了？

此时时间已晚，不得不先休息，第一天过去了。。。

## 第二天

第二天的晚上我和K老师再度开始折腾这个路由器；我认为☝️``内存应该是没有真正坏块``，于是又又又经过查阅恩山论坛和各处博客，终于发现的问题的关键：应该先``刷bl2，fip和ubi分区``，于是我们用了新的uboot，但新问题又又又又出现了：mtd命令``无法操作bl2，fip和ubi分区``，这是怎么一回事？

又又又经过查阅恩山论坛和各处博客，发现该108M大分区表是锁分区的，不能直接操作，于是经过一番查找``使用了 Kmod 模块解锁了分区表``并刷入了bl2和fip，似乎要好起来了😭，但此时无形的大手再一次愚弄了我们：系统``依然无限循环bad_block``。。于是现在我们强行刷入ImmortalWrt系统是可以的，但``它只能运行在内存之中，一断电就会消逝``😭 总不能让它一直在内存里面跑吧。。

此时时间已晚，不得不先休息，第二天过去了。。。

> 致敬传奇liveCD跑server的运维大师🫡

## 第三天

第三天晚上，我和K老师都有点疲惫，现在无限循环bad_block的报错还未解决，是umbm导致的，在检测到坏块后会报错；然而实际上我们的路由器并没有真正坏块，是在刷入固件的时候导致了尾部的分区错误，随即受到了umbm的制约。现在我们``要么刷一个支持umbm的系统，要么刷一个支持umbm的uboot，要么想办法关闭umbm``，于是K老师编译了一个ImmortalWrt固件并刷了进去，但此时由于前面刷错了bl2，检验依然没有通过。。

此时时间已晚，不得不先休息，第三天过去了。。。

## 第四天

神奇的事情发生了：K老师成功刷入了ImmortalWrt，终于😭😭😭😭，随即我们在ubuntu虚拟机中``编译了C语言写就的 inyn 校园网客户端``，并通过SSH将ipk安装到了ImmortalWrt之上，但此时``报错缺库``。。。又是一顿焦头烂额，最后K老师使用了Go版本的 nyn 解决了问题，我终于用上了无线校园网😭实际测试T7性能非常强大，信号强劲，支持Hnat硬件加速和多路复用，速度轻松跑到800兆。

Done.

## 参考

[360T7刷机](http://www.ttcoder.cn/index.php/2023/07/11/p0/)