+++
title = "Docker学习笔记(二)"
date = 2024-03-26

[taxonomies]
tags = ["Tech","Docker"]
+++

前言 了解支持 Docker 的核心技术将有助于更深入地了解 Docker 的工作原理，并更有效地使用该平台。
<!-- more -->

## **Linux 容器 （LXC）**

Linux 容器 （LXC） 是 Docker 的基础。LXC 是一种轻量级虚拟化解决方案，它允许多个隔离的 Linux 系统在单个主机上运行，而无需成熟的虚拟机管理程序。LXC 以安全和优化的方式有效地隔离应用程序及其依赖项。

## **控制组 （cgroups）**

控制组 （cgroups） 是一项 Linux 内核功能，允许将 CPU、内存和 I/O 等资源分配给一组进程并对其进行管理。Docker 利用 cgroups 来限制容器使用的资源，并确保一个容器不会垄断主机系统的资源。


## **联合文件系统 （UnionFS）**

UnionFS 是一种文件系统服务，允许在单个统一视图中叠加多个文件系统。Docker 使用 UnionFS 为镜像和容器创建分层方法，从而实现更好的通用文件共享和更快的容器创建。

## **命名空间**

命名空间是 Docker 用于在容器之间提供隔离的核心技术之一。在本节中，我们将简要讨论什么是命名空间以及它们是如何工作的。
在 Linux 内核中，命名空间是一种允许隔离各种系统资源的功能，使进程及其子进程能够查看与其他进程分开的系统子集。命名空间有助于创建抽象层，以使容器化进程彼此分离并与主机系统分离。

Linux 中有几种类型的命名空间，包括：

- PID（进程 ID）：隔离进程 ID 号空间，这意味着容器中的进程只能看到自己的进程，而看不到主机或其他容器中的进程。

- 网络 （NET）：为每个容器提供单独的网络堆栈视图，包括其自己的网络接口、路由表和防火墙规则。

- 挂载 （MNT）：隔离文件系统挂载点，使每个容器都有自己的根文件系统，并且挂载的资源仅显示在该容器中。

- UTS（UNIX 分时系统）：允许每个容器拥有自己的主机名和域名，与其他容器和主机系统分开。

- 用户 （USER）：在容器和主机之间映射用户和组标识符，以便可以为容器中的资源设置不同的权限。

- IPC（进程间通信）：允许或限制不同容器中进程之间的通信。

## **Docker如何使用命名空间**

Docker 使用命名空间为容器创建隔离环境。启动容器时，Docker 会为该容器创建一组新的命名空间。这些命名空间仅适用于容器内，因此在容器内运行的任何进程都可以访问与其他容器以及主机系统隔离的系统资源子集。

Docker 容器和 LXC 容器很相似，所提供的安全特性也差不多。当用 docker run 启动一个容器时，在后台 Docker 为容器创建了一个独立的命名空间和控制组集合。

命名空间提供了最基础也是最直接的隔离，在容器中运行的进程不会被运行在主机上的进程和其它容器发现和作用。

每个容器都有自己独有的网络栈，意味着它们不能访问其他容器的 sockets 或接口。不过，如果主机系统上做了相应的设置，容器可以像跟主机交互一样的和其他容器交互。当指定公共端口或使用 links 来连接 2 个容器时，容器就可以相互通信了（可以根据配置来限制通信的策略）。

从网络架构的角度来看，所有的容器通过本地主机的网桥接口相互通信，就像物理机器通过物理交换机通信一样。

那么，内核中实现命名空间和私有网络的代码是否足够成熟？

内核命名空间从 2.6.15 版本（2008 年 7 月发布）之后被引入，数年间，这些机制的可靠性在诸多大型生产系统中被实践验证。

实际上，命名空间的想法和设计提出的时间要更早，最初是为了在内核中引入一种机制来实现 OpenVZ 的特性。 而 OpenVZ 项目早在 2005 年就发布了，其设计和实现都已经十分成熟。
通过利用命名空间，Docker 确保容器是真正可移植的，并且可以在任何系统上运行，而不会受到同一主机上运行的其他进程或容器的冲突或干扰。

