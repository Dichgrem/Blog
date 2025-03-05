+++
title = "Docker学习笔记(三)"
date = 2024-03-27

[taxonomies]
tags = ["学习笔记"]
+++

前言 Docker 是一个平台，可简化在轻量级、可移植容器中构建、打包和部署应用程序的过程。在本节中，我们将介绍 Docker 的基础知识、其组件以及入门所需的关键命令。

<!-- more -->

## **基础知识**
Docker 是一个平台，可简化在轻量级、可移植容器中构建、打包和部署应用程序的过程。在本节中，我们将介绍 Docker 的基础知识、其组件以及入门所需的关键命令。

## **什么是容器？**
容器是一个轻量级、独立且可执行的软件包，其中包含运行应用程序所需的所有依赖项（库、二进制文件和配置文件）。容器将应用程序与其环境隔离开来，确保它们在不同系统中一致地工作。

## **Docker 生态系统中有三个关键组件：**

- Dockerfile：包含用于构建 Docker 映像的指令（命令）的文本文件。
- Docker 映像：从 Dockerfile 创建的容器快照。映像存储在注册表（如 Docker Hub）中，可以拉取或推送到注册表。
- Docker 容器：Docker 映像的运行实例。

## **安装Docker**

**安装基础工具**
```
sudo apt-get update
 sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```
**安装docker的gpg key：**
```
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
**安装docker源**

```
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
上面命令中的 lsb_release -cs 返回 bullseye ，也就是debian11的代号。

**安装docker**
```
apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker
```
至此安装完成。

在debian系的Linux发行版上，docker会开机启动启动。

如果平时使用非root账户，又不想每次执行docker命令之前都加上sudo，参考docker的 文档 ，可以添加 docker 组，并将非root账户加入到该组中。下面的命令创建 docker 组并将当前用户加入 docker 组，执行完成之后重新登陆生效：

```
sudo groupadd docker
sudo usermod -aG docker $USER
```
**使用 Docker 存储库安装**

我建议使用此方法的主要原因是您可以轻松升级，因为存储库可以轻松更新！

首先，使用以下命令安装此方法的先决条件：

```
sudo apt update && sudo apt install ca-certificates curl gnupg
```
现在，让我们使用以下命令创建一个目录来存储密钥环：

```
sudo install -m 0755 -d /etc/apt/keyrings
```
接下来，使用给定的命令下载 GPG 密钥并将其存储在  /etc/apt/keyrings/etc/apt/keyrings  目录中：

```
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```
完成后，使用 chmod 命令更改 docker.gpg 文件的权限：

```
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```
最后，使用以下命令为 Docker 设置存储库：

```
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
上述命令中每行末尾的额外  \  只是添加新行的一种方式，以便您可以轻松查看整个命令。就是这样！

现在，您可以使用以下命令更新存储库索引并安装 Docker：

```
sudo apt update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
要验证 Docker 安装，您可以安装 hello-world 映像：

```
sudo docker run hello-world
```
hello-world docker 镜像很小，仅用于检查 Docker 是否运行正常。

## **使用 Docker 而不使用 sudo**

如果您注意到，在运行 hello-world 映像时，我使用了 sudo。

这可能不太方便。那么如何将其配置为不必使用 sudo 呢？

首先使用 groupadd 命令创建一个 docker 组：

```
sudo groupadd docker
```
现在，将用户添加到组（docker）：

```
sudo usermod -aG docker $USER
```
现在从终端注销并重新登录以使更改生效。

如果您在虚拟机中安装 Docker，需要重新启动才能使您所做的更改生效。

让我们通过运行 hello-world 图像来测试它：

```
docker run hello-world
```
正如您所看到的，我无需使用 sudo 即可获得相同的结果。

## **卸载 Docker**

首先，使用以下命令停止 docker 服务：

```
sudo systemctl stop docker
```
然后按以下方式使用 apt purge 命令从系统中删除 Docker：

```
sudo apt purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 
```
如果您打算进行全新安装或者不想拥有任何以前的数据，那么您可以使用 rm 命令删除 Docker 文件：
```
sudo rm -rf /var/lib/docker
```

```
sudo rm -rf /var/lib/containerd
```
就是这样！ Docker 已成功删除。



## **Docker Commands Docker 命令**

```
docker pull <image>：                   从注册表（如 Docker Hub）下载映像。
docker build -t <image_name> <path>：   从 Dockerfile 构建映像，其中 <path> 是包含 Dockerfile 的目录。
docker image ls：                       列出本地计算机上可用的所有映像。
docker run -d -p <host_port>:<container_port> --name <container_name> <image>：从映像运行容器，将主机端口映射到容器端口。
docker container ls：                   列出所有正在运行的容器。
docker container stop <container>：     停止正在运行的容器。
docker container rm <container>：       移除停止的容器。
docker image rm <image>：               从本地计算机中删除映像。
```

