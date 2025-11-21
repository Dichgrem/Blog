+++
title = "综合工程:OpenWrt路由部署与软件编译"
date = 2023-08-12

[taxonomies]
tags = ["综合工程"]
+++


前言 openwrt 是一个自由的、兼容性好的嵌入式 linux 发行版。作为软路由玩家必备的一款神器，可以实现诸如去广告，多拨和科学上网等多种功能。本文介绍openwrt在各种平台上的部署流程。
<!-- more -->

## **要实现的目标**

- 1.IPv6 分配到每个设备；
- 2.NAT类型为NAT1（全锥形）；
- 3.可控的流量记录与IP控制/QOS；
- 4.可靠的硬件加速；
- 5.多线多播/宽带提速；
- 6.PPPoE拨号，替代一部分光猫功能；
- 7.智能DNS配置与去广告；
- 8.VPN配置回家；
- 9.实现透明代理。

## 大致思路

- 使用高性能的X86主机管理拨号和 DHCP 内网的工作，其他无线路由器桥接做AP，Mesh组网；
- 使用绕过中国流量模式，国内流量不经过代理内核直接直连，加快国内网站访问。保持尽可能高的 NAT 等级；
- 不使用旁路由，所有流量过主路由；由于第二点代理挂了也不影响国内正常上网；
- 国内外域名分流查询，国内域名查运营商 DNS ，国外域名经代理查国外 DoH ，直接返回真实 IP；
- 良好的国内 IPv6 支持，只对国内域名返回 IPv6 AAAA 结果，国外域名只用 IPv4；
- 兼容 Adguard Home ，方便管理域名黑白名单；
- 对能直连的国外服务能返回最优的节点，而不是绕路其他地方；


## **选择合适的设备**

