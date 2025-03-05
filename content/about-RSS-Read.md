+++
title = "搭建个人信息流:RSS阅读指南"
date = 2024-03-05

[taxonomies]
tags = ["乱七八糟"]
+++
前言 RSS 提供了一种数据格式，以 XML（可扩展标记语言）的形式组织信息，包括文章标题、摘要、链接和发布日期等。这些信息形成了所谓的“订阅源”（Feed），用户可以使用RSS阅读器（Feed Reader）来订阅这些源。
<!-- more -->
## 一.什么是RSS

如果你使用过类似红板报，轻芒杂志,摸鱼 kiki,今日热榜等 APP，应该对 RSS 并不陌生。

RSS（Really Simple Syndication）是一种用于发布经常更新的内容的标准，通常用于博客、新闻网站和其他线上发布的信息。RSS 允许用户订阅这些站点的内容，以便在内容有更新时，用户能够获得及时的通知。

基本上，RSS 提供了一种数据格式，以 XML（可扩展标记语言）的形式组织信息，包括文章标题、摘要、链接和发布日期等。这些信息形成了所谓的“订阅源”（Feed），用户可以使用 RSS 阅读器（Feed Reader）来订阅这些源。

RSS 的主要优势包括：

- 即时通知：用户订阅了 RSS 源后，当源中的内容有更新时，用户将立即收到通知，而无需手动检查网站。

- 集中管理：使用 RSS 阅读器，用户可以集中管理多个网站的更新，而无需逐个访问这些站点。

- 隐私保护：RSS 订阅不需要提供个人信息，用户只需关注感兴趣的内容，而无需注册账户。

- 定制内容：用户可以选择订阅感兴趣的主题或网站，定制他们的信息流。

- 减少信息过载：通过只关注真正感兴趣的内容，用户可以减少信息过载，集中注意力在最关键的信息上。

如果我们想更高效地获取信息，不在多个应用间来回切换，另一方面拒绝算法给我们推荐的内容，那么建议用回原始的 RSS。

虽然 RSS 曾经非常流行，但随着社交媒体和其他信息传递方式的兴起，逐渐成为时代的眼泪。然而，RSS 仍然是一种有效的信息分发和获取方式，许多网站和博客仍提供 RSS 源。题主曾经计划使用 Kindle 作为专门的RSS阅读器，后来由于过于昂贵而作罢。

## 二.如何进行RSS阅读

基本上有以下几步：

- 寻找 RSS 订阅源

- 确定 RSS 客户端

- 自建 RSS 服务端（可选）

**寻找RSS订阅源**

要知道一个网站是否支持 RSS 订阅，最直接的方法就是看网站的底部或侧边栏是否有 RSS 图标。一般来说，图标所指向的地址就是该网站的订阅链接，可以直接点击 跳转到 RSS 客户端内进行订阅，也可以复制粘贴按钮中的地址到自己在用的 RSS 服务中订阅这些网站中的内容。

在浏览器中推荐使用 RSS Hub radar 插件，可以自动找到可用的RSS源并提示。

有时候网站不会直接给出订阅源，这时候你也可以尝试在网站域名后面加上 /feed 或 /rss 或许可以碰巧猜中，比如少数派的 RSS 订阅链接就是 https://sspai.com/feed。当然，你也可以直接通过搜索引擎通过 网站名 + RSS 的关键字进行搜索，往往都能找到支持网站的 RSS 链接。

MoreRSS，这个网站提供中、英文的RSS源，并且显示源的订阅量，对于一些受欢迎的英文 RSS，还提供了中文翻译。但此网站还在建设中，收录量不大、功能也不完善，可以关注其更新。

有一些中文博客聚合网站，收录了多则1000+少则几百的中文博客（PS.经查世界上现存的大熊猫数量约2600只），知名的有十年之约、博友圈、BlogFinder 、积薪、川流 等，不一一列举了。

Feedsearch，如果在网站的首页看不到 RSS 信息，可以使用这个 RSS 源搜索服务，实测准确度很高，我用它找出来很多隐藏的 RSS 源，如果这个网站搜不到，那可能是网站确实没有提供 RSS。

RSSAnything ，如果 RSSHub 也没有找到需要的 RSS，可以尝试使用这个网站生成 RSS，这是我试过的效果最好的，但要看运气，有的时候效果很好，有的时候达不到期望值。

有一些针对具体的社会化媒体生成 RSS 的服务，但或者收费，或者稳定性欠佳失效，或者收费且稳定性欠佳失效（我就订阅了一个微信公众号的 RSS 服务，没用多久就失效了还不退款），想了下，就不在这里列举了，感兴趣可以直接在https://morerss.com/tools_zh.html查找。


>英文RSS源翻译  
可以把外语信息源翻译为中文的，这里推荐的服务器是 RSS-Translator，功能强大但需要一定的能力。MoreRSS 基于 RSS-Translator 的服务，翻译了一批优质的外语信息源，可以直接订阅。

当然，我们也可以直接导入现有的订阅源，一般为 OPML 文件，如 RSS Source;或者调用第三方的 RSS 服务，如 anyfeeder，等等。

这里介绍一个 RSS 神器，由 DIygod 发起的RSShub项目：

RSSHub 是一个开源项目，旨在为用户提供一个集中化、可定制的RSS（Really Simple Syndication）源的生成器。该项目的目标是通过从各种网站和平台获取信息，将其聚合到用户自定义的RSS源中，从而使用户能够方便地订阅他们关心的内容。

- 开源性质： RSSHub 是一个开源项目，其源代码可以在 GitHub 上找到。这意味着任何人都可以查看、使用、修改和贡献代码。

