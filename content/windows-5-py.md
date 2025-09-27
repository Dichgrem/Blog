+++
title = "Windows系列(5):Python开发配置"
date = 2024-05-31

[taxonomies]
tags = ["Windows"]
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

> linux中安装Miniconda 
```
# Miniconda安装脚本
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# 执行以下命令启动安装程序：
bash Miniconda3-latest-Linux-x86_64.sh
# 验证安装
conda --version
```

## 使用

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
conda deactivate env_name
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
- 在本地使用yml文件创建虚拟环境
```
conda env create -f environment.yml
```
- 列出本机的所有环境，如下，可见当前有2个环境，当前激活的是test环境：
```
(test) ➜  ~ conda info -e
- conda environments:
#
base                     /Volumes/300g/opt/anaconda3
test                  *  /Volumes/300g/opt/anaconda3/envs/test
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

## Jupyter使用

安装Anaconda并启动一个环境之后，如何让Jupyter Notebook在我们要的环境中启动呢？

- 安装jupyter
```
conda install jupyter notebook
```
- 配置虚拟机中允许宿主机访问
```
# 生成配置
jupyter notebook --generate-config
# 编辑配置
nano ~/.jupyter/jupyter_notebook_config.py
# 写入这三行
c.NotebookApp.ip = '0.0.0.0'         # 允许任何 IP 访问
c.NotebookApp.port = 8888            # 指定端口
c.NotebookApp.open_browser = False   # 不自动开浏览器
# 重启jupyter
jupyter notebook
```

- 安装 ipykernel

为了让 Jupyter Notebook 能识别该环境中的 Python 解释器，你需要在该环境中安装 ipykernel：

```
conda install ipykernel
```
- 注册环境内核

将该环境注册为 Jupyter 的一个内核（kernel），这样启动 Jupyter Notebook 后就能选择这个内核：
```
python -m ipykernel install --user --name myenv --display-name "Python (myenv)"
```
这里 --name 指定内核的名称，--display-name 是在 Jupyter Notebook 界面中显示的名称，你可以根据需要自定义。

- 启动 Jupyter Notebook：依然在激活后的环境中，启动 Jupyter Notebook；启动后，你在新建 notebook 时可以选择刚刚注册的内核 “Python (myenv)” 来确保使用该环境的 Python 解释器。

```
jupyter notebook
```

- 汉化jupyter(可选)

Jupyter Notebook 本身没有官方语言包，但可以用第三方扩展 ``jupyter_contrib_nbextensions``和``notebook-translation``来实现部分汉化

```
pip install jupyter_contrib_nbextensions
jupyter contrib nbextension install --user
pip install jupyter-notebook-translation
```

> 当然，你也可以使用其他编辑器/IDE如 Sublime Text 或者 JetBrains 系列的 PyCharm 。

## 使用UV替代Conda

> UV（由 Astral 团队开发）是一个用 Rust 编写的高性能包管理器，提供了类似 Conda 的虚拟环境管理和依赖解析功能，并且在大多数场景下比 pip 和 Conda 快 10–100 倍。它通过命令行工具如 uv venv（创建/管理虚拟环境）和 uv pip（安装/锁定/同步依赖）来覆盖传统的 conda create、conda install、conda env export 等操作，但本身并不管理底层的 C/C++ 库，因此对于诸如 GDAL、SciPy 等需要系统级二进制依赖的包，仍建议在 Conda/系统包管理器中预装相关库，然后用 UV 来管理 Python 包。

**安装与激活**
```
wget -qO- https://astral.sh/uv/install.sh | sh
```
- 在当前目录下创建 .venv，使用系统默认 Python（若不存在则自动下载）
```
uv venv
```
- 指定环境名称或路径
```
uv venv myenv
```
- 指定 Python 版本（需系统已有或可下载）
```
uv venv --python 3.11
```
- 激活
```
source .venv/bin/activate
```
**安装包**

```bash
# 安装单个包
uv pip install requests

# 批量安装并自动锁定依赖
uv pip install fastapi uvicorn sqlalchemy
```

**生成与同步锁文件**

```bash
# 从 requirements.in 生成统一依赖文件
uv pip compile docs/requirements.in \
   --universal \
   --output-file docs/requirements.txt

# 根据锁文件同步环境
uv pip sync docs/requirements.txt
```

此流程替代 `conda env export` + `conda env update`，并保证跨平台一致性 ([GitHub][3])。

**查看与卸载**

```bash
uv pip list       # 列出已安装包（类似 conda list）
uv pip uninstall numpy
```

**替代常见 Conda 工作流**

| Conda 操作                         | UV 对应                                    |
| -------------------------------- | ---------------------------------------- |
| `conda create -n env python=3.x` | `uv venv --python 3.x`                   |
| `conda activate env`             | `source .venv/bin/activate` 或 `activate` |
| `conda install pkg1 pkg2`        | `uv pip install pkg1 pkg2`               |
| `conda env export > env.yml`     | `uv pip compile requirements.in`         |
| `conda env update -f env.yml`    | `uv pip sync requirements.txt`           |
| `conda list`                     | `uv pip list`                            |

**最佳实践**：

1. **系统依赖**：用 Conda/Mamba 安装较难编译的 C 库（`conda install gdal`）。
2. **Python 包**：用 UV 管理所有纯 Python 依赖（`uv pip install pandas scikit-learn`）。
3. **统一锁定**：把 `uv pip compile` 生成的 `requirements.txt` 放入版本控制，确保团队环境一致。

## ipynb转markdown

首先安装 nbformat 和 nbconvert包：
```
conda install nbformat nbconvert -y
touch ipynb2md.py && nano ipynb2md.py
```
写入以下脚本：
```
import nbformat
from nbconvert import MarkdownExporter
from pathlib import Path

def ipynb_to_md(ipynb_path: Path, output_dir: Path):
    """单个 ipynb 转 md"""
    with open(ipynb_path, "r", encoding="utf-8") as f:
        nb = nbformat.read(f, as_version=4)

    exporter = MarkdownExporter()
    body, resources = exporter.from_notebook_node(nb)

    output_file = output_dir / (ipynb_path.stem + ".md")
    with open(output_file, "w", encoding="utf-8") as f:
        f.write(body)

    print(f"✔ 转换完成: {ipynb_path} -> {output_file}")

def batch_convert(input_dir: str, output_dir: str = "markdown_output"):
    input_dir = Path(input_dir)
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    for ipynb_file in input_dir.glob("*.ipynb"):
        ipynb_to_md(ipynb_file, output_dir)

if __name__ == "__main__":
    # 修改这里的目录路径即可
    batch_convert(input_dir=".")
```
运行脚本：
```
python ipynb2md.py
```
脚本会自动扫描当前目录下的所有 .ipynb 文件，并把 .md 文件输出到 markdown_output/ 文件夹。

--- 
**Done.**

