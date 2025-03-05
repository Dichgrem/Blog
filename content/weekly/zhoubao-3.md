+++
title = "谈天说地:狄奇周刊(三)"
date = 2024-06-26


+++

前言 这里是Dich的周刊,通过博客的形式讲述每周互联网形势,以及分享一些文章,这周三提前一天更新.
<!-- more -->
# **事记**

## **一.[阿桑奇刑满出狱](https://newsapp.abc.net.au/newsapp//chinese/2024-06-26/peter-greste-prison-julian-assange-case-press-freedom-journalism/104025642)**
朱利安·阿桑奇（Julian Assange）在同意对违反美国《间谍法》的一项指控认罪后已经出狱。预计本周在北马里亚纳群岛的美国法庭出庭后，他将获得自由。26日，阿桑奇承认了一项“共谋获取和披露国防信息”的刑事指控。`法官判处阿桑奇在狱中服刑期满，他已重获自由并将返回澳大利亚`。）

## **二.[湖北电信屏蔽苹果ESS查询服务导致iMssage登录和互联互通无法使用](https://t.me/zaihuapd/25763)**

近期，湖北电信的部分宽带用户遭遇了苹果设备功能异常，包括`iMessage、FaceTime、Apple TV屏幕镜像、HomePod`使用受限及连续互通功能失效。起初，人们怀疑是苹果设备的问题，但随着网上讨论增多，发现受影响的用户主要集中在特定的宽带运营商服务范围内。经分析，`宽带服务商屏蔽了identity.apple.com域名`，导致设备无法正常验证Apple ID状态，进而影响功能使用。

使用在线路由追踪验证了湖北电信和联通的线路，发现`联通线路能正常与苹果服务器通信，而电信则在本地终止。`

> [解决方法](https://github.com/ifr0zen/DoH-for-iMessage-FaceTime?tab=readme-ov-file)


## **三.**[CSDN的gitcode正在批量搬运github](https://t.me/zaihuapd/25753)

近期，有网友在csdn推出的[gitcode](https://gitcode.com/404)中发现了自己在github上的项目，而自己并未入驻gitcode。

经测试发现，`github 上的仓库几乎都搬了过去`，不过也根据关键词屏蔽了一些仓库。

比较有趣的是，可能csdn没有设置vpn相关的屏蔽词，因此上面`有许多的vpn教程仓库`,甚至有许多敏感话题的仓库.

大家可以试试搜搜，看看自己的github有没有被搬运。

> 随后[由于热度较高，目前GitCode无法正常访问](https://t.me/zaihuapd/25757),ITdog测速全红;然后又被V友爆料对敏感仓库进行的是[前端屏蔽](https://v2ex.com/t/1052804),可谓抽象.


## **四.[Linux 资深网络开发者 Larry Finger 去世](https://www.phoronix.com/news/Larry-Finger-Linux-Wireless)**

> 2024-06-24 17:37 by RIP

Linux 资深网络开发者 Larry Finger 于 6 月 21 日去世，享年 84 岁。他的妻子在 linux-wireless 邮件列表上通过了一份简短声明发布了他去世的消息。`Larry Finger 自 2005 年起参与 Linux 内核无线驱动的开发，近二十年来向主线内核贡献了逾 1500 个补丁。`最初是博通的 BCM43XX 驱动，近期则是 RTW88、RTW89、R8188EU、R8712、RTLWIFI、B43 等内核网络驱动。部分是`由于他的贡献，Linux 无线硬件支持过去二十年取得了长足进步`。

## **五.[中国公司帮助缅甸屏蔽 VPN](https://www.techradar.com/pro/vpn/how-the-myanmar-vpn-ban-is-plunging-citizens-into-online-darkness)**

缅甸军政府从 5 月 30 日起开始屏蔽 VPN 使用，如`赛风和NordVPN`等。军政府还让士兵随机检查行人的手机，寻找是否安装了非法 VPN 应用。报道称，`有城市居民因为安装了 VPN 应用被罚款 300 万缅元（1380 美元）`，如果`付不起钱则会遭到逮捕`。知情人士称，军政府雇佣了一家中国公司实现 VPN 屏蔽，屏蔽使用了来自中国的软件。Access Now 的亚太政策分析师 Wai Phyo Myint 表示，军政府过去三年一直在寻找最新技术和工具加强对信息访问的控制，最新禁令是至今最严厉的互联网访问限制。


## **六.[京东禁止用户使用第三方比价工具或插件,否则将限制账号使用](https://www.landiannews.com/archives/104595.html)**

从6月22日开始多名网友收到京东商城发来的通知短信，在短信中京东称`监测到用户账号可能被恶意使用`，如果用户`使用第三方比价工具或插件则必须卸载并修改京东账号密码`，`否则账号将被持续进行限制`。

目前电商网站类的比价工具、扩展程序乃至使用脚本进行嵌入式比价的非常多，京东此番操作将会影响不少用户，逼迫用户停止使用此类软件。

> 另附:中国“618”购物节销售额首次下降

随着中国电商平台竞相提供全年大幅折扣，中国的网络购物节正开始失去光彩。根据数据公司 Syntun 的报告，在`周四结束的“618”购物节期间，全网销售总额同比下降7%，至7430亿元人民币。`研究公司 Feigua 的数据显示，5月下半月，中国“直播带货一哥”李佳琦的销售额同比下降46%，美妆主播骆王宇的销售额暴跌了68%……。


# **文推**

[性癖纵横观 I](https://onojyun.com/2024/06/21/%e6%80%a7%e7%99%96%e7%ba%b5%e6%a8%aa%e8%a7%82-i/)

[性癖纵横观 II](https://onojyun.com/2024/06/25/%E6%80%A7%E7%99%96%E7%BA%B5%E6%A8%AA%E8%A7%82-ii/)

[你所熟知的时代，才开始没多久](https://telegra.ph/%E4%BD%A0%E6%89%80%E7%86%9F%E7%9F%A5%E7%9A%84%E6%97%B6%E4%BB%A3%E6%89%8D%E5%BC%80%E5%A7%8B%E6%B2%A1%E5%A4%9A%E4%B9%85-06-25)


[只需一人努力，就可以让一个国家进入原始社会](https://chinadigitaltimes.net/chinese/709228.html)

[“你是爸妈不要的孩子。” 送养的女孩被接回家后](https://telegra.ph/%E4%BD%A0%E6%98%AF%E7%88%B8%E5%A6%88%E4%B8%8D%E8%A6%81%E7%9A%84%E5%AD%A9%E5%AD%90-%E9%80%81%E5%85%BB%E7%9A%84%E5%A5%B3%E5%AD%A9%E8%A2%AB%E6%8E%A5%E5%9B%9E%E5%AE%B6%E5%90%8E-06-26)

[思源字体背后的中国公司- 造福亿万国人，默默无闻 40 载，让中国字体走向世界](https://mp.weixin.qq.com/s/HEcx83sPV0dcTWj9yb5DuA)

[做好优化、选好软件，改善 Android 类原生 ROM 的使用体验](https://sspai.com/post/89282)




# **项目**

[VPS剩余价值计算器](https://github.com/xiangmingya/vps_valuation)


[gcop:Your git AI copilot.](https://github.com/Undertone0809/gcop)


[GPT 学术优化 (GPT Academic)](https://github.com/binary-husky/gpt_academic)


[ONLYOFFICE Docker部署](https://github.com/ONLYOFFICE/Docker-DocumentServer)


[把主动权「完全」握在自己手里：HTML 个人电子工作台搭建指南](https://sspai.com/post/89853)

