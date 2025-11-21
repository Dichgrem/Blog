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
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```
- 使用 Docker 存储库安装

使用以下命令安装此方法的先决条件：

````bash
sudo apt update && sudo apt install ca-certificates curl gnupg
````

创建一个目录来存储密钥环：

````bash
sudo install -m 0755 -d /etc/apt/keyrings
````

使用给定的命令下载 GPG 密钥并将其存储在 `/etc/apt/keyrings/etc/apt/keyrings` 目录中：

````bash
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
````

使用 chmod 命令更改 docker.gpg 文件的权限：

````bash
sudo chmod a+r /etc/apt/keyrings/docker.gpg
````

使用以下命令为 Docker 设置存储库：

````bash
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
````
现在可以使用以下命令更新存储库索引并安装 Docker：

````bash
sudo apt update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
````

## 常用命令
### 基础命令

| 命令                        | 说明                       |
| ------------------------- | ------------------------ |
| `docker version`          | 查看 Docker 版本信息           |
| `docker info`             | 查看 Docker 系统信息，包括镜像和容器数量 |
| `docker help`             | 查看帮助信息                   |
| `docker <command> --help` | 查看某个命令的详细帮助              |

---

### 镜像相关命令（Images）

| 命令                                 | 说明                |
| ---------------------------------- | ----------------- |
| `docker images`                    | 列出本地所有镜像          |
| `docker search nginx`              | 从 Docker Hub 搜索镜像 |
| `docker pull nginx:latest`         | 拉取镜像              |
| `docker rmi nginx:latest`          | 删除镜像              |
| `docker rmi $(docker images -q)`   | 删除所有镜像            |
| `docker inspect nginx`             | 查看镜像详细信息          |
| `docker tag nginx myrepo/nginx:v1` | 给镜像打标签            |
| `docker save -o nginx.tar nginx`   | 导出镜像为 tar 包       |
| `docker load -i nginx.tar`         | 从 tar 文件加载镜像      |

---

### 容器管理命令（Containers）

| 命令                                            | 说明                |
| --------------------------------------------- | ----------------- |
| `docker ps`                                   | 查看正在运行的容器         |
| `docker ps -a`                                | 查看所有容器（包括已停止）     |
| `docker run -d -p 80:80 --name web nginx`     | 启动容器（后台运行）        |
| `docker run -it ubuntu /bin/bash`             | 启动交互式容器           |
| `docker exec -it web bash`                    | 进入正在运行的容器         |
| `docker logs -f web`                          | 查看容器日志（`-f` 实时输出） |
| `docker stop web`                             | 停止容器              |
| `docker start web`                            | 启动容器              |
| `docker restart web`                          | 重启容器              |
| `docker rm web`                               | 删除容器              |
| `docker rm $(docker ps -aq)`                  | 删除所有容器            |
| `docker inspect web`                          | 查看容器详细信息          |
| `docker stats`                                | 查看容器资源使用情况        |
| `docker top web`                              | 查看容器内运行的进程        |
| `docker cp web:/path/in/container ./localdir` | 从容器复制文件到主机        |
| `docker cp ./file web:/path/in/container`     | 从主机复制文件到容器        |

---

### 网络相关命令（Networks）

| 命令                                    | 说明       |
| ------------------------------------- | -------- |
| `docker network ls`                   | 列出所有网络   |
| `docker network inspect bridge`       | 查看网络详情   |
| `docker network create mynet`         | 创建自定义网络  |
| `docker network connect mynet web`    | 将容器连接到网络 |
| `docker network disconnect mynet web` | 将容器从网络断开 |
| `docker network rm mynet`             | 删除网络     |

---

### 数据卷（Volumes）

| 命令                                 | 说明         |
| ---------------------------------- | ---------- |
| `docker volume ls`                 | 查看所有卷      |
| `docker volume create mydata`      | 创建数据卷      |
| `docker volume inspect mydata`     | 查看卷详情      |
| `docker volume rm mydata`          | 删除数据卷      |
| `docker run -v mydata:/data nginx` | 启动容器并挂载卷   |
| `docker run -v $(pwd):/app nginx`  | 挂载主机目录到容器中 |

---

### 构建与导出镜像（Build & Export）

| 命令                                      | 说明           |
| --------------------------------------- | ------------ |
| `docker build -t myapp:latest .`        | 构建镜像         |
| `docker commit web myimage:v1`          | 将容器保存为镜像     |
| `docker save -o myimage.tar myimage:v1` | 导出镜像文件       |
| `docker load -i myimage.tar`            | 导入镜像文件       |
| `docker export web > web.tar`           | 导出容器文件系统     |
| `docker import web.tar myweb:v1`        | 从 tar 文件导入镜像 |

---

### 系统清理与维护

| 命令                       | 说明              |
| ------------------------ | --------------- |
| `docker system df`       | 显示磁盘使用情况        |
| `docker system prune`    | 清理无用的容器、镜像、卷和网络 |
| `docker image prune`     | 清理未使用的镜像        |
| `docker container prune` | 清理已停止的容器        |
| `docker volume prune`    | 清理无用卷           |

---

### Docker Compose（多容器管理）

| 命令                       | 说明       |
| ------------------------ | -------- |
| `docker compose up -d`   | 启动服务（后台） |
| `docker compose down`    | 停止并删除容器  |
| `docker compose ps`      | 查看当前项目容器 |
| `docker compose logs -f` | 查看日志     |
| `docker compose build`   | 重新构建服务镜像 |
| `docker compose restart` | 重启服务     |

---

### 卸载 Docker

> 删除所有 Docker 容器和 Docker 本身

1. 首先停止所有正在运行的容器：
```bash
docker stop $(docker ps -aq)
```
2. 删除所有容器

删除所有容器（包括停止的容器）：
```bash
docker rm $(docker ps -aq)
```
3. 删除所有镜像

```bash
docker rmi $(docker images -q)
```
4. 删除所有网络

```bash
docker network prune -f
```
5. 删除所有未使用的卷

```bash
docker volume prune -f
```
6. 卸载 Docker

如果您希望完全删除 Docker 本身，可以执行以下命令:
```bash
sudo apt-get purge docker-ce docker-ce-cli containerd.io
sudo apt-get autoremove --purge
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker
```
这些命令会卸载 Docker 软件并删除 Docker 数据目录。

---


## 使用Docker-Compose

- 目标：创建一个``Searxng服务``并对外开放。
- 方法：创建两个 docker-compose 文件，并``使用同一个外部 Docker 网络``使两个服务互联。

0. 首先``创建好工作目录``,例如：
```bash
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
```bash
docker network create nginx 
```
这样，无论是哪个 docker-compose 项目中的容器，只要加入此网络，就能直接通信。

