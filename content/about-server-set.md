+++
title = "乱七八糟:服务器初始化与安全设置"
date = 2024-06-12

[taxonomies]
tags = ["乱七八糟"]
+++

前言 本文记录服务器常用操作步骤。
<!-- more -->

## Doamin

建站不一定需要服务器、域名和备案。尤其不要买腾讯云，不要买CN域名；备案过程要填很多个人信息，且一周没有解析网站，备案就会自动注销。

- **cn 域名没有隐私保护（whois protection）**。国内域名注册商说的隐私保护根本是自欺欺人，在它们隐私保护就是在自己的查询服务隐藏注册人信息。但在别的地方是能查到的，在[中国互联网络信息中心](https://whois.cnnic.cn/)可以查到每个 cn 域名注册人的姓名和邮箱。

- **注册 cn 域名必须使用真实身份信息**。要是你想用假信息注册来保护隐私，那就太天真了。审核的时候不会通过的。真的不想用自己的信息注册的话，要么以公司名义注册，但公司的法定代表人还是能查到的。要么叫别人注册域名之后给你用，可谁愿意冒这种风险呢。

- **cn 域名无法删除**。如果你觉得 cn 域名暴露了你的隐私，那对不起，这是不能注销的[3](https://cyrusyip.org/zh-cn/post/2021/05/25/damn-cn-domain/#fn:3)。你只能修改邮箱地址，然后等到它过期。或者转让给别人，不过感觉把别人推到火坑里不太好啊。

- **cn 域名有被停用的风险**。2008 年，有人以跳水奥运冠军吴敏霞拼音注册了 wuminxia.cn，[结果被中国互联网络信息中心（CNNIC）回收了域名](https://www.cnbeta.com/articles/tech/62209.htm)，并转交给国家体育总局。此域名在 2021 年 2 月 28 日被优视科技[注册](https://whois.cnnic.cn/WhoisServlet?queryType=Domain&domain=wuminxia.cn)，呵呵。2009 年，牛博网被域名注册商万网停止解析。

## VPS
```
# 更新系统
apt update && apt upgrade -y
apt install wget curl vim sudo neofetch
# 创建用户并赋予sudo
adduser xxx
sudo usermod -aG sudo xxx
```
## BBR

- 查询系统所支持的拥塞控制算法
````
sysctl net.ipv4.tcp_available_congestion_control
````
- 查询正在使用中的拥塞控制算法（Linux 绝大部分系统默认为 Cubic 算法）
````
sysctl net.ipv4.tcp_congestion_control
````
- 指定拥塞控制算法为 bbr
````
echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf && sysctl -p
````

## Safe

> 使用密码登录：更换SSH端口+安装UFW+安装Fail2ban
> 使用密钥登录：不用额外操作

### 更换SSH端口

使用root账户或已经有sudo权限的用户登录到系统。

打开SSH配置文件`sshd_config`，可以使用文本编辑器如nano或vi。以下是使用nano编辑器的示例：

````
sudo vim /etc/ssh/sshd_config
````

在配置文件中找到以下行：

````
Port 22
````

这是SSH默认的端口号，你可以将其更改为你想要的任何未被占用的端口号。例如，将端口更改为2222：

````
Port 2222
````

保存并关闭文本编辑器。重新启动SSH服务，以应用更改：

````
sudo service ssh restart
````

或者，如果你的系统使用systemd，可以使用以下命令：

````
sudo systemctl restart ssh
````

### 安装 UFW

````
sudo apt install ufw
````

**如果你在远程位置连接你的服务器，在启用 UFW 防火墙之前，你必须显式允许进来的 SSH 连接。否则，你将永远都无法连接到机器上。**

````
sudo ufw allow 22/tcp
````

> 如果 SSH 运行在非标准端口，你需要将上述命令中的 22 端口替换为对应的 SSH 端口。

**启动 UFW**

````
sudo ufw enable
````

### 安装 Fail2ban

````
sudo apt-get install fail2ban
````

**2、Debian 12 及以上的版本需要手动安装 rsyslog**

````
sudo apt-get install rsyslog
````

**3、启动 Fail2ban 服务**

````
sudo systemctl start fail2ban
````

**4、开机自启动**

````
sudo systemctl enable fail2ban
````

**5、查看 Fail2ban 服务状态。**

````
sudo systemctl status fail2ban
````



### 改为密钥登录

- 执行以下命令生成.pub后缀的公钥和无后缀的密钥：
```
ssh-keygen
```
注意不同密钥对名称不能相同；同时可以为这两个文件用密码加密；

- 随后将.pub后缀的公钥中的内容写入服务器的``~/.ssh/authorized_keys``中；

- 使用以下命令编译服务器的SSH配置：
```
vim /etc/ssh/sshd_config
```
将其中的该行改为``PasswordAuthentication no``，保存退出；随后使用
```
sudo systemctl restart sshd
```
重启SSH即可禁用密码登录；

- 将**PermitRootLogin**一栏改为**PermitRootLogin prohibit-password**，即可实现仅root用户密钥登录；

- 使用以下命令查看输出，
```
sudo cat /etc/ssh/sshd_config | grep -E 'PasswordAuthentication|PubkeyAuthentication'
```
如有**PasswordAuthentication no → 禁用密码登录**以及**PubkeyAuthentication yes → 允许密钥登录**则成功。

> 注意**authorized_keys**的权限为600，如果不是则需要改正：``chmod 600 ~/.ssh/authorized_keys``

## 常用环境

- ALL 

```
apt install curl wget gpg vim nano sudo neofetch openssh-server
```
- C/C++ 
```
sudo apt install build-essential gdb cmake clangd clang-format libstdc++-dev
```
- Miniconda 
```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```
- UV
```
curl -LsSf https://astral.sh/uv/install.sh | sh
```
- Docker
```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```
- OpenCV
```
sudo apt install tree libx11-dev libgtk-3-dev freeglut3-dev libopencv-dev libdlib-dev
```
- Vmware
```
sudo apt install open-vm-tools
sudo apt install open-vm-tools-desktop
```
> Vscode无法连接：需要删除本地存储的错误密钥，powershell：

```powershell
(Get-Content "$env:USERPROFILE\.ssh\known_hosts") | 
Where-Object { $_ -notmatch '<你的IP>' } | 
Set-Content "$env:USERPROFILE\.ssh\known_hosts"
```
## 1panel

执行如下命令一键安装 1Panel:

````
curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sudo bash quick_start.sh
````



### 禁用 IPv6

手动 禁用 VPS 的 IPv6 命令:
```
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
```
如果想重启系统也生效， 执行：
```
echo 'net.ipv6.conf.all.disable_ipv6=1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.default.disable_ipv6=1' >> /etc/sysctl.conf
```
手动 启用 VPS 的 IPv6 命令:
```
sysctl -w net.ipv6.conf.all.disable_ipv6=0
sysctl -w net.ipv6.conf.default.disable_ipv6=0
```
重新载入 sysctl 配置
```
sysctl --system # reload sysctl
```
如果重载, 还无效果, 可能要 reboot 重启下.
查看 VPS 的 IPv6 信息
```
ip -6 addr show scope global

或者 curl ipv6.ip.sb
```


## IP证书申请部署

- 在 [ZeroSSL](https://zerossl.com/) 中申请一个90天的证书；

- 然后在VPS上输入以下命令：

```
mkdir -p ./.well-known/pki-validation
```
- 随后在ZeroSSL中将所给出的类似**B992F08CB46748D02E4C553A4038BC.txt**复制；

- 将从ZeroSSL下载得到的文件打开，复制里面的东西形成以下的格式:``将pki-validation/之后EOF之前的内容``替换为你自己的。
```
cat << EOF | sudo tee ./.well-known/pki-validation/B992F08CB46748D02E4C553A4038BC.txt
254563C20918258D661E7D43D6A43A2A258857E191977DD5F740FBB9ABD25279
comodoca.com
ca5792984e3f0a1
EOF
```
随后在VPS上运行该命令。
- 开启一个临时HTTP服务器：
```
python3 -m http.server 80
```
- 随后即可在ZeroSSL中验证证书并开启SSL。


## 忘记密码怎么办

通过恢复模式 (Recovery Mode) 修改用户权限：

- 重启计算机，按住 Shift 键进入 GRUB 菜单（或者按 Esc 键）。

- 在 GRUB 菜单中，选择`Advanced options for Ubuntu`然后选择带有`recovery mode`的内核版本。

- 进入恢复模式后，选择`root – Drop to root shell prompt`进入 root shell（不需要密码）。

- 挂载文件系统为可写模式：
```
mount -o remount,rw /
```
- 将用户添加到 sudo 组：
```
usermod -aG sudo 用户名
```
- 重启计算机：
```
reboot
```

## 更换内核

以Xanmod为例：

1. 添加 XanMod 仓库密钥和源

```bash
echo 'deb [signed-by=/usr/share/keyrings/xanmod.gpg] http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod.list
curl -fsSL https://dl.xanmod.org/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/xanmod.gpg > /dev/null
```

2. 更新软件包列表

```bash
sudo apt update
```

3. 搜索可用内核
```
apt search xanmod
sudo apt install linux-image-6.8.6-x64v3-xanmod1 linux-headers-6.8.6-x64v3-xanmod1
```

### 常见 XanMod 内核后缀含义对比

| 后缀示例                       | 含义简述                               | 适合用途                |
| -------------------------- | ---------------------------------- | ------------------- |
| `xanmod1`, `xanmod2`, …    | 主线 XanMod 版本编号（带通用优化）              | 桌面、通用、游戏            |
| `x64v3-xanmod1`            | 针对 **x86\_64-v3 架构优化**（AVX2 以上指令集） | 高性能桌面、较新 CPU（2011+） |
| `rt-xanmod1`               | **实时（RT）内核**，用于极低延迟任务              | 音频制作、工业控制           |
| `lts-xanmod1`              | **长期支持版本**（LTS）                    | 服务器、稳定性优先           |
| `edge-xanmod1`             | 更前沿、不稳定的测试版本                       | 喜欢尝鲜的高级用户           |
| `x64v2-xanmod1`, `x64v4-…` | 针对特定 **微架构（CPU 指令集）** 的优化版本        | 有特定硬件支持的系统          |

你可以用以下命令检测你的 CPU 是否支持 `x64v3`：

```bash
lscpu | grep avx2
```
如果输出中有 `avx2`，就可以用 `x64v3` 版本。



4. 更新 GRUB 并重启

```bash
sudo update-grub
sudo reboot
uname -r
```

5. 移除旧内核（可选）

查看已安装内核：

```bash
dpkg --list | grep linux-image
```

移除旧的：

```bash
sudo apt remove linux-image-5.10.0-26-amd64
```

---

6. 自动选择 XanMod 为默认（可选）

如果你想默认引导到 XanMod 内核：

编辑 `/etc/default/grub`：

```bash
GRUB_DEFAULT="Advanced options for Debian>Debian, with Linux 6.8.6-x64v3-xanmod1"
```
然后：

```bash
sudo update-grub
```

## 更换系统

除了到VPS后台更换外，还可以使用这个脚本：

- [bin456789/reinstall](github.com/bin456789/reinstall)

```
一键重装到 Linux，支持 19 种常见发行版
一键重装到 Windows，使用官方原版 ISO 而非自制镜像，脚本支持自动查找 ISO 链接、自动安装 VirtIO 等公有云驱动
支持任意方向重装，即 Linux to Linux、Linux to Windows、Windows to Windows、Windows to Linux
自动设置 IP，智能设置动静态，支持 /32、/128、网关不在子网范围内、纯 IPv6、IPv4/IPv6 在不同的网卡
专门适配低配小鸡，比官方 netboot 需要更少的内存
全程用分区表 ID 识别硬盘，确保不会写错硬盘
支持 BIOS、EFI 引导，支持 ARM 服务器
不含自制包，所有资源均实时从镜像源获得
```

---
**Done.**

