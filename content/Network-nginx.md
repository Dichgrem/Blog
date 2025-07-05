+++
title = "网络艺术:Docker建站与反向代理"
date = 2024-07-14

[taxonomies]
tags = ["Network"]
+++

前言 Docker的出现极大简化了建站流程，较过去的LAMP方式优雅了许多，配合Nginx反向代理可以快速上线HTTPS站点。
<!-- more -->

## 安装Docker

这里以Debian12为例：
- 官方安装脚本:
```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```
- 使用 Docker 存储库安装

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
现在可以使用以下命令更新存储库索引并安装 Docker：

````
sudo apt update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
````

## 使用Docker-Compose

- 目标：创建一个``Searxng服务``并对外开放。
- 方法：创建两个 docker-compose 文件，并``使用同一个外部 Docker 网络``使两个服务互联。

0. 首先``创建好工作目录``,例如：
```
.
└── docker
    ├── docker-compose.nginx.yml
    ├── docker-compose.searxng.yml
    └── nginx
        ├── certs
        │   ├── fullchain.pem
        │   └── privkey.pem
        └── searxng.conf
```

1. 在启动服务前，首先创建一个 Docker 外部网络（例如命名为 nginx）：
```
docker network create nginx 
```
这样，无论是哪个 docker-compose 项目中的容器，只要加入此网络，就能直接通信。

2. 编写 searxng 的 docker-compose 文件
```
version: '3'

services:
  searxng:
    image: searxng/searxng
    container_name: searxng
    restart: unless-stopped
    ulimits:
      nproc: 65535
      nofile:
        soft: 65535
        hard: 65535   
    volumes:
      - /var/lib/docker/volumes/searxng/_data:/etc/searxng
    networks:
      - nginx
    ports:
      # 如果希望 searxng 只对内部服务开放，则可不映射外部端口
      - "127.0.0.1:18080:8080"

networks:
  nginx:
    external: true
```
3. 编写 Nginx 的 docker-compose 文件

创建 nginx 的 docker-compose 文件，例如：
```
version: '3'

services:
  nginx:
    image: nginx:latest
    container_name: nginx
    restart: unless-stopped
    ports:
      - "80:80"
      # 如需要 HTTPS，请映射 443 端口并挂载证书目录
      #- "443:443"
    volumes:
      - ./nginx/searxng.conf:/etc/nginx/conf.d/default.conf:ro
      #- ./nginx/certs:/etc/nginx/certs:ro
    networks:
      - nginx

networks:
  nginx:
    external: true
```
4. 编写 Nginx 配置文件
```
server {
    listen 80;
    server_name searxng.dich.bid;

    client_max_body_size 10M;

    location / {
        proxy_pass http://searxng:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }

    error_page 502 /502.html;
    location = /502.html {
        root /usr/share/nginx/html;
        internal;
    }
}
```


5. 启动服务

- 启动 searxng 服务：
```
docker-compose -f docker-compose.searxng.yml up -d
```
- 启动 nginx 服务：
```
docker-compose -f docker-compose.nginx.yml up -d
```
由于两者都加入了外部网络 nginx，nginx 内的``proxy_pass http://searxng:8080``就能解析到 searxng 容器，实现反向代理效果。现在，访问``http://ip:18080``就可以访问Searxng搜索引擎。

## 添加HTTPS

在实际生产环境中我们不能使用IP直接访问，因此需要为我们的站点开启SSL证书，也就是要申请证书并在配置文件中声明。


1. 证书生成

- 如果只是用于测试可以生成自签名证书：
```
mkdir -p /home/dich/docker/nginx/certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /home/dich/docker/nginx/certs/privkey.pem \
  -out /home/dich/docker/nginx/certs/fullchain.pem \
  -subj "/CN=your-domain.com"
```

