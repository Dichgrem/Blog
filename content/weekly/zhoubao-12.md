+++
title = "谈天说地:狄奇周刊(十二)"
date = 2024-08-29


+++

前言 这里是Dich的周刊,通过博客的形式讲述每周互联网形势,以及分享一些文章。

<!-- more -->
# **事记**

## **一.[猴痘病毒被发现可以通过呼吸道飞沫传播](https://www.bilibili.com/video/av1856623583?p=1)**

据新华社报道，泰国公共卫生部召开新闻发布会，称该国发现了首例猴痘Ib变异株病例。此次发现的该种变异株``新增了可通过呼吸道飞沫等分泌物、皮疹、受感染物品等的传播途径``。此外，包括中国在内的多个国家已开启针对入境人员的防疫措施。


## **二.[微软“闯祸”Linux躺枪：更新之后，Linux打不开了](https://www.qbitai.com/2024/08/183019.html)**

两年前GRUB有个漏洞，能绕过安全启动机制;``微软去修 Windows+Linux 的双OS用户的 GRUB 引导，修坏了``...
此次事件中受到波及的，是``Windows+Linux的双系统用户``。

安装更新后，这些用户在启动Linux时会发生报错，提示“出现严重错误”。

```
Verifying shim SBAT data failed: Security Policy Violation.
shim SBAT数据校验失败：违反安全策略
Something has gone seriously wrong: SBAT self-check failed: Security Policy Violation.
出现严重错误：SBAT自检失败：违反安全策略
```
应急补救措施——

首先进入``BIOS关闭安全启动``，目的是先进入到Linux系统。

之后利用``命令行把引发故障的SBAT策略删除``，然后重启让设置生效。

最后，再次进入BIOS重新打开安全启动，问题就暂时解决了。


## **三.[微软正式确认：Windows 控制面板将被弃用](https://www.ithome.com/0/790/274.htm)**

微软一直致力于为 Windows 添加新功能，同时也会淘汰一些不再必要的旧功能。这些功能会被添加到 Windows 过时功能列表中，``最近的一个是 Paint 3D，微软宣布其即将被淘汰``。与 Paint 3D 类似，微软似乎也希望尽快淘汰控制面板。

早在 2011 年，就有传闻称微软计划用``“PC 设置”取代控制面板``。虽然“PC 设置”的设计更加适合触摸操作，但控制面板仍然存在。

直到几天前，微软才在其网页上正式发布相关信息。在一个关于各种原生 Windows 配置工具的新支持页面上，微软终于表示，控制面板“正在被弃用，取而代之的是设置应用”。

> 控制面板是于 1985 年首次在 Windows 1.0 中引入的。


## **四.[Telegram 创始人帕维尔-杜罗夫在巴黎被捕](https://t.me/zaihua/26960)**

据法国媒体TF1 Info报道，加密通讯公司 Telegram 的创始人兼首席执行官帕维尔·杜罗夫 (Pavel Durov) 于法国时间24日晚上 8 点（北京时间周日凌晨 2 时）左右在勒布尔热机场的停机坪上从私人飞机上下来时被捕。这位 39 岁的法俄混血男子由他的保镖和一名女子陪同。

根据通缉人员档案，杜罗夫``从阿塞拜疆直接抵达``。Telegram 创始人头上挂着法国司法警察局 OFMIN（隶属于法国海关部门的国家反欺诈办公室）签发的法国搜查令，该搜查令在初步调查的基础上签发。

法国当局认为，Telegram 缺乏审核、与执法部门的合作以及其提供的工具（一次性号码和加密货币）使其成为``贩毒、恋童癖和欺诈的帮凶``。但该搜查令只有当帕维尔·杜罗夫在法国国土上时才有效。

``当前，ONAF 的调查人员通知了他并将其拘留``。他应该在本周六晚上被送交调查法官，然后周日可能会因多项罪行被起诉：恐怖主义、毒品、同谋、欺诈、洗钱、收受赃物、儿童犯罪内容等。

