+++
title = "Docker学习笔记(九)"
date = 2024-04-02

[taxonomies]
tags = ["学习笔记"]
+++

前言 Docker CLI（命令行界面）是一个强大的工具，允许您与 Docker 容器、映像、卷和网络进行交互和管理。它为用户提供了广泛的命令，用于在开发和生产工作流中创建、运行和管理 Docker 容器和其他 Docker 资源。


<!-- more -->
在本主题中，我们将深入探讨 Docker CLI 的一些关键方面，包括以下内容：

**1. 安装**

要开始使用 Docker CLI，您需要在计算机上安装 Docker。您可以按照 Docker 文档中相应操作系统的官方安装指南进行操作。

**2. 基本命令**

以下是一些需要熟悉的基本 Docker CLI 命令：
```
docker run：从 Docker 镜像创建并启动容器
docker container：列出正在运行的容器
docker image：列出系统上所有可用的镜像
docker pull：从 Docker Hub 或其他注册表拉取映像
docker push：将映像推送到 Docker Hub 或其他注册表
docker build：从 Dockerfile 构建映像
docker exec：在正在运行的容器中运行命令
docker logs：显示容器的日志
```
**3. Docker 运行选项**

docker run 是 Docker CLI 中最重要的命令之一。您可以使用各种选项自定义容器的行为，例如：
```
-d, --detach：在后台运行容器
-e, --env：为容器设置环境变量
-v, --volume：绑定挂载卷
-p, --publish：将容器的端口发布到主机
--name：为容器分配名称
--restart：指定容器的重启策略
--rm：容器退出时自动移除容器
```

**4. Dockerfile**

Dockerfile 是一个脚本，其中包含用于构建 Docker 映像的指令。您可以使用 Docker CLI 通过 Dockerfile 构建、更新和管理 Docker 映像。

下面是 Dockerfile 的简单示例：
```
# Set the base image to use
FROM alpine:3.7

# Update the system and install packages
RUN apk update && apk add curl

# Set the working directory
WORKDIR /app

# Copy the application file
COPY app.sh .

# Set the entry point
ENTRYPOINT ["./app.sh"]
```
若要生成映像，请使用以下命令：
```
docker build -t my-image .
```
**5. Docker Compose**

Docker Compose 是一个 CLI 工具，用于使用 YAML 文件定义和管理多容器 Docker 应用程序。它与 Docker CLI 协同工作，提供一种一致的方式来管理多个容器及其依赖项。

使用官方安装指南安装 Docker Compose，然后您可以创建一个 docker-compose.yml 文件来定义和运行多容器应用程序：
```
version: '3'
services:
  web:
    image: webapp-image
    ports:
      - "80:80"
  database:
    image: mysql
    environment:
      - MYSQL_ROOT_PASSWORD=my-secret-pw
```
使用以下命令运行应用程序：
```
docker-compose up
```


## **Docker Images Docker 镜像**
Docker 映像是轻量级、独立且可执行的包，其中包含运行应用程序所需的一切。这些映像包含所有必要的依赖项、库、运行时、系统工具和代码，使应用程序能够在不同的环境中一致地运行。

Docker 映像是使用 Dockerfile 构建和管理的。Dockerfile 是一个脚本，其中包含用于创建 Docker 映像的指令，提供设置应用程序环境的分步指南。

**使用 Docker 映像**

Docker CLI 提供了多个命令来管理和处理 Docker 映像。一些基本命令包括：
```
docker image ls: List all available images on your local system.
docker image ls：列出本地系统上所有可用的镜像。
docker build: Build an image from a Dockerfile.
docker build：从 Dockerfile 构建映像。
docker image rm: Remove one or more images.
docker image rm：删除一个或多个镜像。
docker pull: Pull an image from a registry (e.g., Docker Hub) to your local system.
docker pull：将映像从注册表（例如 Docker Hub）拉取到本地系统。
docker push: Push an image to a repository.
docker push：将镜像推送到存储库。
```
例如，要从 Docker Hub 拉取官方 Ubuntu 映像，可以运行以下命令：
```
docker pull ubuntu:latest
```
拉取映像后，可以使用该映像和 docker run 命令创建并运行容器：
```
docker run -it ubuntu:latest /bin/bash
```
此命令创建一个新容器，并使用 /bin/bash shell 在容器内启动交互式会话。

**Sharing Images 共享镜像**

可以使用容器注册表（如 Docker Hub、Google Container Registry 或 Amazon Elastic Container Registry （ECR））共享和分发 Docker 映像。将映像推送到注册表后，其他人可以轻松访问和使用它们。

要共享您的镜像，您首先需要使用正确的命名格式对其进行标记：
```
docker tag <image-id> <username>/<repository>:<tag>
```
然后，您可以使用以下命令将标记的映像推送到注册表：
```
docker push <username>/<repository>:<tag>
```


