+++
title = "乱七八糟:浏览器碎碎念"
date = 2025-11-10

[taxonomies]
tags = ["乱七八糟"]
+++

前言 Chrome 占了全球七成份额，Edge 靠 Windows 预装刷存在感，Arc 在设计师圈火了一阵然后被母公司判了死刑。剩下 Firefox 系勉力支撑。
<!-- more -->

## **从哪里来的**

1990 年 Tim Berners-Lee 在 NeXT 工作站上写了 WorldWideWeb，既是浏览器也是编辑器。三年后 Mosaic 让图片和文字能混排，普通人终于能上网了。

核心开发者 Marc Andreessen 出去创办 Netscape，1994 年发布 Netscape Navigator，迅速占领 90% 市场。微软 1995 年把 IE 捆绑进 Windows 95，免费送——"第一次浏览器大战"开打。Netscape 打不过免费加预装，1998 年开源代码成立 Mozilla 后关门。2004 年 Mozilla 发布 Firefox 1.0，靠标签页、弹窗拦截、扩展系统把 IE 从 90% 撕到 60% 以下。

微软以为战争赢了，IE 6 从 2001 年到 2006 年几乎没更新，安全漏洞满天飞。Firefox 就在这个空档起飞。

另一边，2003 年苹果基于 KDE 的 KHTML 做了 Safari。2008 年 Google 拿 WebKit 加自研 V8 引擎推出 Chrome，极简快，2012 年登顶全球，至今没下来。2013 年 Google 从 WebKit fork 出 Blink，Opera 同年放弃自研 Presto 投奔。2015 年微软发 Edge 想翻身，2018 年也转向 Chromium。

