+++
title = "网络艺术:Yt-dlp使用指南"
date = 2025-04-12

[taxonomies]
tags = ["网络艺术"]
+++

前言 有时候我们想要视频保存到本地以便离线回看。yt-dlp是一款功能强大的命令行工具，专注于下载视频与音频内容，支持数千个平台，是开源下载工具爱好者的常用选择。

<!-- more -->


## 历史沿革：从 youtube-dl 到 yt-dlp

- **起源与演进**
  `youtube-dl` 由 Ricardo García González 于 **2006 年**创建，最初仅支持 YouTube，随后扩展至其他网站，成为 GitHub 上最受欢迎的开源下载项目之一.项目维护者在 2011 年、2021 年等阶段陆续交替，由 phihag、dstftw 等接手.2020 年，唱片业协会（RIAA）发起 DMCA 要求删除该项目，虽一度被移除，但在公众与 EFF 的推动下于当年 11 月恢复，并促使 GitHub 改进相关策略.

- **停滞，youtube-dlc → yt-dlp 的诞生**
  随着开发进度放缓，社区于 2020 年衍生出 youtube-dlc 分支，随即在 **2021 年**演变为更活跃的 `yt-dlp` 项目,它继承了 youtube-dl 的核心功能，并引入更多改进，包括更好的格式选择、多线程下载等，迅速在 Linux 发行版中取代 youtube-dl (如 Ubuntu 22.04 之后).

- **重构与功能拓展**
  `yt-dlp` 从 youtube-dlc 完全重构，新增许多 extractor（解析器）、改进配置与默认行为，还扩展了插件系统和兼容性支持.


## 各平台安装指南

- 通用（Linux/macOS/Windows）

下载官方最新可执行文件：

```bash
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp
````

更新版本：

```bash
yt-dlp -U
```

- Python Pip 安装

```bash
python3 -m pip install -U yt-dlp
```

- Linux 发行版仓库

各发行版可能提供略滞后的 yt-dlp：

- Debian / Ubuntu：`sudo apt install yt-dlp`
- Arch / Manjaro：`sudo pacman -S yt-dlp`
- Fedora：`sudo dnf install yt-dlp` 等。

- Android（Termux）

```bash
pkg update && pkg upgrade
pkg install python libexpat openssl ffmpeg
python3 -m pip install -U yt-dlp
```

## 常用命令

- **下载视频**：

  ```bash
  yt-dlp "视频链接"
  ```

- **提取为 MP3 音频**：

  ```bash
  yt-dlp -x --audio-format mp3 "视频链接"
  ```

- **下载播放列表**：

  ```bash
  yt-dlp -i "播放列表链接"
  ```

- **批量处理（文件或多个 URL）**：

  ```bash
  yt-dlp -a urls.txt
  ```

- **选择格式下载**：

  ```bash
  yt-dlp -F "视频链接"      # 显示所有格式
  yt-dlp -f 137+140 "链接"  # 下载指定视频 + 音频合并
  ```

- **自定义输出路径与模板**：

  ```bash
  yt-dlp -o '%(title)s by %(uploader)s on %(upload_date)s.%(ext)s'
  ```

- **日期过滤**：

  ```bash
  yt-dlp --dateafter 20230101 --datebefore 20231231 "链接"
  ```

- **速度限制 / 恢复下载 / 年龄筛选**：

  ```bash
  -r 500K        # 限速
  -c             # 断点续传
  --age-limit 18 # 仅下载适合年龄 ≥18 的视频
  ```

- **只输出描述，不下载内容**：

  ```bash
  yt-dlp --skip-download "链接"
  ```

- **下载封面、字幕、缩略图、元数据等**：

  ```bash
  --write-thumbnail --write-sub --embed-subs --embed-thumbnail
  ```

- **使用浏览器 Cookies 下载私密内容**：

  ```bash
  --cookies your-cookies.txt
  --cookies-from-browser firefox
  ```

- **并行下载示例（Hacker News 用户提供）**：

  ```bash
  yt-dlp --flat-playlist --print id playlist_url | \
    parallel yt-dlp -x --wait-for-video 3 --download-archive archive.txt https://www.youtube.com/watch?v={}
  ```

- **记录下载历史**：

  ```bash
  yt-dlp --download-archive archive.txt "链接"
  ```

- **配置文件设定默认参数**：

  在 `~/.config/yt-dlp/config` 文件中添加习惯参数，如下载路径、格式偏好等。

- **比如下载B站带字幕视频的命令**:

```
yt-dlp "https://www.bilibili.com/video/BVxxxxx" --write-subs --embed-subs --sub-langs all,-live_chat

--write-subs: 将字幕文件下载为单独文件 (如 .vtt 或 .ass)

--embed-subs: 将下载的字幕嵌入到视频文件中（如果格式支持）

--sub-langs all,-live_chat: 下载所有字幕语言，但排除像“弹幕/实时聊天”之类的非标准字幕流
```

---

## 进阶技巧

- **FFmpeg 合并支持**：若视频与音频分离，需安装 FFmpeg 才能完成合并。

- **处理地理限制**：结合 `--proxy` 或 `--geo-bypass` 等选项使用 VPN/代理绕过区域限制。

- **应对下载失败（如 403）**：

  ```bash
  yt-dlp --rm-cache-dir
  ```

- **设置 UA、Referer、打印请求头调试**：

  ```bash
  --add-headers "User-Agent: ..." --print http_headers
  ```

- **Stability & 更新问题**：建议避免使用发行版中的旧版本，推荐使用官方可执行或 pip 方法。

---
**Done.**

