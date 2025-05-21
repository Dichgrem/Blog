+++
title = "乱七八糟:lazyvim快速上手"
date = 2025-04-20

[taxonomies]
tags = ["乱七八糟"]
+++

前言 ​LazyVim 是一个基于 Neovim 的现代化配置框架，易于定制和扩展，这里对其介绍并说明使用方法。

<!-- more -->
## Lazy!

> ​LazyVim 是一个基于 Neovim 的现代化配置框架，旨在简化 Neovim 的配置过程。​它通过集成的 lazy.nvim 插件管理器，提供了一种易于定制和扩展配置的方式，结合了从头开始配置的灵活性和预配置设置的便利性 。

> Lazyvim是在Neovim的基础上进行配置，Neovim又继承了vim的操作模式，对vim不熟悉的同学可以看[这里](https://vimsheet.com/)。

## 安装

首先安装neovim,在arch linux上是：
```
paru -S neovim
```

备份现有配置：
```
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```
克隆 LazyVim Starter 模板：
```
git clone https://github.com/LazyVim/starter ~/.config/nvim
```
启动 Neovim：
```
nvim
```
首次启动时，LazyVim 会自动安装并配置所需的插件。

## 结构

LazyVim 的配置目录通常位于``~/.config/nvim/``中：
```
~/.config/nvim/
├── init.lua
└── lua/
    ├── config/
    │   ├── options.lua
    │   ├── keymaps.lua
    │   ├── autocmds.lua
    │   └── lazy.lua
    └── plugins/
        ├── plugin1.lua
        ├── plugin2.lua
        └── ...
```
- **init.lua**

Neovim 的主配置文件，作为入口点，通常用于加载 lazy.nvim 并设置插件：​
```
require("lazy").setup("plugins")
```
这行代码会自动加载 lua/plugins/ 目录下的所有插件配置文件。​
- **lua/config/**

用于存放通用配置文件，LazyVim 会在适当的时间自动加载这些文件，无需手动引入：​
```
options.lua：​设置 Neovim 的基本选项，如行号、缩进等。
keymaps.lua：​定义全局快捷键映射。
autocmds.lua：​配置自动命令，如保存文件时自动格式化。
lazy.lua：​用于初始化 lazy.nvim 插件管理器的设置。​
```
- **lua/plugins/**

用于存放插件的配置文件。每个插件可以有一个独立的 Lua 文件，也可以将多个相关插件的配置合并到一个文件中。LazyVim 会自动加载此目录下的所有插件配置文件。​

## 自定义配置 

- **添加插件**：​在 lua/plugins/ 目录下创建一个新的 Lua 文件，返回插件的配置表。

- **修改快捷键**：​编辑 lua/config/keymaps.lua 文件，添加或修改快捷键映射。

- **调整选项**：​编辑 lua/config/options.lua 文件，设置 Neovim 的行为选项。​


## 常用快捷键

LazyVim 默认使用``<space> 作为 <leader>``，\ 作为``<localleader>``，并通过 which-key.nvim 插件动态展示所有以``<space>``开头的可用映射，极大降低了记忆成本。​

- **导航与窗口管理**
```
- 在窗口间切换：Ctrl +h / Ctrl +j / Ctrl +k / Ctrl +l
- 调整当前窗口尺寸：Ctrl + ↑ / Ctrl + ↓ / Ctrl + ← / Ctrl + →
```
- **缓冲区切换与管理**
```
- 切换到上一个/下一个缓冲区：Shift +h / Shift +l
- 切换“另一个”缓冲区：Space + b + b
- 关闭当前缓冲区：Space + b + d
- 只保留当前缓冲区：Space + b + o
```
- **文件与搜索**
```
- 新建文件：Space + f + n
- 打开文件（普通命令）：输入 :e <文件名> 回车
- 在项目根目录查找文件：Space + Space
- 在项目根目录查找文件（另一路径）：Space + f + f
- 在当前工作目录查找文件：Space + f + F
- 查找 Git 管理的文件：Space + f + g
- 列出最近打开的文件：Space + f + r
- 列出所有缓冲区：Space + ,
- 全局全文搜索：Space + /
```
- **分割与终端**
```
- 向下分割：Space + -
- 向右分割：Space + |
- 关闭当前窗口：Space + w + d
- 窗口最大化/恢复：Space + w + m 或 Space + u + Z
- 打开根目录终端：Space + f + t
- 打开当前目录终端：Space + f + T
- 切换（隐藏/显示）终端：Ctrl + /
```
- **LSP 相关**
```
- 跳转到定义：g + d
- 查找引用：g + r
- 跳转到实现：g + I
- 跳转到声明：g + D
- 查看文档悬停：K
- 插入模式签名帮助：Ctrl + k
- 代码操作：Space + c + a
- 重命名：Space + c + r
- 运行 CodeLens：Space + c + c
- 显示行诊断：Space + c + d
```
- **Git 操作**
```
- 查看状态：Space + g + s
- 查看差异：Space + g + d
- 查看行级 Blame：Space + g + b
- 在浏览器打开当前文件：Space + g + B
- Git Stash（snacks.nvim）：Space + g + S
```
- **诊断与快速修复**
```
- 打开 Location List：Space + x + l
- 打开 Quickfix List：Space + x + q
- 在 Quickfix 跳转：[ q / ] q
```

## 添加插件

- **Markdown预览**

在``~/config/nvim/lua/plugins/``下新建一个mp.lua，写入如下配置：

```
return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = ':call mkdp#util#install()'
    }
}
```

随后即可在 Neovim 中打开一个 Markdown 文件，执行以下命令启动预览：​
```
:MarkdownPreview
```

🔗

[用 neovim 写 markdown 是一种什么样的体验](https://yelog.org/2024/08/02/write-markdown-in-neovim-experience-and-tips/)

---
**Done.**