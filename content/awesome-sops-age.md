+++
title = "乱七八糟:Sops+Age管理Git仓库"
date = 2026-05-10

[taxonomies]
tags = ["乱七八糟"]
+++

前言 当你把 Docker Compose 文件放在 Git 仓库里时，数据库密码、API 密钥这些敏感信息怎么办？`gitignore` 掉的话每次部署都要手动填，提交明文又等于裸奔。Sops + Age 就是干这个的：把 secrets 加密后直接放进仓库，需要的时候自动解密注入环境变量，既安全又省事。
<!-- more -->

## **为什么要用 Sops + Age**

传统的做法有两种，都不理想：

1. **全部 `.gitignore`**：每台机器手动创建 secrets 文件，时间一长文件丢了、格式不一致、换了机器忘了怎么配。
2. **提交加密后的文件**：思路对，但多半是自己写脚本拿 `openssl` 搞，脚本散落在各处，维护起来难受。

Sops（Mozilla 出的 Secrets OPerationS）专门解决这个问题。它不加密整个文件，而是只加密 YAML / JSON / ENV 文件里的**值**，保留键的明文。这样你一眼就能看到有哪些字段，Git diff 也有意义——哪个 key 变了，哪个没变，一清二楚。

Age 是 Sops 推荐的加密后端。相比 GPG，Age 没有信任链、没有过期日、密钥就是一个文件，简单到你不知道该配错点什么。

配合使用的大致流程：

```
本地编辑 secrets 文件 → Sops 用 Age 公钥加密 → push 到 Git
部署时 → Sops 用 Age 私钥解密 → 注入环境变量 → Docker 启动
```

下面以 Traefik + Miniflux 为例，走一遍完整配置。

## **安装 Sops 和 Age**

```bash
# Debian/Ubuntu
sudo apt install sops age

# macOS
brew install sops age

# Arch
sudo pacman -S sops age
```

装完验证：

```bash
sops --version
age-keygen --version
```

## **生成 Age 密钥**

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
chmod 700 ~/.config/sops/age/
chmod 600 ~/.config/sops/age/keys.txt
```

输出类似：

```text
# created: 2026-05-10T12:00:00+08:00
# public key: age1rmku52qh0x7panw7h9362eqlhqhmwdkj7y8cpgx3kthfnvs9ass72dvma
AGE-SECRET-KEY-19SR8JUFJX8F6H0E0DZVUAEH5M7L3HTFVCRY90HQ8H6563QPP7SUQ590DXX
```

记下 `age1` 开头的**公钥**，后面要用。私钥自动存在 `~/.config/sops/age/keys.txt`，Sops 运行时默认从这里找。

**注意**：如果你有多台机器需要解密（笔记本 + VPS），每一台都要生成自己的 age 密钥，然后把各自的公钥都写进 `.sops.yaml`。Sops 会用**所有列出的公钥**分别加密一份数据密钥，任意一台机器的私钥都能解开。

## **配置 `.sops.yaml`**

在 Git 仓库根目录创建 `.sops.yaml`：

```yaml
keys:
  - &dich_laptop age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  - &dich_vps    age1yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy

creation_rules:
  - path_regex: traefik/secrets/.*\.yaml$
    key_groups:
      - age:
          - *dich_laptop
          - *dich_vps
```

几点说明：

- `&anchor_name` 是 YAML 的锚点引用，定义一个值后可以用 `*` 复用，方便在多个规则里引用同一组密钥。
- `path_regex` 是匹配规则，只有路径符合正则的文件才会用对应的密钥加密。这里只匹配 `traefik/secrets/` 下的 `*.yaml` 文件。
- 如果仓库里有不同种类的 secrets（比如环境变量文件），可以加多条 `creation_rules`。

## **创建和编辑加密文件**

```bash
mkdir -p traefik/secrets
sops traefik/secrets/miniflux.yaml
```

Sops 会打开默认编辑器（`$EDITOR`），在编辑器里可以像改普通 YAML 一样编辑：

```yaml
admin_username: admin
admin_password: xxxxxxxx9999
db_user: miniflux
db_password: xxxxxxxxxxxx
```

保存退出，Sops 自动加密。文件变成这样：

```yaml
admin_username: ENC[AES256_GCM,data:abc123...,iv:def456...,tag:ghi789...,type:str]
admin_password: ENC[AES256_GCM,data:xyz...,iv:uvw...,tag:rst...,type:str]
db_user: ENC[AES256_GCM,data:...,iv:...,tag:...,type:str]
db_password: ENC[AES256_GCM,data:...,iv:...,tag:...,type:str]
sops:
    kms: []
    gcp_kms: []
    azure_kv: []
    hc_vault: []
    age:
        - recipient: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
          enc: ...
        - recipient: age1yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
          enc: ...
    lastmodified: "2026-05-10T12:00:00Z"
    mac: ENC[AES256_GCM,data:...,iv:...,tag:...,type:str]
    ...
