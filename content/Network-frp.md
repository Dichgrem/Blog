+++
title = "网络艺术:FRP使用指南"
date = 2025-03-01

[taxonomies]
tags = ["Network"]
+++

前言 FRP (Fast Reverse Proxy) 是一个用Go语言开发的高性能反向代理应用，可以帮助您轻松地进行内网穿透，对外提供服务.

<!-- more -->

## 简介

FRP (Fast Reverse Proxy) 主要功能包括：

- 支持TCP、UDP、HTTP、HTTPS等多种协议
- 支持Web服务、远程桌面、SSH、游戏服务器等多种应用场景
- 提供加密和压缩功能，保证数据安全性
- 支持多个客户端连接服务端，适用于复杂网络环境

FRP分为客户端(frpc)和服务端(frps)两部分：
- **服务端(frps)**: 部署在有公网IP的服务器上
- **客户端(frpc)**: 部署在内网机器上，负责将内网服务映射到公网

## 安装

### 服务端安装

服务端需要部署在具有公网IP的服务器上。

1. 下载最新版本的FRP发行包：

```bash
wget https://github.com/fatedier/frp/releases/download/v0.51.3/frp_0.51.3_linux_amd64.tar.gz
```

2. 解压文件：

```bash
tar -xzvf frp_0.51.3_linux_amd64.tar.gz
cd frp_0.51.3_linux_amd64
```

3. 现在您可以看到以下文件：
   - frps: 服务端可执行文件
   - frps.ini: 服务端配置文件
   - frpc: 客户端可执行文件
   - frpc.ini: 客户端配置文件


### 客户端安装

客户端需要安装在您的内网设备上，例如需要提供服务的电脑、服务器或IoT设备上。

- Linux/macOS

与服务端安装步骤相同，只需使用frpc程序和frpc.ini配置文件。

- Windows

同样下载Windows版本，解压后使用frpc.exe和frpc.ini。

## 配置

### 服务端配置

服务端配置文件为frps.ini，基本配置如下：

```ini
[common]
# 服务端监听端口，用于与客户端建立连接
bind_port = 7000

# 用于身份验证的token
token = yourSecureToken

# 后台管理页面端口（可选）
dashboard_port = 7500
dashboard_user = admin
dashboard_pwd = admin

# 日志配置
log_file = /var/log/frps.log
log_level = info
log_max_days = 3
```

### 客户端配置

客户端配置文件为frpc.ini，基本配置如下：

```ini
[common]
# 服务端的IP地址或域名
server_addr = x.x.x.x
# 服务端的端口
server_port = 7000
# 认证token，需要与服务端匹配
token = yourSecureToken

# 示例：SSH服务代理
[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000

# 示例：HTTP服务代理
[web]
type = http
local_ip = 127.0.0.1
local_port = 80
custom_domains = www.yourdomain.com
```

### 常用配置示例

#### 1. 代理SSH服务

```ini
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000
token = yourSecureToken

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000
```

使用方法：`ssh -p 6000 username@服务端IP`

#### 2. 代理HTTP网站

```ini
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000
token = yourSecureToken

[web]
type = http
local_ip = 127.0.0.1
local_port = 80
custom_domains = www.yourdomain.com
```

在服务端需要将域名解析到服务端IP。

#### 3. 代理HTTPS网站

```ini
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000
token = yourSecureToken

[web-https]
type = https
local_ip = 127.0.0.1
local_port = 443
custom_domains = www.yourdomain.com
```

#### 4. 代理远程桌面(RDP)

```ini
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000
token = yourSecureToken

[rdp]
type = tcp
local_ip = 127.0.0.1
local_port = 3389
remote_port = 7001
```

## 启动与运行

### 服务端启动

#### Linux/macOS

```bash
./frps -c frps.ini
```

后台运行：

```bash
nohup ./frps -c frps.ini &
```

#### Windows

双击frps.exe或在命令行运行：

```
frps.exe -c frps.ini
```

### 客户端启动

#### Linux/macOS

```bash
./frpc -c frpc.ini
```

后台运行：

```bash
nohup ./frpc -c frpc.ini &
```

#### Windows

双击frpc.exe或在命令行运行：

```
frpc.exe -c frpc.ini
```

### 设置为系统服务

#### Linux (Systemd)

