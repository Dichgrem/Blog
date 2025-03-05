+++
title = "谈天说地:狄奇周刊(十九)"
date = 2024-10-23


+++

前言 这里是Dich的周刊,通过博客的形式讲述每周互联网形势,以及分享一些文章。

<!-- more -->
# **事记**

## **一.[Win 11 24H2 更新导致部分西数SSD用户蓝屏](https://www.windowslatest.com/2024/10/15/windows-11-24h2-causing-bsods-microsoft-will-reportedly-halt-update-for-more-pcs/)**

Windows 11 24H2 更新导致某些 PC 崩溃并出现蓝屏死机 (关键进程已死亡)。微软已经意识到了这一点，并计划暂停今年在受影响硬件上的更新。据透露，微软已经意识到少数搭载西部数据特定 SSD 的设备可能会遇到蓝屏死机错误的问题。蓝屏死机与存储驱动程序和 RAID 控制器有关。WD SN770 会提供 200MB 主机内存缓冲区 (HMB)，而 23H2 只会分配 64MB 所以没有问题，然而 24H2 会分配完整的 200MB ，并导致蓝屏死机错误“关键进程已死亡”。用户虽然可以通过设置注册表“HMBAllocationPolicy = 0”关闭 HMB 来缓解该问题，但可能会影响硬盘性能。



## **二.[Ubuntu诞生20周年:Canonical发布了即将到来的24.10版本——它一如既往的出色](https://ubuntu.com/20years)**

The story of Ubuntu is a story written by many hands. This page is a tribute to our community, partners and Canonical staff who have all given a piece of themselves to making this open source project thrive. Thank you to all of you.
Ubuntu的故事是由许多人书写的故事。 此页面是向我们的社区、合作伙伴和 Canonical 员工致敬，他们为使这个开源项目蓬勃发展做出了自己的贡献。 谢谢大家。

Above all, it’s a celebration of what Ubuntu has achieved so far, and an invitation to collaborate with us in delivering an even faster pace of innovation in the future.
最重要的是，这是对 Ubuntu 迄今为止所取得的成就的庆祝，并邀请我们与我们合作，在未来提供更快的创新步伐。



## **三.[Linux 内核将数名与俄罗斯联邦相关的贡献者从维护者列表中移除](https://lwn.net/Articles/995186/)**

日前，Linux 内核主要维护者之一 Greg Kroah-Hartman (Greg K-H) 提交了一项不寻常的“文档”更新，将数名具有 <.ru> 顶级域名邮箱的维护者，和一名明确为俄罗斯身份的维护者从 MAINTAINERS（维护者名录）文件除名。

这一提交已于上周日被 Linus Torvalds 拉取并包含于 6.12-rc4 版本的代码中。

Greg K-H 并未详述这项更新的具体原因，仅含糊其辞地表示该更改是“由于某些合规性要求”，并指出“（相关人员）提供充足文档后，方可回归（维护者名录）”。

相关的维护者移除方式相当暴力，其中部分子系统由于唯一维护者使用 <.ru> 顶级域名邮箱，整个子系统都被从 MAINTAINERS 文件中移除，这之中不乏诸如 UFS 文件系统和 PPTP 驱动等重要且被广泛使用的子系统。由于 Linux 内核开发流程完全基于邮件列表进行，当 MAINTAINERS 文件中移除相关维护者后，也就意味着与相关子系统的补丁或沟通将不再被发送至维护者的邮箱，乃至相关的邮件列表。这很可能会造成许多补丁“石沉大海”；而如果某个子系统未得到充分维护，那么其被从内核中移除也只是时间问题了。

通常而言，Linux 内核补丁除了发送至邮件列表外，还需要抄送与之相关的人士（如子系统维护者和活跃贡献者），并且经过讨论和审阅后才会被拉取合并。然而，Greg K-H 似乎刻意绕过了这部分流程，仅仅将补丁发送至流量最大、几乎不会有人认真阅读每封邮件的 patches@lists.linux.dev 列表，并于仅仅两天后就向 Linus Torvalds 发起拉取请求，而 Torvalds 亦未对相关修改提出质疑和意见便拉取合并这笔更改了。

考虑到 Linus Torvalds 与 Greg K-H 均受雇于 The Linux Foundation，后者为注册在美国的 501(c)(6) 组织，“某些合规性要求”为何显而易见。

截至发稿时，Greg K-H 尚未回应邮件列表上的相关质询。无论结果为何，这都将是 Linux 内核社区历史上最为耻辱的提交之一。


## **四.[RackNerd 和 CloudCone 服务出现中断](https://t.me/vps_xhq/662)**

RackNerd 服务状态显示，其位于洛杉矶DC-02 所在的大楼出现火警，洛杉矶消防局因此切断了供电，DC-02的所有服务器受到影响。RackNerd 强调该公司服务器所在楼层没有火灾，因此数据是安全的。

据了解，RackNerd DC-02由跨国宽带网络服务提供商 MultaCom 直接运营。另外一家运营商 CloudCone 也在此处托管有大量服务器。今天CC同样出现了大面积服务中断，截止目前该公司尚未发布通告。


# **文推**

[图解网络协议系列](https://tls13.xargs.org/)

[MySQL的性能优化](https://advancedmysql.github.io/The-Art-of-Problem-Solving-in-Software-Engineering_How-to-Make-MySQL-Better/)

---

# **项目**

[出色的网络安全手册](https://github.com/0xsyr0/Awesome-Cybersecurity-Handbooks)

[egos-2000 ：仅用 2000 行代码就实现了教育操作系统的每个组件](https://github.com/yhzhang0128/egos-2000)

[海狸笔记](https://github.com/Beaver-Notes/Beaver-Notes)

[开源免费采集 HTTP（S） 流量软件 ProxyPin，支持全平台系统](https://github.com/wanghongenpin/network_proxy_flutter)

[适用于 Windows 10/11 的通用窗口升频器](https://github.com/Blinue/Magpie/releases)