> Toncoin 价格 已下跌17.4%，部分交易所出现 20% 以上的剧烈跌幅

## **五.[无线充电新规9月1日起施行：MagSafe/Qi2因频率冲突停售，iPhone无线功率调整至7.5W](https://t.me/zaihua/26966)**

中国将于2024年9月1日起实施新的《无线充电（电力传输）设备无线电管理暂行规定》，规定无线充电设备的工作频率和额定传输功率。MagSafe和Qi2协议使用的频率为360kHz，不符合新规要求的频率范围，可能面临停售。工信部明确指出，``325-405KHz频段在中国不可用于无线充电设备``。苹果官网已更新iPhone的无线充电参数，显示``额定传输功率为7.5W，工作频率为127.7kHz``，符合新规。

苹果iPhone 15等机型目前``仍显示支持MagSafe与Qi2无线充电，最高功率达15W``。新规施行后，不符合要求的设备将停止生产或进口，但``已生产或进口的设备可继续销售至报废``。新规对无线充电设备市场及苹果产品销售策略可能产生影响。


# **文推**

[靠打零工生活的年轻人挤在廉价青旅](https://telegra.ph/%E9%9D%A0%E6%89%93%E9%9B%B6%E5%B7%A5%E7%94%9F%E6%B4%BB%E7%9A%84%E5%B9%B4%E8%BD%BB%E4%BA%BA%E6%8C%A4%E5%9C%A8%E5%BB%89%E4%BB%B7%E9%9D%92%E6%97%85-08-27-2)

[月薪10万的人，不想吃鼎泰丰了](https://telegra.ph/%E6%9C%88%E8%96%AA10%E4%B8%87%E7%9A%84%E4%BA%BA%E4%B8%8D%E6%83%B3%E5%90%83%E9%BC%8E%E6%B3%B0%E4%B8%B0%E4%BA%86-08-28)

[短篇漫画小狐狸化形记](https://telegra.ph/%E7%9F%AD%E7%AF%87%E6%BC%AB%E7%94%BB%E5%B0%8F%E7%8B%90%E7%8B%B8%E5%8C%96%E5%BD%A2%E8%AE%B0-08-23-2)

[普通人该如何认清当下的经济环境](https://telegra.ph/%E6%99%AE%E9%80%9A%E4%BA%BA%E8%AF%A5%E5%A6%82%E4%BD%95%E8%AE%A4%E6%B8%85%E5%BD%93%E4%B8%8B%E7%9A%84%E7%BB%8F%E6%B5%8E%E7%8E%AF%E5%A2%83-08-23)

[计算机学院的老师们的实际编程能力如何](https://telegra.ph/计算机学院的老师们的实际编程能力如何-08-22)

[终于可以愉快地扫描了：Linux 扫描仪配置与使用攻略](https://sspai.com/post/91396)

[《一人企业方法论》第二版，也适合做其他副业（比如自媒体、电商、数字商品）的非技术人群](https://github.com/easychen/one-person-businesses-methodology-v2.0)

---

# **项目**

[网站图标下载器 ](https://www.faviconextractor.com/)

[开源的豆瓣替代品](https://github.com/neodb-social/neodb)

[微信公众号文章批量下载工具](https://github.com/qiye45/wechatDownload)

[Megalodon 的一个分支，功能丰富](https://github.com/LucasGGamerM/moshidon)


[Zen Browser：基于firefox的新浏览器](https://github.com/zen-browser/desktop)

[Supersonic:自托管音乐服务器的轻量全功能跨平台桌面客户端](https://github.com/dweymouth/supersonic)

[Go 语言开发的个人阅读/观影/看剧/追番/游戏记录 Web 管理工具](https://github.com/scenery/mediax)

[Deku SMS – 开源安卓短信工具，支持 Webhook、SMTP、FTP 转发短信｜集成 RabbitMQ ](https://github.com/deku-messaging/Deku-SMS-Android)

