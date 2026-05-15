+++
title = "Windows系列(5):Python开发配置"
date = 2024-05-30

[taxonomies]
tags = ["Windows"]
+++

前言：Windows 下搭建 Python 开发环境比 Linux 繁琐不少——没有内置包管理器、PATH 配置容易出错、各种工具散落各处。本文从零开始，依次介绍环境管理工具的选择、推荐方案 UV、传统方案 Conda，最后是 Jupyter 的通用配置和常用技巧。

<!-- more -->

## 方案对比

|                | UV                           | Conda                      |
| -------------- | ---------------------------- | -------------------------- |
| 速度           | 快（Rust 实现，10-100x）     | 慢                         |
| 包来源         | PyPI                         | conda-forge + PyPI         |
| 非 Python 依赖 | 需手动安装系统库             | 内置预编译二进制包         |
| 适用场景       | Web 开发、通用项目           | 科学计算、数据科学         |
| 推荐           | **日常开发首选**             | 需要复杂 C/C++ 底层库时    |

经验之谈：大多数项目直接用 UV。只有当你发现 `pip install` 报 build 错误（常见于 NumPy、SciPy、OpenCV 等依赖 C/C++ 编译链的包），才需要切回 Conda。

---

## 推荐方案：UV

UV 是 Astral 团队（ruff 的作者）用 Rust 写的高性能 Python 包管理器，100% 兼容 pip 生态。

### 安装 UV

Windows（PowerShell）：

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Linux/macOS：

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

装完重启终端，验证：

```bash
uv --version
```

更新 UV 自身：

```bash
uv self update
```

### 创建与激活环境

UV 支持两种用法：项目化管理（推荐），或传统 venv。

**项目化管理（推荐，适合有工程感的项目）：**

```bash
# 初始化项目，自动生成 pyproject.toml 和 .venv
uv init myproject
cd myproject

# 如果想指定 Python 版本（UV 会自动下载）
uv init myproject --python 3.12
```

**传统 venv（轻量，适合临时环境）：**

```bash
uv venv --python 3.12
```

激活环境：

```powershell
# Windows (PowerShell)
.venv\Scripts\Activate.ps1

# Windows (CMD)
.venv\Scripts\activate
```

```bash
# Linux/macOS
source .venv/bin/activate
```

退出和删除：

```bash
deactivate                   # 退出当前环境
rm -rf .venv                 # 删除环境（Windows: rmdir /s /q .venv）
```

### 管理依赖

UV 有两个并行的工作流，按需选择：

**项目工作流（推荐，依赖写入 pyproject.toml）：**

```bash
uv add fastapi uvicorn sqlalchemy   # 安装并写入 pyproject.toml
uv sync                             # 按 pyproject.toml + uv.lock 同步环境
uv remove fastapi                   # 卸载并从 pyproject.toml 移除
uv add --dev pytest ruff            # 安装开发依赖
```

**pip 兼容工作流：**

```bash
uv pip install requests numpy       # 传统 pip 风格
uv pip list                         # 列出已安装包
uv pip uninstall numpy              # 卸载
```

### 直接运行（无需手动激活）

UV 的最大亮点之一——可以跳过 `activate` 步骤，直接用 `uv run` 执行命令：

```bash
uv run python script.py
uv run jupyter lab
uv run pytest
uv run python -m ipykernel install --user --name myenv --display-name "Python (myenv)"
```

### pyproject.toml 示例

```toml
[project]
name = "myproject"
version = "0.1.0"
requires-python = ">=3.12"
dependencies = [
    "fastapi>=0.115",
    "uvicorn[standard]>=0.30",
    "sqlalchemy>=2.0",
]

[dependency-groups]
dev = [
    "pytest>=8",
    "ruff>=0.5",
]
```

### 团队协作：已有项目快速上手

项目已经配好 `pyproject.toml` 和 `uv.lock` 时，团队成员克隆下来只需一条命令：

```bash
# 1. 克隆项目
git clone <repo-url> && cd <project>

# 2. 同步环境——UV 自动创建 .venv、下载 Python、安装依赖，全自动
uv sync
```

然后直接跑起来：

```bash
uv run jupyter lab
# 或
uv run python main.py
```

如果需要 Jupyter 内核：

```bash
uv run python -m ipykernel install --user --name myproject --display-name "Python (myproject)"
```

> 关键点：`uv sync` 依据 `uv.lock` 精确还原依赖版本，所有成员的环境完全一致。不会出现"我这能跑你那不行"的问题。记得把 `.venv` 写入 `.gitignore` 而 `uv.lock` 应该提交到仓库。

### Conda → UV 速查

| Conda 操作                                | UV 等效命令                                                  |
| ----------------------------------------- | ------------------------------------------------------------ |
| `conda create -n foo python=3.12`         | `uv init foo --python 3.12` 或 `uv venv --python 3.12`      |
| `conda activate foo`                      | `.venv\Scripts\activate`（Windows） 或 `source .venv/bin/activate` |
| `conda install numpy`                     | `uv add numpy`                                               |
| `conda env export > env.yml`              | 自动生成 `uv.lock`，无需手动导出                             |
| `conda env create -f env.yml`             | `uv sync`                                                    |
| `conda list`                              | `uv pip list`                                                |
| `conda remove numpy`                      | `uv remove numpy`                                            |