```

注意两点：
- **键名是明文的**。你可以通过 `git diff` 看到哪个字段被改了、哪个是新加的。
- **两个 age recipient** 各有一份加密的数据密钥。任何一台机器的私钥都能打开。

加密后的文件直接提交到 Git：

```bash
git add traefik/secrets/miniflux.yaml
git commit -m "feat: add miniflux secrets"
```

## **更新 `.gitignore`**

只忽略**未加密的**明文文件：

```gitignore
# 防止把没加密的明文不小心提交
*.plain.yaml
*.decrypted.yaml
```

加密后的 `.yaml` 文件不受影响，正常跟踪。另外记得把 `${HOME}/.config/sops/age/keys.txt` 也加进系统的全局 gitignore——这个文件绝不能进仓库。

## **在 Docker Compose 中引用**

在 `docker-compose.miniflux.yml` 里，环境变量的值用 `sops exec-env` 注入：

```yaml
services:
  miniflux:
    image: miniflux/miniflux:latest
    environment:
      - DATABASE_URL=postgres://${db_user}:${db_password}@miniflux-db/miniflux?sslmode=disable
      - RUN_MIGRATIONS=1
      - CREATE_ADMIN=1
      - ADMIN_USERNAME=${admin_username}
      - ADMIN_PASSWORD=${admin_password}
```

部署时这样启动：

```bash
sops exec-env traefik/secrets/miniflux.yaml 'docker compose -f docker-compose.miniflux.yml up -d'
```

`sops exec-env` 做的事：解密文件 → 把每个 key 变成环境变量 → 传给后面的命令。Docker Compose 里 `${db_user}` 这类占位符就能拿到解密后的值。

如果不想每次手打这么长的命令，可以写个启动脚本 `start-miniflux.sh`：

```bash
#!/bin/bash
set -euo pipefail
sops exec-env traefik/secrets/miniflux.yaml \
    docker compose -f docker-compose.miniflux.yml up -d
```

## **常用命令**

```bash
# 编辑加密文件（解密 → 编辑器 → 加密）
sops traefik/secrets/miniflux.yaml

# 查看解密后的内容（不进编辑器）
sops --decrypt traefik/secrets/miniflux.yaml

# 原地加密一个已有的明文文件
sops --encrypt --in-place secrets.yaml

# 原地解密（谨慎使用）
sops --decrypt --in-place secrets.yaml

# 将解密后的值当作环境变量注入命令
sops exec-env traefik/secrets/miniflux.yaml 'env | grep admin_'
```

## **多环境管理**

如果 Dev 和 Prod 用不同的密钥（Prod 的密钥不该放在开发机上），可以在 `.sops.yaml` 里用 path 区分：

```yaml
creation_rules:
  - path_regex: traefik/secrets/dev/.*\.yaml$
    key_groups:
      - age:
          - &dev_key age1xxxxxxxxx...
  - path_regex: traefik/secrets/prod/.*\.yaml$
    key_groups:
      - age:
          - &prod_key age1yyyyyyyyy...
```

Dev 目录下的文件只有 Dev 机器能解，Prod 同理。

## **注意事项**

- **备份私钥**。`keys.txt` 丢了就是真丢了，加密的 secrets 全变废铁。把它放进密码管理器（Bitwarden / 1Password）或者离线 U 盘里。
- **全局 gitignore**。把 `~/.config/sops/age/keys.txt` 写进 `~/.config/git/ignore`，防止哪天不小心提交。
- **`.sops.yaml` 要进仓库**。这个文件本身没有密钥，只记录公钥和匹配规则，应该 commit。
- **CI/CD**。在 GitHub Actions 里同样装 sops + age，把私钥放进 Secret 然后用 `age-keygen` 还原，流程跟本地一样。

---

**Done.**
