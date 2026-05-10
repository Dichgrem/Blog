+++
title = "Linux系列(4):NixOS 使用"
date = 2025-10-03

[taxonomies]
tags = ["Linux"]
+++

前言 用过 Arch Linux 的同学大概都对滚动更新的痛深有体会——某天 `paru -Syu` 之后系统炸了，然后花一下午排查是哪个包的哪个依赖搞的鬼。NixOS 用一种完全不同的思路解决了这个问题：把整个系统变成一份配置文件，炸了可以一键回滚到上一个正常状态。这篇文章从零开始讲 NixOS 的核心概念和日常用法。
<!-- more -->

## **为什么是 NixOS**

传统 Linux 发行版（包括 Arch）有一个共同的毛病：系统状态是"累积"出来的。你今天装个包、明天改个配置、后天删个依赖，每一步都在修改系统的全局状态。时间一长，你根本不知道这个系统是怎么变成现在这样的。而滚挂之后想还原，基本靠记忆和运气。

Arch 用户常见的痛点：

- `paru -Syu` 失败，包管理直接爆炸
- 每天都在更新大量软件包，但滚动发行版实际上**要求**你必须一直更新，不然某天想装个新包发现依赖链已经错位
- 删掉一个软件包之后，连带删掉了有用的依赖，某个角落里的脚本突然就跑不起来了

NixOS 是**声明式的操作系统**。你用一份 Nix 配置文件描述你想要什么（装哪些包、开哪些服务、配成什么样），NixOS 负责从零构造出这个状态。改配置就是改这份文件，不满意就回滚到 Git 里上一个版本，完全不需要"修复系统"这种操作。

核心优势：

- **配置即代码**：整个系统状态由一份（或几份）配置文件定义，干净、可审计、可 Git 管理
- **原子化升级**：每次 `nixos-rebuild switch` 生成一个新的 generation，失败了自动回滚
- **可复现**：同一份配置文件，在任意机器上构建出来的是完全相同的系统
- **多版本共存**：同一个软件的不同版本可以同时存在 `/nix/store` 里，互不干扰
- **不会被强制更新**：通过 `flake.lock` 锁定版本，想什么时候更新就什么时候更新
- **开发环境隔离**：`nix shell` / `nix develop` 可以秒建隔离的临时环境，不污染系统

缺点也得说清楚：

- 学习曲线陡峭——要学 Nix 语言、理解 `/nix/store`、习惯声明式思维
- 不符合 FHS 标准，`/lib` 下没有 `ld-linux.so`，其他发行版的二进制基本跑不了
- 磁盘占用大（每个版本的包都独立存储，靠硬链接去重）
- 文档相对较少，很多东西得自己翻源码和 GitHub Issues

## **核心概念速览**

刚接触 NixOS 的时候，这几个名字会反复出现，先搞清楚：

| 概念 | 一句话解释 |
|------|-----------|
| **Nix** | 一门函数式语言 + 一个包管理器命令，用来写配置和执行构建 |
| **Nixpkgs** | NixOS 的软件包仓库，GitHub 上最大的包仓库之一（12 万+ 包） |
| **NixOS** | 基于 Nix 包管理器构建的完整 Linux 发行版 |
| **Flakes** | Nix 的新特性（实验性但已广泛使用），提供锁文件、标准化输入输出 |
| **Home Manager** | 管理用户级配置和 dotfiles 的工具，相当于把 `~/.config` 也声明式化 |
| **Derivation** | Nix 中的"构建配方"，描述如何从源码产出 `/nix/store` 里的一个包 |
| **Generation** | 每次 `nixos-rebuild switch` 产生的系统快照，可以随时切回去 |

Nix 这门语言可以理解为"JSON + 函数"。它是一门纯函数式语言，没有副作用，评估结果就是一个巨大的结构化数据，NixOS 的构建系统消费这份数据来完成系统构建。

```nix
# 最简单的 Nix 表达式
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
  ];
}
```

这段代码的意思是：接收 `pkgs` 作为输入，返回一个包含 `environment.systemPackages` 的配置，里面装上 neovim、git、curl。

## **安装 NixOS**

