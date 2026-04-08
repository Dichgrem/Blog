+++
title = "Linux-Android开发环境部署"
date = 2025-11-20

[taxonomies]
tags = ["Linux"]
+++

前言 本文记录Android命令行开发环境在Linux上的部署，用以替代Android-studio。

<!-- more -->

## Flutter 开发

以 Ubuntu 为例，环境变量由direnv来管理：

> Direnv 是一个 shell 扩展工具，用于根据当前目录自动加载/卸载环境变量，非常适合管理开发工具链路径。

- Direnv

首先安装 direnv 包,并让其加入当前shell的配置，这里使用zsh；

```bash
sudo apt install direnv
echo 'eval "$(direnv hook zsh)"' >> ~/.zshenv
source ~/.zshenv
```

如果是bash：

```bash
echo 'if [ -f ~/.bashrc ]; then source ~/.bashrc; fi' >> ~/.bash_profile
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
source ~/.bashrc
```

随后使用``touch ./.envrc``在项目下新建配置文件,写入：

```toml
# Java
export JAVA_HOME="/usr/lib/jvm/java-1.17.0-openjdk-amd64"

# Android SDK
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"

# PATH
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

# Flutter
export PATH="$HOME/flutter/bin:$PATH"
```

随后使用``direnv allow``即可每次进入该目录的时候自动激活环境变量.

- Android Sdk

随后安装安卓SDK工具链，首先从 Google 官网下载 commandlinetools:

```bash
mkdir -p ~/Android/Sdk
cd ~/Android/Sdk

wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip commandlinetools-linux-*.zip -d tmp
mkdir -p cmdline-tools/latest
mv tmp/cmdline-tools/* cmdline-tools/latest/
rm -rf tmp
```

随后使用其中的 sdkmanager 下载 platforms 和 build-tools ，注意版本为36.

```bash
sdkmanager \
  "cmdline-tools;latest" \
  "platform-tools" \
  "platforms;android-36" \
  "build-tools;36.0.0"

sdkmanager --licenses
```

- Flutter

现在下载 Flutter 工具链，使用 GitHub 下载并同意 license.

```bash
git clone https://github.com/flutter/flutter.git  ~/flutter

## 告诉 Flutter SDK Android SDK 安装位置
flutter config --android-sdk $HOME/Android/Sdk
## 检查开发环境是否完整，并提示缺失的依赖
flutter doctor
## 同意 Flutter 编译 APK 所需的 Android 协议
flutter doctor --android-licenses
## 提前下载 Android 构建依赖，加快后续构建速度
flutter precache --android
```

- Build apk

随后即可构建apk并进行安装测试：

```bash
just init
just build-apk
```

## 安卓原生开发

- 首先安装依赖包：

```bash
sudo apt install openjdk-17-jdk nodejs
```

- 安装Command-tools：

```bash
mkdir -p ~/Android/cmdline-tools/latest
## 下载链接：https://developer.android.com/studio?hl=zh-cn#command-tools
cd ~/Android/cmdline-tools/latest
wget https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip
unzip ./commandlinetools-linux-13114758_latest.zip
```

- 使用官方脚本安装Sdkman包管理器：

```bash
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
```

- 随后使用Sdkman下载并安装gradle/kotlin：

```bash
sdk install gradle
sdk install kotlin
```

- 设置环境变量：

```bash
export ANDROID_HOME=$HOME/Android
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/build-tools/34.0.0
source ~/.bashrc
```

- 继续下载一些SDK平台与构建工具：

```bash
sdkmanager "platforms;android-34" "build-tools;34.0.0" "platform-tools"
sdkmanager "emulator"   //虚拟机中调试
```

- 查看版本

```bash
(base) dich@uos:~$ sdk version

SDKMAN!
script: 5.20.0
native: 0.7.14 (linux x86_64)

(base) dich@uos:~$ gradle -v

------------------------------------------------------------
Gradle 8.10.2
------------------------------------------------------------

Build time:    2024-09-23 21:28:39 UTC
Revision:      415adb9e06a516c44b391edff552fd42139443f7

Kotlin:        1.9.24
Groovy:        3.0.22
Ant:           Apache Ant(TM) version 1.10.14 compiled on August 16 2023
Launcher JVM:  17.0.16 (Ubuntu 17.0.16+8-Ubuntu-0ubuntu124.04.1)
Daemon JVM:    /usr/lib/jvm/java-17-openjdk-amd64 (no JDK specified, using current Java home)
OS:            Linux 6.14.0-35-generic amd64

(base) dich@uos:~/Git/android-templates$ kotlin -version
Kotlin version 1.6.21-release-334 (JRE 21.0.8+9-Ubuntu-0ubuntu124.04.1)
(base) dich@uos:~/Git/android-templates/template-compose$ kscript -v
Copyright : 2022 Holger Brandl
License   : MIT
Version   : v4.0.3
Website   : https://github.com/holgerbrandl/kscript
A new version (v4.2.0) of kscript is available.
Kotlin    : 2.1.10-release-473
Java      : JRE 17.0.16+8
```

## Key方案

构建Release包需要密钥签名验证，可以使用传统的环境变量配置或者使用密钥管理器.

### 相同部分

- 生成密钥

```bash
keytool -genkey -v \
  -keystore ~/.android/jetlagged-release.keystore \
  -alias jetlagged \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

- 修改app/build.gradle.kts

```java
    signingConfigs {
        create("release") {
            storeFile = System.getenv("KEYSTORE_FILE")?.let { file(it) }
            storePassword = System.getenv("KEYSTORE_PASSWORD")
            keyAlias = System.getenv("KEY_ALIAS")
            keyPassword = System.getenv("KEY_PASSWORD")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")  // 添加这行
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
```

### 传统方法

- 创建配置文件

```bash
cat > ~/.android-signing-secrets << 'EOF'
export KEYSTORE_FILE="$HOME/.android/jetlagged-release.keystore"
export KEYSTORE_PASSWORD="你的keystore密码"
export KEY_ALIAS="jetlagged"
export KEY_PASSWORD="你的key密码"
EOF

# 设置权限
chmod 600 ~/.android-signing-secrets

# 添加到 gitignore (全局)
echo ".android-signing-secrets" >> ~/.gitignore_global
```

- flake配置

```bash
# Auto load Key
if [ -f "$HOME/.android-signing-secrets" ]; then
    source "$HOME/.android-signing-secrets"
    echo "KeyOK"
fi
```

### 现代方法

- 安装libsecret包
- keepassxc新建Android群组，添加条目``android_key_password``和``android_keystore_password``；
- 设置密码，和上面生成的相同；
- 在条目的高级-属性中添加``name/android_key_password``和``name/android_keystore_password``；
- 打开设置-保密服务集成，公开Android文件夹
- flake中写

```bash
# Release Key
export KEYSTORE_FILE="$HOME/.android/jetlagged-release.keystore"
export KEY_ALIAS="jetlagged"
export KEYSTORE_PASSWORD="$(secret-tool lookup name android_keystore_password)"
export KEY_PASSWORD="$(secret-tool lookup name android_key_password)"
```

---

**Done.**
