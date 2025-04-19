+++
title = "乱七八糟:Aria2各平台使用指南"
date = 2025-04-15

[taxonomies]
tags = ["乱七八糟"]
+++

前言 Aria2是一款开源、跨平台的命令行界面下载管理器，常常被各种下载器软件使用。

<!-- more -->
## 介绍

[Aria2](https://github.com/aria2/aria2)是一款开源、跨平台的命令行界面下载管理器，支持的下载协议有：``HTTP、HTTPS、FTP、Bittorrent 和 Metalink``。​它以高效、轻量和灵活著称，适用于需要批量下载、自动化任务或远程控制的用户。

Aria2 有以下几个特点：

- ``多连接下载``：可以从多个来源/协议下载文件并尝试利用您的最大下载带宽，真正加快您的下载体验；
- ``轻量``：不需要太多内存和 CPU 时间；
- ``全功能的 BitTorrent 客户端``：BitTorrent 客户端的所有功能都可用,，如 DHT、PEX、加密、Magnet URI、网络播种、选择性下载、本地对等发现和 UDP 跟踪器；
- ``支持Metalink``：支持 Metalink 下载描述格式。 在下载中使用 Metalink 数据块的校验和自动验证下载的数据部分；
- ``远程控制``：支持 RPC 接口来控制 aria2 进程。 支持的接口是 JSON-RPC（通过 HTTP 和 WebSocket）和 XML-RPC。

Aria2 原生使用命令行工具进行操作，为了更方便控制我们可以使用其他开源的面板配合本体，如[AriaNg](https://github.com/mayswind/AriaNg)或者[webui-aria2](https://github.com/ziahamza/webui-aria2)。

## Windows

首先下载[aria2-1.37.0-win-64bit-build1.zip](https://github.com/aria2/aria2/releases/tag/release-1.37.0)，将下载好的文件解压并放到你喜欢的目录下，设置系统环境变量，类似``D:\DATA\Data\AriaNg-1.3.10-AllInOne``,随后即可在 CMD 中使用 Aria2 。

随后可以安装 AriaNg 前端，AriaNg 使用纯 html & javascript 开发, 所以其不需要任何编译器或运行环境. 

![ariang-1](https://raw.githubusercontent.com/mayswind/AriaNg-WebSite/master/screenshots/desktop.png)

AriaNg 现在提供三种版本, ``标准版、单文件版和 AriaNg Native. ``标准版适合在 Web 服务器中部署, 提供资源缓存和按需加载的功能. 单文件版适合本地使用, 您下载后只要在浏览器中打开唯一的 html 文件即可. AriaNg Native 同样适合本地使用, 并且不需要使用浏览器.这里``建议使用单文件版或者Native版。``

[单文件版(AllinOne)](https://github.com/mayswind/AriaNg/releases)
[Native版](https://github.com/mayswind/AriaNg-Native/releases/tag/1.3.10)



## Arch linux
首先安装aria2本体:
```
paru -S aria2
```
随后创建配置文件
```
nano /home/<you-username>/.config/aria2/aria2.conf
```

内容为
```
enable-rpc=true
rpc-listen-all=true
rpc-allow-origin-all=true
rpc-listen-port=6800
continue=true
dir=/home/<you-username>/Downloads
input-file=/home/<you-username>/.config/aria2/aria2.session
save-session=/home/<you-username>/.config/aria2/aria2.session
save-session-interval=60
```
保存退出；随后创建守护进程以便开机自启动：
```
nano ~/.config/systemd/user/aria2.service
```
写入：
```
[Unit]
Description=Aria2 Daemon
After=network.target

[Service]
ExecStart=/usr/bin/aria2c --conf-path=/home/<you-username>/.config/aria2/aria2.conf
Restart=on-failure

[Install]
WantedBy=default.target
```

在更新配置文件和服务文件后，执行以下命令以重启服务：​
```
systemctl --user daemon-reload
systemctl --user enable aria2.service
systemctl --user start aria2.service
```
使用以下命令检查服务状态：​
```
systemctl --user status aria2.service
```

## 浏览器插件

如果你想让其直接接管浏览器下载,可以使用以下几种浏览器插件：

**Chrome 浏览器**

- [Aria2 Explorer](https://github.com/alexhua/Aria2-Explorer)是一款功能强大的扩展，能够自动拦截浏览器的下载任务，并通过 JSON-RPC 接口将其导出到 Aria2 进行下载。 ​
- [Aria2 for Chrome](https://github.com/alexhua/Aria2-for-chrome)
**Firefox 浏览器**

- Integrated Aria2 Download Manager 是一款 Firefox 扩展，能够拦截下载任务，并将其转发到 Aria2。

**通用版**

- [varia](https://github.com/giantpinkrobots/varia)

🔗

**附带 aria2 的服务端应用**

- [AriaNg for Openwrt](https://github.com/openwrt/packages/tree/master/net/ariang)
- [aria2-ariang-docker](https://github.com/wahyd4/aria2-ariang-docker)

---
**Done.**