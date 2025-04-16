+++
title = "电子邮件是如何工作的:自建域名邮箱"
date = 2024-02-22

[taxonomies]
tags = ["网络艺术"]
+++

前言 poste.io 邮件服务基于 Docker 搭建，用的是 Haraka + Dovecot + SQLite 邮件系统，占用资源较少，安装简单，适合个人使用。

<!-- more -->

## VPS上的配置

### 修改VPS hostname
```
hostnamectl set-hostname mail.your-domain.com
```
### 修改hosts文件
```
vim /etc/hosts
```
添加一行
```
127.0.1.1 localhost.localdomain mail.your-domain.com
```


## 安装poste

docker compose文件示例：

```
version: '3.7'

services:
  mailserver:
    image: analogic/poste.io
    hostname: mail.your-domain.com
    ports:
      - "25:25"
      - "110:110"
      - "143:143"
      - "587:587"
      - "993:993"
      - "995:995"
      - "4190:4190"
      - "465:465"
      - "127.0.0.1:8808:80"
      - "127.0.0.1:8843:443"
    environment:
      - LETSENCRYPT_EMAIL=admin@your-domain.com
      - LETSENCRYPT_HOST=mail.your-domain.com
      - VIRTUAL_HOST=mail.your-domain.com
      - DISABLE_CLAMAV=TRUE
      - TZ=Asia/Shanghai
      - HTTPS=OFF
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./mail-data:/data
```

- 禁用反病毒功能（DISABLE_CLAMAV=TRUE）、禁用反垃圾邮件功能（DISABLE_RSPAMD=TRUE），可以大幅减低内存和CPU占用，请酌情设置禁用选项。

- 禁用WEB收发功能（DISABLE_ROUNDCUBE=TRUE），可以进一步减少资源占用，不过非必要不建议禁止。

- 8808为http端口，可以根据自己的需求修改。

## Dns配置


| 记录类型 | 主机记录 | 记录值 |
|----------|----------|----------|
| A        | mail | 1.2.3.4 (your ip) |
| MX       | your-domain.com | mail.your-domain.com |
| TXT      | your-domain.com | v=spf1 mx ~all |
| TXT      | _s20160910378._domainkey.your-domain.com | k=rsa;p=MII.........|
| TXT      | _dmarc | v=DMARC1; p=none; pct=100; rua=mailto:mail@your-domain.com |
| CNAME    | imap | mail |
| CNAME    | smtp | mail |
| CNAME    | pop  | mail |

最后还需到 VPS 服务商处添加一个反向 DNS，也就是 rDNS 解析，把 IP 解析到 mail.your-domain.com 这个域名，有些 VPS 商家不提供这种服务,所以需要选择好VPS服务商。

## 配置poste

通过浏览器访问``https://mail.your-domain.com/admin/login``进入poste.io的配置页面，按照提示进行配置，然后点击 Generate new key，生成 key，添加到 DNS 解析记录，就是上面最后一条解析``_s20160910378._domainkey.your-domain.com``

## 第三方客户端 SMTP/IMAP/POP3 配置

搭建完毕之后我们也可以通过客户端软件连接到我们的邮箱，如thunderbird.

| 协议 | 服务器地址 | 端口 | SSL |
|------|------------|------|-----|
| SMTP | mail.your-domain.com, smtp.your-domain.com | 25, 465, 587 | STARTTLS |
| IMAP | mail.your-domain.com, imap.your-domain.com | 993, 143 | STARTTLS |
| POP3 | mail.your-domain.com, pop.your-domain.com | 995, 110 | STARTTLS |

---
Done.