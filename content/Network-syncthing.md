+++
title = "网络艺术:Syncthing 使用指南"
date = 2025-04-17

[taxonomies]
tags = ["Network"]
+++

前言  在多设备使用的时代，我们常常需要在电脑、服务器、笔记本之间同步文件。常见方案包括网盘、WebDAV、rsync 等，但这些方案要么依赖中心服务器、要么配置复杂、要么对实时性不友好。

<!-- more -->

## 介绍

**Syncthing** 是一款开源、去中心化、点对点（P2P）的文件同步工具，主打 **安全、私有、实时同步**。与传统网盘不同，Syncthing 不依赖任何中心服务器，所有数据直接在你的设备之间传输。

Syncthing 具有以下特点：

- ``去中心化``：设备之间点对点同步，不依赖第三方服务器；
- ``安全``：所有通信均使用 TLS 加密，并基于设备 ID 认证；
- ``跨平台``：支持 Windows、Linux、macOS、Android 等；
- ``实时同步``：文件变化可实时同步到其他设备；
- ``Web 管理界面``：通过浏览器即可完成绝大多数配置；
- ``开源``：代码完全开源，社区活跃。

## Windows

Windows 下推荐直接使用[SyncthingWindowsSetup](https://github.com/Bill-Stewart/SyncthingWindowsSetup)安装,会自动下载最新的syncthing二进制并设置系统服务。

- Web UI 默认地址：

```bash
http://127.0.0.1:8384
```

## Arch Linux

- 使用paru包管理器安装：

```bash
paru -S syncthing
```

- 创建 systemd 用户服务

```bash
sudo systemctl enable --now syncthing@<你的用户名>.service
```

- 查看状态：

```bash
systemctl --user status syncthing.service
```

- Web UI 默认地址：

```bash
http://127.0.0.1:8384
```

## NixOS

NixOS 自带 Syncthing 模块，配置非常优雅。

```nix
{ lib, pkgs, username, ... }:

{
  services.syncthing = {
    enable = true;
    user = username;
    dataDir = "/home/${username}/Sync";
    configDir = "/home/${username}/.config/syncthing";
    guiAddress = "127.0.0.1:8384";
  };
}
```

- 服务状态查看：

```bash
systemctl status syncthing.service
```

## 基本使用

Syncthing 的所有核心操作都可以通过 Web UI 完成，进入 Web UI 后先设置用户名和密码：

```bash
http://127.0.0.1:8384
```

### 添加设备

- 在本机和另一台设备上启动 Syncthing；
- 分别设置同步文件夹，注意ID要相同；
- 复制对方的 **设备 ID**；
- 在 Web UI 中点击「添加远程设备」；
- 双方确认后即可开始同步。

### 文件夹同步模式

Syncthing 支持多种同步模式：

* **Send & Receive**：双向同步（默认）
* **Send Only**：只向外同步
* **Receive Only**：只接收更改

---

**Done.**