1. 创建服务文件 `/etc/systemd/system/frps.service` (服务端) 或 `/etc/systemd/system/frpc.service` (客户端)

**服务端示例 (frps.service):**

```ini
[Unit]
Description=Frp Server Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/frps -c /etc/frps/frps.ini
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

**客户端示例 (frpc.service):**

```ini
[Unit]
Description=Frp Client Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/frpc -c /etc/frpc/frpc.ini
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

2. 启用并启动服务:

```bash
# 服务端
sudo systemctl enable frps
sudo systemctl start frps

# 客户端
sudo systemctl enable frpc
sudo systemctl start frpc
```

3. 查看服务状态:

```bash
sudo systemctl status frps
# 或
sudo systemctl status frpc
```

#### Windows

1. 使用NSSM (Non-Sucking Service Manager) 创建服务:
   - 下载NSSM: http://nssm.cc/download
   - 安装服务:
     ```
     nssm.exe install frpc C:\path\to\frpc.exe -c C:\path\to\frpc.ini
     ```
   - 启动服务:
     ```
     nssm.exe start frpc
     ```

## 进阶功能

### HTTPS支持

要支持HTTPS服务，需要在服务端添加配置：

```ini
# frps.ini
[common]
bind_port = 7000
vhost_https_port = 443
```

客户端配置：

```ini
# frpc.ini
[web]
type = https
local_ip = 127.0.0.1
local_port = 443
custom_domains = www.yourdomain.com
```

### 多路复用

使用多路复用可以减少连接数，提高性能：

```ini
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000
token = yourSecureToken
# 启用多路复用
tls_enable = true
pool_count = 5
```

### 加密与压缩

增加数据传输的安全性：

```ini
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000
token = yourSecureToken
# 启用加密和压缩
use_encryption = true
use_compression = true
```

### 负载均衡

通过配置多个后端服务实现负载均衡：

```ini
# frpc.ini
[web]
type = tcp
local_ip = 127.0.0.1
local_port = 80
remote_port = 8080
group = web
group_key = 123456

[web2]
type = tcp
local_ip = 127.0.0.1
local_port = 8081
remote_port = 8080
group = web
group_key = 123456
```

### 访问控制

限制客户端连接数量和带宽：

```ini
# frps.ini
[common]
bind_port = 7000
token = yourSecureToken
max_pool_count = 50
max_ports_per_client = 10
```

## 常见问题排查

### 1. 连接被拒绝

**问题**: 客户端报错 "dial tcp x.x.x.x:7000: connect: connection refused"

**解决方案**:
- 检查服务端IP和端口是否正确
- 确认服务端frps是否正在运行
- 检查防火墙是否允许7000端口通信

### 2. 认证失败

**问题**: 客户端日志显示 "login to server failed: authentication failed"

**解决方案**:
- 确认客户端和服务端的token设置一致
- 检查服务端日志是否有更多错误信息

### 3. 端口已被占用

**问题**: 服务端启动失败，提示 "bind: address already in use"

**解决方案**:
- 更改配置中的端口
- 终止占用该端口的其他应用
- 使用 `netstat -tunlp | grep 端口号` 查看占用该端口的进程

### 4. 无法访问代理服务

**问题**: 代理设置正确，但无法访问服务

**解决方案**:
- 检查本地服务是否正常运行
- 确认local_ip和local_port设置正确
- 使用 `curl localhost:本地端口` 测试本地服务
- 检查服务端防火墙是否开放了remote_port

### 5. 代理连接不稳定

**问题**: 连接经常断开

**解决方案**:
- 增加心跳包频率，在[common]部分添加:
  ```
  heartbeat_interval = 30
  heartbeat_timeout = 90
  ```
- 启用多路复用和连接池

### 6. 域名解析失败

**问题**: 使用custom_domains配置，但无法通过域名访问

**解决方案**:
- 确保域名已正确解析到服务端IP
- 检查frps.ini中是否配置了http/https的监听端口
- 使用 `dig` 或 `nslookup` 命令验证域名解析


🔗

- [FRP官方文档](https://gofrp.org/docs/)
- [FRP GitHub仓库](https://github.com/fatedier/frp)
- [FRP常见问题解答](https://github.com/fatedier/frp/issues)

---
**Done.**
