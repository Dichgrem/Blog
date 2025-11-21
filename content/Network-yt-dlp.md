+++
title = "下载系列(2):Yt-dlp使用指南"
date = 2025-04-12

[taxonomies]
tags = ["Network"]
+++

前言 yt-dlp是一款功能强大的命令行工具，专注于下载视频与音频内容，支持数千个平台，是开源下载工具爱好者的常用选择。

<!-- more -->

有时候我们想要下载网络上的某些视频，比如Bilibili，YouTube等等，但它们没有提供下载按钮，这时候就可以用开源的yt-dlp来进行下载。和Aria2一样，很多下载软件的核心就是yt-dlp.

## 历史

- **起源与演进**
`youtube-dl` 由 Ricardo García González 于 **2006 年**创建，最初仅支持 YouTube，随后扩展至其他网站，成为 GitHub 上最受欢迎的开源下载项目之一.项目维护者在 2011 年、2021 年等阶段陆续交替，由 phihag、dstftw 等接手.2020 年，唱片业协会（RIAA）发起 DMCA 要求删除该项目，虽一度被移除，但在公众与 EFF 的推动下于当年 11 月恢复，并促使 GitHub 改进相关策略.

- **停滞，youtube-dlc → yt-dlp 的诞生**
随着开发进度放缓，社区于 2020 年衍生出 youtube-dlc 分支，在**2021 年**演变为更活跃的 `yt-dlp` 项目,它继承了 youtube-dl 的核心功能，并引入更多改进，包括更好的格式选择、多线程下载等，成为了GitHub上star最多的项目之一.

- **重构与功能拓展**
`yt-dlp` 从 youtube-dlc 完全重构，新增许多 extractor（解析器）、改进配置与默认行为，还扩展了插件系统和兼容性支持.


## 安装

### Windows

从yt-dlp官方GitHub上下载exe二进制文件：

