+++
title = "网络艺术:SSH使用指南"
date = 2025-05-02

[taxonomies]
tags = ["Network"]
+++

前言 SSH（Secure Shell 的缩写）是一种网络协议，用于加密两台计算机之间的通信，并且支持各种身份验证机制。

<!-- more -->

## 历史

1995年，芬兰赫尔辛基工业大学的研究员 Tatu Ylönen 设计了 ``SSH 协议的第一个版本（现称为 SSH 1）``，同时写出了第一个实现（称为 SSH1）。

当时，他所在的大学网络一直发生密码嗅探攻击，他不得不为服务器设计一个更安全的登录方式。写完以后，他就把这个工具公开了，允许其他人免费使用。

SSH 可以替换 rlogin、TELNET、FTP 和 rsh 这些不安全的协议，所以大受欢迎，用户快速增长，1995年底已经发展到五十个国家的20,000个用户。SSH 1 协议也变成 IETF 的标准文档。

1995年12月，由于客服需求越来越大，``TatuYlönen就成立了一家公司SCS，专门销售和开发SSH``。这个软件的后续版本，逐渐从免费软件变成了专有的商业软件。

SSH 1 协议存在一些安全漏洞，所以``1996年又提出了 SSH 2 协议（或者称为 SSH 2.0）``。这个协议与1.0版不兼容，在1997年进行了标准化，1998年推出了软件实现 SSH2。但是，官方的 SSH2 软件是一个专有软件，不能免费使用，而且 SSH1的有些功能也没有提供。

1999年，OpenBSD 的开发人员决定写一个``SSH 2 协议的开源实现`` ，这就是 OpenSSH 项目。该项目最初是基于 SSH 1.2.12 版本，那是当时 SSH1 最后一个开源版本。但是，OpenSSH 很快就完全摆脱了原始的官方代码，在许多开发者的参与下，按照自己的路线发展。OpenSSH 随 OpenBSD 2.6 版本一起提供，以后又移植到其他操作系统，成为最流行的 SSH 实现。目前，Linux 的所有发行版几乎都自带 OpenSSH。

## 开始

李华是一个大学生，现在他买了一台服务器，公网IPv4为114.514.114.514,李华打算连到上面看看：

```
ssh -p 22 root@114.514.114.514
```
随后命令行弹出了密码输入，李华输入了初始密码114514,成功登录了进去；现在每次登录只要输入一行命令就可以，大功告成！

## 安全

一段时间后，李华的linux知识提高了不少，他发现有不少IP在用随机密码不断尝试登录自己的服务器！这太危险了！

