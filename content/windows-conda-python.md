+++
title = "乱七八糟:Windows-Jupyter开发Python"
date = 2024-05-31

[taxonomies]
tags = ["乱七八糟","Windows"]
+++

前言 由于 Windows 中开发环境较 linux 复杂，这里总结 Windows 中使用 Jupyter 开发 Python 的环境配置。

<!-- more -->
## 安装

Python是一种跨平台的编程语言,社区生态丰富，有许多现成的包可以调用。传统的安装方法如下：

- 下载、安装Pythond解释器；
- 验证安装；
- 安装VScode以及Python的拓展；

但Python开发项目时往往需要不同版本，不同的第三方包，如果用传统方法难以管理；因此现在的主流方法是：

- 安装Anaconda或miniconda等Python集成包；
- 使用conda创建并启动一个Python环境；
- 安装jupyter编辑器编写python。

在[Anaconda官网](https://www.anaconda.com/)下载并安装，安装成功后，命令行中敲``conda info``，会显示conda的版本和python的版本等详细信息；再敲``conda list``，会列出当前环境下所有安装的包。

安装好了Anaconda，就相当于同时有了Python、环境管理器、包管理器以及一大堆开箱即用的科学计算工具包。

## 使用

安装好了，默认是在base虚拟环境下，此时我们从base环境复制一份出来，在新环境里工作。

- 复制base环境, 创建test环境
```
conda create --name test --clone base
```
- 激活test环境
```
conda activate test
```
- 取消Conda默认激活base虚拟环境
```
conda config --set auto_activate_base false
```
- 列出本机的所有环境，如下，可见当前有2个环境，当前激活的是test环境：
```
(test) ➜  ~ conda info -e
- conda environments:
#
base                     /Volumes/300g/opt/anaconda3
test                  *  /Volumes/300g/opt/anaconda3/envs/test
```
- Anaconda默认安装了jupyter，打开jupyter：
```
jupyter notebook
```
此时会自动弹出浏览器窗口打开Jupyter Notebook网页，默认为``http://localhost:8888``

> Jupyter汉化/下载中文包：``pip install jupyterlab-language-pack-zh-CN``


### 虚拟环境管理

- 创建环境，后面的python=3.6是指定python的版本
```
conda create --name env_name python=3.6
```
- 创建包含某些包的环境（也可以加上版本信息）
```
conda create --name env_name python=3.7 numpy scrapy
```
- 激活某个环境
```
conda activate env_name
```
- 关闭某个环境
```
conda deactivate
```
- 复制某个环境
```
conda create --name new_env_name --clone old_env_name
```
- 删除某个环境
```
conda remove --name env_name --all
```
- 生成需要分享环境的yml文件（需要在虚拟环境中执行）
```
conda env export > environment.yml
```
- 别人在自己本地使用yml文件创建虚拟环境
```
conda env create -f environment.yml
```
### 包管理

- 列出当前环境下所有安装的包
```
conda list
```
- 列举一个指定环境下的所有包
```
conda list -n env_name
```
- 查询库
```
conda search scrapys
```
- 安装库安装时可以指定版本例如：（scrapy=1.5.0）
```
conda install scrapy
```
- 为指定环境安装某个包
```
conda install --name target_env_name package_name
```
- 更新安装的库
```
conda update scrapy
```
- 更新指定环境某个包
```
conda update -n target_env_name package_name
```
- 更新所有包
```
conda update --all
```
- 删除已经安装的库
```
conda remove scrapy
```
- 删除指定环境某个包
```
conda remove -n target_env_name package_name
```
- 更多命令请查看官方文档或者查询帮助命令：
```
conda --help

conda install --help
```

有了Conda包管理器，为什么Anaconda环境中，可能还需要用pip安装包呢？因为Anaconda本身只提供部分包，远没有pip提供的包多，有时conda无法安装我们需要的包，此时需要用pip将其装到conda环境里。

安装特定版本的包，conda用=，pip用==。例如：
```
conda install xxx=1.0.0
pip install xxx==1.0.0
```

--- 
**Done.**

