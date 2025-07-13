+++
title = "Windows系列(6):C/C++开发配置"
date = 2024-05-30

[taxonomies]
tags = ["Windows"]
+++

前言 由于 Windows 中开发环境较 linux 复杂，这里总结 Windows 中使用 VScode 开发 C/C++ 的环境配置。

<!-- more -->

## 步骤

- 下载安装 Vscode(Visual Studio Code)
- 配置安装中文插件,C/C++插件和 Code Runner 插件
- 安装 MinGW64 编译器并配置环境变量
- 配置 tasks.json 和 launch.json
- 开始C/C++之旅！

## 安装VScode

- [官网](https://code.visualstudio.com/)-微软官方版
- [vscodium](https://github.com/VSCodium/vscodium)-社区开源版本，去除官方版中不开源成分

## 配置插件

- 默认为英文，在左侧 ``Extensions`` 中安装 ``Chinese(simplified)`` 插件，重启即可变为中文；
- 随后安装[C/C++插件](https://github.com/Microsoft/vscode-cpptools)，即下载名称为``cpptools-windows-x64.vsix``
的插件并在扩展中``从VSIX安装``，然后搜索 Code Runner 并安装。

## 安装 MinGW64 编译器

- 首先打开[官方文档](https://www.mingw-w64.org/)，然后点击左侧的 Downloads，再点击 Pre-built Toolchains。往下拉，可以看到许多系统的下载包，这里我们选``MinGW-W64-builds``并点击。页面自动跳转，再点击最上方的 MinGW-W64-builds 下的 GitHub 链接。

- 进入Github，找到``x86_64-14.2.0-release-win32-seh-ucrt-rt_v12-rev1.7z``（版本会更新，选择最新的即可）点击然后下载。

- 下载完成后解压得到 mingw64 文件夹，将其移动到``C:\Program Files``下，随后复制该文件夹中/bin的路径。

- 按下 Win + S，在搜索框中输入“系统环境变量”，点击“编辑系统环境变量“，点击环境变量。在下方的系统变量中，选中``Path``，然后点击编辑，点击右侧的新建，然后黏贴刚刚拷贝的路径，随后一直用``确定``退出。

- 检验是否成功：在cmd中输入``gcc -v``，如果有版本号则成功。

## 配置JSON

- 回到 Visual Studio Code 继续配置。点击左侧的资源管理器，点击打开文件夹，创建一个``.cpp``文件，里面代码可以是
```
#include <iostream>

int main() {
    std::cout << "Hello" << std::endl;
    return 0;
}
```
- 保存，然后点击右上角的三角形，选择“运行C/C++文件”。此时上方的搜索框会有弹出，点击“C/C++: g++.exe 构建和调试活动文件”。 然后会生成一个 .vscode 的文件夹，里面包含 tasks.json 文件。打开这个文件，然后按需调整，设置栈空间（这里设置成了256MB）和 C++ 标准（这里设置成C++17）。

- 接着生成调试文件，用于进行 debug。点击左侧的运行和调试，然后点击“创建 launch.json 文件”。点击弹出的“另外 C++ (GDB/LLDB) 个选项”。

- 点击右下角的“添加配置”，然后点击“C/C++: (gbd) 启动”。对Program部分进行修改（编译产物的路径）。

> 手动编译：``g++ <源代码的相对路径>`` 手动运行编译产物：一般为``./a.out``

至此 Visual Studio Code 的 C++ 环境已经配置完成。


> 在ubuntu上配置环境需要安装 `sudo apt install build-essential gdb cmake clangd clang-format libstdc++-dev`
---
**Done.**



