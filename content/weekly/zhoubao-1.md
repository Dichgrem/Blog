+++
title = "谈天说地:狄奇周刊(一)"
date = 2024-06-13


+++

前言 这里是Dich的周刊,通过博客的形式讲述每周互联网形势,以及分享一些文章,暂定每周四进行更新.


<!-- more -->
# **事记**
## **一.[Google直接将广告嵌入视频避免被屏蔽](https://ourl.co/104471)**

据广告拦截软件 SponsorBlock 开发者发布的消息，YouTube 正在测试直接将广告`从服务端注入到视频中`。

这种技术对服务端的基础设施要求应该是非常高的，因为 YouTube 仍然`需要考虑个性化广告`，即每次需要将针对特定用户感兴趣的广告注入到视频流的特定位置。当然用户观看界面也需要做一些改变，因为进入广告片段后还需要提供能够给用户点击链接的交互选项，避免广告确实被用户看了，但感兴趣的用户没法直接点击广告内容。

那么有办法能够继续屏蔽这种视频流广告吗？应该是有的，SponsorBlock 认为既然 YouTube 需要在前端界面提供可点击的链接，那就必然需要加载某段代码用来标记广告频段出现的时刻，`如果能检测到视频流中的广告时刻，那么进行针对化的操作也可以跳过广告`，最简单的方式就直接快进这部分。

## **二.[国内Docker镜像站全部下架](https://sjtug.org/post/mirror-news/2024-06-06-takedown-dockerhub/1)**

SJTUG（上海交通大学 Linux 用户组）6月6日发布公告：

>非常遗憾，接上级通知，即时起我们将中止对 dockerhub 仓库的镜像。docker 相关工具默认会自动处理失效镜像的回退，如果对官方源有访问困难问题，建议尝试使用其他仍在服务的镜像源。我们对给您带来的不便表示歉意，感谢您的理解与支持。