2. 更改searxng.conf:
```
server {
    listen 443 ssl;
    server_name searxng.dich.bid;

    # SSL 证书配置
    ssl_certificate /home/dich/docker/nginx/certs/fullchain.pem;
    ssl_certificate_key /home/dich/docker/nginx/certs/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    client_max_body_size 10M;

    location / {
        proxy_pass http://searxng:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }

    error_page 502 /502.html;
    location = /502.html {
        root /usr/share/nginx/html;
        internal;
    }
}

# HTTP 服务器块，将所有流量重定向到 HTTPS
server {
    listen 80;
    server_name searxng.dich.bid;
    return 301 https://$host$request_uri;
}
```

3. 更改docker-compose.nginx.yml
```
version: '3'

services:
  nginx:
    image: nginx:latest
    container_name: nginx
    restart: unless-stopped
    ports:
      - "80:80"
      # 如需要 HTTPS，请映射 443 端口并挂载证书目录
      - "443:443"
    volumes:
      - ./nginx/searxng.conf:/etc/nginx/conf.d/default.conf:ro
      - ./nginx/certs:/home/dich/docker/nginx/certs
    networks:
      - nginx

networks:
  nginx:
    external: true
```


4. 启动新配置

- 重启容器
```
sudo docker compose -f docker-compose.nginx.yml up -d
```
- 查看日志
```
sudo docker logs searxng
```
## Caddy

> Caddy 自 2015 年起用 Go 语言重写，定位为“开箱即用”的现代 Web 服务器，内置自动 Let’s Encrypt 证书管理和续期，默认支持 HTTP/2 及 HTTP/3（QUIC），并通过简洁明了的 Caddyfile 语法极大降低配置成本.

0. 示例结构：
```
.
└── compose
    ├── certs
    │   ├── cert.pem
    │   └── key.pem
    ├── compose.caddy.yml
    ├── compose.miniflux.yml
    ├── compose.searxng.yml
    └── conf
        └── Caddyfile
```
1. 同样创建名为Caddy的docker网络：
```
docker network create caddy
```
2. 编写Caddy的compose，可以看到caddy可以自带签发证书：
```
version: '3.7'

# 自动签发模式

services:
  caddy:
    image: caddy:latest
    container_name: caddy
    restart: unless-stopped
    volumes:
      - ./conf:/etc/caddy:ro 
      - caddy_data:/data
      - caddy_config:/config
    ports:
      - "80:80"    
      - "443:443"  
    networks:
      - caddy     

networks:
  caddy:
    external: true

volumes:
  caddy_data:
  caddy_config:


# 自备证书模式

services:
  caddy:
    image: caddy:latest
    container_name: caddy
    restart: unless-stopped
    environment:
      - CADDYPATH=/etc/caddycerts    
    volumes:
      - ./conf:/etc/caddy
      - ./certs:/etc/caddycerts   
      - caddy_data:/data
      - caddy_config:/config
    ports:
      - "80:80"
      - "443:443"
    networks:
      - caddy

volumes:
  caddy_data:
  caddy_config:
networks:
  caddy:
    external: true
```
3. 编写Caddyfile，可以看到自动开启HTTPS模式：
```
# 自动签发模式
searxng.dich.bid {
    reverse_proxy searxng:8080 {
        header_up Host {upstream_hostport}
    }
}

miniflux.dich.bid {
    reverse_proxy miniflux:8080 {
        header_up Host {upstream_hostport}
    }
}

# 自备证书模式
searxng.dich.bid {
    reverse_proxy searxng:8080
    tls /etc/caddycerts/cert.pem /etc/caddycerts/key.pem
}
miniflux.dich.bid {
    reverse_proxy miniflux:8080
    tls /etc/caddycerts/cert.pem /etc/caddycerts/key.pem
}
```
4. Docker compose的用法不再赘述。

**FAQ**

- 使用nginx的docker版本而非apt安装的版本；
- 注意相对路径和绝对路径，不同容器可能冲突；
- 使用网络创建的方法简化了配置；
- 使用127.0.0.1:port的配置增加了安全性，无法ip访问；
- conf中的服务端口是compose中的port：port的后一个；
- 更改配置后需要删除现有的容器再生成；
- version字段可以不需要；
- 注意加上container_name；
- 每增加一个服务需要在nginx中更新volume；

---
**Done.**
