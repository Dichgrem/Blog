+++
title = "乱七八糟:Vim编辑器速查"
date = 2024-08-15

[taxonomies]
tags = ["乱七八糟"]
+++

前言 Vim 是从早期的 vi 编辑器发展而来的增强版，其名称代表“Vi IMproved”。由荷兰程序员 Bram Moolenaar 于 1991 年首次发布。Vim 是开源软件，支持多种操作系统，包括 Unix、Linux、Windows 和 macOS 等。

<!-- more -->

---

## 一份优秀的 Vim 速查表

> 翻译自``https://vimsheet.com/``

我整理了一份我每天使用的 Vim 基本命令列表，并提供了一些配置建议，使 Vim 更加实用。因为没有配置的 Vim 使用起来会比较痛苦。

## 基础命令

### 光标移动（普通模式/可视模式）

* `h` `j` `k` `l`：左、下、上、右移动
* `w` / `b`：下一个/上一个单词
* `W` / `B`：下一个/上一个以空格分隔的单词
* `e` / `ge`：下一个/上一个单词的结尾
* `0` / `$`：行首/行尾
* `^`：行首第一个非空白字符（等同于 `0w`）

### 编辑文本

* `i` / `a`：在光标处/之后进入插入模式
* `I` / `A`：在行首/行尾进入插入模式
* `o` / `O`：在当前行下方/上方插入空行
* `Esc` 或 `Ctrl+[`：退出插入模式
* `d`：删除
* `dd`：删除整行
* `c`：删除并进入插入模式
* `cc`：删除整行并进入插入模式

### 操作符

* 操作符也适用于可视模式
* `d`：从光标处删除到移动目标
* `c`：从光标处删除到移动目标，并进入插入模式
* `y`：从光标处复制到移动目标
* `>`：缩进一级
* `<`：取消缩进一级
* 操作符可与移动命令组合使用，例如：`d$` 删除从光标到行尾的内容

### 标记文本（可视模式）

* `v`：进入可视模式
* `V`：进入行可视模式
* `Ctrl+v`：进入块可视模式
* `Esc` 或 `Ctrl+[`：退出可视模式

### 剪贴板操作

* `yy`：复制整行
* `p`：在光标后粘贴
* `P`：在光标前粘贴
* `dd`：剪切整行
* `x`：删除当前字符
* `X`：删除前一个字符
* 默认情况下，`d` / `c` 会将删除的内容复制到剪贴板

### 退出

* `:w`：保存文件但不退出
* `:wq`：保存并退出
* `:q`：退出（如果有修改会失败）
* `:q!`：强制退出并放弃修改

### 搜索/替换

* `/pattern`：搜索 pattern
* `?pattern`：向上搜索 pattern
* `n`：重复上一次搜索（同方向）
* `N`：重复上一次搜索（反方向）
* `:%s/old/new/g`：全文件替换 old 为 new
* `:%s/old/new/gc`：全文件替换 old 为 new，并逐个确认

### 常规命令

* `u`：撤销
* `Ctrl+r`：重做

## 高级命令

### 光标移动

* `Ctrl+d`：向下移动半页
* `Ctrl+u`：向上移动半页
* `}`：跳转到下一个段落（空行）
* `{`：跳转到上一个段落（空行）
* `gg`：跳转到文件顶部
* `G`：跳转到文件底部
* `:[num]`：跳转到指定行号
* `Ctrl+e` / `Ctrl+y`：向下/向上滚动一行

### 字符搜索

* `f [char]`：向前移动到指定字符
* `F [char]`：向后移动到指定字符
* `t [char]`：向前移动到指定字符之前
* `T [char]`：向后移动到指定字符之前
* `;` / `,`：重复上一次字符搜索（正向/反向）

### 编辑文本

* `J`：将下一行合并到当前行
* `r [char]`：用指定字符替换当前字符（不进入插入模式）

### 可视模式

* `O`：移动到块的另一个角
* `o`：移动到标记区域的另一端

### 文件标签

* `:e filename`：编辑文件
* `:tabe`：打开新标签页
* `gt`：切换到下一个标签页
* `gT`：切换到上一个标签页
* `:vsp`：垂直分割窗口
* `Ctrl+ws`：水平分割窗口
* `Ctrl+wv`：垂直分割窗口
* `Ctrl+ww`：在窗口间切换
* `Ctrl+wq`：关闭当前窗口

### 标记

* 标记允许你跳转到代码中的指定位置
* `m{a-z}`：在光标位置设置标记 {a-z}
* 大写标记 {A-Z} 是全局标记，可跨文件使用
* `'{a-z}`：跳转到设置标记的行首
* `''`：返回上一个跳转位置

### 文本对象

* 例如：`def (arg1, arg2, arg3)`，光标在括号内
* `di(`：删除括号内的内容，即“删除最近括号内的内容”
* 如果没有文本对象，你需要使用 `T(dt)` 来实现相同的功能

### 常规命令

* `.`：重复上一次命令
* 在插入模式下，`Ctrl+r 0`：插入最近复制的文本
* `gv`：重新选择上一次选中的文本块
* `%`：在匹配的 `()` 或 `{}` 之间跳转

---

如果你希望将此速查表保存为 PDF 或打印出来，可以使用 Markdown 编辑器（如 Typora）或在线工具（如 Dillinger）进行导出。

此外，Vim 的默认配置可能不够友好，建议你参考以下资源进行配置优化：

* [vim-sensible](https://github.com/tpope/vim-sensible)：提供一套合理的默认配置
* [vim-pathogen](https://github.com/tpope/vim-pathogen)：插件管理工具
* [ag.vim](https://github.com/rking/ag.vim)：快速全局搜索插件
* [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)：文件和缓冲区快速切换插件
* [nerdcommenter](https://github.com/preservim/nerdcommenter)：代码注释插件

这些插件可以显著提升 Vim 的功能，使其更接近一个完整的 IDE。

---
**Done.**




