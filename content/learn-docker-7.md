+++
title = "Docker学习笔记(七)"
date = 2024-03-31

[taxonomies]
tags = ["学习笔记"]
+++

前言 容器镜像仓库是 Docker 容器镜像的集中存储和分发系统。它允许开发人员以这些映像的形式轻松共享和部署应用程序。容器镜像仓库在容器化应用程序的部署中起着至关重要的作用，因为它们提供了一种快速、可靠且安全的方式来跨各种生产环境分发容器映像。

<!-- more -->

## **Container Registries 容器镜像仓库**

以下是当今可用的常用容器镜像仓库列表：

- Docker Hub：Docker Hub 是公共 Docker 映像的默认注册表，用作在开发人员之间共享和分发映像的平台。
- Google Container Registry （GCR）：GCR 是 Google Cloud Platform 提供的托管、安全且高度可用的注册表，非常适合托管私有容器镜像。
- Amazon Elastic Container Registry （ECR）：Amazon ECR 是由 Amazon Web Services 提供的完全托管的 Docker 容器镜像仓库，为存储、管理和部署容器映像提供高可扩展性和性能。
- Azure 容器镜像仓库 （ACR）：ACR 是 Microsoft Azure 提供的托管注册表，提供异地复制、访问控制以及与其他 Azure 服务的集成。

**DockerHub**
DockerHub 是 Docker Inc. 提供的基于云的注册服务。它是默认的公共容器镜像仓库，您可以在其中存储、管理和分发 Docker 映像。DockerHub 使其他用户可以轻松查找和使用您的映像，或者与 Docker 社区共享他们自己的映像。

**DockerHub的功能**
- 公共和私有存储库：将映像存储在每个人都可以访问的公共存储库中，或者选择仅限您的团队或组织访问的私有存储库。
- 自动构建：DockerHub 与 GitHub 和 Bitbucket 等常用代码存储库集成，允许您为 Docker 映像设置自动构建。每当您将代码推送到存储库时，DockerHub 都会自动创建一个包含最新更改的新映像。
- Webhook：DockerHub 允许您配置 Webhook，以便在构建或更新映像时通知其他应用程序或服务。
- 组织和团队：通过创建组织和团队来管理对映像和存储库的访问，使协作变得容易。
- 官方镜像：DockerHub 为 MongoDB、Node.js、Redis 等流行软件提供了一组精选的官方镜像。这些映像由 Docker Inc. 和上游软件供应商维护，确保它们是最新且安全的。

要开始使用 DockerHub，您需要在他们的网站上创建一个免费帐户。注册后，您可以创建存储库、管理组织和团队以及浏览可用映像。

当您准备好共享自己的映像时，可以使用 docker 命令行工具将本地映像推送到 DockerHub：
```
docker login
docker tag your-image your-username/your-repository:your-tag
docker push your-username/your-repository:your-tag
```
要从 DockerHub 拉取镜像，可以使用 docker pull 命令：
```
docker pull your-username/your-repository:your-tag
```
DockerHub 对于分发和共享 Docker 映像至关重要，使开发人员能够更轻松地部署应用程序和管理容器基础架构。

## **镜像标记最佳实践**
正确标记 Docker 映像对于高效的容器管理和部署至关重要。在本节中，我们将讨论镜像标记的一些最佳实践。

**使用语义版本控制**
标记镜像时，建议遵循语义版本控制指南。语义版本控制是一种广受认可的方法，可以帮助更好地维护应用程序。Docker 镜像标签应具有以下结构 <major_version>.<minor_version>.<patch>。示例：3.2.1。

**标记最新版本**
除了版本号之外，Docker 还允许您将映像标记为“最新”。通常的做法是将映像的最新稳定版本标记为“最新”，以便用户无需指定版本号即可快速访问它。但是，在发布新版本时保持此标记更新非常重要。
```
docker build -t your-username/app-name:latest .
```
**具有描述性和一致性**
选择清晰且描述性的标签名称，以传达镜像的用途或与先前版本相比的更改。您的标签还应该在映像和存储库中保持一致，以便更好地组织和易用。

