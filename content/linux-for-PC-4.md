+++
title = "Linux-For-PC(四):Terminal，Console and Shell"
date = 2023-07-23

[taxonomies]
tags = ["Tech","linux"]
+++


前言 在linux的学习过程中，我们常常遇到诸如 Terminal，Console，bash,zsh,shell,tty 等概念，这些概念常常被混淆，似乎都和命令行相关。本文从历史角度出发介绍它们的前世今生。
<!-- more -->


## 终端和控制台

终端，英文叫做 terminal ,通常简称为 term；控制台，英文叫做 console。

要明白这两者的关系，还得从最初的计算机说起。当时的计算机价格昂贵，一台计算机一般是由多个人同时使用的。在这种情况下一台计算机需要连接上许多套键盘和显示器来供多个人使用。在以前专门有这种可以连上一台电脑的设备，只有显示器和键盘，还有简单的处理电路，本身不具有处理计算机信息的能力，他是负责连接到一台正常的计算机上（通常是通过串口） ，然后登陆计算机，并对该计算机进行操作。当然，那时候的计算机操作系统都是多任务多用户的操作系统。这样一台只有显示器和键盘能够通过串口连接到计算机的设备就叫做终端。




而控制台又是什么回事呢？其概念来自于管风琴的控制台。顾名思义，控制台就是一个直接控制设备的台面（一个面板，上面有很多控制按钮）。 在计算机里，把那套直接连接在电脑上的键盘和显示器就叫做控制台。




终端是通过串口连接上的，不是计算机本身就有的设备，而控制台是计算机本身就有的设备，一个计算机只有一个控制台。计算机启动的时候，所有的信息都会显示到控制台上，而不会显示到终端上。也就是说，控制台是计算机的基本设备，而终端是附加设备。 当然，由于控制台也有终端一样的功能，控制台有时候也被模糊的统称为终端。




以上是控制台和终端的历史遗留区别。现在由于计算机硬件越来越便宜，终端和控制台的概念也慢慢演化了。终端和控制台由硬件的概念，演化成了软件的概念。
　　




## 内核与外壳

内核（ Kernel ）和外壳（ Shell ）是 linux 的两个主要部分。Kernel 是操作系统的核心，系统的文件管理、进程管理、内存管理、设备管理这些功能，都是由 Kernel 提供的。




用户和操作系统内核交流需要一个工具，那么这个工具就是 Shell。




什么是 Shell？在 Linux 中，最常见的 Shell 形式有命令行界面命令行界面和图形界面两种。并不是打开的那个终端窗口就是 Shell，如Alacritty、Gnome-Terminal、xterm 、kitty等程序，它们不是 Shell，而它们里面运行的 Bash、Zsh、fish 等命令行解释器程序，才是 Shell。




那 Alacritty、Gnome-Terminal、xtermxterm 是什么？




它们是终端模拟器。

前面提到过，在远古时代，终端和控制台都是有实体的。控制台直接和计算机在一起，你可以通过控制台控制计算机。终端通过数据线和计算机连接，终端也提供一个键盘和一个屏幕，你可以通过键盘向计算机下达指令，然后通过屏幕观察输出。




但是现在的计算机组成和以前不一样了，一般一台电脑都是自带键盘和屏幕，很少再外接终端设备。

所以 Linux 提供了另外一个更高级的功能，那就是虚拟终端。那就是在一台电脑上，通过软件的模拟，好像有好几个终端连接在这台计算机上一样。




现在说的终端，比如 linux 中的虚拟终端，都是软件的概念。虚拟终端称之为 tty，tty 是电传打字机电传打字机 Teletypewriter 的缩写，在带显示屏的视频终端出现之前，tty是最流行的终端设备。每一个 tty 都有一个编号，在/dev目录下有相应的设备文件。其中/dev/tty1到/dev/tty7可以通过 Ctrl+Alt+F1 到 Ctrl+Alt+F7 进行切换，也可以通过 chvt 命令进行切换，就好比是以前多人公用的计算机中的六个终端设备，这就是为什么这个叫“虚拟终端”的原因。




## 时代变迁

随着时间的推移，我们看到了从硬件到软件的转变，以及从多用户共享到个人使用的转变。这种变迁不仅影响了终端和控制台的概念，也塑造了我们对计算机的理解和期待。