2. 编写 searxng 的 docker-compose 文件
```yaml
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
```yaml
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
```conf
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
```bash
docker-compose -f docker-compose.searxng.yml up -d
```
- 启动 nginx 服务：
```bash
docker-compose -f docker-compose.nginx.yml up -d
```
由于两者都加入了外部网络 nginx，nginx 内的``proxy_pass http://searxng:8080``就能解析到 searxng 容器，实现反向代理效果。现在，访问``http://ip:18080``就可以访问Searxng搜索引擎。

## 添加HTTPS

在实际生产环境中我们不能使用IP直接访问，因此需要为我们的站点开启SSL证书，也就是要申请证书并在配置文件中声明。


1. 证书生成

- 如果只是用于测试可以生成自签名证书：
```bash
mkdir -p /home/dich/docker/nginx/certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /home/dich/docker/nginx/certs/privkey.pem \
  -out /home/dich/docker/nginx/certs/fullchain.pem \
  -subj "/CN=your-domain.com"
```

2. 更改searxng.conf:
```conf
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
```yaml
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
```bash
sudo docker compose -f docker-compose.nginx.yml up -d
```
- 查看日志
```bash
sudo docker logs searxng
```
## Caddy

> Caddy 自 2015 年起用 Go 语言重写，定位为“开箱即用”的现代 Web 服务器，内置自动 Let’s Encrypt 证书管理和续期，默认支持 HTTP/2 及 HTTP/3（QUIC），并通过简洁明了的 Caddyfile 语法极大降低配置成本.

0. 示例结构：
```bash
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
```bash
docker network create caddy
```
2. 编写Caddy的compose，可以看到caddy可以自带签发证书：
```yaml
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
```conf
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
