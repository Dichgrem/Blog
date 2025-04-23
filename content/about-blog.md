+++
title = "乱七八糟:个人博客搭建"
date = 2023-10-12

[taxonomies]
tags = ["乱七八糟"]
+++


前言 个人博客的搭建具有许多的方案可以选择，本文介绍如何快速部署一个博客，并将其发布到公网。
<!-- more -->

## 前情回顾
在互联网冲浪的过程中，我们常常看到许多独立站点，他们往往是个人博客，有各种各样的主题样式；这些站点见证了互联网的发展历史。从最初的手工编写HTML页面，到后来的内容管理系统（CMS）如WordPress的兴起，再到如今流行的静态网站生成器（SSG），如Hugo，Hexo，Zola等等。

个人博客的定义是什么？私以为是``域名+站点+原创内容``三要素组成。当然，最重要的原创内容往往被忽视...

- 域名可以在[Dynadot](https://www.dynadot.com/)等平台购买，也可以申请如``eu.org``或``us.kg``等免费域名，目的是为了好记；
- 站点可以在自己的服务器上使用动态的``WordPress``或者``Halo``来一键创建，也可以使用``静态框架``部署在PAAS平台上；

因此，整体成本应该是非常低的。

## 使用Halo快速搭建博客

- 首先你需要有一台自己的云服务器，建议在1核1G以上配置，并安装Debian系统；
- 随后我们安装1panel，执行以下命令一键安装：
```
curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sudo bash quick_start.sh
```
> 1panel依赖于docker，如果实现没有安装docker，脚本会帮你安装。

- 安装过程中选择好端口，随后即可使用``http:<ip>:<port>:<安全入口>``进入登录界面，并使用默认随机生成的密码进入面板。

- 进入之后我们可以看到里面有应用商店，在其中安装``OpenResty``与``Halo``与``mysql``，安装完毕后打开外部访问地址``http://ip:8090``，即可进入halo的后台，在其中写入文章并发布。

但我们不能使用不安全的HTTP以及IP来访问博客；因此，我们需要一个域名指向我们的博客，例如本文的``blog.dich.bid``;可以在在[Dynadot](https://www.dynadot.com/)等平台购买域名，并托管到[Cloudflare](https://askai.glarity.app/zh-CN/search/%E5%A6%82%E4%BD%95%E5%B0%86Dynadot%E6%B3%A8%E5%86%8C%E7%9A%84%E5%9F%9F%E5%90%8D%E8%BD%AC%E7%A7%BB%E5%88%B0Cloudflare)。

- 随后可以在1panel的``网站``中创建一个反向代理，代理地址即为http://ip:8090，主域名为刚刚注册的域名前加blog或其他，如``blog.xxx.com``

- 创建完成后我们还需要配置TLS证书，在网站-HTTPS中添加证书，可以选择[自签名证书](https://bkssl.com/ssl/selfsign)正式或者通过Acme申请免费的``Let's Encrypt``证书。

- 配置完成后在Cloudflare的DNS解析界面创建一个A记录，将你的``blog.xxx.com解析到你的服务器的IP``；

- 大功告成！现在你应该可以通过HTTPS域名访问自己的博客！

## 使用Hugo框架构建博客

首先明确你需要的架构，一般有两种选择：
- 使用现有的架构,包括Hugo,Hexo，Zola,Astro等等；
- 或者从头写一个框架，需要HTML/CSS/JS等知识；

> 可以在[这个网站](https://jamstackthemes.dev/)上面查看常见的框架与主题的显示效果

1. **安装Hugo**:选择好你的框架与主题后（这里以hugo为例子），随后安装hugo以及对应的依赖：

- **Windows**
```
# 打开以管理员模式运行的PowerShell,输入命令安装 Hugo Extended：
winget install Hugo.Hugo.Extended
```
- **Arch linux**
```
paru -S hugo
```
- **检查版本**
```
hugo version
```

2. **创建新的 Hugo 站点**：选择一个文件夹打开命令行，执行：
```
hugo new site myblog
```
该命令会在``myblog``文件夹下生成hugo的基础目录。

3. **安装主题**，这里以[hugo-blog-awesome](https://jamstackthemes.dev/theme/hugo-blog-awesome/)主题为例：

```
cd myblog
git clone https://github.com/hugo-sid/hugo-blog-awesome.git themes/hugo-blog-awesome
```
并在``hugo.toml``顶层添加：
```
theme = "hugo-blog-awesome"
```
这样 Hugo 在构建时会从 themes/ 目录加载主题文件。后续可使用``git pull``获取主题更新。

> 你也可以直接用theme中的文件夹替换掉项目根目录下的同名文件夹，并再次修改。

4. **写入文章**：使用 Hugo 提供的命令创建新文章：
```
hugo new posts/hello-world.md
```
该命令会在``content/posts/``下生成 Markdown 文件，打开后修改``title、date、tags``等前缀然后撰写 Markdown 正文, Markdown 编辑器参考[前文](https://blog.dich.bid/about-markdown/)。

> 注意md文章头部和正文之间得使用``<!-- more -->``隔断

5. **本地测试**：在项目根目录运行：
```
hugo server -D
```
然后在浏览器访问``http://localhost:1313``即可实时预览并查看更新效果。

6. **上传到GitHub**：新建一个Github仓库，用Git连接并将Hugo项目的文件夹push上去；

7. **使用PAAS平台部署**：随后使用[Vercel](https://vercel.com)/[Netlify](https://www.netlify.com/)等平台读取GitHub仓库并部署Hugo博客项目，并设置指向自己的域名，即``设置一条CNAME记录``。部署的时候可以让``平台command运行部署``也可以``本地build之后直接上传public文件夹``并在平台中指定。

> 当然，也可以使用GitHub Pages部署，详见[官方文档](https://docs.github.com/zh/pages/quickstart?library=true)
### 可选定制项

**你想要的显示效果?**

- 风格，包括命令行风格，极简风格，MD3风格等等;
- 布局，是响应式还是传统布局？

**你需要那些功能?**

- 黑暗/白天模式切换;
- 高斯模糊？动态取色？
- PPT般的动效？
- 访问人数和运行天数统计？
- Tag分类和时间排序？
- 搜索功能和RSS？

**需要处理哪些外部依赖?**

- 域名和paas平台？
- 图床还是直接嵌入图片？
- 是否需要自动编译？
- 是否需要多平台发布？
- 是否需要加密特定文章？

**以上的功能和需求是否对SEO和界面相应时间造成影响？**

## 🔗
- [Hugo官方文档](https://gohugo.io/documentation/)
- [zola官方文档](https://www.getzola.org/documentation/getting-started/overview/)
- [zoal-terminimal主题](https://github.com/pawroman/zola-theme-terminimal)
- [中文排版指南](https://github.com/aaranxu/chinese-copywriting-guidelines)
- [如何提高用户网页阅读体验](https://atpx.com/blog/improving-online-reading-experience/)

---
**Done.**