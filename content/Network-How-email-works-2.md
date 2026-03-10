+++
title = "网络艺术:自建域名邮箱"
date = 2024-02-22

[taxonomies]
tags = ["Network"]
+++

前言 Maddy 邮件服务基于 Docker 搭建,占用资源较少，安装简单，适合个人使用。

<!-- more -->

## 安装Maddy

docker compose文件示例：

```yaml
services:
  maddy:
    image: foxcpp/maddy:latest
    container_name: maddy
    restart: unless-stopped
    volumes:
      - maddy-data:/data
    ports:
      - "25:25"
      - "587:587"
      - "993:993"
      - "143:143"
    environment:
      - MADDY_DOMAIN=your-domain
      - MADDY_HOSTNAME=mail.your-domain
    networks:
      - websecure
    labels:
      - traefik.enable=true
      - traefik.docker.network=websecure
      - traefik.http.routers.maddy.rule=Host(`mail.your-domain`)
      - traefik.http.routers.maddy.entrypoints=websecure
      - traefik.http.routers.maddy.tls=true
      - traefik.http.routers.maddy.tls.certresolver=static
      - traefik.http.services.maddy.loadbalancer.server.port=80
  roundcube:
    image: roundcube/roundcubemail:latest
    container_name: roundcube
    restart: unless-stopped
    depends_on:
      - maddy
    environment:
      - ROUNDCUBEMAIL_DEFAULT_DOMAIN=your-domain
    volumes:
      - roundcube-data:/var/roundcube
    networks:
      - websecure
    labels:
      - traefik.enable=true
      - traefik.docker.network=websecure
      - traefik.http.routers.roundcube.rule=Host(`your-domain`)
      - traefik.http.routers.roundcube.entrypoints=websecure
      - traefik.http.routers.roundcube.tls=true
      - traefik.http.routers.roundcube.tls.certresolver=static
      - traefik.http.services.roundcube.loadbalancer.server.port=80
networks:
  websecure:
    external: true
volumes:
  maddy-data:
  roundcube-data:
```

- 创建账户
```
docker exec -it maddy maddy creds create xxx@your-domain
docker exec -it maddy maddy imap-acct create xxx@your-domain
```

- 获取 DKIM 公钥：
```
bashdocker exec -it maddy cat /data/dkim_keys/your-domain_default.dns
```

- 改密码
```
docker exec -it maddy maddy creds password xxx@your-domain
```


## Dns配置


| 记录类型 | 主机记录 | 记录值 |
|----------|----------|----------|
| A        | mail | 1.2.3.4 (your ip) |
| MX       | your-domain.com | mail.your-domain.com |
| TXT      | your-domain.com | v=spf1 mx ~all |
| TXT      | _s20160910378._domainkey.your-domain.com | k=rsa;p=MII.........|
| TXT      | _dmarc | v=DMARC1; p=none; pct=100; rua=mailto:mail@your-domain.com |


最后还需到 VPS 服务商处添加一个反向 DNS，也就是 rDNS 解析，把 IP 解析到 mail.your-domain.com 这个域名，有些 VPS 商家不提供这种服务,所以需要选择好VPS服务商。

---
Done.
