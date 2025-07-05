+++
title = "Linux之旅(7):系统与终端字体设置"
date = 2023-08-01

[taxonomies]
tags = ["Linux"]
+++

前言 一个好看的字体会提高工作效率与审美.Linux 下的字体可以很漂亮,但需要一些设置.
<!-- more -->

随着 FreeType2 由于专利过期默认开启了高质量的 LCD 优化,以及一批高质量的开源字体的公布,Linux 上的中文字体渲染比过去好了太多.

> Windows 的字体渲染从技术上来说是相当先进的,问题是在中文字体的选择上实在是一坨...


## 选择字体

近几年来出现了一大批自由字体（包括工作量极大的 CJK 字体）,使 Linux 下的字体选择一下子丰富了起来.如果愿意花一点时间的话,可以去[ArchWiki](https://wiki.archlinux.org/title/Fonts#Font_packages) 上看看,里面涵盖了相当多的自由字体.

### 终端字体

[Maple Mono](https://github.com/subframe7536/maple-font?tab=readme-ov-file),这是一款字形整洁、拥有手写风格的斜体、细粒度配置、内置 Nerd-Font、中英文2:1等宽 的字体.我使用的:
```
MapleMono-Bold
```
### 阅读器字体

[霞鹜文楷](https://github.com/lxgw/LxgwWenKai),一款开源中文字体,基于 FONTWORKS 出品字体 Klee One 衍生.我使用的:
```
LXGW WenKai
```
### 浏览器字体
```
拉丁字体
├── Inter -无衬线,类似于 Roboto 但更适合屏幕显示的字体 
├── Noto Serif -衬线
└── Sarasa Term SC -等宽,拉丁文字符严格为半宽的字体,中英文混排时较协调
├── 如果不适应这种较瘦的字体风格, 则可以尝试使用:
│   ├── Adobe Source Pro
│   ├── Cascadia Code
│   └── Fira Code
中文字体
├── Noto Sans CJK SC （思源黑体）
└── Noto Serif CJK SC（思源宋体）
```
---
**Done.**
