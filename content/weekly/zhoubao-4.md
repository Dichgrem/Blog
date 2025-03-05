+++
title = "谈天说地:狄奇周刊(四)"
date = 2024-07-04


+++

前言 这里是Dich的周刊,通过博客的形式讲述每周互联网形势,以及分享一些文章,每周四更新.
<!-- more -->
# **事记**

## **一.[日本政府宣布废除所有软盘使用规定](https://newsdig.tbs.co.jp/articles/1270285)**

日本数字厅大臣河野在上月的发布会表示：“在 1,034 项法规中，我们已经完成了对 1,033 项要求通过软盘提交的法规的审查”，`法规关于软盘的使用已全部废除`。河野大臣表示，接下来还会`推动废除传真机办公`。

## **二.[最新的CVE漏洞目前严重影响了Open-SSH的安全性](https://www.qualys.com/regresshion-cve-2024-6387/)**

`SSH RCE: CVE-2024-638`该漏洞是由于 OpenSSH 服务器 (sshd) 中的信号处理程序竞争问题，未经身份验证的攻击者可以利用此漏洞在 Linux 系统上以 root 身份执行任意代码。

影响版本：`8.5p1 <= OpenSSH < 9.8p1`

在我们的实验中，平均需要约 10,000 次尝试才能赢得这种竞争条件，因此每 120 秒 (LoginGraceTime) 接受 100 个连接 (MaxStartups) 需要约 3-4 小时。最终，`平均需要约 6-8 小时才能获得远程 root shell`，因为我们只有一半的时间可以正确猜出 glibc 的地址（由于 ASLR）。

> 目前几个发行版的动静:

- Fedora: 💤 [9.6p1]
- openSUSE: 几分钟前打了 patch [9.6p1]，二进制包可能要稍晚更新；Leap 中 15.6 依旧 💤 [9.6p1]
- ArchLinux: 推了 9.8p1-1
- Ubuntu: 22.04-24.04 均已 backport [src]
- Alpine: 💤 [9.7p1]，因为人家用的是 musl 压根不受影响
- Debian: bookworm 在 6/22 悄悄 backport 直到今日才推送 [9.2p1-2+deb12u3]，sid 依旧有漏洞 [9.7p1-6]
- NixOS: backport 了补丁 [9.8p1]
- CentOS Stream: 💤 [9.6p1-1]
- Gentoo: 已 backport [9.6p1,9.7p1]
- openEuler: 💤 [9.3p2-3]
- openAnolis: 💤 [9.3p2-1]
- AOSC OS: 推了 [9.8p1]
- Deepin: backport 了 [9.7p1-4deepin2]
- openKylin: 💤 [9.6p1-ok4]
- LoongnixServer: 不受影响 [8.0p1]
- Loongnix: 不受影响 [7.9p1]


## **三.[多款国内安卓系统设备名称联网校验](https://s.v2ex.com/t/1053659)**


Android 系统里存在`设备名称`这个配置，它会作为蓝牙、Wi-Fi 热点网络共享的默认名称，展示给其他设备。并且会作为环境变量 Settings.Global.DEVICE_NAME，能被 App 读取。

2024年6月 下旬，真我（realme）手机在系统更新日志中提到：

>新增 更改手机名称联网校验功能，系统会检测手机名称是否存在敏感字符，校验未通过将无法保存或使用更改的手机名称

根据 V2EX 上的讨论来看，`小米手机也被添加了此限制`。而造成此审查的直接原因，可能与限制 AirDrop 相同，都是在`尝试管理「近距离自组网」`

关于使用 Wi-Fi 名称来抗议，在俄罗斯存在类似的先例：`2024年3月，一名学生将路由器的名称设置为：Slava Ukraini!（荣耀属于乌克兰！），`如果有人在范围里检查 Wi-Fi 选项，就会看到这段口号。随后该学生在莫斯科被捕，法院以展示「极端主义组织标志」的罪名，判处其 10 天监禁，该学生随后还被莫斯科国立大学开除。

## **四.[知乎加强爬虫限制](https://t.me/zaihuapd/25788)**

使用包含"bot"或"spider"的UA访问知乎时，页面的部分内容被替换为随机汉字

知乎在` robots.txt 中移除 Google 和 Bing 等搜索引擎`后，近期又针对UA进行了严格的限制。目前，在 `User Agent 中出现"bot"或"spider"的访问结果`中，知乎会将问题或专栏的标题、发布者的用户名、文章正文等文本`替换为随机汉字`。必应的部分搜索结果已经受到了影响。

## **五.[CentOS Linux 7 生命周期正式结束](https://t.me/CE_Observe/34311)**

此外，与 CentOS 7 同源的红帽企业` Linux 7（RHEL 7）也于今日进入 EOM 停止维护阶段`，企业可通过 ELS 订阅付费获得额外 4 年的延长支持。

据介绍，CentOS 项目与红帽已于 2020 年结束 CentOS Linux 开发，将`全部投资转向 CentOS Stream`：

- 在 RHEL 新版本发布之前，红帽会在 `CentOS Stream 上持续发布源代码，作为 RHEL 的上游`开源开发平台

- CentOS 创始人 Gregory Kurtzer 启动 `Rocky Linux `项目，开发 RHEL 的下游二进制兼容版本


## **六.[亚马逊Kindle中国服务正式停止](https://t.me/xhqcankao/11529)**

据亚马逊中国官网消息，`2024年6月30日起，Kindle中国电子书店停止云端下载服务`，此后`未下载的电子书将无法下载和阅读`。同时，Kindle客户服务也将停止支持。

Kindle中国电子书店已于2023年6月30日停止运营。亚马逊建议用户及时将已购买电子书及其他Kindle内容下载至Kindle阅读器和Kindle App (含手机端和电脑端).


# **文推**


[置身事内 - 读书笔记](https://tw93.fun/2024-06-30/china.html)

[我们所认识的胡友平](https://mp.weixin.qq.com/s/Fxczq9ba_WFs9WM32-7AtA)

[是语言基于文字，还是文字基于语言？](https://telegra.ph/%E6%98%AF%E8%AF%AD%E8%A8%80%E5%9F%BA%E4%BA%8E%E6%96%87%E5%AD%97%E8%BF%98%E6%98%AF%E6%96%87%E5%AD%97%E5%9F%BA%E4%BA%8E%E8%AF%AD%E8%A8%80---%E7%9F%A5%E4%B9%8E%E6%97%A5%E6%8A%A5-06-26-3)

[066｜真正松弛的感觉是：听从内心，去创造，去生活](https://usefulness.zhubai.love/posts/2420277964471472128)

# **项目**

[全栈 DS/DA 养成手册](https://github.com/Jace-Yang/Full-Stack_Data-Analyst)


[网络信息安全从业者面试指南](https://github.com/FeeiCN/SecurityInterviewGuide)

[Go 写的 VitePress 可视化配置工具](https://github.com/zhangdi168/VitePressSimple)

[TradingView : 一个图表平台和社交网络，全球60M+交易员和投资者使用它](https://cn.tradingview.com/markets/world-stocks/worlds-largest-companies/)

[一个干净、深色的 Neovim 主题，用 Lua 编写，支持 lsp、treesitter 和许多插件](https://github.com/folke/tokyonight.nvim?tab=readme-ov-file)