**Containers 容器**

容器可以被认为是轻量级、独立和可执行的软件包，其中包括运行软件所需的一切，包括代码、运行时、库、环境变量和配置文件。容器将软件与其周围环境隔离开来，确保它在不同的环境中统一工作。

**为什么要使用容器？**
- 可移植性：容器确保应用程序在不同平台上一致地工作，无论是开发人员的笔记本电脑还是生产服务器。这消除了“它在我的机器上工作”的问题。
- 效率：容器是轻量级的，因为它们使用共享资源，而没有成熟操作系统的开销。这样可以缩短启动时间并减少资源使用。
- 可扩展性：容器可以根据工作负载轻松扩展或缩减，使其成为分布式应用程序和微服务的理想选择。
- 一致性：容器使开发人员、QA 和运营团队能够在整个应用程序生命周期中拥有一致的环境，从而实现更快、更顺畅的部署管道。
- 安全性：容器提供与其他容器和底层主机系统的隔离级别，这有助于维护应用程序安全性。

**使用 Docker CLI 处理容器**
Docker CLI 提供了多个命令来帮助你创建、管理容器并与之交互。一些常用命令包括：

```
docker run：用于创建和启动新容器。
docker container ls：列出正在运行的容器。
docker container stop：停止正在运行的容器。
docker container rm：删除已停止的容器。
docker exec：在正在运行的容器内执行命令。
docker logs：获取容器的日志，可用于调试问题。
```



## **Docker Volumes** 
Docker 卷是一种用于保存 Docker 容器生成和使用的数据的机制。它们允许您将数据与容器本身分开，从而轻松备份、迁移和管理持久性数据。

**为什么卷很重要** 

Docker 容器本质上是短暂的，这意味着它们可以很容易地停止、删除或替换。虽然这对于应用程序开发和部署非常有用，但在处理持久性数据时会带来挑战。这就是销量的来源。它们提供了一种独立于容器生命周期存储和管理数据的方法。

**Types of Volumes 卷的类型**
 
Docker 中有三种类型的卷：

- 主机卷 Host Volumes：它们存储在主机的文件系统中，通常位于 /var/lib/docker/volumes 目录中。这些可以很容易地访问，但可能会带来可移植性或文件系统兼容性的问题。
- 匿名卷 Anonymous Volumes：这些卷是在运行容器时自动创建的，无需指定卷。它们的 ID 由 Docker 生成，也存储在主机的文件系统中。
- 命名卷 Named Volumes：与匿名卷类似，命名卷存储在主机的文件系统中。但是，您可以提供自定义名称，以便于在其他容器或备份中引用。

**使用 Docker CLI 进行卷管理**

Docker CLI 提供了各种命令来管理卷：
```
docker volume create：创建具有给定名称的新卷。
docker volume ls：列出系统上的所有卷。
docker volume inspect：提供有关特定卷的详细信息。
docker volume rm：删除卷。
docker volume prune：删除所有未使用的卷。
```
若要在容器中使用卷，可以在 docker run 命令中使用 -v 或 --volume 标志。例如：
```
docker run -d --name my-container -v my-named-volume:/var/lib/data my-image
```
此命令使用“my-image”映像创建名为“my-container”的新容器，并将“my-named-volume”卷挂载到容器内的 /var/lib/data 路径处。


## **Docker Networks Docker 网络**
Docker 网络提供了管理容器通信的基本方法。它允许容器使用各种网络驱动程序相互通信以及与主机通信。通过了解和利用不同类型的网络驱动程序，可以设计容器网络以适应特定方案或应用程序要求。

**Network Drivers 网络驱动程序**

Docker 中提供了多个网络驱动程序。在这里，我们将介绍四种最常见的：

- bridge：容器的默认网络驱动程序。它创建一个专用网络，容器可以在其中相互通信并与主机通信。此网络上的容器可以通过主机的网络访问外部资源。
- host：此驱动程序删除网络隔离，并允许容器共享主机的网络。它适用于网络性能至关重要的情况，因为它可以最大程度地减少容器网络的开销。
- none：此网络驱动程序禁用容器网络。使用此驱动程序的容器在隔离环境中运行，无需任何网络访问。
- overlay：此网络驱动程序使部署在不同主机上的容器能够相互通信。它旨在与 Docker Swarm 配合使用，非常适合多主机或基于集群的容器部署。

**管理 Docker 网络**

Docker CLI 提供了各种命令来管理网络。以下是一些有用的命令：
```
列出所有网络：docker network ls
检查网络：docker network inspect <network_name>
创建新网络：docker network create --driver <driver_type> <network_name>
将容器连接到网络：docker network connect <network_name> <container_name>
断开容器与网络的连接：docker network disconnect <network_name> <container_name>
移除网络：docker network rm <network_name>
```