[yt-dlp](https://github.com/yt-dlp/yt-dlp/releases/tag/2025.08.22)

将其放到一个目录下，比如``C:\Users\<你的用户名>\yt-dlp\yt-dlp.exe``,随后添加环境变量。

> 添加环境变量：Win键搜索“环境变量”，打开“编辑系统环境变量”，点击最下方的“环境变量”，选择“系统变量”中的path，点击“编辑”，新建一个变量，将上面的目录 C:\Users\<你的用户名>\yt-dlp\ 写入，注意去掉前后引号，随后确定-确定-确定退出。

更新版本：

```bash
yt-dlp -U
```

- Python Pip 安装

```bash
python3 -m pip install -U yt-dlp
```

### Linux 发行版

- Debian / Ubuntu：`sudo apt install yt-dlp`
- Arch / Manjaro：`sudo pacman -S yt-dlp`
- Fedora：`sudo dnf install yt-dlp`
- Nixos: 
```nix
{pkgs, ...}: {
  home.packages = with pkgs; [
    peazip
  ];
}
```

### Android（Termux）

```bash
pkg update && pkg upgrade
pkg install python libexpat openssl ffmpeg
python3 -m pip install -U yt-dlp
```

## 下载实战

- **下载B站带字幕视频**:

```bash
yt-dlp "https://www.bilibili.com/video/BVxxxxx" --write-subs --embed-subs --sub-langs all,-live_chat

--write-subs: 将字幕文件下载为单独文件 (如 .vtt 或 .ass)

--embed-subs: 将下载的字幕嵌入到视频文件中（如果格式支持）

--sub-langs all,-live_chat: 下载所有字幕语言，但排除像“弹幕/实时聊天”之类的非标准字幕流
```

- **下载YouTube视频**

先使用这个命令查看可用格式：
```bash
yt-dlp -F https://www.youtube.com/watch?v=xxxxxxxxxxxx
```
然后它会列举出所有可用的格式，如下：
```bash
[youtube] MgtOAVOXBWo: Downloading webpage
[youtube] MgtOAVOXBWo: Downloading tv client config
[youtube] MgtOAVOXBWo: Downloading tv player API JSON
[youtube] MgtOAVOXBWo: Downloading ios player API JSON
[youtube] MgtOAVOXBWo: Downloading m3u8 information
[info] Available formats for MgtOAVOXBWo:
ID  EXT   RESOLUTION FPS │   FILESIZE   TBR PROTO │ VCODEC          VBR ACODEC     MORE INFO
──────────────────────────────────────────────────────────────────────────────────────────────────────────
sb2 mhtml 48x27        0 │                  mhtml │ images                         storyboard
sb1 mhtml 80x45        0 │                  mhtml │ images                         storyboard
sb0 mhtml 160x90       0 │                  mhtml │ images                         storyboard
233 mp4   audio only     │                  m3u8  │ audio only          unknown    Untested, Default, low
234 mp4   audio only     │                  m3u8  │ audio only          unknown    Untested, Default, high
602 mp4   256x144     15 │ ~  9.23MiB   81k m3u8  │ vp09.00.10.08   81k video only Untested
269 mp4   256x144     30 │ ~ 14.94MiB  130k m3u8  │ avc1.4D400C    130k video only Untested
603 mp4   256x144     30 │ ~ 15.90MiB  139k m3u8  │ vp09.00.11.08  139k video only Untested
229 mp4   426x240     30 │ ~ 33.33MiB  291k m3u8  │ avc1.4D4015    291k video only Untested
604 mp4   426x240     30 │ ~ 25.82MiB  225k m3u8  │ vp09.00.20.08  225k video only Untested
230 mp4   640x360     30 │ ~ 73.50MiB  642k m3u8  │ avc1.4D401E    642k video only Untested
605 mp4   640x360     30 │ ~ 55.73MiB  487k m3u8  │ vp09.00.21.08  487k video only Untested
231 mp4   854x480     30 │ ~104.35MiB  911k m3u8  │ avc1.4D401F    911k video only Untested
606 mp4   854x480     30 │ ~ 94.79MiB  827k m3u8  │ vp09.00.30.08  827k video only Untested
311 mp4   1280x720    60 │ ~330.73MiB 2887k m3u8  │ avc1.4D4020   2887k video only Untested
612 mp4   1280x720    60 │ ~197.04MiB 1720k m3u8  │ vp09.00.40.08 1720k video only Untested
312 mp4   1920x1080   60 │ ~486.64MiB 4248k m3u8  │ avc1.64002A   4248k video only Untested
617 mp4   1920x1080   60 │ ~369.06MiB 3222k m3u8  │ vp09.00.41.08 3222k video only Untested
623 mp4   2560x1440   60 │ ~  1.00GiB 8945k m3u8  │ vp09.00.50.08 8945k video only Untested
```
我们下载312和233,即视频和音频，使用以下命令：
```bash
yt-dlp -f "312+233" -o "<新视频的名字，要短一点>.%(ext)s" https://www.youtube.com/watch?v=xxxxxxxxxxxx
```
这行命令会自动将下载的312的1080p/H.264的视频和233的音频合并为一个mp4视频，注意新的名称不能太长，否则会下载失败。

如果要下载带字幕的视频，则使用
```bash
yt-dlp -f "312+233" --write-subs --write-auto-subs --embed-subs --sub-langs "zh.*,en.*" -o "<新视频的名字，要短一点>.%(ext)s" https://www.youtube.com/watch?v=xxxxxxxxxxx
```
这个命令会：

- 下载1080p视频
- 下载中文和英文字幕（包括自动生成的）
- 将字幕嵌入到视频文件中
- 同时保存单独的字幕文件

- 参数说明

```bash
--write-subs: 下载手动字幕
--write-auto-subs: 下载自动生成的字幕
--embed-subs: 将字幕嵌入到视频中
--sub-langs "zh.*": 指定下载中文字幕（所有中文变体）
--sub-format srt: 指定字幕格式（可选）
```

## 常用参数

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

---
**Done.**

