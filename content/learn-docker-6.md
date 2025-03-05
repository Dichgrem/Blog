+++
title = "Docker学习笔记(六)"
date = 2024-03-30

[taxonomies]
tags = ["学习笔记"]
+++

前言 容器映像是可执行包，其中包含运行应用程序所需的所有内容：代码、运行时、系统工具、库和设置。通过构建自定义映像，您可以在任何 Docker 支持的平台上无缝部署应用程序及其所有依赖项。


<!-- more -->

## **Dockerfile**
构建容器镜像的关键组件是 Dockerfile。它本质上是一个脚本，其中包含有关如何组装 Docker 映像的说明。Dockerfile 中的每条指令都会在映像中创建一个新图层，从而更轻松地跟踪更改并最小化映像大小。下面是 Dockerfile 的简单示例：
```
# Use an official Python runtime as a parent image
FROM python:3.7-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
```
## **Building an Image 构建映像**
创建 Dockerfile 后，可以使用 docker build 命令生成映像。在包含 Dockerfile 的目录中的终端中执行以下命令：
```
docker build -t your-image-name .
```
此命令告诉 Docker 使用当前目录 （.） 中的 Dockerfile 构建映像，并为其分配名称 （-t your-image-name）。

检查镜像和图层
成功构建后，可以使用 docker image 命令检查创建的映像：
```
docker image ls
```
要仔细查看镜像的各个图层，请使用 docker history 命令：
```
docker history your-image-name
```
要查看镜像的图层，还可以使用 docker inspect 命令：
```
docker inspect your-image-name
```
要删除镜像，请使用 docker image rm 命令：
```
docker image rm your-image-name
```
将映像推送到注册表
构建映像后，可以将其推送到容器注册表（例如 Docker Hub、Google Container Registry 等），以便轻松分发和部署应用程序。首先，使用您的凭据登录注册表：
```
docker login
```
然后，使用注册表 URL 标记映像：
```
docker tag your-image-name username/repository:tag
```
最后，将标记的映像推送到注册表：
```
docker push username/repository:tag
```
构建容器映像是使用 Docker 的一个关键方面，因为它使你能够轻松打包和部署应用程序。通过创建具有精确指令的 Dockerfile，您可以毫不费力地在各种平台上构建和分发映像。


Dockerfile
Dockerfile 是一个文本文档，其中包含 Docker 引擎用于构建映像的指令列表。Dockerfile 中的每条指令都会向映像添加一个新层。Docker 将根据这些说明生成映像，然后您可以从映像运行容器。Dockerfile 是基础结构即代码的主要元素之一。


## **常见 Dockerfile 说明**
以下是一些常见的 Dockerfile 指令及其用途的列表：
```
FROM：    设置基础映像的开始。必须将 FROM 作为 Dockerfile 中的第一条指令。
WORKDIR：   设置任何 RUN、CMD、ENTRYPOINT、COPY 或 ADD 指令的工作目录。如果该目录不存在，则会自动创建该目录。
COPY：   将文件或目录从主机复制到容器的文件系统中。
ADD：    类似于 COPY，但也可以处理远程 URL 并自动解压缩存档。
RUN：    在镜像中作为新图层执行命令。
CMD：    定义从映像运行容器时要执行的默认命令。
ENTRYPOINT：    类似于 CMD，但它旨在允许容器作为具有自己参数的可执行文件。
EXPOSE：    通知 Docker 容器将在运行时侦听指定的网络端口。
ENV：    为容器设置环境变量。

# 若要从 Dockerfile 生成映像，请使用 docker build 命令，指定生成上下文（通常为当前目录）和映像的可选标记。
```
```
docker build -t my-image:tag .
```
运行此命令后，Docker 将按顺序执行 Dockerfile 中的每条指令，并为每个指令创建一个新层。


## **高效的层缓存**
构建容器镜像时，Docker 会缓存新创建的层。然后，这些图层可以在以后构建其他映像时使用，从而减少构建时间并最大限度地减少带宽使用。但是，要充分利用此缓存机制，您应该了解如何有效地使用图层缓存。