于是，李华查阅了资料，发现有一篇博客[乱七八糟:服务器初始化与安全设置](https://blog.dich.bid/about-server-set/)，于是他将openssh-server的端口改成了2333,并开启了fail2ban，这下应该安全了！

```
### 更换SSH端口

使用root账户或已经有sudo权限的用户登录到系统。

打开SSH配置文件`sshd_config`，可以使用文本编辑器如nano或vi。以下是使用nano编辑器的示例：

sudo vim /etc/ssh/sshd_config

在配置文件中找到以下行：

Port 22

这是SSH默认的端口号，你可以将其更改为你想要的任何未被占用的端口号。例如，将端口更改为2333：

Port 2333

保存并关闭文本编辑器。重新启动SSH服务，以应用更改：

sudo service ssh restart

或者，如果你的系统使用systemd，可以使用以下命令：

sudo systemctl restart ssh

### 安装 Fail2ban

sudo apt-get install fail2ban

#### Debian 12 及以上的版本需要手动安装 rsyslog

sudo apt-get install rsyslog

####启动 Fail2ban 服务

sudo systemctl start fail2ban

#### 开机自启动

sudo systemctl enable fail2ban

#### 查看 Fail2ban 服务状态

sudo systemctl status fail2ban

```

但是服务器依然在被爆破，李华又又研究了以下教程，决定将自己的服务器由密码登录改为密钥登录，这下没有牛马来爆破了！

```
#### 执行以下命令生成.pub后缀的公钥和无后缀的密钥：

ssh-keygen

注意不同密钥对名称不能相同；同时可以为这两个文件用密码加密；

#### 随后将.pub后缀的公钥中的内容写入服务器的~/.ssh/authorized_keys中；

#### 使用以下命令编译服务器的SSH配置：

vim /etc/ssh/sshd_config

将其中的该行改为PasswordAuthentication no，保存退出；随后使用

sudo systemctl restart sshd

重启SSH即可禁用密码登录；

#### 将PermitRootLogin一栏改为PermitRootLogin prohibit-password**，即可实现仅root用户密钥登录；

#### 使用以下命令查看输出，

sudo cat /etc/ssh/sshd_config | grep -E 'PasswordAuthentication|PubkeyAuthentication'

如有PasswordAuthentication no → 禁用密码登录以及PubkeyAuthentication yes → 允许密钥登录则成功。

> 注意authorized_keys**的权限为600，如果不是则需要改正：chmod 600 ~/.ssh/authorized_keys
```

## 管理

现在服务器安全了，但随着服务器数量的增加，李华很快发现一个新问题，如何管理这些个SSH连接呢？手动输入太慢了，每次都要复制粘贴也很麻烦，但是又不得不用，总不能回退到密码时代吧？况且数量多了，密码也记不住。

于是李华运用软件工程学的思想，想着，这种大众的需求应该有人解决过了吧？果然，李华很快在GitHub上找到了一个开源跨平台的SSH管理软件，[electerm](https://github.com/electerm/electerm)!

![electerm](/images/electerm.png)

通过在electerm的书签中写入服务器的地址，登录用户和密钥，只要打开electerm并点击书签就可以连接了，太方便了！

## 返璞

随着技术阅历的增长，李华看electerm越来越不顺眼：用它管理SSH固然方便，但同时这就得在各个系统上安装一个Electron架构的软件，而且用electerm的shell并不好用,并且备份electerm的配置不能给其他软件使用。终于，在一次界面崩溃之后李华忍无可忍，决定更换新的方案！

通过研究，李华发现原来openssh有自带的管理方法，且非常便捷好用。

首先，李华在用户目录下创建了一个``.ssh``文件夹，linux中在``/home/username/.ssh``这里，windows下在``C:\Users\username\.ssh``这里。

随后，李华安装了openssh在系统上，linux中一般已经存在，windows上在``设置-系统-可选功能-添加功能``中选中OpenSSH Client和openssh-server开启即可.

随后，李华在.ssh文件夹下创建了一个文件，名为``config``，并在其中写入以下内容：

```
Host US
    HostName 114.514.114.514
    User root
    IdentityFile ~/.ssh/US
    IdentitiesOnly yes
```

随后李华在对应的位置``~/.ssh/US``创建了一个文件，李华将服务器的私钥放了进去,里面是以``-----BEGIN OPENSSH PRIVATE KEY-----``开头``-----END OPENSSH PRIVATE KEY-----``结尾的私钥。

现在，要登录``114.514.114.514``这台服务器，只需要使用``ssh US``命令就可以连上服务器了，不用再手动输入了！

## 归真

在进一步了解SSH之后，李华很快又发现了新的问题，服务器的私钥放在本地是不安全的！尤其是Windows这种安装源松散，鱼龙混杂的系统上。究竟有没有更好的方法呢？在对keepassxc进行研究后，李华终于得出了一个几乎完美的方案！

- 开启keepassxc的SSH代理集成
- 本地.ssh文件夹只保留公钥
- 私钥保存在keepassxc的一个组中

这样一来，当你执行``ssh xxx``时，ssh 不是去读私钥文件，而是通过``SSH_AUTH_SOCK``环境变量找到 KeePassXC 的 agent。KeePassXC 会提示你解锁数据库/确认使用密钥。私钥不会离开 KeePassXC，只是 KeePassXC ``用私钥做一次签名``，把结果返回给 ssh。这样，``硬盘上不需要保存私钥文件``，安全性更高，且``只需要备份.ssh文件夹和keepassxc的kbdx文件``即可.

那么该怎么做呢？

首先，将.ssh文件夹中的config进行修改,把私钥文件改为公钥文件，同时创建对应的``~/.ssh/US.pub``公钥文件，里面是以ssh-ed25519或者ssh-rsa开头的公钥.


```
Host US
    HostName 114.514.114.514
    User root
    IdentityFile ~/.ssh/US.pub
    IdentitiesOnly yes
```

随后在keepassxc的设置-ssh代理中开启``启用SSH代理集成``.（openssh）

接下来在keepassxc中左侧栏``新建一个文件夹``，名为SSH，里面``新建条目``，标题为US（和config中一致），然后在右侧``高级``中``新建``附件，文件名为US（和config中保持一致），文件内容为US的私钥.随后在左侧SSH代理中选中``在打开或解锁数据库的时候，向代理添加密钥``和``数据库锁定或关闭时，从SSH代理中删除密钥``这两个选项，并将下面的``私钥``选择``附件``，即为我们刚刚在高级中新建的US，可以看到对应的公钥也出现了，上一步没有公钥的可以在这里添加.按``确定``后关闭keepassxc并重新开启，这时候就可以使用``ssh US``命令登录了！

> 注意每次登录前先开启keepassxc并解锁！

---
**Done.**










