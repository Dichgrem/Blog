+++
title = "谈天说地:狄奇周刊(二一)"
date = 2025-02-04

[taxonomies]
tags = ["谈天说地"]
+++

前言 这里是Dich的周刊,通过博客的形式讲述每周互联网形势,以及分享一些文章。

<!-- more -->
# **事记**

## **一.[Cloudflare推出验证在线图片的真实性的功能](https://blog.cloudflare.com/preserve-content-credentials-with-cloudflare-images/)**

Cloudflare采用由Adobe主导的“内容凭证”系统，为图片和视频添加数字元数据标签，追踪其所有权、发布历史以及是否经过篡改，特别是是否使用了生成性AI工具。

Cloudflare还推出了一个“保留内容凭证”的一键设置功能，适用于所有通过Cloudflare Images托管的内容，用户可以通过Adobe的“内容真实性”网页工具或Chrome扩展程序，轻松验证这些图片的数字历史。

该系统基于“内容来源与真实性联盟”（C2PA）制定的开放标准，旨在帮助艺术家和摄影师保留作品的归属权，并帮助用户区分真实和经过AI工具生成或篡改的图像与视频。


## **二.[Apple开源 Xcode 底层构建引擎 Swift Build](https://www.swift.org/blog/the-next-chapter-in-swift-build-technologies/)**


苹果正式宣布将 Swift Build 开源，并纳入 Swift 项目，致力于为所有 Swift 用户提供更强大且统一的跨平台构建体验。Swift Build 作为 Xcode 的底层构建引擎，已为数百万 App 和苹果自家操作系统构建流程提供支持，现开源后也可面向 Linux、Windows 等平台。

Swift Package Manager 将逐步采用统一引擎，确保在所有平台和工具中获得一致的构建体验，并为后续新功能和性能改进铺平道路。目前，Swift Build 已在 GitHub 的 Swift 组织下公开，社区开发者可提交反馈与改进建议，共同推进这一新里程碑的发展。


## **三.[Firefox 离线翻译插件在 Nightly 上已经开始支持中译英。](https://connect.mozilla.org/t5/ideas/support-chinese-translations/idc-p/81626/highlight/true#M43969)**

此插件是 Project Bergamot 的一部分，后者由欧盟资助，旨在提升浏览器离线机器翻译的效果。

插件目前支持 12 种语言，包括德语、西语、俄语、葡萄牙语、意大利语等。


## **四.[小米向 AOSP 提交补丁，拟禁止用户通过 adb 等方式提取 APK 文件](https://android-review.googlesource.com/c/platform/system/sepolicy/+/2101015)**

一位小米工程师向 AOSP 提交了一个补丁，该补丁将添加一个 SELinux 策略，禁止用户通过 adb 等方式来提取 APK 文件，理由是 APK 中可能会包含一些「私有资源」。

该补丁提交后，在 AOSP Code Review 中引起热议。该工程师称，“APK 只应该从谷歌市场或其他应用市场等可靠来源获取，如果一个 APK 可以被 adb 提取，它就可以被反编译，这样会有一定的安全风险。”。有网友在下面顺势质问小米不开源内核，小米并未对此答复。

好在 Google 拒绝将此补丁合入 AOSP，并称“APK 基本上不是(原文大写强调)秘密”，但 Google 拒绝合并并不意味着 MIUI 不会采取措施来进一步限制用户权限，好时代，来临力🤮

## **五.[DeepSeek发布的开源推理大模型R1震动全球AI圈](https://telegra.ph/%E4%B8%80%E6%96%87%E8%AF%BB%E6%87%82DeepSeek%E6%96%B0%E6%A8%A1%E5%9E%8B%E5%A4%A7%E6%8F%AD%E7%A7%98%E4%B8%BA%E4%BD%95%E5%AE%83%E8%83%BD%E9%9C%87%E5%8A%A8%E5%85%A8%E7%90%83AI%E5%9C%88-01-26)**

1 月 20 日，DeepSeek 发布了全新的开源推理大模型 DeepSeek-R1，在数学、编程和推理等多个任务上达到了与 OpenAI o1 相当的表现水平，同时将API调用成本降低了 90-95%。

和上次不同的是，这次推出的新模型DeepSeek-R1不仅成本低，更是在技术上有了大福提升。

AI圈大V Yuchen Jin认为，DeepSeek-R1 论文中的这个“顿悟时刻”意义巨大：纯强化学习 (RL) 使LLM自动学习思考和反思。

这挑战了之前的观点，即复制 OpenAI 的 o1 推理模型需要大量 CoT 数据。事实证明，你只需要给予它正确的激励即可。

# **文推**

[让 Android 手机更省电流畅，你可以试试「刷内核」](https://sspai.com/post/56296)


[《纽约客》主编专访比尔·盖茨｜盖茨和新晋特朗普科技寡头](https://telegra.ph/%E7%BA%BD%E7%BA%A6%E5%AE%A2%E4%B8%BB%E7%BC%96%E4%B8%93%E8%AE%BF%E6%AF%94%E5%B0%94%E7%9B%96%E8%8C%A8%E7%9B%96%E8%8C%A8%E5%92%8C%E6%96%B0%E6%99%8B%E7%89%B9%E6%9C%97%E6%99%AE%E7%A7%91%E6%8A%80%E5%AF%A1%E5%A4%B4-02-04)

[对 DeepSeek 真实水平的分析](https://mp.weixin.qq.com/s/66d0tcyDdAq9cUPVZH4VRA)

# **项目**


[互传联盟，在不同品牌设备上互传](https://github.com/kmod-midori/CatShare)


[SamWaf开源轻量级网站防火墙，完全私有化部署](https://github.com/samwafgo/SamWaf)


[在PDF里运行Linux，利用RISC-V模拟器，将Linux系统嵌入PDF文件，基于TinyEMU，支持32位和64位系统；](https://github.com/ading2210/linuxpdf)