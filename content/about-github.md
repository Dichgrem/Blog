+++
title = "乱七八糟:Github的使用"
date = 2025-08-24

[taxonomies]
tags = ["乱七八糟"]
+++

前言 对于GitHub，相信我们都不陌生。本文介绍GitHub上许多好用的服务和资源。
<!-- more -->

## Github Gist

GitHub Gist 是 GitHub 提供的代码片段服务，用来``存放单个或少量文件的代码/文本``（如示例代码、配置片段、日志、临时笔记等）。

官方说明是

```
Instantly share code, notes, and snippets.
```

和 repo 相同的是，gist 也分为``public``和``private``；

我们可以从一个简单的书签同步服务来实践：

1. 创建一个gist，权限为 private; 随后可以看到类似``Dichgrem / gist:37f2ebad89923d49d8854c368d7f5c91``，gist后面这一串就是GistID；  

2. 在这个[界面](https://github.com/settings/tokens)创建一个token，选择开启gist权限；

3. 安装这个书签同步[浏览器扩展](https://www.github.com/dudor/BookmarkHub)；

3. 将tokens 和 前面的 GistID 复制到这个浏览器扩展中；

4. 随后可以使用这个插件进行书签同步。

> 原理：使用浏览器api提取出书签，向 gist 仓库进行上传，gist仓库验证 tokens 后保存，在另一个浏览器中用同样的插件进行下载，即可同步.

## GitHub Pages

GitHub Pages 是 GitHub 提供的静态托管服务，常常用于快速部署纯前端网站。

比如你有一个 Vue 写的网站仓库，在该仓库的``设置-Build and deployment``下，选择source，选择分支，并将public目录部署到GitHub Pages，随后会得到一个类似dichgrem.github.io 的域名，即可看到网站。

当然你也可以绑定自己的域名，在custom dommain下添加，并在你的dns解析处添加对应的CNAME记录。

> 具体流程可以参考Hexo的[文档](https://hexo.io/zh-cn/docs/github-pages)

> GitHub Pages 的限制

- 不能运行后端代码
- 站点大小有限制
- 构建和发布有时间限制
- 私有仓库 Pages 需要付费计划

## Github actions

GitHub Actions 是 GitHub 提供的 CI/CD 与自动化平台，用于``在代码仓库中自动执行任务，比如测试、构建、发布、部署``等。

听起来有点抽象，实际上就是在仓库的这个位置放入一个yml文件 ``.github/workflows/*.yml``，比如

```bash
name: C Build

on:
  push:
  pull_request:
  workflow_dispatch:

jobs:
  build-and-run:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Show compiler version
        run: gcc --version

      - name: Build
        run: gcc -O2 -Wall -Wextra -std=c11 -o app main.c

      - name: Run
        run: ./app
```

这个文件的意思就是

- 触发条件：push / pull_request / 手动触发
- actions/checkout@v4：拉取仓库代码
- gcc ... main.c：将main.c编译成产物 app
- ./app：运行，确保编译出来的程序能执行


把本地的环境迁移到github的runner中，这样做有几个好处：

- 统一了编译环境，不用考虑开发成员之间的环境区别；
- 将构建自动化，开发者可以专注于代码，新人也可以快速上手；
- 自动发布到release，极大方便了项目管理;
- GitHub Actions提供许多现有的steps，类似乐高积木的体验;


> GitHub Actions的限制

- public仓库通常没有限制
- privat仓库为2,000 分钟，500 MB

## GitHub Copilot

从11月起GitHub首页增加了AI对话功能，调用的就是 [GitHub Copilot](https://github.com/features/copilot)。

GitHub Copilot 是一个 AI 驱动的 智能编码助手，由 GitHub 和 OpenAI 联合开发。可以调用GPT/gemini/Claude等多家模型.

你可以在vscode中下载copilot插件并使用，它会给你带来自动补全以及按照上下文生成整段代码的功能.

> 现在copilot已经开源，并且在vscode中自带，直接登录就可以使用，无须手动下载.

> GitHub Copilot的限制

- 免费版本约 2,000 次代码自动完成（completions） —— 即 Copilot 在 IDE 里根据你的输入生成代码的次数。
- 约 50 次 Copilot Chat 消息 / 会话请求 —— 即和 Copilot Chat 对话或高级问答次数。


---
**Done.**