无论是传统的无线路由器还是小主机都有成为openwrt路由的潜力。截止到今天，已经有20多个品牌（小米，华硕，锐捷，华三等）30多种架构（x86,ipq,bcm,mtd等）支持刷入openwrt；你可以在这个[网站](https://mao.fan/select)找到符合你预算和其他要求的，能刷机的路由器。
传统家用无线路由器由于主频低，内存小，并不适合作为软路由；而 NAS-软路由一体式 又有 all in boom 的风险，因此推荐X86平台作为物理机。当然，也可以采用 armbian 平台或是开发板，例如网心云老母鸡、树莓派等设备。截至本文撰写时间，二手平台上的价格不太利好：一台J1900平台的售价往往在200左右，而专门的多网口工控机价格在200到1000不等，树莓派更是成为了理财产品，需要慎重选择。


## **选择合适的系统**
除了openwrt主线外，还可以选择：

- [LEDE](https://github.com/coolsnowwolf/lede) 高质量，更新快速，具有新特性的openwrt分支。

- [iStoreOS](https://github.com/istoreos) iStoreOS是openwrt的一个分支，iStoreOS 提供了软件中心：iStore，以及较美观的界面和docker支持，对新手体验较好。

- [ImmortalWrt](https://firmware-selector.immortalwrt.org/) 是一个原版openwrt的分支，中文优化好，更新也勤快，内置镜像源可以直连下载&更新。

## **如何得到一个openwrt系统**

1. 使用编译好的现成的镜像:

- 恩山论坛上的"高大全","精品小包"等等，但存在一定风险；
- 使用[官方固件](https://downloads.openwrt.org)下载得到一个最小化的系统，再一步步添加自己要用的包；注意需要根据你的uboot来选择，注意固件名称是否带了uboot_mod!

2. 自行编译:

- [Openwrt.ai](https://openwrt.ai/?target=x86%2F64&id=generic)在线编译
一个固件；
- 可以使用GitHub action 云编译一个固件；
- 可以在本地linux环境中进行编译。

3. ImageBuilder

- 使用[Openwrt 官方ImageBuilder编译](https://firmware-selector.openwrt.org/)
- 自行下载对应的ImageBuilder包并构建.

## Toolchain/SDK/ImageBuilder

| 特性       | **Toolchain**                          | **SDK**                                        | **Image Builder**                                                              |
| -------- | -------------------------------------- | ---------------------------------------------- | ------------------------------------------------------------------------------ |
| 包含内容     | 仅交叉编译工具链（二进制版 GCC、ld、musl、binutils）    | 完整交叉编译环境 + feeds 脚本 + package 目录，用于 `.ipk` 包开发 | 预编译的根文件系统 + opkg 包（无需源码编译），用于快速定制固件映像 |
| 典型用途     | 用于编译第三方程序或 CI，如 hello-world 示例         | 编写和编译 `.ipk` 包，本地或自动化环境中离线开发                   | 快速生成可刷写的固件镜像，集成所需包且无需完整源码树                                                     |
| 解压即用     | ✅                                      | ✅                                              | ✅                                                                              |
| 在源码树中的作用 | `make toolchain/install` 自动识别并使用跳过编译流程 | 源码树中不会触发 SDK 安装，需要手动解压并进入其目录使用                 | 不使用源码树，直接在 Image Builder 根目录下运行 `make image` 等命令                               |
| 大小       | 较小（几十 MB）                              | 较大（上百 MB）                                      | 中等（约数百 MB，因包含预编译包）                                                             |
| 构建时间     | 几秒到几分钟                                 | 几分钟到十几分钟（取决于 feeds 大小）                         | 极快，可在几十秒到几分钟内完成定制镜像                                                            |
| 兼容性      | 与对应 Release 完全匹配                       | 与对应 Release 完全匹配                               | 与对应 Release 完全匹配                                                               |
| 使用难度     | 简单，只需解压并设置 PATH                        | 适中，需要理解 feeds 机制及包管理                           | 最简单，适合终端用户或快速测试环境

## **X86平台安装流程：**

0. 安装准备：

- 一个U盘与一台双网口物理机

- openwrt 的编译包，官方网站：[OpenWrt Firmware Selector](https://firmware-selector.openwrt.org/?version=24.10.0-rc2&target=ipq40xx%2Fgeneric&id=glinet_gl-a1300)

- 或者用由 eSir 大佬编译的[懒人包](https://drive.google.com/drive/folders/1uRXg_krKHPrQneI3F2GNcSVRoCgkqESr)


- PE 启动盘，这里推荐[HotPE](https://github.com/VirtualHotBar/HotPEToolBox)

- [img 写盘工具](https://www.roadkil.net/program.php?ProgramID=12#google_vignette)

1. 进入PE环境：

- 打开微PE，将其安装进U盘中，安装完成后将 img 工具和 openwrt 包一起放进去；
- 将U盘插入目标主机，进入 BIOS-boot 设置U盘优先启动，各主板进入 BIOS 的按键不同，不确定的话建议都试一遍。

2. 格式化硬盘并写盘

- 进入PE环境中，可以看到存在名为“分区助手”的软件，打开它并将目标主机硬盘格式化；注意不要分区！不要分区！不要设置文件系统！否则后续可能无法编译！点击左上角提交并执行
- 打开img写盘工具，将openwrt包写入硬盘，注意不要写进U盘里。

3. 进入配置界面

- 重启系统并快速拔出U盘，避免重新进入PE；这时系统开始运行了。注意Esir固件是不跑码的，无需担心。- 一个U盘与一台双网口物理机
- 当看到 `please press Enter to activate this console`这个提示的时候系统就安装完毕了。可使用 passwd 命令设置密码。软路由将自动获取IP地址，随后我们在浏览器中打开该地址，即可看到 Lucl 界面。

4. 如果你使用官方固件，注意:
- 硬盘空间有一部分没有被格式化，可以手动格式化为ext4并挂载。
- 注意初始IP往往是192.168.1.1，如果和光猫冲突需要在网络-接口中更改。
- 基本系统主题比较简陋，可以使用luci-theme-argon。
- 刷错主题无法打开luci：通过 SSH 登录路由器，切换到另一个已知正常的主题（例如 Bootstrap）： 
``uci set luci.main.mediaurlbase='/luci-static/bootstrap'
uci commit luci
/etc/init.d/uhttpd restart``
然后重新访问 Web 界面，查看是否恢复正常。


## **X86平台本地编译完整openwrt**

- **系统版本：Debian 11 或者 Ubuntu LTS**

- **网络要求：科学上网环境，配置推荐 2H4G 以上**

- **编译依赖**

```bash
sudo apt update
sudo apt install -y \
  ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
  bzip2 ccache clang cmake cpio curl device-tree-compiler diffutils diffstat findutils flex gawk \
  gcc-multilib g++-multilib git gettext gperf grep haveged help2man intltool \
  libelf-dev libfuse-dev libgmp3-dev libgl1-mesa-dev libgraphene-1.0-dev libglib2.0-dev \
  libltdl-dev libmpc-dev libmpfr-dev libncurses-dev libpython3-dev libreadline-dev libssl-dev \
  libtool lrzsz make mesa-common-dev msmtp ninja-build p7zip p7zip-full patch pkgconf \
  perl python-is-python3 python3 python3-dev python3-distutils-extra python3-pip python3-pyelftools \
  python3-setuptools qemu-utils rsync scons squashfs-tools subversion swig texinfo uglifyjs \
  upx-ucl unzip vim wget gnu-which xmlto xxd zlib1g-dev genisoimage llvm llvm-runtime docutils-common \
  ecj fastjar java-wrappers libeclipse-jdt-core-java libgnutls-dane0t64 \
  libgnutls-openssl27t64 libgnutls28-dev libidn2-dev libp11-kit-dev libtasn1-6-dev libtasn1-doc \
  libunbound8 libyaml-dev lld lld-18 nettle-dev python3-docutils python3-ply python3-roman re2c
```

- **清理**
```bash
sudo apt autoremove --purge
sudo apt clean
```


- **新建一个用户，用于编译固件(可选)**
```bash
useradd -m openwrt  # 新建一个名为 openwrt 的用户
```
> 不可以使用Root用户进行编译!!!

- **修改用户默认的 Shell**
```bash
apt install -y sudo
usermod -s /bin/bash openwrt
```
 
- **切换用户**
```bash
su openwrt
cd ~
```

- **拉取源码，这里用的是 ImmortalWrt 24.10 分支源码：**
```bash
git clone https://github.com/immortalwrt/immortalwrt.git
cd immortalwrt
```

- **选择分支**

如果你想要编译稳定版(stable),使用
```bash
git checkout xxx #例如git checkout v24.10.2
```
如果你想要编译最新版(snapshot),使用
```bash
git switch xxx #例如git switch openwrt-24.10
```

### 目录说明

| 名称                   | 作用                                                                     |
| -------------------- | ---------------------------------------------------------------------- |
| `Makefile`           | **整个 OpenWrt 构建系统的总入口点**（顶层 Makefile），运行 `make menuconfig`、`make` 都依赖它 |
| `Config.in`          | Kconfig 系统的入口配置文件，决定 `make menuconfig` 菜单显示什么选项                        |
| `config/`            | 构建系统的默认配置模板、菜单逻辑，和 `menuconfig` 相关                                     |
| `include/`           | 包含通用 makefile 片段的目录（比如编译选项、函数定义）                                       |
| `rules.mk`           | 所有包编译通用规则都写在这里，`include $(TOPDIR)/rules.mk` 是常见语句                      |
| `feeds.conf.default` | 定义 Feed 源（即可选的软件源），可用于管理外部包，比如 `luci`、`packages`                       |
| `feeds/` *(克隆后还没出现)* | `./scripts/feeds update -a` 后才会出现，用来保存外部 feed 的代码                      |
| `package/`           | OpenWrt 自带的核心包和第三方包（除 feeds 外的）都在这，结构是 `package/<分类>/<包名>`             |
| `target/`            | 支持的平台架构，比如 `x86`、`ramips`、`ath79`、`mediatek` 等都在里面                     |
| `toolchain/`         | 编译器链、glibc/musl、binutils、gcc 都在这里构建                                    |
| `tools/`             | 构建工具目录，编译前工具如 `m4`、`autoconf`、`xz`、`patch` 等放在这                        |
| `scripts/`           | 脚本工具目录，如 `feeds` 管理、镜像合并、menuconfig 支持等                                |
| `LICENSES/`          | 所有包/组件的许可证归档                                                           |
| `COPYING`            | OpenWrt 的主许可证（GPLv2）                                                   |
| `README.md`          | 简要介绍如何开始使用 OpenWrt 的说明文档                                               |
| `BSDmakefile`        | 为 BSD 系统一些兼容 makefile，Linux 用户用不到                                      |


- **添加软件源,可自行添加软件源至 feeds.conf.default 文件**
```bash
vim feeds.conf.default
```

**常用源**
```bash
src-git kenzo https://github.com/kenzok8/openwrt-packages
src-git small https://github.com/kenzok8/small
src-git haibo https://github.com/haiibo/openwrt-packages
src-git liuran001 https://github.com/liuran001/openwrt-packages
```
**常用仓库**
```bash
src/gz kwrt_core https://dl.openwrt.ai/releases/24.10/targets/x86/64/6.6.83
src/gz kwrt_base https://dl.openwrt.ai/releases/24.10/packages/x86_64/base
src/gz kwrt_packages https://dl.openwrt.ai/releases/24.10/packages/x86_64/packages
src/gz kwrt_luci https://dl.openwrt.ai/releases/24.10/packages/x86_64/luci
src/gz kwrt_routing https://dl.openwrt.ai/releases/24.10/packages/x86_64/routing
src/gz kwrt_kiddin9 https://dl.openwrt.ai/releases/24.10/packages/x86_64/kiddin9
```

- **单独添加**（在更新并安装插件之前执行）例如：

```bash
git clone https://github.com/chenmozhijin/turboacc.git
```

- **更新并安装插件**
```bash
./scripts/feeds clean
./scripts/feeds update -a
./scripts/feeds install -a
```

| `./scripts/feeds update -a`  | 同步／更新 **外部 feed**（packages、luci、routing 等）的 Git 仓库到本地 `feeds/` 目录 |
| ---------------------------- | ----------------------------------------------------------------- |
| `./scripts/feeds install -a` | 把你在 feeds 里选要用的包 **链接** 到源码树的 `package/feeds/`，让它们参与编译            |

- **自定义配置**

```bash
#!/usr/bin/env bash
# diy-part2.sh — 在镜像生成时注入默认设置和定制 SSH 横幅及模型修复

# 1. 默认 hostname（可选）
sed -i 's/=ImmortalWrt/=my-device/' package/base-files/files/bin/config_generate

# 2. 默认 IP 地址（可选）
sed -i 's/192.168.1.1/192.168.5.1/' package/base-files/files/bin/config_generate

# 3. 默认 root 密码（请换成安全密码）
HASH=$(openssl passwd -1 'yourpassword')
sed -i "s|root::0:0:99999|root:${HASH}:0:0:99999|" package/base-files/files/etc/shadow

# 4. 设置默认 LuCI 主题为 argon（内置在 luci feeds）
cat >>package/base-files/files/etc/uci-defaults/99_set_theme <<'EOF'
uci set luci.main.mediaurlbase=/luci-static/argon
uci commit luci
EOF
chmod +x package/base-files/files/etc/uci-defaults/99_set_theme

# 5. 默认加载 BBR 拥塞控制算法
mkdir -p package/base-files/files/etc/sysctl.d
cat >>package/base-files/files/etc/sysctl.d/99-bbr.conf <<'EOF'
net.core.default_qdisc=fq_codel
net.ipv4.tcp_congestion_control=bbr
EOF

# 检查BBR: sysctl net.ipv4.tcp_congestion_control

# 6. 将默认 shell 修改为 bash
sed -i "s|/bin/ash|/bin/bash|g" package/base-files/files/etc/passwd
# 请在 .config 中添加 TARGET_PACKAGES += bash

# 7. 自定义 SSH 登录横幅（banner）
mkdir -p package/base-files/files/etc
if [ -f "scripts/custom-files/banner.txt" ]; then
  cp scripts/custom-files/banner.txt package/base-files/files/etc/banner
else
  cat >package/base-files/files/etc/banner <<'EOF'
Welcome to MyDevice (ImmortalWrt)\n
EOF
fi

# 8. 自定义 LuCI 概览设备型号 🛠
# 通过 uci-defaults 脚本写入 /tmp/sysinfo/model
cat >>package/base-files/files/etc/uci-defaults/99-model-fix <<'EOF'
#!/bin/sh
# 设置自定义设备型号
mkdir -p /tmp/sysinfo
echo "Your Router Model" > /tmp/sysinfo/model
exit 0
EOF
chmod +x package/base-files/files/etc/uci-defaults/99-model-fix
```

- 执行 **make menuconfig** 命令进入编译菜单。


| 命令                | 功能描述                                                 | 优点                   | 适用场景           |
| ----------------- | ---------------------------------------------------- | -------------------- | -------------- |
| `make menuconfig` | 以 ncurses 界面交互式地浏览、修改当前 `.config` 与最新 Kconfig 中的所有选项 | 界面友好，支持搜索和分类；可直观调整   | 想手动挑选/调整配置时    |
| `make oldconfig`  | 在命令行逐项对比 `.config` 与最新 Kconfig：保留原值、提示新增项、删除废弃项      | 快速同步，只对新增选项发出提示；无需界面 | 自动化脚本或快速同步配置时  |
| `make defconfig`  | 忽略当前 `.config`，直接加载架构/板级目录下的默认配置（`defconfig`）        | 一键生成官方/平台推荐的「干净」配置   | 想重置到官方默认或重新开始时 |


### **编译配置菜单说明（部分）**

```bash
Target System (x86)                                # 选择目标平台
└── Subtarget (x86_64)                             # 选择 64-bit 子架构
    └── Target Profile (Generic)                   # “Generic” 表示通用 x86_64 设备
        └── Target Images                          # 固件镜像设置
            ├── ramdisk                            # 可选内存盘镜像
            │   ├── Compression                    # 压缩类型（如 none 表示无压缩）
            │   ├── Root filesystem archives       # 压缩存档：cpio.gz 或 tar.gz
            │   └── Root filesystem images         # 文件系统镜像：ext4、squashfs、Gzip
            └── Image Options                      # 镜像选项
                ├── Kernel partition size           # 内核分配分区大小
                ├── Root filesystem partition size # 根文件系统分区大小
                └── Make /var persistent            # 是否保留 /var 持久化

Global build settings                             # 全局构建设置
Advanced configuration options (for developers)  # 开发者高级选项
Build the OpenWrt Image Builder                  # 编译镜像构建器
Build the OpenWrt SDK                            # 构建交叉编译 SDK
Package the OpenWrt‑based Toolchain              # 打包 OpenWrt 工具链
Image configuration                              # 镜像总体配置页面

Base system         # 系统基础组件
Administration      # 管理工具（如 ssh、管理员脚本）
Boot Loaders        # 引导程序（如 grub、syslinux）
Development         # 编译/调试辅助工具
Extra packages      # 附加应用（如 wget、curl）
Firmware            # 固件工具
Fonts               # 字体支持
Kernel modules      # x86 内核模块驱动
Languages           # 编程语言包（如 Python3、Node.js）
Libraries           # 系统库依赖
LuCI                # Web UI 前端
└── Collections
└── Modules
└── Applications
└── Themes
└── Protocols
└── Libraries
└── default‑settings

Mail                # 邮件客户端
Multimedia          # 媒体工具（如 ffmpeg）
Network             # 网络功能（如 openvpn、wireguard）
Sound               # 音频相关软件
Utilities           # 常用实用程序（如 vim、htop）
Xorg                # 桌面环境支持（X11 图形系统）

```

- **预下载编译所需的软件包**
```bash
make download -j8
```

- **检查文件完整性**
```bash
find dl -size -1024c -exec ls -l {} \;
```
检查文件完整性命令可以列出下载不完整的文件，小于1k的文件属于下载不完整，如果存在则用下面的命令删除，然后重新下载编译所需的软件包，再次检查.确认所有文件完整可大大提高编译成功率，避免浪费时间
```bash
find dl -size -1024c -exec rm -f {} \;
```

- **最后编译固件（-j 后面是线程数，首次编译推荐用单线程）编译完成后输出路径是bin/targets.**
```bash
make V=s -j1

或者使用 make world -j1 V=s 2>&1 | tee world_debug.log

如果报错可查看 grep -E "(error|fatal|Cannot install package)" world_debug.log -n
```
| make层级   | 目录示例                         | 说明               |
| -------- | ---------------------------- | ---------------- |
| make\[1] | 顶层 Makefile                  | 解析依赖，调度模块        |
| make\[2] | `tools/`                     | 编译辅助工具           |
| make\[2] | `toolchain/`                 | 编译交叉编译工具链        |
| make\[2] | `target/linux/`              | 编译内核及设备树         |
| make\[2] | `package/`                   | 进入包管理，调度包构建      |
| make\[3] | `package/libs/libc`          | 单个包的 Makefile    |
| make\[3] | `package/utils/busybox`      | 单个包的 Makefile    |
| make\[4] | `build_dir/target-...`       | 包源码目录，运行源码的 make |
| make\[4] | `build_dir/target-linux-...` | 内核源码目录           |

## 二次编译

| 命令               | 清除内容                                                          | 保留内容                                    | 适用场景                                           |
| ---------------- | ------------------------------------------------------------- | --------------------------------------- | ---------------------------------------------- |
| `make clean`     | 删除 `bin/` 镜像、`build_dir/` 编译产物                                | `.config`、`staging_dir/`、`toolchain/` 等 | 小修改后重建镜像，速度快，常用于增量编译。|
| `make dirclean`  | 和 `make clean` 一样，还删除 `staging_dir/`、`toolchain/`、`logs`      | `.config`                               | 彻底重建交叉编译环境，适合更改编译配置如 `.config`、feeds 等。        |
| `make distclean` | 删除 `make dirclean` 的所有内容 + feeds 下载文件 + `.config`、patch 等所有状态 | 只有源码目录保持不变                              | 专用于回到一个“零配置、重做一切”的状态，完全从头开始构建。                 |

恢复所有修改（包括未跟踪文件）:
```bash
git clean -fd
git restore --source=v24.10.2 --staged --worktree .
```

## Dwrt 方案

| 作用          | 组件                   |
| ----------- | -------------------- |
| 主题        | argon                |
| Shell    | bash                 |
| SSH 服务器     | dropbear             |
| Web 服务器    | uhttpd               |
| DNS/DHCP 服务 | dnsmasq‑full         |
| 加密库         | openssl              |
| 压缩算法        | zram+zstd                 |
| 拥塞控制        | bbr                  |
| 防火墙         | nftables + iptables  |
| 调度模块    | BPF + kmod-sched-xxx |
| 时间同步        | ntpd-full            |
| 文本编辑        | vim-full vim-runtime |
| 编译优化        | LTO + O3             |

要启用的软件包：

**base**
```bash
autocore base-files bash block-mount ca-bundle coremark curl dnsmasq-full dropbear ds-lite e2fsprogs fdisk firewall4 fstools grub2-bios-setup htop kmod-8139cp kmod-8139too kmod-amazon-ena kmod-amd-xgbe kmod-atlantic kmod-bnx2 kmod-bnx2x kmod-button-hotplug kmod-drm-amdgpu kmod-drm-i915 kmod-dwmac-intel kmod-e1000 kmod-e1000e kmod-forcedeth kmod-fs-f2fs kmod-fs-vfat kmod-i40e kmod-iavf kmod-igb kmod-igbvf kmod-igc kmod-ixgbe kmod-ixgbevf kmod-lib-zstd kmod-mlx4-core kmod-mlx5-core kmod-mmc kmod-pcnet32 kmod-phy-broadcom kmod-r8101 kmod-r8125 kmod-r8126 kmod-r8168 kmod-sdhci kmod-tcp-bbr kmod-tg3 kmod-tulip kmod-usb-hid kmod-vmxnet3 libc libgcc libustream-mbedtls lm-sensors-detect logd lsblk luci-app-fan luci-app-filemanager luci-app-firewall luci-app-log-viewer luci-app-package-manager luci-app-syscontrol luci-app-upnp  luci-base luci-compat luci-lib-fs luci-lib-ipkg  mkf2fs mtd nano netifd odhcp6c odhcpd-ipv6only openssh-sftp-server opkg partx-utils pciutils ppp ppp-mod-pppoe resolveip swconfig uci uclient-fetch urandom-seed urngd usbutils wget-ssl zram-swap
```
**cli**
```bash
btop iperf3 tcpdump
```
**luci**
```bash
luci-app-argon luci-app-upnp luci-app-ttyd luci-app-eqosplus luci-app-timecontrol luci-app-parentcontrol luci-app-homeproxy luci-app-daed
```
**lib**
```bash
kmod-ipt-conntrack kmod-ipt-nat kmod-nft-compat kmod-ipt-fullconenat kmod-ip6tables ca-certificates
```
## 使用SDK快速编译包

首先新建一个文件夹并将SDK克隆下来：

```bash
mkdir imwrt-sdk
cd ./imwrt-sdk
wget https://downloads.immortalwrt.org/snapshots/targets/mediatek/filogic/immortalwrt-sdk-mediatek-filogic_gcc-14.3.0_musl.Linux-x86_64.tar.zst
```

新版本的SDK使用ZSTD压缩，因此解压的命令为

```bash
tar -I zstd -xvf ./immortalwrt-sdk-mediatek-filogic_gcc-14.3.0_musl.Linux-x86_64.tar.zst
```

随后进入该目录并和一般流程一样更新Feeds：

```bash
cd ./immortalwrt-sdk-mediatek-filogic_gcc-14.3.0_musl.Linux-x86_64/
./scripts/feeds update -a
./scripts/feeds install -a
```

更新完成后克隆你要编译的包的源码到package下：

```bash
cd ./package/
git clone https://github.com/Dichgrem/luci-app-nyn.git
cp ./luci-app-nyn/luci-app-zzz ./
cp ./luci-app-nyn/zzz ./
rm -rf ./luci-app-nyn
cd ../
```

随后开始编译，编译结果在对应架构的base目录下：

```bash
make package/luci-app-zzz/compile V=s

~/imwrt-sdk/immortalwrt-sdk-24.10.3-x86-64_gcc-13.3.0_musl.Linux-x86_64 dich@uos
❯ find ./ -name "zzz*.ipk"
./bin/packages/x86_64/base/zzz_0.1.1-r1_x86_64.ipk
```

## 常用命令:
```bash
# 更新软件列表
opkg update

# 更新所有 LUCI 插件
opkg list-upgradable | grep luci- | cut -f 1 -d ' ' | xargs opkg upgrade

# 如果要更新所有软件，包括 OpenWRT 内核、固件等
opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade

# 固件版本号
vim /etc/os-release

# 脚本&脚注
vim /etc/openwrt_release

# ASCII字符画
vim /etc/banner

# 登录脚本显示
vim /etc/profile
```

## 常用科学插件

| 特性         | HomeProxy | OpenClash  | Passwall  | ShellClash  |
|-------------|----------|------------|------------|-------------|
| **核心** | Sing-box、Xray | Clash | Xray、Sing-box | Clash、Xray、Sing-box |
| **UI 管理** | ✅（Web UI、桌面端 GUI） | ✅（OpenClash Web UI） | ✅（Luci Web UI） | ❌（Shell 终端管理） |
| **适用场景** | 性能较好,但分流设置复杂 | 适用于clash系,机场首选 | 操作简单,分流完善,但对路由器性能要求较高 | 没有UI界面，性能最好，支持完善，可以通过clashapi安装UI |


## 校园网多设备防检测

**常见检测方法**：
- TTL检测法 解法：插件统一修复或使用桥接；使用kmod-iptables-ipot模块；
- User-Agent 解法：统一经过singbox代理或使用UA2F/UA3F；
- 时间戳检测法 解法：统一NTP服务器；

**高性能开销检测方法**：
- IP-ID检测法 解法：UDP over TCP或rkp-IPid；
- Flash cookie 解法：内置防火墙组件；
- DPI检测法 深度包检测特征值 解法：代理协议；

> 高性能开销的检测方法会浪费大量性能，一般很少有学校这么做。IP-ID和Flash检测法如今已经不多见。

**TTL修复**:
```
依赖包
opkg install kmod-nft-core kmod-nft-bridge kmod-nft-net kmod-nft-offload kmod-nft-nat

首先检查 mangle 表是否存在
nft list tables

创建 mangle 表（如果不存在）
nft add table ip mangle

创建 POSTROUTING 链（如果不存在）
nft add chain ip mangle POSTROUTING { type nat hook postrouting priority 0 \; }


添加 TTL 规则
nft add rule ip mangle POSTROUTING ip ttl set 64

检查规则是否生效
nft list table ip mangle
```
## Openwrt改AP模式

有时候我们使用X86做主路由，想让无线路由器只起到发射信号的作用，就可以将其改为AP模式，一般步骤为：

- 更改lan地址，将lan口地址改到主路由下的一个IP;
- 关闭DHCP服务；
- 关闭WAN口；
- 关闭防火墙的禁止转发规则，全部允许；
- 将X86主路由的网线插到AP的任意一个LAN口。

## 🔗

- [Openwrt wiki](https://openwrt.org/zh/docs/start)
- [OpenWrt在线定制编译](https://openwrt.ai/?target=ipq807x%2Fgeneric&id=xiaomi_ax3600)
- [openwrt luci 页面无法访问 问题排查](https://www.cnblogs.com/tfel-ypoc/p/17226064.html)
- [超详细，多图，简单，OpenWRT 设置，IPV6配置](https://post.smzdm.com/p/axz6369w/)
- [保姆级-光猫改桥接-路由拨号-openwrt端口转发](https://blog.csdn.net/weixin_44548582/article/details/121064734)