官方 ISO 安装流程在 [nixos.org](https://nixos.org/download) 有详细文档，这里提几个重点：

1. 启动 ISO 后先用 `nixos-generate-config --root /mnt` 生成初始配置
2. 这会产出两个文件：`/mnt/etc/nixos/configuration.nix`（系统配置）和 `hardware-configuration.nix`（硬件扫描结果）
3. 编辑 `configuration.nix` 加上基本设置（用户名、桌面环境、网络等）
4. `nixos-install` 完成安装

如果你想把配置放在 Git 仓库里管理（强烈建议），可以用 Flakes 模式：

```bash
# 安装时不直接用 /etc/nixos，而是 clone 自己的配置仓库
git clone git@github.com:yourname/nix-config.git /mnt/etc/nixos
nixos-install --flake /mnt/etc/nixos#your-hostname
```

对于没有预装 NixOS 的 VPS，可以用 `nixos-anywhere` 通过 SSH 远程安装：

```bash
nix run github:nix-community/nixos-anywhere -- \
  --flake .#your-hostname \
  root@your-server-ip
```

## **Flakes：NixOS 的现代配置方式**

Flakes 是目前管理 NixOS 配置的推荐方式。一个 `flake.nix` 文件类似于 Rust 的 `Cargo.toml` 或 JS 的 `package.json`——定义依赖（inputs）和产物（outputs），并生成 `flake.lock` 锁定版本。

典型的 `flake.nix` 结构：

```nix
{
  description = "My NixOS config";

  inputs = {
    # nixpkgs 稳定版
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # 或者用 unstable
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";  # 共用同一份 nixpkgs
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: {
    nixosConfigurations = {
      # 每台机器一个配置
      my-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.dich = ./hosts/desktop/home.nix;
          }
        ];
      };

      my-vps = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/vps/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.root = ./hosts/vps/home.nix;
          }
        ];
      };
    };
  };
}
```

`inputs.*.follows` 是重要概念：确保所有 input 共用同一份 nixpkgs，避免下载多份副本。

配置推荐模块化拆分：

```text
nix-config/
├── flake.nix          # 入口，定义输入和机器列表
├── flake.lock         # 锁文件，记录精确版本
├── hosts/
│   ├── desktop/
│   │   ├── configuration.nix
│   │   └── home.nix
│   └── vps/
│       ├── configuration.nix
│       └── home.nix
└── modules/           # 可复用模块
    ├── common.nix     # 所有机器共享
    ├── desktop.nix    # 桌面相关
    └── server.nix     # 服务器相关
```

## **Home Manager：管理你的 dotfiles**

Home Manager 是 NixOS 生态里仅次于 Nixpkgs 的第二重要的项目。它把用户级别的配置文件（dotfiles）也声明式管理起来。

有了 Home Manager，你不再需要手动维护 `.gitconfig`、`.tmux.conf`、starship 配置等。全部用 Nix 写：

```nix
# home.nix
{ pkgs, ... }: {
  home.username = "dich";
  home.homeDirectory = "/home/dich";
  home.stateVersion = "24.11";

  # 装用户级软件包
  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    lazygit
  ];

  # 配置程序
  programs.git = {
    enable = true;
    userName = "Dich";
    userEmail = "dich@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$all";
      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
      };
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
```

[Home Manager 选项搜索页](https://nix-community.github.io/home-manager/options.xhtml) 可以查所有支持的程序配置项。NixOS 系统级选项搜 [search.nixos.org/options](https://search.nixos.org/options)。

## **开发环境：nix shell 和 nix develop**

Nix 最实用的功能之一是创建临时开发环境。比如要试用一个工具但不装进系统：

```bash
# 临时使用 python 和 node 做点事，退出 shell 后自动清理
nix shell nixpkgs#python3 nixpkgs#nodejs -c zsh
```

更常用的 `nix develop` + `flake.nix`：

```nix
# flake.nix 里加一个 devShell
{
  outputs = { nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        python3
        nodejs
        gcc
      ];
      shellHook = ''
        echo "Dev environment ready"
      '';
    };
  };
}
```

```bash
nix develop -c zsh
```

配合 `nix-direnv` 可以做到进入目录自动激活环境：

```bash
# 安装 direnv + nix-direnv
# 在项目目录里
echo "use flake" > .envrc
direnv allow
```

之后每次 `cd` 进这个目录就自动加载对应的依赖，`cd` 出去就卸载。比 Docker 轻量，比 venv 干净。

## **日常操作**

### 构建和切换

```bash
# 基于 flake 切换系统配置
sudo nixos-rebuild switch --flake .#my-desktop

# 仅测试构建，不切换（CI 场景）
nix build .#nixosConfigurations.my-desktop.config.system.build.toplevel

# 更新 flake.lock 到最新
nix flake update

# 更新单个 input
nix flake lock --update-input nixpkgs
```

### Generations 管理

每次 `switch` 都生成一个 generation，是系统快照。系统挂了可以切回去：

```bash
# 列出所有 generation
sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# 切换到第 116 代
sudo nix-env -p /nix/var/nix/profiles/system --switch-generation 116

# 删除第 117 代
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations 117

# 回滚到上一个 generation
sudo nixos-rebuild switch --rollback
```

### 查看两次更新之间的变化

```bash
# 最近一次更新发生了什么
sudo nix profile diff-closures --profile /nix/var/nix/profiles/system

# 比较两个具体 generation
sudo nix profile diff-closures --profile /nix/var/nix/profiles/system \
  --from-generation 45 --to-generation 46
```

### 垃圾回收

NixOS 不会自动删除旧文件，需要手动 GC：

```bash
# 删除当前 generation 用不到的包
sudo nix-collect-garbage

# 删除所有旧 generation，只保留当前（激进）
sudo nix-collect-garbage -d

# 删除 30 天前的 generation
sudo nix-collect-garbage --delete-older-than 30d
```

### nix-store 修复

笔者曾经遇到突然断电导致 `/nix/store` 损坏：

```bash
# 检测并尝试修复
nix-store --verify --check-contents --repair
ls /nix/var/nix/profiles/system-*-link
# 删除损坏的一代
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations 680
# 重新构建系统并清理
just upgrade
sudo nix-collect-garbage -d
nix-store --verify --check-contents
just upgrade
```

## **远程部署服务器**

NixOS 非常适合管理多台服务器。配置统一在本地仓库，push 到远程：

```bash
# 本地构建 + 远程切换
nixos-rebuild switch \
  --flake .#my-vps \
  --target-host root@vps-ip \
  --use-remote-sudo

# 或者只在远程构建（适合架构不同）
nixos-rebuild switch \
  --flake .#my-vps \
  --target-host root@vps-ip \
  --build-host root@vps-ip
```

如果服务器是新机器没装 NixOS，用 `nixos-anywhere`：

```bash
nix run github:nix-community/nixos-anywhere -- \
  --flake .#my-vps \
  root@new-server-ip
```

## **给 Nixpkgs 做贡献**

Nixpkgs 包多但总有缺失的，有时候需要自己打包并提交 PR。基本流程：

```bash
# clone 自己的 fork
git clone --depth=1 git@github.com:Dichgrem/nixpkgs.git
cd nixpkgs

# 创建分支
git checkout -b some-package-update

# 用 nix-update 自动更新包
nix-update some-package

# 手动改的话，编辑对应的 default.nix 后验证
nix-build -A some-package

# 提交 PR
git commit -m "some-package: 1.0.0 -> 2.0.0"
git push -u origin some-package-update
# 然后去 GitHub 开 Pull Request
```

社区 PR 编号可以到 `https://github.com/NixOS/nixpkgs/pull/NNNN` 查看处理进度。

## **SSL 证书在 NixOS 服务器上**

NixOS 下管理 SSL 证书可以直接用 `security.acme`（Let's Encrypt 自动续期），也可以手动生成自签名证书用于内网：

```bash
openssl req -x509 -newkey rsa:4096 \
  -keyout /var/lib/certs/privkey.pem \
  -out /var/lib/certs/fullchain.pem \
  -days 3650 -nodes \
  -subj "/CN=*.dich.bid" \
  -addext "subjectAltName=DNS:*.dich.bid,DNS:dich.bid"

chown root:traefik /var/lib/certs/*.pem
chmod 640 /var/lib/certs/*.pem
systemctl restart traefik
```

配套的 NixOS 配置里声明好服务：

```nix
services.traefik = {
  enable = true;
  staticConfigOptions = {
    entryPoints.web.address = ":80";
    entryPoints.websecure.address = ":443";
  };
};
```

## **小结**

NixOS 的上手成本确实不低，但一旦搭好了自己的配置仓库，收益是持续的：装新机器、换电脑、系统炸了回滚，全都是分分钟的事。一份配置同步管理笔记本 + 台式机 + VPS 多台机器的体验，是传统发行版做不到的。

推荐的学习路径：

1. 先看 [nixos-and-flakes.thiscute.world](https://nixos-and-flakes.thiscute.world/zh/) 的中文教程，照着搭一套基础配置
2. 翻 [nix.dev](https://nix.dev) 的官方教程理解 Nix 语言和 Flakes
3. 在 [search.nixos.org/options](https://search.nixos.org/options) 搜索需要的配置项
4. 在 [Noogle](https://noogle.dev) 搜索 nixpkgs lib 函数
5. 参考社区的配置仓库（GitHub 搜 `nix-config`），偷学别人的写法

---

**Done.**
