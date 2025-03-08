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

> 剩余专业路由功能可以由ROS替代，服务则跑在NAS系统上，避免ALL in Boom！


## **选择合适的设备**

无论是传统的无线路由器还是小主机都有成为openwrt路由的潜力。截止到今天，已经有20多个品牌（小米，华硕，锐捷，华三等）30多种架构（x86,ipq,bcm,mtd等）支持刷入openwrt；你可以在这个[网站](https://mao.fan/select)找到符合你预算和其他要求的，能刷机的路由器。
传统家用无线路由器由于主频低，内存小，并不适合作为软路由；而 NAS-软路由一体式 又有 all in boom 的风险，因此推荐X86平台作为物理机。当然，也可以采用 armbian 平台或是开发板，例如网心云老母鸡、树莓派等设备。截至本文撰写时间，二手平台上的价格不太利好：一台J1900平台的售价往往在200左右，而专门的多网口工控机价格在200到1000不等，树莓派更是成为了理财产品，需要慎重选择。


## **选择合适的系统**
除了openwrt主线外，还可以选择：

- [LEDE](https://github.com/coolsnowwolf/lede) 高质量，更新快速，具有新特性的openwrt分支。

- [iStoreOS](https://github.com/istoreos) iStoreOS是openwrt的一个分支，iStoreOS 提供了软件中心：iStore，以及较美观的界面和docker支持，对新手体验较好。

- [ImmortalWrt](https://firmware-selector.immortalwrt.org/) 是一个原版openwrt的分支，中文优化好，更新也勤快，内置镜像源可以直连下载&更新。

## **如何得到一个openwrt系统**

- 可以在恩山论坛上使用他人编译好的现成的镜像，如"高大全","精品小包"等等，但存在一定风险；
- 可以使用[官方固件](https://downloads.openwrt.org/)下载得到一个最小化的系统，再一步步添加自己要用的包；注意需要根据你的uboot来选择，注意固件名称是否带了uboot_mod!
- 可以使用[Openwrt 在线编译](https://firmware-selector.openwrt.org/)或[Openwrt.ai](https://openwrt.ai/?target=x86%2F64&id=generic)在线编译
一个固件；
- 可以使用GitHub action 云编译一个固件；
- 可以在本地linux环境中进行编译。

## **X86平台安装准备：**

- 一个U盘与一台双网口物理机

- openwrt 的编译包，官方网站：[OpenWrt Firmware Selector](https://firmware-selector.openwrt.org/?version=24.10.0-rc2&target=ipq40xx%2Fgeneric&id=glinet_gl-a1300)

- 或者用由 eSir 大佬编译的[懒人包](https://drive.google.com/drive/folders/1uRXg_krKHPrQneI3F2GNcSVRoCgkqESr)


- PE 启动盘，这里推荐[HotPE](https://github.com/VirtualHotBar/HotPEToolBox)

- [img 写盘工具](https://www.roadkil.net/program.php?ProgramID=12#google_vignette)



## **X86平台安装流程：**

1.进入PE环境：

- 打开微PE，将其安装进U盘中，安装完成后将 img 工具和 openwrt 包一起放进去；
- 将U盘插入目标主机，进入 BIOS-boot 设置U盘优先启动，各主板进入 BIOS 的按键不同，不确定的话建议都试一遍。

2.格式化硬盘并写盘

- 进入PE环境中，可以看到存在名为“分区助手”的软件，打开它并将目标主机硬盘格式化；注意不要分区！不要分区！不要设置文件系统！否则后续可能无法编译！点击左上角提交并执行
- 打开img写盘工具，将openwrt包写入硬盘，注意不要写进U盘里。

3.进入配置界面

- 重启系统并快速拔出U盘，避免重新进入PE；这时系统开始运行了。注意Esir固件是不跑码的，无需担心。- 一个U盘与一台双网口物理机
- 当看到 `please press Enter to activate this console`这个提示的时候系统就安装完毕了。可使用 passwd 命令设置密码。软路由将自动获取IP地址，随后我们在浏览器中打开该地址，即可看到 Lucl 界面。
> 硬盘空间有一部分没有被格式化，可以手动格式化为ext4并挂载。

> 注意初始IP往往是192.168.1.1，如果和光猫冲突需要在网络-接口中更改。

> 基本系统主题比较简陋，可以使用luci-theme-argon。

> 刷错主题无法打开luci：通过 SSH 登录路由器，切换到另一个已知正常的主题（例如 Bootstrap）： 
``uci set luci.main.mediaurlbase='/luci-static/bootstrap'
uci commit luci
/etc/init.d/uhttpd restart``
然后重新访问 Web 界面，查看是否恢复正常。

## **X86平台本地编译完整openwrt**

- **系统版本：Debian 11 或者 Ubuntu LTS**

- **网络要求：科学上网环境，配置推荐 2H4G 以上**

- **编译依赖**

```
安装依赖

sudo apt update -y

sudo apt full-upgrade -y

sudo apt install -y ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
bzip2 ccache clang cmake cpio curl device-tree-compiler flex gawk gcc-multilib g++-multilib gettext \
genisoimage git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libfuse-dev libglib2.0-dev \
libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libpython3-dev \
libreadline-dev libssl-dev libtool llvm lrzsz msmtp ninja-build p7zip p7zip-full patch pkgconf \
python3 python3-pyelftools python3-setuptools qemu-utils rsync scons squashfs-tools subversion \
swig texinfo uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev

```

- **清理**
```
sudo apt autoremove --purge
sudo apt clean
```


- **新建一个用户，用于编译固件(可选)**
```
useradd -m openwrt  # 新建一个名为 openwrt 的用户
```
> 不可以使用Root用户进行编译！!!

- **修改用户默认的 Shell**
```
apt install -y sudo

usermod -s /bin/bash openwrt
```
 
- **切换用户**
```
su openwrt

cd ~
```

- **拉取源码，这里用的是 LEDE 分支源码：**
```
git clone https://github.com/coolsnowwolf/lede

cd lede
```

### 目录说明

- buildroot: OpenWrt 的核心目录，包含构建系统相关的文件。 
  - `feeds.conf.default`：定义软件包源的配置文件。
  - `files/`：存放自定义文件，用于覆盖默认的 root 文件系统。

- target: 包含目标设备架构的配置和构建信息。
  - `linux/`：包含与 Linux 内核相关的代码和配置。
  - `generic/`：通用配置文件。
  - `platform/`：针对具体设备平台的特定配置。

- package: 包含所有 OpenWrt 的软件包。
  - `base/`：基本功能相关的软件包（如 BusyBox、opkg）。
  - `kernel/`：与内核相关的补丁或模块。
  - `network/`：网络工具和协议（如 DHCP、DNS）。
  - `utils/`：各种实用工具（如编解码器、文件工具）。

- config: 存放默认配置文件，例如 `Config.in`，用于定义菜单项。
- scripts: 构建过程中使用的辅助脚本（如生成补丁、编译镜像）。
- toolchain: 构建工具链所需的文件，如编译器、链接器。
- tools: 一些构建系统依赖的额外工具（如 `autoconf`、`zlib`）。
- include: 存放 Makefile 的通用模板和其他全局定义文件。
- feeds: 包含通过 `feeds.conf` 配置的外部软件包源。
- documentation: 包含与 OpenWrt 项目相关的文档，如构建指南和开发文档。


- **添加软件源,可自行添加软件源至 feeds.conf.default 文件，也可以直接git添加需要的软件到lede目录下：**
```
vim feeds.conf.default
```
```
常用源
src-git kenzo https://github.com/kenzok8/openwrt-packages
src-git small https://github.com/kenzok8/small
src-git haibo https://github.com/haiibo/openwrt-packages
src-git liuran001 https://github.com/liuran001/openwrt-packages
```
 

- **单独添加**（在更新并安装插件之前执行）例如：

```
git clone https://github.com/chenmozhijin/turboacc.git
```

- **更新并安装插件**
```
./scripts/feeds clean

./scripts/feeds update -a

./scripts/feeds install -a
```
- **自定义配置**

**修改默认IP为 10.0.0.2**
```
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
```
 

**修改默认主机名**
```
sed -i '/uci commit system/i\uci set system.@system[0].hostname='OpenWrt'' package/lean/default-settings/files/zzz-default-settings
```

**加入编译者信息**
```
sed -i "s/OpenWrt /smith build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings
```
 

**修改默认主题**
```
sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" feeds/luci/collections/luci/Makefile
```

执行 **make menuconfig** 命令进入编译菜单。

**编译配置菜单说明（部分）**

    Target System (Broadcom BCM27xx) #选择处理器架构
    Subtarget (BCM2711 boards (64 bit)) #选择处理器
    Target Profile (Raspberry Pi 4B/400/4CM (64bit)) #预制配置文件
    Target Images #固件映像设置
    ramdisk # 内存盘, 硬件内存充裕的话可以打开，有效提升性能
        Compression # 压缩等级(none表示不压缩)
        Root filesystem archives #根文件系统存档类型
            cpio.gz
            tar.gz
        Root filesystem images #根文件系统格式
            ext4 #适用于大容量闪存,易于修改分区大小,没有恢复出厂设置的功能
            squashfs #适用于小容量闪存，不可修改分区大小，有恢复出厂设置的功能
            Gzip images #Gzip存档
        Image Options
            Kernel partition size #内核分区大小，建议64M到256M，足够了
            Root filesystem partition size #跟文件系统分区大小，根据闪存大小自行设定
            Make /var persistent #持久化/var(开启后重启软路由/var下内容会保留)
    Enable experimental features by default #默认启用实验性功能
    Global build settings #全局编译设置
    Advanced configuration options (for developers) #高级选项(仅供开发者)
    Build the OpenWrt Image Builder #编译OpenWrt镜像编译器
    Build the OpenWrt SDK #编译OpenWrt SDK
    Package the OpenWrt-based Toolchain #打包OpenWrt工具链
    Image configuration #镜像选项
    Base system #基本组件
    Administration #管理员工具
    Boot Loaders #引导程序
    Development #开发者工具
    Extra packages #额外包
    Firmware #固件工具
    Fonts #字体
    Kernel modules #内核模块
    Languages #额外的语言(Python3,PHP,NodeJS等)
    Libraries #系统库
    LuCI #LuCI插件(一般只需修改应用和主题)
        Collections #合集
        Modules #模块
        Applications #应用程序
        Themes #主题
        Protocols #协议支持
        Libraries #运行库
        default-settings # 默认选项(自动配置语言包)
    Mail #邮件
    Multimedia #多媒体
    Network #网络相关
    Sound #音频
    Utilities #各类实用软件(比如VIM)
    Xorg


- **菜单选项说明**

**选择 CPU 类型**
```
Target System (x86) --> # 软路由选择 x86，硬路由根据型号厂家自行选择

Subtarget (x86_64) --> # CPU 子选项

Target Profile (Generic x86/64) --> # 厂家具体型号
```
**设置镜像编译的格式（squashfs，ext4）**
```
Target Images --> # 默认 squashfs
```
**添加较多插件时，为了避免空间不足，建议修改下面两项默认大小（x86/64）**
```
Target Images --> (16) Kernel partition size (in MB) # 默认是16，建议修改为256
```

**开启 IPv6 支持**
```
Extra packages --> ipv6helper（选定这个后，下面几项会自动选择）
```
**开启适用于 VMware 的 VMware Tools**
```
Utilities --> open-vm-tools

Utilities --> open-vm-tools-fuse
```
**选择插件**
```
LuCI --> Applications # 根据需要选择，* 代表编入固件，M 表示编译成模块或者IPK包，为空表示不编译
```
**选择主题**
```
LuCI --> Themes # 选择喜欢的主题，可以选多个
```
配置完成后使用编译菜单底部的 Save 保存，然后退出菜单 Exit，开始下载软件包

- **预下载编译所需的软件包**
```
make download -j8
```

- **检查文件完整性**
```
find dl -size -1024c -exec ls -l {} \;
```
检查文件完整性命令可以列出下载不完整的文件，小于1k的文件属于下载不完整，如果存在则用下面的命令删除，然后重新下载编译所需的软件包，再次检查.确认所有文件完整可大大提高编译成功率，避免浪费时间
```
find dl -size -1024c -exec rm -f {} \;
```
最后编译固件，编译完成后输出路径是 **bin/targets**，默认密码是 **password**.

- **编译固件（-j 后面是线程数，首次编译推荐用单线程）**
```
make V=s -j1
```
- **二次编译**

拉取最新 OpenWrt 源码和更新 feeds 源中的软件包源码
```
cd lede

git pull

./scripts/feeds update -a

./scripts/feeds install -a
```
清除旧的编译产物和目录（可选）
```
make clean
```
- 源码有大规模更新或者内核更新后执行，以保证编译质量;此操作会删除 /bin 和 /build_dir 目录中的文件

 
```
make dirclean
```
> 更换架构编译前必须执行

> 此操作会删除 /bin 和 /build_dir 目录的中的文件（make clean），以及 /staging_dir、/toolchain、/tmp 和 /logs 中的文件

同首次编译，多线程编译失败后自动进入单线程编译，失败则输出详细日志
```
make defconfig

make download -j8

find dl -size -1024c -exec ls -l {} \;

make -j$(nproc) || make -j1 || make -j1 V=s
```
 

## 如果需要重新配置
```
rm -rf ./tmp && rm -rf .config # 清除临时文件和编译配置文件

make menuconfig

make download -j8

find dl -size -1024c -exec ls -l {} \;

make -j$(nproc) || make -j1 || make -j1 V=s
```



## Arm平台安装OpenWrt：

相比X86平台，arm架构的设备兼容性不高，不能随便找一个包就能安装。以下是一般步骤：

- 首先得知道你的设备的CPU，比如ipq40XX系列，然后在对应的[仓库](https://archive.openwrt.org/releases/23.05.4/targets/)查看并下载包体。

- 当然也可以在[这里](https://firmware-selector.openwrt.org/)直接下载相关型号对应的固件，其中 Sysupgrade 映像是用来更新现有运行 OpenWrt 的设备，使用 Factory 映像在首次刷机时刷入。

- 随后开启Telnet或者SSH或者TTL串口连接到路由器，将对应的Uboot刷入，如果没有适配的包就无法刷openwrt。

- 通过Uboot的网络界面刷入Factory包，随后就可以在后台（如192.168.1.1）进入openwrt的管理界面。



## 在ubuntu上单独编译openwrt的ipk包

这里以ubuntu环境为例，我们假设你有一台虚拟机或者WSL。

> ``注意编译不能使用Root用户！``

**随后安装编译依赖的各个包：**

```
sudo apt install python3-distutils-extra git gawk libncurses-dev build-essential binutils bzip2 diff find flex gawk gcc-6+ getopt grep install libc-dev libz-dev make4.1+ perl python3.7+ rsync subversion unzip which

sudo apt install -y build-essential python3-dev python3-setuptools swig \
    libmesa-dev libwayland-dev libgraphene-dev \
    gawk wget git-core diffstat unzip texinfo gcc-multilib \
    libncurses5-dev libncursesw5-dev zlib1g-dev \
    libssl-dev flex bison gperf libxml-parser-perl \
    python-is-python3 python3-pip gettext

sudo apt install -y swig
sudo apt install -y mesa-common-dev libwayland-dev libgraphene-1.0-dev
```
随后下载我们**刷入openwrt的对应的SDK包**，如

```
git clone https://github.com/immortalwrt/immortalwrt.git
```

**下载和安装仓库信息**
```
./scripts/feeds update -a
./scripts/feeds install -a
```
**下载并选中我们需要编译的包,这里以inyn为例：**
```
git clone https://github.com/diredocks/openwrt-inyn.git ./package/inyn
make menuconfig
```

在 `menuconfig` 的命令行界面中，选中 `Network -> inyn` 将其首部调整为 `<M>` 表示按需编译，最后选中 `Save -> OK -> Exit` 保存配置信息，然后 `Exit` 退出配置。

**编译 inyn 软件包**
```
make package/inyn/compile V=s
## 如果不行则需要先编译工具链，即为 make j=4 ，j为CPU核数
```

## Github Actions 编译OpenWrt

Github为我们提供了免费的E5主机用来编译。

- 首先Fork[这个仓库](https://github.com/hugcabbage/shared-lede)，可以看到有许多现成的配置，在**顶栏actions里面可以直接启动一个Workflow**来编译。

- 大体架构是选择**源码 -- 机型 -- 版本 -- 插件/主题 -- 配置（IP/密码/Hostname/编译者）**，由一个config文件管理，这个文件在前面也提到过，可以在本地生成并上传；

- 想要什么插件可以直接git clone过来原仓库，如果你想要添加其他架构和设备，这里**使用templet里面的init.toml来创建**，按照类似的格式填好；

- 在actions里面运行produce，注意这需要**GitHub Personal Access Token (PAT)**；如果没有，必须先添加：

- 打开 GitHub，进入[GitHub Developer Settings](https://github.com/settings/tokens)点击 “Generate new token (classic)”，**勾选所需权限**（最关键的是 repo 和 workflow）：✅ repo（所有子权限）✅ workflow✅ read:packages **Token 过期时间**：选择 “No expiration”（不过期），否则过期后需要重新生成。**点击** “Generate token”
**复制 Token**（只显示一次，一定要保存好！）

- 然后添加 **PRODUCE_DEVICE** 到 **GitHub Secrets**，
首先进入你的 GitHub 仓库，依次进入：Settings（设置）-
Secrets and variables-Actions-New repository secret
名称为PRODUCE_DEVICE，值为粘贴刚刚复制的 GitHub Token，点击 “Add secret” 完成添加。

- 随后在actions里面运行produce，完成后即可出现新架构的编译按钮.



## 常用命令:
```
# 更新软件列表
opkg update

# 更新所有 LUCI 插件
opkg list-upgradable | grep luci- | cut -f 1 -d ' ' | xargs opkg upgrade

# 如果要更新所有软件，包括 OpenWRT 内核、固件等
opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade
```
> 新版本的openwrt（24.10）已经改用APK包管理器。


## 🔗

- [Openwrt wiki](https://openwrt.org/zh/docs/start)
- [OpenWrt在线定制编译](https://openwrt.ai/?target=ipq807x%2Fgeneric&id=xiaomi_ax3600)
- [openwrt luci 页面无法访问 问题排查](https://www.cnblogs.com/tfel-ypoc/p/17226064.html)
- [超详细，多图，简单，OpenWRT 设置，IPV6配置](https://post.smzdm.com/p/axz6369w/)
- [保姆级-光猫改桥接-路由拨号-openwrt端口转发](https://blog.csdn.net/weixin_44548582/article/details/121064734)
