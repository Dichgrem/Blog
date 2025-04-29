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
apt install wget curl vim sudo neofetch
apt update && apt upgrade -y
apt-get install --fix-missing
adduser xxx
sudo usermod -aG sudo xxx
```
## BBR
查询系统所支持的拥塞控制算法。

````
$ sysctl net.ipv4.tcp_available_congestion_control
net.ipv4.tcp_congestion_control = bbr cubic reno
````

查询正在使用中的拥塞控制算法（Linux 绝大部分系统默认为 Cubic 算法）。

````
$ sysctl net.ipv4.tcp_congestion_control
net.ipv4.tcp_congestion_control = cubic
````

指定拥塞控制算法为 bbr。

````
$ echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf && sysctl -p
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




## Docker

### 脚本安装

Docker 官方提供了一个安装脚本，可以自动选择适当版本，并规避仓库问题：
```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```
这个脚本会为你的系统自动选择合适的安装方式。

### 使用 Docker 存储库安装

使用以下命令安装此方法的先决条件：

````
sudo apt update && sudo apt install ca-certificates curl gnupg
````

创建一个目录来存储密钥环：

````
sudo install -m 0755 -d /etc/apt/keyrings
````

使用给定的命令下载 GPG 密钥并将其存储在 `/etc/apt/keyrings/etc/apt/keyrings` 目录中：

````
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
````

使用 chmod 命令更改 docker.gpg 文件的权限：

````
sudo chmod a+r /etc/apt/keyrings/docker.gpg
````

使用以下命令为 Docker 设置存储库：

````
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
````

上述命令中每行末尾的额外 `\` 只是添加新行的一种方式，以便您可以轻松查看整个命令。就是这样！

现在可以使用以下命令更新存储库索引并安装 Docker：

````
sudo apt update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
````

要验证 Docker 安装，安装 hello-world 映像：

````
sudo docker run hello-world
````

hello-world docker 镜像很小，仅用于检查 Docker 是否运行正常。


### 卸载 Docker

要删除所有 Docker 容器和 Docker 本身，可以按照以下步骤操作：
1. 首先停止所有正在运行的容器：
```
docker stop $(docker ps -aq)
```
2. 删除所有容器

删除所有容器（包括停止的容器）：
```
docker rm $(docker ps -aq)
```
3. 删除所有镜像

```
docker rmi $(docker images -q)
```
4. 删除所有网络

```
docker network prune -f
```
5. 删除所有未使用的卷

```
docker volume prune -f
```
6. 卸载 Docker

最后，如果您希望完全删除 Docker 本身，可以执行以下命令:
```
sudo apt-get purge docker-ce docker-ce-cli containerd.io
sudo apt-get autoremove --purge
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker
```

这些命令会卸载 Docker 软件并删除 Docker 数据目录。

### Docker 常用命令
```
docker-compose up -d    #在后台启动容器
docker-compose ps       #查看正在运行的容器
docker-compose down     #停止并移除所有运行中的容器
docker-compose stop     #停止容器，但保留数据和卷
docker pull <镜像名称>:latest #拉取最新镜像
docker-compose build    #更新镜像后重新构建
docker-compose logs     #查看日志
docker image prune -a   #删除所有未被容器使用的镜像
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
---
**Done.**

