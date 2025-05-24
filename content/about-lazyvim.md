+++
title = "乱七八糟:lazyvim快速上手"
date = 2025-04-20

[taxonomies]
tags = ["乱七八糟"]
+++

前言 ​LazyVim 是一个基于 Neovim 的现代化配置框架，易于定制和扩展，这里对其介绍并说明使用方法。

<!-- more -->
## Lazy!

> LazyVim 是一个基于 Neovim 的现代化配置框架，旨在简化 Neovim 的配置过程。它通过集成的 lazy.nvim 插件管理器，提供了一种易于定制和扩展配置的方式，结合了从头开始配置的灵活性和预配置设置的便利性 。

> LazyVim 是在Neovim的基础上进行配置，Neovim又继承了vim的操作模式，对vim不熟悉的同学可以看[这里](https://vimsheet.com/)。

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
~/.config/nvim
❯ tree
.
├── init.lua
├── lazy-lock.json
├── lazyvim.json
├── LICENSE
├── lua
│   ├── config
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── options.lua
│   └── plugins
│       ├── example.lua
│       └── mp.lua
├── README.md
└── stylua.toml

4 directories, 12 files
```

另外在``~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/``目录下看到的文件结构，是 LazyVim 为其核心插件和扩展插件提供的模块化配置体系。这些配置文件并不直接出现在``~/.config/nvim/lua/plugins/``目录中，是因为 LazyVim 采用了模块化和懒加载的设计理念，将核心插件和配置封装在其自身的代码库中。

### 各文件和目录的作用

* **`init.lua`**：主配置文件，负责加载 `lua/config/lazy.lua`，从而引导整个 LazyVim 的初始化过程。

* **`lazy-lock.json`**：由 `lazy.nvim` 插件管理器生成的锁定文件，记录了已安装插件的精确版本，确保插件的一致性。

* **`lazyvim.json`**：用于记录通过 `:LazyExtras` 命令启用的额外功能（Extras），便于在不同设备间同步配置。

* **`LICENSE`** 和 **`README.md`**：分别为许可协议和项目说明文档。

* **`stylua.toml`**：`stylua` 的配置文件，用于格式化 Lua 代码。

* **`lua/config/`**：包含 Neovim 的基础配置文件，如自动命令（`autocmds.lua`）、快捷键（`keymaps.lua`）、插件管理（`lazy.lua`）和编辑器选项（`options.lua`）。这些文件会被 LazyVim 自动加载，无需手动引入。

* **`lua/plugins/`**：用于添加或修改插件配置的目录。您可以在此目录中添加新的 Lua 文件，以引入其他插件或更改现有插件的设置。
​

## Lazyvim自带配置

在 LazyVim 中，插件被分类为已加载（Loaded）和未加载（Not Loaded）。

### ✅ 已加载的插件（Loaded）

* **blink.cmp**：一个高性能、开箱即用的自动补全引擎，旨在替代 `nvim-cmp`，提供更快的性能和更少的配置需求。

* **bufferline.nvim**：用于在顶部显示缓冲区列表的插件，提供类似于浏览器标签页的界面。

* **friendly-snippets**：一个包含多种语言代码片段的集合，可与多个片段引擎（如 `luasnip`）配合使用。

* **gitsigns.nvim**：在编辑器中显示 Git 更改标记（如添加、修改、删除）的插件，增强版本控制的可视化。

* **lazy.nvim**：LazyVim 的插件管理器，支持懒加载和依赖管理，提升启动速度和性能。

* **lualine.nvim**：一个高度可定制的状态栏插件，支持多种主题和组件。

* **mason-lspconfig.nvim** & **mason.nvim**：用于自动安装和配置 LSP（语言服务器协议）服务器的插件组合，简化开发环境的设置。

* **mini.ai**、**mini.pairs**：`mini.nvim` 插件集合的一部分，分别用于增强文本对象操作和自动括号配对功能。

* **noice.nvim**：改进 Neovim 消息和命令行界面的插件，提供更丰富的 UI 体验。

* **nui.nvim**：一个用于构建 Neovim 用户界面的 Lua 库，被多个插件作为依赖使用。

* **nvim-lint**：一个异步代码检查器，支持多种语言的语法和风格检查。

* **nvim-lspconfig**：提供预配置的 LSP 客户端设置，简化语言服务器的集成。

* **nvim-treesitter**、**nvim-treesitter-textobjects**、**nvim-ts-autotag**：基于 Tree-sitter 的语法高亮和代码结构分析插件，增强代码编辑体验。

* **persistence.nvim**：自动保存和恢复会话的插件，方便在不同项目之间切换。

* **snacks.nvim**：提供快速导航和编辑功能的插件，提升编辑效率。

* **todo-comments.nvim**：高亮和管理代码中的 TODO、FIXME 等注释的插件，方便任务跟踪。

* **tokyonight.nvim**：一个流行的 Neovim 主题，提供多种配色方案。

* **trouble.nvim**：一个用于显示诊断信息（如 LSP 错误、警告）的插件，提供统一的界面。

* **ts-comments.nvim**：基于 Tree-sitter 的注释插件，支持多语言的智能注释功能。

* **which-key.nvim**：在按下快捷键时弹出可用键位提示的插件，帮助记忆和发现快捷键。


### ❌ 未加载的插件（Not Loaded）

* **catppuccin**：一个柔和的 Neovim 主题，提供多种风格的配色方案。

* **conform.nvim**：一个用于代码格式化的插件，支持多种语言的格式化工具。

* **grug-far.nvim**：一个快速的全局查找和替换插件，提供直观的界面和操作。

* **lazydev.nvim**：用于 LazyVim 插件开发的辅助工具，简化开发流程。

* **markdown-preview.nvim**：在浏览器中实时预览 Markdown 文件的插件，提升写作体验。

* **plenary.nvim**：一个 Lua 函数库，提供多种实用功能，被许多插件作为依赖使用。

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

## tips

- 你会发现lazyvim中的行号是非自然序的，比如你在第245行，前一个行边数是1，这是为了方便光标移动而设置的：你可以在正常模式中通过10k快速移动光标到10行前，10j，10h，10l同理。
- lazyvim的字体是和终端相同的，不同单独设置；
- lazyvim中在侧边栏选择文件按d删除,按y复制,按p粘贴,按a创建,按r重命名；

## Edit!

> 编辑器的基本素养

``文件操作``
- 创建文件/文件夹
- 打开/关闭/切换文件
- 复制/粘贴
- 写入/保存/退出
- 搜索替换

``字符处理``
- LF/CRLF处理
- 零宽字符处理
- GBK/UTF-8处理

``终端``
- 打开终端/复用终端

``其他功能``
- LSP
- 代码调试
- 工作区切换
- Git支持
- 主题与显示效果

🔗

[用 neovim 写 markdown 是一种什么样的体验](https://yelog.org/2024/08/02/write-markdown-in-neovim-experience-and-tips/)

---
**Done.**
