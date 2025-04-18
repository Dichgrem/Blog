+++
title = "乱七八糟:Git使用简明手册"
date = 2023-12-15

[taxonomies]
tags = ["乱七八糟"]
+++



前言 Git，作为现代软件开发中不可或缺的版本控制工具，常常让初学者感到困惑。本文旨在介绍 Git 的全流程安装和基本使用，希望能够帮助新手更轻松地理解和掌握 Git 的基本概念和操作。
<!-- more -->
## 安装git

- Windows：[Git-download](https://git-scm.com/download/)

- Archlinux：`sudo pacman -S git`

## 原理

一个Git仓库的目录里面包括``工作目录``（即我们要追踪的代码）以及``.git``目录（Git 在这里存储自己的数据）。Git 维护了三棵“树”:第一个是你的 `工作目录`，它持有实际文件；第二个是 `暂存区（Index）`，它像个缓存区域，临时保存你的改动；最后是 `HEAD`，它指向你最后一次提交的结果。


![git-tree](http://marklodato.github.io/visual-git-guide/basic-usage.svg.png)

## 创建新仓库

首先我们需要得到一个Git仓库，一般有两种方法：

- 在本地初始化之后连接到远程；
- 在远程创建后”下载“到本地。

**方法一**
创建新文件夹，在你的项目目录中运行以下命令： 
```
git init --initial-branch=main
```
这里设置默认仓库主分支名称为 main,避免因为 main/master 名称不同导致的推送问题。

> Git目前默认的主分支为 master，和 github 默认分支 main 不同，这使得默认配置下 git 往往连接失败。除了创建的时候设定外还可以通过以下方法改变默认分支。
```
git config --global init.defaultBranch main  //将默认分支修改成main
```
**方法二**

克隆远端服务器上的仓库，例如:
```
git clone https://github.com/Dichgrem/script.git
# 这是HTTPS方法
```
或者使用SSH方法：`` git clone git@github.com:Dichgrem/script.git``

## 配置

Git的设置文件为.gitconfig，它可以在用户主目录下（全局配置），也可以在项目目录下（项目配置）。

- 显示当前的Git配置
```
git config --list
```
- 编辑Git配置文件
```
git config -e [--global]
```
- 设置提交代码时的用户信息
```
git config [--global] user.name "[name]"
git config [--global] user.email "[email address]"
```
- 设置大小写敏感（windows不区分大小写的解决办法）
```
git config core.ignorecase  false
```
## 连接远程仓库

连接到远程仓库并推送需要证明你有权写入仓库。早期Github可以使用密码认证，现在则使用密钥认证。

- 生成密钥：
```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
- 可以生成多个不同名字的密钥：
```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/github_key1
```
- 使用 `ssh-add` 命令将生成的密钥添加到 SSH 代理中。
```
ssh-add ~/.ssh/github_key1

ssh-add ~/.ssh/github_key2
```
- 在 `~/.ssh/config` 文件中配置不同的主机别名以及相应的密钥文件。编辑该文件并添加以下内容：
```
# GitHub repository 1

Host github1

    HostName github.com

    User git

    IdentityFile ~/.ssh/github_key1

# GitHub repository 2

Host github2

    HostName github.com

    User git

    IdentityFile ~/.ssh/github_key2
```
- -随后使用``cat ~/.ssh/id_rsa.pub``,将其添加至 Github的Deploy密钥中，勾选write权限；

- 连接到github：
```
ssh -T git@github.com
```
- 添加远程仓库：
```
git remote add origin <remote_repository_url>

# 例如：git remote add origin git@github.com:Dichgrem/dichos.git
```
- 设置远程仓库
```
git remote set-url origin git@github.com:Dichgrem/dichos.git
```

## 创建分支
```
git branch main
```
这将创建一个名为 main 的分支。

- 删除分支
```
git branch -d master
```
- 使用大写强制删除
```
git branch -D master
```


## 添加和提交

你可以提出更改（把它们添加到暂存区），使用如下命令： 
``` 
git add <filename>
git add *
```
这是 git 基本工作流程的第一步；使用如下命令以实际提交改动：
``` 
git commit -m "代码提交信息"
# 例如：git commit -m "Initial commit"
```
现在，你的改动已经提交到了 **HEAD**，但是还没到你的远端仓库。

- 添加指定文件到暂存区
```
git add [file1] [file2] ...
```
- 添加指定目录到暂存区，包括子目录
```
git add [dir]
```
- 添加当前目录的所有文件到暂存区
```
git add .
```
添加每个变化前，都会要求确认
- 对于同一个文件的多处变化，可以实现分次提交
```
git add -p
```
- 删除工作区文件，并且将这次删除放入暂存区
```
git rm [file1] [file2] ...
```
- 停止追踪指定文件，但该文件会保留在工作区
```
git rm --cached [file]
```
- 改名文件，并且将这个改名放入暂存区
```
git mv [file-original] [file-renamed]
```
## 推送改动

你的改动现在已经在本地仓库的 **HEAD** 中了。执行如下命令以将这些改动提交到远端仓库： 
``` 
git push origin main
```
可以把 **main** 换成你想要推送的任何分支,如**master**或者**test**

如果你的远程仓库是最新的，可以使用以下命令更新本地仓库：
``` 
git pull
```
## 合并分支

分支是用来将特性开发绝缘开来的。比如你在本地的test分支新增了一个功能，想要合并到主分支中。

创建一个叫做“test”的分支，并切换过去： 
```
git checkout -b test
```
新增某些功能后切换回主分支： 
```
git checkout master
```
在主分支上执行合并操作，将 test 分支的改动合并到主分支：
```
git merge test
```
推送完成后可以把新建的分支删掉：
``` 
git branch -d test
```

### 分支常用操作
```
- 列出所有本地分支
git branch

- 列出所有远程分支
git branch -r

- 列出所有本地分支和远程分支
git branch -a

- 列出所有本地分支，并展示没有分支最后一次提交的信息
git branch -v

- 列出所有本地分支，并展示没有分支最后一次提交的信息和远程分支的追踪情况
git branch -vv

- 列出所有已经合并到当前分支的分支
git branch --merged

- 列出所有还没有合并到当前分支的分支
git branch --no-merged

- 新建一个分支，但依然停留在当前分支
git branch [branch-name]

- 新建一个分支，并切换到该分支
git checkout -b [branch]

- 新建一个与远程分支同名的分支，并切换到该分支
git checkout --track [branch-name]

- 新建一个分支，指向指定commit
git branch [branch] [commit]

- 新建一个分支，与指定的远程分支建立追踪关系
git branch --track [branch] [remote-branch]

- 切换到指定分支，并更新工作区
git checkout [branch-name]

- 切换到上一个分支
git checkout -

- 建立追踪关系，在现有分支与指定的远程分支之间
git branch --set-upstream-to=[remote-branch]
git branch --set-upstream [branch] [remote-branch] - 已被弃用

- 合并指定分支到当前分支
git merge [branch]

- 中断此次合并（你可能不想处理冲突）
git merge --abort

- 选择一个commit，合并进当前分支
git cherry-pick [commit]

- 删除分支
git branch -d [branch-name]

#新增远程分支 远程分支需先在本地创建,再进行推送
git push origin [branch-name]

- 删除远程分支
git push origin --delete [branch-name]
git branch -dr [remote/branch]
```

## 标签

Git 的 tag 功能主要用于``给仓库历史中的某个特定提交打上“标签”``，通常用于标记版本发布点（例如 v1.0、v2.0 等），以``便于后续的版本定位、回溯和发布管理``。

### 标签类型

Git 提供两种类型的标签：

- 附注标签（Annotated Tag）会创建成一个完整的 Git 对象，存储打标签者的名字、邮箱、日期和标签说明，还可采用 GPG 进行签名。推荐用于正式发布，因为包含更多元数据和安全信息。

- 轻量标签（Lightweight Tag）实际上只是对某个提交的引用，不保存额外信息，类似一个固定的分支。适用于临时标记或非正式用途。

### 创建标签

- 创建附注标签

使用 -a 参数表示“annotated”，并用 -m 提供标签说明。例如，给当前提交创建一个名为 v1.0 的附注标签：
```
git tag -a v1.0 -m "发布版本 v1.0"
```
这会在 Git 数据库中生成一个完整的标签对象，可通过 git show v1.0 查看标签信息和对应的提交详情。

如果需要给旧提交贴标签，可以在命令末尾指定提交的 SHA 值（部分 SHA 也可）：
```
git tag -a v1.0 <commit-sha> -m "发布版本 v1.0"
```

- 创建轻量标签

直接指定标签名即可，不加任何参数：
```
git tag v1.0-light
```
轻量标签仅仅是一个提交引用，因此查看时不会显示附加信息。

### 列出标签
- 列出所有标签
```
git tag
```
- 还可以使用通配符过滤：
```
git tag -l "v1.*"
```
这样便于管理和筛选大量标签。
- 查看标签详细信息
```
git show v1.0
```
这会显示标签对象的元数据以及对应的提交记录。

### 推送标签
``默认情况下，git push 不会将本地标签推送到远程仓库。推送标签有两种方式：``
- 推送单个标签
```
git push origin v1.0
```
- 一次性推送所有标签
```
git push origin --tags
```
### 删除标签
- 删除本地标签
```
git tag -d v1.0
```
- 删除远程标签
```
git push origin --delete v1.0
```
## 日志

如果你想了解本地仓库的历史记录，最简单的命令就是使用:  
```
git log
```
- 只看某一个人的提交记录:  
```
git log --author=bob
```
- 一个压缩后的每一条提交记录只占一行的输出: 
```
git log --pretty=oneline
```
- 看看哪些文件改变了: 
```
git log --name-status
```

## 删除前一个提交记录
有时候手滑或者不想使用一个commit说明，可以用以下命令撤销上一个 commit：
```
git reset --soft HEAD~1
```
这个命令会撤销上一个 commit，但保留文件修改（代码仍然在工作区）。适用于 想要重新提交（amend）或调整 commit 的情况。

如果你想彻底删除更改（不保留代码修改），可以使用：
```
git reset --hard HEAD~1
```
> 注意：--hard 会清除未提交的更改，无法恢复。

## Commit规范

### 提交信息的基本格式

- Header（头部）
格式：
```
<type>[可选的 scope]: <简短描述>
```

type 表示提交类型，如：feat（新功能）、fix（修复bug）等。
scope 是可选的，用于指出变更影响的模块或范围。
简短描述 用于概述本次提交的核心内容，通常使用祈使语气。

- Body（正文）
用于详细说明变更的动机、方法以及可能的影响，建议每行不超过 72 个字符。

- Footer（脚注）
可选部分，用来引用相关 issue、任务或说明破坏性变更（例如：BREAKING CHANGE: ...）。例如：

```
Fixes #123
```
这可以在提交后自动关闭相关问题。

### 常见的 Commit 类型
```
- feat：新功能的添加
    示例：feat(user): 添加用户注册功能

- fix：修复 Bug
    示例：fix(parser): 修复解析错误导致程序崩溃

- docs：文档相关的修改
    示例：docs(readme): 更新使用说明

- style：代码格式、排版等不影响代码逻辑的调整
    示例：style: 优化代码缩进和空格

- refactor：代码重构，不涉及新功能或 Bug 修复
    示例：refactor: 优化数据处理逻辑

- perf：性能优化
    示例：perf: 提升数据查询速度

- test：添加或修改测试代码
    示例：test: 补充用户登录单元测试

- build：构建相关的变更，如依赖管理、构建脚本等
    示例：build: 更新 webpack 配置

- ci：持续集成相关的修改
    示例：ci: 调整 GitHub Actions 配置

- chore：其他杂项维护，不涉及源代码或测试文件的修改
    示例：chore: 更新项目依赖

- revert：回滚到上一个版本的提交
    示例：revert: 撤销上次提交
```
---
**Done.**