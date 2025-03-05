+++
title = "乱七八糟:个人博客搭建"
date = 2023-10-12

[taxonomies]
tags = ["乱七八糟"]
+++


前言 个人博客的搭建有诸多框架的选择。本文以Zola框架为例，介绍如何部署该静态站点，并将其托管到Paas平台上。
<!-- more -->
## 前情回顾
在互联网冲浪的过程中，我们常常看到许多独立站点，有各种各样的主题样式；这些站点见证了互联网的发展历史。从最初的手工编写HTML页面，到后来的内容管理系统（CMS）如WordPress的兴起，再到如今流行的静态网站生成器（SSG），如Hugo，Hexo，Zola等等。

如今，静态网站生成器以其简单易用和高效性而备受青睐。其工作原理是在本地计算机上生成整个网站的HTML文件，然后将这些静态文件上传到服务器，这样用户访问网站时就可以直接从服务器上获取到HTML文件，而无需动态生成页面。这种方式不仅能够提高网站的访问速度，还可以减轻服务器的负载压力。

## 搭建博客

首先明确你需要的架构，一般有两种选择：
 - 使用现有的架构,包括Hugo,zola,astro等等,可以在[这个网站](https://jamstackthemes.dev/)上面查看效果;
 - 或者从头写一个框架，需要HTML/CSS/JS等知识；

随后需要列出你想要的显示效果：

- 风格，包括命令行风格，极简风格，MD3风格等等;
- 布局，是响应式还是传统布局？

你需要那些功能？

- 黑暗/白天模式切换;
- 高斯模糊？动态取色？
- PPT般的动效？
- 访问人数和运行天数统计？
- Tag分类和时间排序？
- 搜索功能和RSS？

需要处理哪些外部依赖？

- 域名和paas平台？
- 图床还是直接嵌入图片？
- 是否需要自动编译？
- 是否需要多平台发布？
- 是否需要加密特定文章？

以上的功能和需求是否对SEO和界面相应时间造成影响？


## 构建过程
- 安装Zola到一个文件夹，并为其命名；
- 选择主题（theme），将下载好的主题与Zola同名文件夹合并；
- 运行zola build和zola serve,在本机浏览器127.0.0.1：1111上查看站点；
- 使用notion,obsdian,bluestone等软件写markdown格式的文章；
- 保存文章到content文件夹中；
- 随后再次运行运行zola build和zola serve，生成public文件夹；
- 新建一个Github仓库，用Git连接并push上去；
- 在Vercel/Fleek等平台将仓库部署并设置域名。

## 后记
通过简单的步骤，我们已经快速地创建一个具有自定义主题和样式的独立站点，并将其发布到互联网上供他人访问。而在这期间，各种工具链的完善和前端基本原理了解也是收获的一部分。


## 参考
- [zola官方文档](https://www.getzola.org/documentation/getting-started/overview/)
- [zoal-terminimal主题](https://github.com/pawroman/zola-theme-terminimal)
- [中文排版指南](https://github.com/aaranxu/chinese-copywriting-guidelines)
- [如何提高用户网页阅读体验](https://atpx.com/blog/improving-online-reading-experience/)