---

## 传统方案：Conda

如果项目用到了 NumPy、SciPy、OpenCV 等需要 C/C++ 编译链的包，Conda 凭借预编译二进制生态依然是更省心的选择。

### 安装 Miniconda

推荐 Miniconda（体积小，无预装冗余包）而非 Anaconda。

在 [Miniconda 官网](https://docs.conda.io/en/latest/miniconda.html) 下载 Windows 安装包，一路下一步。装完后打开终端验证：

```bash
conda --version
conda info
```

安装 Miniconda 的同时，你就拥有了 Python 解释器、conda 环境管理器、conda 包管理器以及 conda-forge 上大量预编译的科学计算工具包。

### 环境管理

```bash
# 创建环境（指定 Python 版本和初始包）
conda create --name myenv python=3.12 numpy pandas

# 激活环境
conda activate myenv

# 退出环境（不带参数）
conda deactivate

# 复制环境
conda create --name new_env --clone old_env

# 删除环境
conda remove --name myenv --all

# 列出所有环境
conda env list

# 导出环境配置
conda env export > environment.yml

# 从配置文件重建环境
conda env create -f environment.yml
```

### 包管理

```bash
conda list                    # 当前环境已安装的包
conda list -n myenv           # 指定环境
conda search scipy            # 搜索可用包
conda install scipy=1.11      # 安装（可指定版本）
conda install -n myenv numpy  # 安装到指定环境
conda update scipy            # 更新指定包
conda update --all            # 更新所有包
conda remove scipy            # 卸载
conda remove -n myenv scipy   # 从指定环境卸载
```

### 卸载 Conda

Windows 下通过"设置 → 应用 → 添加或删除程序"卸载 Miniconda/Anaconda 即可。Linux/macOS 手动删除：

```bash
rm -rf ~/miniconda3 ~/.conda ~/.condarc ~/.continuum
```

---

## Jupyter 配置

无论用 UV 还是 Conda，Jupyter 的配置流程是通用的。

### 安装

推荐 JupyterLab（界面更现代，集成终端、文件浏览器和扩展管理），而非旧版 Notebook。

```bash
# UV
uv add jupyterlab ipykernel

# Conda
conda install jupyterlab ipykernel
```

### 注册内核

让 Jupyter 能识别你环境中的 Python 解释器：

```bash
# UV
uv run python -m ipykernel install --user --name myenv --display-name "Python (myenv)"

# Conda
python -m ipykernel install --user --name myenv --display-name "Python (myenv)"
```

`--name` 是内核的内部标识，`--display-name` 是 Jupyter 界面中显示的名称，按需自定义。

### 启动

```bash
# UV
uv run jupyter lab

# Conda
jupyter lab
```

### 允许远程访问

在服务器或 WSL 中运行 Jupyter 时，需要绑定到 `0.0.0.0` 以便宿主机访问：

```bash
jupyter lab --generate-config
```

编辑 `~/.jupyter/jupyter_lab_config.py`，添加：

```python
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = 8888
c.ServerApp.open_browser = False
```

> 注意：旧版 Jupyter 的配置项名为 `c.NotebookApp.*`，新版（Jupyter Server 2.x+）改用 `c.ServerApp.*`。不确定版本的话，看看生成的配置文件里实际有哪些字段。

### 汉化（可选）

```bash
pip install jupyterlab-language-pack-zh-CN
```

---

## 附录：ipynb 转 Markdown

最简方式——一行命令用 `nbconvert` CLI：

```bash
jupyter nbconvert --to markdown notebook.ipynb
```

批量转换脚本 `ipynb2md.py`：

```python
import nbformat
from nbconvert import MarkdownExporter
from pathlib import Path

def ipynb_to_md(ipynb_path: Path, output_dir: Path):
    with open(ipynb_path, "r", encoding="utf-8") as f:
        nb = nbformat.read(f, as_version=4)
    exporter = MarkdownExporter()
    body, _ = exporter.from_notebook_node(nb)
    output_file = output_dir / (ipynb_path.stem + ".md")
    with open(output_file, "w", encoding="utf-8") as f:
        f.write(body)
    print(f"✔ 转换完成: {ipynb_path} -> {output_file}")

def batch_convert(input_dir: str = ".", output_dir: str = "markdown_output"):
    input_dir = Path(input_dir)
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    for ipynb_file in input_dir.glob("*.ipynb"):
        ipynb_to_md(ipynb_file, output_dir)

if __name__ == "__main__":
    batch_convert()
```

先装依赖再运行：

```bash
pip install nbformat nbconvert         # 或 conda install nbformat nbconvert -y
python ipynb2md.py
```

脚本扫描当前目录下所有 `.ipynb` 文件，把生成的 `.md` 输出到 `markdown_output/` 文件夹。

---

**Done.**