**包括生成和 Git 信息（可选）**
在某些情况下，在镜像标记中包含有关构建和 Git 提交的信息可能会有所帮助。这有助于识别用于生成映像的源代码和环境。示例：app-name-1.2.3-b567-d1234efg。

**使用特定于环境和体系结构的标签**
如果应用程序部署在不同的环境（生产、暂存、开发）或具有多个体系结构（amd64、arm64），则可以使用指定这些变体的标记。示例：your-username/app-name:1.2.3-production-amd64。

**需要时重新标记镜像**
有时，您可能需要在将映像推送到注册表后重新标记映像。例如，如果您已经为应用程序发布了补丁，则可能需要使用与以前版本相同的标记重新标记新的补丁版本。这样可以更顺畅地更新应用程序，并减少需要应用补丁的用户的手动工作。

**使用自动生成和标记工具**
请考虑使用 CI/CD 工具（Jenkins、GitLab CI、Travis-CI）根据提交、分支或其他规则自动生成映像和标记。这确保了一致性，并减少了人工干预导致错误的可能性。

通过遵循这些映像标记的最佳做法，可以确保 Docker 映像的容器注册表更有条理、更可维护且用户友好。

## **Running Containers 运行容器**
要启动一个新容器，我们使用 docker run 命令，后跟映像名称。基本语法如下：
```
docker run [options] IMAGE [COMMAND] [ARG...]
```
例如，要运行官方的 Nginx 镜像，我们将使用：
```
docker run -d -p 8080:80 nginx
```
这将启动一个新容器，并将主机的端口 8080 映射到容器的端口 80。

**Listing Containers 列出容器**
要列出所有正在运行的容器，请使用 docker ps 命令。要查看所有容器（包括已停止的容器），请使用 -a 标志：
```
docker container ls -a
```
**Accessing Containers 访问容器**
要访问正在运行的容器的 shell，请使用 docker exec 命令：
```
docker exec -it CONTAINER_ID bash
```
将 CONTAINER_ID 替换为所需容器的 ID 或名称。您可以在 docker ps 的输出中找到它。

**Stopping Containers 停止容器**
若要停止正在运行的容器，请使用 docker stop 命令，后跟容器 ID 或名称：
```
docker container stop CONTAINER_ID
```
**Removing Containers 移除容器**
容器停止后，我们可以使用 docker rm 命令后跟容器 ID 或名称将其删除：
```
docker container rm CONTAINER_ID
```
若要在容器退出时自动删除容器，请在运行容器时添加 --rm 标志：
```
docker run --rm IMAGE
```


**使用 docker run 运行容器**
在本节中，我们将讨论 docker run 命令，该命令使你能够运行 Docker 容器。docker run 命令从指定映像创建一个新容器并启动它。

docker run 命令的基本语法如下：
```
docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
OPTIONS：这些是命令行标志，可用于调整容器的设置，如内存约束、端口、环境变量等。
IMAGE：容器将运行的 Docker 映像。这可以是 Docker Hub 中的映像，也可以是存储在本地的您自己的映像。
COMMAND：这是容器启动时将在容器内执行的命令。如果未指定，则将使用映像的默认入口点。
ARG...：这些是可选参数，可以传递给正在执行的命令。
```
**常用选项**
以下是一些常用的 docker run 选项：
```
--name：为容器分配名称，使其更易于识别和管理。
-p, --publish：将容器的端口发布到主机。当您想要从容器外部访问容器内运行的服务时，这很有用。
-e, --env：在容器内设置环境变量。您可以多次使用此选项来设置多个变量。
-d, --detach：在分离模式下运行容器，在后台运行容器，并且不在控制台中显示日志。
-v, --volume：将卷从主机绑定挂载到容器。这有助于持久保存容器生成的数据或在主机和容器之间共享文件。
```