- 支持的站点： RSSHub 支持从各种网站和平台提取数据，包括但不限于新闻网站、社交媒体、博客、视频分享平台等。用户可以根据自己的需求选择要订阅的站点。

- 自定义生成： 用户可以通过指定参数和规则来定制他们的 RSS 源，以便获取特定主题或关键字的更新。这使得用户能够灵活地定制他们的订阅流。

- 社区参与： RSSHub 是一个社区驱动的项目，有很多开发者和贡献者参与其中。社区可以通过 GitHub 进行讨论、报告问题和提交代码。

- 部署方式： RSSHub 可以自行部署，用户可以在自己的服务器上搭建RSSHub实例，以便更好地控制和定制生成的RSS源。

**确定RSS客户端**

RSS客户端非常丰富，包括 Android 端，IOS 端，Windows 端，linux 端，浏览器插件，甚至 Vscode 插件（用来摸鱼）等等。这里推荐一些阅读器，当然，也可以选择类似 Feedly 的服务商。

- Android：News，在Fdorid里可下载，中文名为“新闻”，界面简洁，功能全面，支持本地或连接自建服务端。

- IOS：Inoreader， 其提供了方便的阅读体验，支持离线阅读、标签和快速搜索。

- Windows：Fluent Reader,在github上开源，界面优雅，支持本地或连接自建服务端。

- linux：Fluent Reader或Newsboat， 是 Newsbeuter 的一个分支，一款文本控制台 RSS/Atom 订阅阅读器。

**自建RSS服务端**

开源的RSS服务端软件可以用来搭建个人的RSS阅读服务：

- FreshRSS: FreshRSS 是一款简单易用的自建 RSS 服务端软件。它提供了丰富的功能，包括标签、筛选器、阅读统计等，并支持多用户。

- Miniflux: Miniflux 是一个轻量级的 RSS/Atom 阅读器服务，支持自建。它采用 Go 语言编写，具有快速响应和简洁的用户界面。

- Tiny Tiny RSS (tt-rss): Tiny Tiny RSS 是一款功能丰富的自建RSS服务端软件，提供了类似于 Google Reader 的界面，并支持标签、过滤器、插件等。

- Selfoss: Selfoss 是一款支持多种数据源（包括RSS）的自建聚合器。它的界面简洁，支持标签、过滤器和插件，同时也提供了跨平台的客户端。

- Miniflux 2: 不要与上面提到的 Miniflux 混淆，Miniflux 2 是 Miniflux 的一个全新版本，同样支持自建 RSS 服务。

这里以MiniFlux为例，其优势在与：

- 程序设计极简，不处理任何订阅之外的事情。

- 程序无外部依赖，运行性能高。

- 支持自动抓取并缓存图片，加速浏览。

- 有限支持自动将摘要替换为全文进行抓取。

- 支持多账号登录，支持 Fever API ，允许客户端从外部登录。

- 支持集成 PinBoard 、Instapaper、 Pocket、Wallabag、Nunux Keeper 等服务。

- 提供 Open API、书签快速订阅脚本。

- 维护者和社区相对活跃，更新频率高。

**步骤：**

1.安装docker 和docker-compose（略）

2.Docker 安装 miniflux：

（1）创建并进入你想安装 Miniflux 的文件夹：

``mkdir ~/miniflux``  # 在根目录创建名为miniflux的文件夹

``cd ~/miniflux`` # 进入miniflux文件夹

（2）创建docker-compose.yml文件：

``nano docker-compose.yml``  # 使用nano编辑器创建，会自动打开文件以写入内容

（3）在文件中写入以下内容并保存：

```
version: '3.4'

services:

 miniflux:

 image: miniflux/miniflux:latest

 ports:

 - "127.0.0.1:8080:8080" #调整一：增加localhost ip 并改port为8080

 depends_on:

 - db

 environment:

 - DATABASE_URL=postgres://miniflux:secret@db/miniflux?sslmode=disable

 - RUN_MIGRATIONS=1

 - CREATE_ADMIN=1

 - ADMIN_USERNAME=admin # 登录Miniflux的用户名，可自定义

 - ADMIN_PASSWORD=password # 登录Miniflux的密码，可自定义，至少6位

 - "BASE_URL=https://enter.your.url" # 调整二：输入想用来访问Miniflux的域名

 healthcheck:

 test: ["CMD", "/usr/bin/miniflux", "-healthcheck", "auto"]

 db:

 image: postgres:latest

 environment:

 - POSTGRES_USER=miniflux

 - POSTGRES_PASSWORD=secret

 volumes:

 - miniflux-db:/var/lib/postgresql/data

 healthcheck:

 test: ["CMD", "pg_isready", "-U", "miniflux"]

 interval: 10s

 start_period: 30s

volumes:

 miniflux-db:
 ```

该 docker-compose.yml 文档内容基于 Miniflux 官方文档 ，并在细节上进行了调整。调整有两处：一是将 port 改为127.0.0.1:8080:8080，主要目的是错开常用port 80，并调整 localhost 为127.0.0.1来跟 nginx 的设置一致（如不调整， miniflux 将使用0.0.0.0，无法顺利运行 nginx ）；二是在 miniflux 的environment 中加入新的 configuration BASE_URL，请将内容换为你想用来访问 Miniflux 的域名。

//如何用 nano 保存文件：可以使用 ctrl+X，在退出编辑时，选择Y来保存所有更改，再敲一次回车便可以回到命令行。//

（4）运行以下代码进行安装：

``docker-compose up -d``

在浏览器中访问服务器ip:端口号（如http://123.45.67.890:8080），如显示登录界面，即代表安装成功。域名解析和反代步骤略。
## 后记

[RSS源](https://morerss.com/tools_zh.html)
