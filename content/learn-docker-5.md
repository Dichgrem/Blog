+++
title = "Docker学习笔记(五)"
date = 2024-03-29

[taxonomies]
tags = ["学习笔记"]
+++

前言 第三方映像是预构建的 Docker 容器映像，可在 Docker Hub 或其他容器注册表上使用。这些映像由个人或组织创建和维护，可用作容器化应用程序的起点。


<!-- more -->

## **查找第三方镜像**
Docker Hub 是最大、最受欢迎的容器镜像注册表，包含官方和社区维护的镜像。您可以根据要使用的名称或技术搜索镜像。

例如：如果你正在寻找 Node.js 映像，你可以在 Docker Hub 上搜索“Node”，你会找到官方Node.js映像以及许多其他社区维护的映像。

**在 Dockerfile 中使用映像**
要在 Dockerfile 中使用第三方映像，只需使用 FROM 指令将映像名称设置为基础映像即可。下面是使用官方Node.js镜像的示例：

FROM node:14
```
# The rest of your Dockerfile...
```
**注意安全问题**
请记住，第三方映像可能存在安全漏洞或配置错误。在生产中使用镜像之前，请务必验证镜像的来源并检查其信誉。更喜欢使用官方镜像或维护良好的社区镜像。

**维护您的镜像**
使用第三方映像时，必须保持更新，以包含最新的安全更新和依赖项更改。定期检查基础映像中的更新，并相应地重新生成应用程序容器。

## **使用第三方映像：数据库**
在 Docker 容器中运行数据库有助于简化开发过程并简化部署。Docker Hub 为 MySQL、PostgreSQL 和 MongoDB 等流行数据库提供了大量预制映像。

**示例：使用 MySQL 镜像**
要使用 MySQL 数据库，请在 Docker Hub 上搜索官方镜像：
```
docker search mysql
```
找到官方图片，然后拉动它：
```
docker pull mysql
```
现在，您可以运行 MySQL 容器。指定所需的环境变量，例如 MYSQL_ROOT_PASSWORD，并选择性地将容器的端口映射到主机：
```
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -p 3306:3306 -d mysql
```
此命令创建一个名为 some-mysql 的新容器，将 root 密码设置为 my-secret-pw，并将主机上的端口 3306 映射到容器上的端口 3306。

**示例：使用 PostgreSQL 镜像**
对于 PostgreSQL，请执行与上述步骤类似的步骤。首先，搜索官方图片：
```
docker search postgres
```
Pull the image: 拉取图像：
```
docker pull postgres
```
运行 PostgreSQL 容器，指定环境变量，例如 POSTGRES_PASSWORD：
```
docker run --name some-postgres -e POSTGRES_PASSWORD=my-secret-pw -p 5432:5432 -d postgres
```


## **使用 Docker 的交互式测试环境**
Docker 允许您创建隔离的一次性环境，这些环境可以在完成测试后删除。这使得使用第三方软件、测试不同的依赖项或版本以及快速试验变得更加容易，而不会损坏本地设置。

**使用 Docker 创建交互式测试环境**
为了演示如何设置交互式测试环境，让我们以 Python 编程语言为例。我们将使用 Docker Hub 上提供的公共 Python 映像。

要使用 Python 映像启动交互式测试环境，只需运行以下命令：
```
docker run -it --rm python
```
在这里，-it 标志确保使用 tty 在交互模式下运行容器，而 --rm 标志将在容器停止后将其删除。

现在，您应该位于容器内的交互式 Python shell 中。您可以像往常一样使用 pip 执行任何 Python 命令或安装其他软件包。
```
print("Hello, Docker!")
```
完成交互式会话后，只需键入 exit() 或按 CTRL+D 即可退出容器。容器将按照 --rm 标志的指定自动删除。

**交互式测试环境的更多示例**
可以使用 Docker Hub 上提供的多个第三方映像，并创建各种交互式环境，例如：

Node.js：若要启动交互式 Node.js shell，可以使用以下命令：
```
docker run -it --rm node
```
Ruby：要启动交互式 Ruby shell，您可以使用以下命令：
```
docker run -it --rm ruby
```
MySQL：要启动临时 MySQL 实例，您可以使用以下命令：
```
docker run -it --rm --name temp-mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -p 3306:3306 mysql
```
这将启动一个临时的MySQL服务器，该服务器可以通过主机端口3306访问。一旦容器停止，它将被移除。

随意探索和测试各种软件，而不必担心损坏本地计算机或安装不必要的依赖项。将 Docker 用于交互式测试环境可以让您在处理各种第三方软件时更高效、更干净地工作。



## **命令行实用程序**
Docker 映像可以包括命令行实用程序或我们可以在容器内运行的独立应用程序。这在使用第三方映像时非常有用，因为我们想要使用的工具已经打包好，无需任何安装或配置即可运行。

**BusyBox**
BusyBox 是一个小型 （1-2 Mb） 且简单的命令行应用程序，它提供了大量常用的 Unix 实用程序，例如 awk、grep、vi 等。要在 Docker 容器中运行 BusyBox，只需拉取映像并使用 Docker 运行它：
```
docker pull busybox
docker run -it busybox /bin/sh
```
进入容器后，您可以开始运行各种 BusyBox 实用程序，就像在常规命令行上一样。

**cURL**
cURL 是一个众所周知的命令行工具，可用于使用各种网络协议传输数据。它通常用于测试 API 或从 Internet 下载文件。若要在 Docker 容器中使用 cURL，可以使用 Docker Hub 上提供的官方 cURL 映像：
```
docker pull curlimages/curl
docker run --rm curlimages/curl https://example.com
```
在此示例中，--rm 标志用于在命令运行完毕后删除容器。当您只需要运行单个命令，然后清理容器时，这很有用。

**其他命令行实用程序**
Docker 映像中提供了许多命令行实用程序，包括但不限于：

- wget：用于从 Web 上非交互式下载文件的免费实用程序。
- imagemagick：用于图像处理和转换的强大软件套件。
- jq：轻量级且灵活的命令行 JSON 处理器。

若要使用这些工具中的任何一个，可以在 Docker Hub 上搜索它们，并按照其各自存储库中提供的说明进行操作。


