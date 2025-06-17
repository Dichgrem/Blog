+++
title = "乱七八糟:GPG使用小记"
date = 2025-06-17

[taxonomies]
tags = ["乱七八糟"]
+++

前言 PGP/GPG 的核心功能——公钥加密、数字签名、信任管理广泛用于各个行业，本文简单说明了其使用方法。 

<!-- more -->

## 什么是 PGP 与 GPG

* **PGP（Pretty Good Privacy）**

  * 由 Phil Zimmermann 于 1991 年发布，是第一个面向个人用户的大众化加密软件。
  * 采用公钥加密体系，用于对邮件和文件进行加密、签名与验证。
* **GPG（GNU Privacy Guard，又称 GnuPG）**

  * 项目发起于 1997 年，由 Free Software Foundation 推动，是 GPL 许可的自由软件实现。
  * 完全兼容 OpenPGP 标准（RFC 4880），可无缝替代 PGP 软件。


## 历史沿革

| 时间     | 事件                                        |
| ------ | ----------------------------------------- |
| 1991 年 | Phil Zimmermann 发布 PGP 1.0，标志个人加密进入大众市场   |
| 1994 年 | PGP 因出口管制遭到美国政府调查，后续改版加密算法合规化             |
| 1997 年 | GNU 推出 GnuPG，目标创建一个开源、自由的 OpenPGP 实现      |
| 2001 年 | OpenPGP 正式成为 IETF 标准（RFC 2440）            |
| 2006 年 | GnuPG 2.0 发布，引入多子系统（gpg-agent、dirmngr 等）  |
| 2014 年 | OpenPGP 更新为 RFC 4880bis，GnuPG 不断改进对新算法的支持 |


## 核心作用

| 应用领域 | 描述 |
|----------|------|
| **1. 电子邮件加密与签名** | - **PGP/MIME**：通过邮件客户端（如 Thunderbird + Enigmail）对正文和附件加密，并用私钥签名。<br>- **PGP inline**：将加密/签名内容以纯文本形式嵌入邮件，兼容性更强。 |
| **2. 文件与目录的加密签名** | - **单文件加密/解密**：<br>`gpg --encrypt --recipient Alice file.txt`<br>`gpg --decrypt file.txt.gpg`<br>- **归档目录加密**：使用 `tar` 打包后再加密。<br>- **签名校验**：<br>`gpg --detach-sign --armor release.tar.gz`<br>`gpg --verify release.tar.gz.asc release.tar.gz` |
| **3. 软件包与系统镜像签名** | - Linux 包管理签名：APT、pacman-key 等验证来源可信性。<br>- 容器镜像签名：结合 TUF/Notary 使用 GPG 保护 Docker 镜像完整性。 |
| **4. SSH 公钥管理与登录** | - 将 GPG 子密钥作为 SSH 密钥使用：<br>`echo "enable-ssh-support" >> ~/.gnupg/gpg-agent.conf`<br>`gpgconf --reload gpg-agent`<br>`ssh-add -L`<br>- 好处：私钥集中管理、PIN保护、跨平台一致。 |
| **5. 自动化脚本与 CI/CD 环境** | - 用 GPG 自动签名构建产物，供用户验证。<br>- 将签名集成进发布脚本（如 `release.sh`），自动生成 `.sig` 并上传。 |
| **6. 文档与 PDF 数字签名** | - 利用 `gpgsm` 或 `OpenPGP.js` 对 PDF、Office 文档签名，保障法律或审计合规性。 |
| **7. 密码管理与“密码库”** | - **pass**：每个密码为一个 GPG 加密文件，支持 Git 同步和版本控制。<br>- **git-crypt**：自动加密 Git 仓库中的敏感文件，仅授权者可解密。 |
| **8. 安全聊天与即时通讯** | - 将 OTR 会话密钥托管在 GPG 中（如 `mcabber` + OTR），实现端到端加密。 |
| **9. 时间戳与不可篡改日志** | - 结合 GPG 签名与时间戳协议（如 RFC 3161）验证文件/日志未被篡改。 |
| **10. 去中心化信任与身份管理** | - 使用 Web of Trust 模型构建可信身份网络，用于开源社区签名、Key Signing Party、LDAP 交换等。 |


## 安装 GnuPG

```
paru -S gnupg
```

## 生成公钥与私钥

使用如下命令：
```
gpg --full-generate-key
```
生成流程：

```
gpg (GnuPG) 2.4.7; Copyright (C) 2024 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (9) ECC (sign and encrypt) *default*
  (10) ECC (sign only)
  (14) Existing key from card
Your selection? 9   ## 默认选择ECC算法
Please select which elliptic curve you want:
   (1) Curve 25519 *default*
   (4) NIST P-384
   (6) Brainpool P-256
Your selection? 1   ## 默认选择标准椭圆曲线
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 1y   ## 默认有效期为一年
Key expires at 2026年06月17日 星期三 13时06分27秒 CST
Is this correct? (y/N) y

GnuPG needs to construct a user ID to identify your key.

## 输入名字与邮箱,comment可省略

Real name: xxx
Email address: xxx@gmail.com
Comment:
You selected this USER-ID:
    "xxx <xxx@gmail.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit?
Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
```

## 列出密钥
```
gpg --list-secret-keys --keyid-format long
```

其中``sec ed25519/xxxxxxxxx 2025-06-17 [SC] [expires: 2026-06-17]``的xxxxxxxxx即为公钥ID。

## 发布公钥

例如上传你的 key：

```
gpg --send-keys <你的Long‑Key‑ID>
```

默认为你的 gpg.conf 中配置的 keyserver，也可以显式指定：

```
gpg --keyserver hkps://keys.openpgp.org --send-keys <Key‑ID>
```

也可以使用如下命令导出公钥为可读 ASCII 格式，类似ssh-keys，随后即可发布在个人博客上等等。
```
gpg --armor --export <Key‑ID>  > mypubkey.asc
```

## 撤销公钥

如果怀疑密钥被泄露或被中间人替换，立即发布“撤销证书”（revocation certificate）并上传到 keyserver。

```
gpg --gen-revoke <KeyID> > revoke.asc
```
上传撤销证书后，所有人都能知道该公钥已不再可信。

---
**Done.**
