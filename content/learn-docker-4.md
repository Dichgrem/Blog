+++
title = "Docker学习笔记(四)"
date = 2024-03-28

[taxonomies]
tags = ["学习笔记"]
+++

前言 Docker 使您能够运行与主机操作系统分离的隔离代码段（包括应用程序及其依赖项）的容器。默认情况下，容器是临时的，这意味着容器中存储的任何数据一旦终止就会丢失。为了克服这个问题并跨容器生命周期保留数据，Docker 提供了多种数据持久化方法。
<!-- more -->

## **Docker 中的数据持久化**

在本节中，我们将介绍：

- Docker Volumes Docker 卷
- Bind Mounts 绑定挂载
- Docker tmpfs mounts Docker tmpfs 挂载

## **Docker Volumes Docker 卷**

Docker 卷是保存 Docker 容器生成和使用的数据的首选方法。卷是 Docker 用于存储文件和目录的主机上的一个目录，这些文件和目录的寿命可能超过容器的生命周期。Docker 卷可以在容器之间共享，它们提供了各种好处，例如轻松备份和数据迁移。

要创建卷，请使用以下命令：
```
docker volume create volume_name
```
要使用卷，请在 docker run 命令中添加 --volume（或 -v）标志：
```
docker run --volume volume_name:/container/path image_name
```

**在容器中挂载卷**
若要将卷装载到容器，需要在运行容器时使用 -v 或 --mount 标志。下面是一个示例：

Using -v flag: 使用 -v 标志：
```
docker run -d -v my-volume:/data your-image
```
Using --mount flag: 使用 --mount 标志：
```
docker run -d --mount source=my-volume,destination=/data your-image
```
在上面的两个示例中，my-volume 是我们之前创建的卷的名称，/data 是容器内将挂载卷的路径。

**在容器之间共享卷**
要在多个容器之间共享卷，只需在多个容器上挂载相同的卷即可。下面介绍如何在运行不同映像的两个容器之间共享 my-volume：
```
docker run -d -v my-volume:/data1 image1
docker run -d -v my-volume:/data2 image2
```
在此示例中，image1 和 image2 将有权访问存储在 my-volume 中的相同数据。

**Removing a Volume 删除卷**
要删除卷，可以使用 docker volume rm 命令，后跟卷名称：
```
docker volume rm my-volume
```
## **Bind Mounts 绑定挂载**
绑定挂载允许您将主机上的任何目录映射到容器中的目录。此方法在需要修改主机系统上的文件的开发环境中非常有用，并且这些更改应立即在容器中可用。

与卷相比，绑定挂载的功能有限。使用绑定挂载时，主机上的文件或目录将装载到容器中。文件或目录由其在主机上的绝对路径引用。相比之下，当您使用卷时，会在主机上的 Docker 存储目录中创建一个新目录，Docker 管理该目录的内容。

文件或目录不需要已存在于 Docker 主机上。如果尚不存在，则按需创建。绑定挂载的性能非常高，但它们依赖于主机的文件系统，该文件系统具有特定的可用目录结构。

要创建绑定挂载，请在 docker run 命令中使用带有 type=bind 的 --mount 标志：
```
docker run --mount type=bind,src=/host/path,dst=/container/path image_name
```
## **Docker tmpfs mounts Docker tmpfs 挂载**

Docker tmpfs 挂载允许您直接在容器的内存中创建临时文件存储。存储在 tmpfs 挂载中的数据快速且安全，但一旦容器终止，数据就会丢失。
要使用 tmpfs 挂载，请在 docker run 命令中添加 --tmpfs 标志：
```
docker run --tmpfs /container/path image_name
```
通过采用这些方法，可以确保跨容器生命周期的数据持久性，从而增强 Docker 容器的实用性和灵活性。请记住选择最适合您的用例的方法，无论是首选的 Docker 卷、方便的绑定挂载，还是快速安全的 tmpfs 挂载。