原公告`"接上级通知","因监管要求"`等字眼,现在已经被删除。随后,中科大及多家其他镜像站也接连停止服务。
据称,是有人上传了关于[涉政人物的AI语音合成器](https://hub.docker.com/r/xijinping615/xi-jinping-tts)的docker镜像。

随后发现原来去年就有了一个 "[AtomHub 可信镜像中心](atomhub.openatom.cn)",由开放原子开源基金会主导，`华为、浪潮、DaoCloud 、谐云、青云、飓风引擎以及 OpenSDV 开源联盟、openEuler 社区、OpenCloudOS 社区`等成员单位共同建设。

V2EX上的讨论:[如何评价新一代的国产可信 Docker 镜像中心 Atomhub](https://www.v2ex.com/t/1049091)



## **三.[Windows11更新推送安装微软电脑管家](https://www.ithome.com/0/770/258.htm)**

如果你的windows没有`关闭自动更新`,那么会被捆绑安装微软电脑管家。该软件提供多种语言，不过现阶段`只在中国市场`进行推送安装。理论上只要是系统区域设置为中国的设备接下来都会自动安装微软电脑管家，不需要经过用户的任何点击。

目前`可以在设置中卸载微软电脑管家`，但继续安装后续的更新就不知道微软是否还会继续给用户捆绑安装。

据反馈不少人对其持中立态度,因为该软件空间占用非常小且功能实用,不过笔者一向对`这些管家类软件抱警惕态度`。

## **四.[Google Chrome 开始淘汰 Manifest V2 扩展](https://blog.chromium.org/2024/05/manifest-v2-phase-out-begins.html)**

从 2024 年 6 月 3 日起在 Chrome Dev、Canary 和 Beta 渠道，如果用户仍然安装有 Manifest V2 扩展，那么用户访问扩展管理页面 chrome://extensions 时会`显示警告信息`，通知他们 Manifest V2 扩展将很快不予支持。。短时间内禁用的 Manifest V2 扩展可以重新启用，但`未来将会被彻底禁用`。

Manifest V3 受争议之处是它限制了 WebRequest API 的功能，用 declarativeNetRequest 替代了 WebRequest。广告屏蔽扩展如 uBlock Origin 会受到影响，因为它们使用 WebRequest 在广告下载前屏蔽其请求。`禁用 Manifest V2 扩展意味着 uBlock Origin 会被禁用。`

开发者已经释出了使用 Manifest V3 的精简版本 `uBO Lite`，其功能弱于原版。`原版未来只能在 Firefox 等浏览器上使用。`

>PS:利好Firefox系浏览器

## **五.[国产NAS绿联系统帮助文件惊现群晖内容](https://t.me/s/TestFlightCN?q=%E5%9B%BD%E4%BA%A7NAS+%E7%BB%BF%E8%81%94%E7%B3%BB%E7%BB%9F%E5%B8%AE%E5%8A%A9%E6%96%87%E4%BB%B6%E6%83%8A%E7%8E%B0%E7%BE%A4%E6%99%96%E5%86%85%E5%AE%B9)**

最近NAS赛道又被卷的火热,由于行业龙头群晖价格偏高，这几年国产 NAS 也是百花齐放，`联想、架那极空间、海康威视、绿联`等等纷纷入场。

5月23号绿联也是发布了自己最新的NAS系列产品,宣发力度非常大，吸引了很多用户购买。但用户使用的过程中发现了很多问题，比如 `CPU 温度过高，相册备份失败，甚至 App 账号注册登陆流程都没法顺利进行等等。`

`最让人绷不住的是使用手册上竟然直接出现了友商“群晖”的字样。`

6月3日晚上绿联被喷的把新 NAS 京东天猫全部下架，并发布了致歉信。

结合这个时间点，可以合理推测可能是领导层为了`赶 618 活动`，导致开发不得不硬着头带 BUG 上线。

## **六.[小米澎湃OS限制安装未知应用权限次数](https://t.me/zaihuapd/25516)**

小米的米柚自 MIUI 9+ (Based on Android 7+ \ SDK 27+) 在安装未知应用(侧载安装未在应用商店商家认证的应用)时，引入了安装应用未知来源需要 SIM 卡的限制;`安装未知应用权限，每张SIM卡拥有一定次数的限制，超限后无法申请该权限。`

>微博网友：那我要是不插卡呢？给不了权限！

其实这个安全性限制原生 Android 也有，当然类原生 Android 也有，只不过需要 SIM 卡限制是小米自己魔改加上去的。

```
# adb shell
adb shell settings put secure install_non_market_apps 1
adb shell appops set <package_name> REQUEST_INSTALL_PACKAGES allow
```

或者安装Termux，并获取相应root权限后，使用 Termux 终端，在 shell 交互窗口设置也行:

```
pkg install root-repo
tsu

settings put secure install_non_market_apps 1
appops set <package_name> REQUEST_INSTALL_PACKAGES allow
```
记得把<package_name>替换成相应的包名，比如 com.topjohnwu.magisk
　
## 七.[讯飞输入法服务器崩溃竟然无法离线使用](https://www.landiannews.com/archives/104314.html)

多名网友反馈，讯飞输入法出现异常，从晚上7点多开始`无法正常弹出键盘，点击提示则显示无法加载资源等`。

要不是此次崩溃可能大家还没意识到讯飞输入法是完全依赖云端服务器的，即`无法在离线的情况下使用`，这个确实有些匪夷所思。

故障持续已经有两个小时，讯飞输入法官方没有发布回应，也没有完成修复;


讯飞输入法官方微博在用户评论中回复：

> 您好，非常抱歉给您使用带来困扰~ 讯飞输入法在配置端午节运营活动过程中出现bug，导致部分用户出现客户端崩溃问题。输入法团队正在对此进行全力抢修，6月5日晚会发布新版本修复问题，新版本发布后、升级版本可恢复使用。 再次表示抱歉，感谢理解与支持~


另外根据网友反馈此次讯飞输入法崩溃只影响官方版，诸如小米定制版的讯飞输入法是正常的，这也可以看出来`定制版使用的可能不是讯飞的服务器，所以并没有发生崩溃`。


> 所谓的"大数据"大头就在与输入法上传数据并推送个性化广告

# 文推


[咖啡简史](https://jandan.net/p/116763#/)

[数字记忆指南](https://invisible.school/digital-memories/)

[拟物图标的消失](https://en.rattibha.com/thread/1622721223561187328)

[何加盐｜中文互联网正在加速崩塌](https://chinadigitaltimes.net/chinese/708143.html)


[Windows 设计史 01 | 从青涩到成熟（Windows 1.0 - 95）](https://sspai.com/post/87835)

[Windows 设计史 02 |「海王星」项目，「稳定」表象背后的求索](https://sspai.com/post/88506)

[Windows 设计史 03 | Windows XP：摆脱机械，拥抱自然](https://sspai.com/post/88722)


# 项目

[996忍者摸鱼站](https://996.ninja/)

[Ploopy耳机：一套开源3D打印耳机](https://github.com/ploopyco/headphones)

[一个极简的RSS在线浏览工具](https://github.com/srcrs/rss-reader)