+++
title = "下载系列(3):Aria2使用指南"
date = 2025-04-15

[taxonomies]
tags = ["Network"]
+++

前言 Aria2是一款开源、跨平台的命令行界面下载管理器，常常被各种下载器软件使用。

<!-- more -->
## 介绍

在上网的时候，我们可能需要下载一些东西，而浏览器自带的下载比较缓慢。为此，许多人安装了类似IDM或者Motrix等等软件，用多线程来加速下载。其实，许多开源的下载器就是Aria2的前端，我们可以直接使用Aria2进行下载。

[Aria2](https://github.com/aria2/aria2)是一款开源、跨平台的命令行界面下载管理器，支持的下载协议有：``HTTP、HTTPS、FTP、Bittorrent 和 Metalink``。它以高效、轻量和灵活著称，适用于需要批量下载、自动化任务或远程控制的用户。

Aria2 有以下几个特点：

- ``多连接下载``：可以从多个来源/协议下载文件并尝试利用您的最大下载带宽，真正加快您的下载体验；
- ``轻量``：不需要太多内存和 CPU 时间；
- ``全功能的 BitTorrent 客户端``：BitTorrent 客户端的所有功能都可用,，如 DHT、PEX、加密、Magnet URI、网络播种、选择性下载、本地对等发现和 UDP 跟踪器；
- ``支持Metalink``：支持 Metalink 下载描述格式。 在下载中使用 Metalink 数据块的校验和自动验证下载的数据部分；
- ``远程控制``：支持 RPC 接口来控制 aria2 进程。 支持的接口是 JSON-RPC（通过 HTTP 和 WebSocket）和 XML-RPC。

要**使用Aria2来替代浏览器自带的下载**，一般需要三个条件：

1. 在系统中安装Aria2,并设置环境变量和开机自启；
2. 让Aria2接管浏览器的下载；
3. 需要一个前端面板来更方便的控制Aria2(可选).

## 安装

### Windows

首先在Github下载aria2[aria2-1.37.0-win-64bit-build1.zip](https://github.com/aria2/aria2/releases/tag/release-1.37.0)，将下载好的文件解压并放到你喜欢的目录下，这里放到``D:\Software\aria2\aria2c.exe``

然后在同一个目录下创建一个配置文件``aria2.conf``，内容如下：

```conf
# 下载目录
dir=C:/Users/<你的用户名>/Downloads

# 断点续传
continue=true
file-allocation=prealloc

# RPC 设置
enable-rpc=true
rpc-listen-all=true
rpc-allow-origin-all=true
rpc-listen-port=6800
rpc-secret=<设置一个密码>
```

随后使用winfet安装servy，servy是一个将任何应用变成原生 Windows 服务的软件，可以让aria2服务开机自启动，类似linux上的systemctl.

```
winget install servy
```
安装完成后打开管理员权限的powershell，运行以下命令，注意路径要和你实际的路径相同：

```bash
servy-cli install `
  --name aria2 `
  --displayName "aria2 download service" `
  --description "aria2 background download daemon" `
  --path D:\Software\aria2\aria2c.exe `
  --params="--conf-path=D:\Software\aria2\aria2.conf" `
  --startupDir D:\Software\aria2 `
  --startupType Automatic `
  --recoveryAction RestartProcess `
  --stdout D:\Software\aria2\stdout.log `
  --stderr D:\Software\aria2\stderr.log
```

随后使用``servy-cli start --name aria2``开启服务，并使用``servy-cli status --name aria2``查看服务，在running中则一切正常！现在可以到本文的末尾安装浏览器插件并连接使用。

> 注意修改用户名！

### Arch linux

Arch linux 和大部分常规发行版可以适用此方法。

首先安装aria2本体:
```bash
paru -S aria2
```
随后创建配置文件
```bash
nano /home/<you-username>/.config/aria2/aria2.conf
```

内容为
```conf
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
```bash
nano ~/.config/systemd/user/aria2.service
```
写入：
```conf
[Unit]
Description=Aria2 Daemon
After=network.target

[Service]
ExecStart=/usr/bin/aria2c --conf-path=/home/<you-username>/.config/aria2/aria2.conf
Restart=on-failure

[Install]
WantedBy=default.target
```

在更新配置文件和服务文件后，执行以下命令以重启服务：
```bash
systemctl --user daemon-reload
systemctl --user enable aria2.service
systemctl --user start aria2.service
```
使用以下命令检查服务状态:
```bash
systemctl --user status aria2.service
```
现在可以到本文的末尾安装浏览器插件并连接使用。

### Nixos

```nix
{ lib, pkgs, username, ... }:
{
  services.aria2.enable = false;
  systemd.services.aria2 = {
    description = "Aria2 Download Manager (dich)";
    after = [ "network.target" ];
    wants = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = username;

      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p /home/${username}/.config/aria2"
        "${pkgs.coreutils}/bin/touch /home/${username}/.config/aria2/aria2.session"
      ];

      ExecStart = "${pkgs.aria2}/bin/aria2c --conf-path=/home/${username}/.config/aria2/aria2.conf";

      Restart = "always";
      RestartSec = "5s";

      NoNewPrivileges = true;
      PrivateTmp = true;
    };
  };
}
```
现在可以到本文的末尾安装浏览器插件并连接使用。

## 命令行用法

如果你不想用浏览器插件或者面板，也可以直接使用命令行操作：

```bash
aria2c [选项] [URL | 磁力链接 | .torrent文件]
```

### 例子：

1. **下载单个文件**

```bash
aria2c https://example.com/file.iso
```

2. **指定保存路径和文件名**

```bash
aria2c -d ~/Downloads -o ubuntu.iso https://releases.ubuntu.com/24.04/ubuntu.iso
```

3. **同时下载多个文件**

```bash
aria2c https://example.com/file1.zip https://example.com/file2.zip
```

4. **从文件读取 URL 列表**

```bash
aria2c -i urls.txt
```
（`urls.txt` 每行一个链接）

7. **下载 torrent 文件**

```bash
aria2c ubuntu.torrent
```

8. **下载磁力链接**

```bash
aria2c "magnet:?xt=urn:btih:xxxxx..."
```

9. **限制 BT 上传**

```bash
aria2c --max-upload-limit=50K ubuntu.torrent
```

## 浏览器插件

如果你想让其直接接管浏览器下载,可以使用以下几种浏览器插件,它们都自带面板：

**Chrome 浏览器**

- [Aria2 Explorer](https://github.com/alexhua/Aria2-Explorer)是一款功能强大的扩展，能够自动拦截浏览器下载任务并自带Aria2-NG面板。

**Firefox 浏览器**

- [Aria2-Integration](https://github.com/RossWang/Aria2-Integration?tab=readme-ov-file)也是一款 Firefox 拓展，拦截下载任务的同时带有 Aria2-NG面板，方便使用。

> 注意！如果你前面配置中设置了rpc的密码，需要在面板中也写入才可连接成功。

![aria2-rpc](/images/aria2-rpc.webp)

## 面板

如果你不想使用浏览器插件，也可以使用aria2+独立面板的方法，但这样就不能接管浏览器的下载，适合其他环境使用。

这里推荐使用 AriaNg 前端，AriaNg 使用纯 html & javascript 开发, 所以其不需要任何编译器或运行环境. 

![ariang-1](https://raw.githubusercontent.com/mayswind/AriaNg-WebSite/master/screenshots/desktop.png)

AriaNg 现在提供三种版本, ``标准版、单文件版和 AriaNg Native. ``标准版适合在 Web 服务器中部署, 提供资源缓存和按需加载的功能. 单文件版适合本地使用, 您下载后只要在浏览器中打开唯一的 html 文件即可. AriaNg Native 同样适合本地使用, 并且不需要使用浏览器.这里``建议使用单文件版或者Native版``,下之后打开其中的html并设为书签即可。

[单文件版(AllinOne)](https://github.com/mayswind/AriaNg/releases)
[Native版](https://github.com/mayswind/AriaNg-Native/releases/tag/1.3.10)

---
**Done.**