到 2026 年，独立浏览器引擎只剩 **Blink（Chromium）、Gecko（Firefox）、WebKit（Safari）**，外加还在早期开发的 [Ladybird](https://ladybird.org)。其他全是壳。

## **内核垄断：90% 以上都姓 G**

Blink 系浏览器合计份额超过 90%（Michael Tsai 在 [The Browser Oligopoly](https://mjtsai.com/blog/2024/01/15/the-browser-oligopoly/) 中引用过这组数据）。欧盟《数字市场法案》把浏览器引擎竞争列为重点关注（[DMA Gatekeepers](https://digital-markets-act.ec.europa.eu/gatekeepers_en)）。

当一家公司控制九成份额的渲染引擎时，Web 标准就是它的实现。HTTP/3、WebGPU、Web Bluetooth、WebUSB——Google 推动，其他人接盘。这是背景。

下面说具体的，Chrome 用这种垄断地位在干什么。

---

## **Chrome 正在对你做什么**

### Manifest V3：掐死广告拦截器

Google 从 2024 年开始强制推进 Manifest V3，逐步禁用 Manifest V2。首当其冲的 uBlock Origin。

MV3 的核心操作：

- `webRequest` API 不能用——只能在请求已发出后声明式过滤，规则上限 30,000 条
- uBlock Origin 默认过滤列表 **超过 30 万条**，三分之一都用不了
- Google 说为了安全和隐私，但自家广告系统不受任何影响

结果：Raymond Hill 被迫发布 [uBlock Origin Lite](https://github.com/gorhill/uBlock/tree/master/platform/mv3)，功能严重阉割。不是阴谋论，是架构上就被钉死了。

> EFF 在 [Chrome Users Beware: Manifest V3 is Deceitful and Threatening](https://www.eff.org/deeplinks/2021/12/chrome-users-beware-manifest-v3-deceitful-and-threatening) 里写的：*"Manifest V3 is outright harmful to privacy efforts. It will restrict the capabilities of web extensions—especially those that are designed to monitor, modify, and compute alongside the conversation your browser has with the websites you visit."*

### 后台偷跑 AI 模型，占你硬盘几个 G

Chrome 从 2023 年底开始，在后台自动下载 "Optimization Guide On Device Model"——本地 Gemini 小模型，用于"帮我写"之类的 AI 功能。

- 用户没有勾选安装，更新后**默认下载**
- 模型约 2-4 GB，直接塞在 Chrome 用户数据目录
- 普通用户根本不知道硬盘被谁吃掉了
- 可以在 `chrome://settings/` 的隐私与安全里关，但不保证下个版本会不会重新打开

[Ars Technica](https://arstechnica.com/gadgets/2024/04/google-ai-search-might-be-behind-a-drop-in-macbook-battery-life/) 报道过此事。一个浏览器不经同意往你硬盘塞几个 G——这已经不是浏览器的行为了。

### 移动端故意不给你扩展

Chrome Android 不支持浏览器扩展。桌面上用的 uBlock Origin、Dark Reader、Bitwarden 到了手机上全废。

这不是做不到。[Kiwi Browser](https://kiwibrowser.com) 就是 Chromium + Chrome 扩展支持，已经好几年了。Google 不做，是选择，不是技术原因。

三件事串在一起看——掐广告拦截、偷偷装 AI 模型、手机端不让你装扩展——逻辑是一致的：Chrome 是为 Google 的商业目标服务的，不是为你。

---

## **Arc、Brave、Opera：Chromium 换皮大赛**

Arc 是设计圈曾经的宠儿——侧栏标签、Space 分组、Boost 自定义 CSS。去掉皮肤，底层是 Chromium。MV3 限制广告拦截？它逃不掉。Blink 里塞了什么？它照样继承。

2024 年 Arc 母公司宣布停止 Arc 2.0，转做全新 AI 浏览器。CEO Josh Miller 对 [The Verge](https://www.theverge.com/2024/10/24/24279020/browser-company-arc-browser-new-product) 说：*"Arc is not the future of browsers from our perspective."*

Brave 是 Chromium + 内置广告拦截 + 加密货币钱包。Opera 2001 年放弃自研 Presto 引擎。Vivaldi 是 Opera 前 CEO 做的，同款 Chromium。

所有 Chromium 系浏览器的差异化都只停留在 UI 层——侧边栏位置、标签页圆角、内置什么 AI——底层引擎行为一模一样，什么都改不了。

---

## **Edge 和国产浏览器：比 Chrome 还过分**

### Edge：密码明文存内存，微软说"故意的"

2024 年挪威安全研究员 Tom Jøran Sønstebyseter Rønning 发现：Edge 启动时把所有保存的密码解密后以明文长期驻留在进程内存。你没访问任何需要密码的网站，密码也在那。

[Forbes 报道](https://www.forbes.com/sites/zakdoffman/2024/10/18/microsoft-edge-browser-chrome-google-samsung-password-security-warning/)后，微软回复：**"This behavior is by design."**

Rønning 测试了 Chrome、Brave、Vivaldi 等所有主流 Chromium 浏览器，只 Edge 有这个问题。这是微软自己在 Chromium 上多写的代码。任何能读 Edge 进程内存的恶意软件都能直接捞走你全部密码。

另外：系统更新后重置默认浏览器、新标签页塞满 MSN 广告、DNT 默认关闭。不展开了。

### 360、2345：不是浏览器，是流量收割机

这些浏览器的商业模式不是"做好浏览器"，是"圈你进来卖流量"：

- **劫持搜索引擎**到自家竞价系统，搜"打印机驱动"前几条都是推广
- **劫持主页**为导航站，每个位置都收了钱
- **静默安装全家桶**：装 360 浏览器会自动多出 360 安全卫士、软件管家、壁纸、压缩。2345 看图王、好压、王牌输入法，卸一个还有三个
- **卸载玩文字游戏**："保留设置吗" → "真的不用了吗" → 跳网页问"为什么离开"。有些版本卸载按钮灰色
- **收集用户数据**：浏览记录、搜索词、系统信息、软件列表，比 Chrome 隐私政策列的还广，服务器在国内，数据怎么用天知道

至于"装 360 是为了玩 4399 的 Flash 游戏"——用 [FlashBrowser](https://github.com/radubirsan/FlashBrowser)，基于 Pale Moon，专门维护 Flash 兼容，不捆绑任何流氓软件。

---

## **为什么是 Firefox**

上面讲了 Chromium 全家的问题。现在说 Firefox 为什么是正解。

### 独立内核，不跟 Google 跑

Firefox 跑的是 Gecko，不受 Blink 路线图约束。Manifest V3？Firefox 实现了，但**同时保留了 MV2 的 `webRequest` API**，uBlock Origin 全功能可用。Google 往引擎里塞的东西，Firefox 不需要接。

也是这条独立的防线——如果 Gecko 没了，Web 标准就是 Google 一家独断。从 AMP 到 Topics API 到 Web DRM，历史已经证明了。

### 在中国大陆：省心

- **扩展商店**：Firefox AMO 一直能用，Mozilla 在国内有合作节点。Chrome Web Store 经常打不开
- **同步**：Firefox Sync 端到端加密，走 Mozilla 自有服务器，国内正常同步。Chrome 同步绑 Google 账号，不开代理全废
- **主页**：Firefox 首页随便折腾——空白页、固定网站、纯搜索框。Chrome 首页有固定快捷方式区，改不了，手机端更严重

### 不再"特供"了

以前在百度搜"Firefox 下载"排第一的是 firefox.com.cn，下到的是北京谋智定制版——默认百度、收藏夹预装淘宝京东。

2023 年底 Mozilla 终止与北京谋智合作。现在 [mozilla.org/firefox](https://www.mozilla.org/firefox) 直接给国际版，默认 Google，没预装书签和扩展。

### 移动端：扩展和同步都到位

Firefox Android/iOS 支持完整扩展系统，跟桌面共享 AMO 商店。uBlock Origin 手机上也能装。标签页一键跨设备发送，书签、密码、历史全同步。

---

## **怎么选**

| 场景 | 推荐 | 理由 |
|------|------|------|
| 日常使用 | **Firefox** | AMO 能用、同步不翻、uBlock 全功能、手机也有扩展 |
| 需要 Chromium 备用 | Ungoogled Chromium | 去 Google 服务，干净 |
| 隐私/匿名 | Tor Browser / Mullvad | 专用工具，不是日常用的 |
| 玩 4399/Flash | FlashBrowser | 不捆绑流氓 |
| 别碰 | 360 / 2345 / 腾讯 / 搜狗 | 全家桶、劫主页、卖流量 |
| 别碰 | Edge | 密码明文，微软说故意的 |

**Firefox 做主浏览器，Ungoogled Chromium 备用**。日常全覆盖，遇到仅 Chromium 兼容的网站也能打开。

---

**Done.**