## **控制组**

cgroups 或控制组是一项 Linux 内核功能，负责实现资源的审计和限制。

它提供了很多有用的特性；以及确保各个容器可以公平地分享主机的内存、CPU、磁盘 IO 等资源；当然，更重要的是，控制组确保了当容器内的资源使用产生压力时不会连累主机系统。

尽管控制组不负责隔离容器之间相互访问、处理数据和进程，它在防止拒绝服务（DDOS）攻击方面是必不可少的。尤其是在多用户的平台（比如公有或私有的 PaaS）上，控制组十分重要。例如，当某些应用程序表现异常的时候，可以保证一致地正常运行和性能。

控制组机制始于 2006 年，内核从 2.6.24 版本开始被引入。

- 资源隔离
cgroups 有助于将每个容器限制在一组特定的资源中，从而确保多个容器之间公平共享系统资源。这样可以更好地隔离不同容器，因此行为异常的容器不会消耗所有可用资源，从而对其他容器产生负面影响。
- 限制资源
使用 cgroups，可以对容器使用的各种系统资源（如 CPU、内存和 I/O）设置限制。这有助于防止单个容器消耗过多资源并导致其他容器或主机系统的性能问题。
- 确定容器的优先级
通过分配不同的资源份额，cgroups 允许您为某些容器提供优先级或优先级。在某些容器比其他容器更关键的情况下，或者在资源争用高的情况下，这可能很有用。
- Monitoring 监测
cGroups 还提供用于监视单个容器的资源使用情况的机制，这有助于深入了解容器性能并识别潜在的资源瓶颈。


## **Union Filesystems 联合文件系统**

联合文件系统，也称为 UnionFS，在 Docker 的整体功能中起着至关重要的作用。联合文件系统是 Docker 镜像的基础。镜像可以通过分层来进行继承，基于基础镜像（没有父镜像），可以制作各种具体的应用镜像。它是一种独特的文件系统类型，它通过覆盖多个目录来创建虚拟的分层文件结构。UnionFS 无需修改原始文件系统或合并目录，而是支持将多个目录同时挂载到单个挂载点上，同时保持其内容独立。此功能在 Docker 的上下文中特别有用，因为它允许我们通过最小化重复和减小容器映像大小来管理和优化存储性能。

以下是联合文件系统的一些基本特性：

- 分层结构：UnionFS 构建了一个分层结构，该结构由多个只读层和一个顶部可写层组成。此结构通过仅更新可写层来有效处理更改，而只读层保留原始数据。

- Copy-on-Write：COW 机制是 UnionFS 不可或缺的功能。如果容器对现有文件进行更改，系统将在可写层中创建该文件的副本，而只读层中的原始文件保持不变。此过程将修改限制在最顶层，确保快速且资源节约的操作。

- 资源共享：联合文件系统允许多个容器在单独运行时共享公共基础层。此功能可防止资源重复并节省大量存储空间。

- 快速容器初始化：联合文件系统只需在现有只读层上创建新的可写层，就可以立即创建新容器。这种快速初始化减少了重复文件操作的开销，最终提高了性能。

## **Docker 中流行的联合文件系统**
Docker 支持多个联合文件系统，便于构建和管理容器。一些流行的选项包括：

- AUFS（高级多层统一文件系统）：AUFS 被广泛用作 Docker 存储驱动程序，可实现多层的高效管理。
- OverlayFS（Overlay Filesystem）：OverlayFS 是 Docker 支持的另一个联合文件系统。与 AUFS 相比，它使用简化的方法来创建和管理覆盖目录。
- Btrfs（B-Tree 文件系统）：Btrfs 是一种现代文件系统，除了快照和校验和等高级存储功能外，还提供与联合文件系统的兼容性。
- ZFS（Z 文件系统）：ZFS 是一个高容量且强大的存储平台，它提供联合文件系统功能以及数据保护、压缩和重复数据删除。