**下面是一些示例命令，可帮助您了解如何使用 docker run：**
```
运行 Ubuntu 容器的交互式会话：
docker run -it --name=my-ubuntu ubuntu
运行 Nginx Web 服务器并在主机上发布端口 80：
docker run -d --name=my-nginx -p 80:80 nginx
使用自定义环境变量运行 MySQL 容器以配置数据库：
docker run -d --name=my-mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=mydb -p 3306:3306 mysql
使用绑定挂载卷运行容器：
docker run -d --name=my-data -v /path/on/host:/path/in/container some-image
```



## **Docker Compose**
Docker Compose 是用于定义和运行多容器 Docker 应用程序的工具。它允许您使用名为 docker-compose.yml 的简单 YAML 文件创建、管理和运行应用程序。此文件描述了应用程序的服务、网络和卷，使您只需使用一个命令即可轻松运行和管理容器。

使用 Docker Compose 的一些好处包括：

- 简化的容器管理：Docker Compose 允许您在一个地方定义和配置所有服务、网络和卷，使其易于管理和维护。
- 可重现版本：与他人共享您的 docker-compose.yml 文件，以确保他们与您运行相同的环境和服务。
- 版本控制支持：可以对 Docker Compose 文件进行版本控制，以便更轻松地兼容不同版本的 Docker Compose 工具本身。

**创建 Docker Compose 文件：**
若要创建 docker-compose.yml 文件，请首先指定要使用的 Docker Compose 版本，然后指定要定义的服务。下面是基本 docker-compose.yml 文件的示例：
```
version: "3.9"
services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
  db:
    image: mysql:latest
    environment:
      MYSQL_ROOT_PASSWORD: mysecretpassword
```
在此示例中，我们指定了两个服务：运行最新版本的 nginx 映像的 Web 服务器 （web） 和运行 MySQL 的数据库服务器 （db）。Web 服务器将其端口 80 公开给主机，并且数据库服务器为 root 密码设置了环境变量。

**运行 Docker Compose：**
要运行 Docker Compose 应用程序，只需导航到包含 docker-compose.yml 文件的目录并运行以下命令：
```
docker-compose up
Docker Compose 将读取文件并按指定顺序启动定义的服务。
```
**其他有用的命令：**
```
docker-compose down：停止并删除 docker-compose.yml 文件中定义的所有正在运行的容器、网络和卷。
docker-compose ps：列出 docker-compose.yml 文件中定义的所有容器的状态。
docker-compose logs：显示 docker-compose.yml 文件中定义的所有容器的日志。
docker-compose build：构建 docker-compose.yml 文件中定义的所有映像。
```



## **运行时配置选项**
运行时配置选项允许您在运行 Docker 容器时自定义它们的行为和资源。这些选项有助于管理容器资源、安全性和网络。以下是一些常用运行时配置选项的简要摘要：

**Resource Management 资源管理**
CPU：您可以使用 --cpus 和 --cpu-shares 选项限制容器的 CPU 使用率。--cpus 限制容器可以使用的 CPU 内核数，而 --cpu-shares 为容器分配 CPU 时间的相对份额。
```
docker run --cpus=2 --cpu-shares=512 your-image
```
内存：您可以使用 --memory 和 --memory-reservation 选项限制和保留容器的内存。这有助于防止容器消耗过多的系统资源。
```
docker run --memory=1G --memory-reservation=500M your-image
```

**Security 安全**
用户：默认情况下，容器以 root 用户身份运行。为了提高安全性，您可以使用 --user 选项以其他用户或 UID 身份运行容器。
```
docker run --user 1000 your-image
```
只读根文件系统：为防止对容器文件系统进行不必要的更改，可以使用 --read-only 选项将根文件系统挂载为只读。
```
docker run --read-only your-image
```
**Networking 联网**
发布端口：可以使用 --publish（或 -p）选项将容器的端口发布到主机系统。这允许外部系统访问容器化服务。
```
docker run -p 80:80 your-image
```
主机名和 DNS：您可以使用 --hostname 和 --dns 选项自定义容器的主机名和 DNS 设置。
```
docker run --hostname=my-container --dns=8.8.8.8 your-image
```
包含这些运行时配置选项将使你能够有效地管理容器的资源、安全性和网络需求。有关可用运行时配置选项的完整列表，请参阅 Docker 的官方文档。