Docker 层缓存的工作原理
Docker 为 Dockerfile 中的每条指令（例如 RUN、COPY、ADD 等）创建一个新层。如果指令自上次生成以来未更改，则 Docker 将重用现有层。

例如，请考虑以下 Dockerfile：
```
FROM node:14

WORKDIR /app

COPY package.json /app/
RUN npm install

COPY . /app/

CMD ["npm", "start"]
```
首次构建镜像时，Docker 将执行每条指令并为每条指令创建一个新层。如果对应用程序进行一些更改并重新生成映像，Docker 将检查更改的指令是否影响任何层。如果任何层均不受更改的影响，则 Docker 将重用缓存的层。

- 高效图层缓存的技巧
- 尽量减少 Dockerfile 中的更改：尽量减少 Dockerfile 中更改的频率，并以最常更改的行显示在底部的方式构建指令。
- 生成上下文优化：使用 .dockerignore 文件从生成上下文中排除可能导致缓存失效的不必要文件。
- 使用较小的基础映像：较小的基础映像可减少提取基础映像所需的时间以及需要缓存的图层数.
- 利用 Docker 的 --cache-from 标志：如果使用的是 CI/CD 管道，则可以指定要用作缓存源的镜像。
- 合并多个指令：在某些情况下，合并指令（例如 RUN）有助于最大限度地减少层数，从而提高缓存效率。
- 通过遵循这些最佳实践，您可以优化层缓存过程并减少 Docker 映像的构建时间，从而提高开发和部署过程的效率。


## **镜像大小和安全性**
生成容器映像时，必须注意映像大小和安全性。映像的大小会影响容器的生成和部署速度。较小的映像可以加快构建速度，并降低下载映像时的网络开销。安全性至关重要，因为容器映像可能包含可能使应用程序面临风险的漏洞。

Reducing Image Size 减小镜像尺寸
使用适当的基础映像：选择更小、更轻量级的基础映像，该基础映像仅包含应用程序所需的组件。例如，请考虑使用官方镜像的 alpine 变体（如果可用），因为它的尺寸通常要小得多。

FROM node:14-alpine
在单个 RUN 语句中运行多个命令：每个 RUN 语句在镜像中创建一个新图层，该图层会影响镜像大小。使用 && 将多个命令合并为一个 RUN 语句，以最小化图层数并减小最终镜像大小。
```
RUN apt-get update && \
    apt-get install -y some-required-package
```
删除同一层中不必要的文件：在映像构建过程中安装包或添加文件时，请删除同一层中的临时或未使用的文件，以减小最终映像大小。
```
RUN apt-get update && \
    apt-get install -y some-required-package && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```
使用多阶段构建：使用多阶段构建创建较小的映像。多阶段构建允许您在 Dockerfile 中使用多个 FROM 语句。每个 FROM 语句在构建过程中创建一个新阶段。您可以使用 COPY --from 语句将文件从一个阶段复制到另一个阶段。
```
FROM node:14-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:14-alpine
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY package*.json ./
RUN npm install --production
CMD ["npm", "start"]
```
使用 .dockerignore 文件：使用 .dockerignore 文件从生成上下文中排除可能导致缓存失效并增加最终映像大小的不必要文件。
```
node_modules
npm-debug.log
```

## **Enhancing Security 增强安全性**
保持基本映像更新：定期更新您在 Dockerfile 中使用的基本映像，以确保它们包含最新的安全补丁。

- 避免以 root 身份运行容器：运行容器时始终使用非 root 用户，以最大程度地降低潜在风险。在运行应用程序之前创建用户并切换到该用户。
```
RUN addgroup -g 1000 appuser && \
    adduser -u 1000 -G appuser -D appuser
USER appuser
```
- 限制 COPY 或 ADD 指令的范围：具体说明要复制到容器映像中的文件或目录。避免使用 COPY . .，因为它可能会无意中包含敏感文件。
```
COPY package*.json ./
COPY src/ src/
```
- 扫描映像中的漏洞：使用 Anchore 或 Clair 等工具扫描映像中的漏洞，并在部署前修复它们。


