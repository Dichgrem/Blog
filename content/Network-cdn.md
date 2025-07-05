+++
title = "网络艺术:CDN技术与应用"
date = 2024-02-16

[taxonomies]
tags = ["Network"]
+++

前言 内容分发网络（CDN）是一组分布在不同地理位置的服务器网络,使用户能够就近获取内容，从而降低延迟并缓解源站压力​.

<!-- more -->

## 什么是CDN？

内容分发网络（CDN）是一组分布在不同地理位置的服务器网络，旨在将网站或应用的静态资源（如HTML、图片、视频等）缓存到距离用户更近的节点，以缩短传输路径、降低带宽成本并提高访问速度​.CDN通过“缓存”机制，在全球多个数据中心临时存储内容副本，用户发起请求时无需回源到主服务器，就能从最近的缓存节点获取数据，从而显著改善页面加载时间和整体用户体验​.相比传统的单点源站访问，CDN在用户和源站之间增加了分层缓存，通过负载均衡技术和智能路由，将访问请求定向到最优节点，既减轻了源站压力，又提升了网络抗拥塞能力和可用性​.

在现代互联网中，内容分发网络（CDN）和域名系统（DNS）相互配合，共同提升了网页和多媒体内容的访问速度与可靠性.CDN通过在全球分布的缓存节点上存储静态资源，使用户能够就近获取内容，从而降低延迟并缓解源站压力​.而DNS则负责将用户的域名请求导向适当的CDN节点，通过CNAME重定向、全局负载均衡（GSLB）、Anycast及EDNS扩展等技术，实现智能化的流量调度和最优路径选择​.

**CDN的核心功能与优势**

- 加速访问：将内容存储于距离用户更近的节点，减少传输延迟，常见于视频点播、大文件下载等场景​.

- 减轻源站压力：缓存请求可直接由CDN节点响应，降低源站带宽和计算资源消耗，有助于应对突发流量和DDoS攻击​.

- 高可用与弹性扩展：全球分布的节点架构，使内容分发具备冗余能力，单点故障不会影响整体服务，且可动态扩容以应对业务增长.

## CDN与DNS的结合方式

1. **通过CNAME实现权威DNS指向CDN**

当用户在浏览器中输入域名发起请求时，首先触发本地DNS解析过程；如果该域名已开通CDN服务，其DNS解析记录通常配置为一条CNAME（别名）记录，指向CDN运营商提供的专用域名；本地DNS服务器再将解析权交给CDN的权威DNS服务器，从而实现对CDN网络的接入​.


CDN的权威DNS服务器根据用户请求的域名，返回一个“全局负载均衡设备”的IP地址，该IP并非最终缓存节点，而是GSLB层用于智能调度的入口地址；浏览器接收到该IP后，向GSLB层发起实际内容请求​.

2. **全局负载均衡（GSLB）与智能DNS**

GSLB（Global Server Load Balancing）是CDN架构中最核心的部分，负责根据多种因素（用户IP地理位置、节点健康状态、节点负载情况等）动态选择最优区域负载均衡节点或缓存服务器，向用户提供最低延迟和最佳性能的服务​.

这一过程通常也基于DNS解析完成：当GSLB层接到DNS查询请求时，智能DNS服务器会返回针对该用户最优的缓存节点IP，从而实现“DNS级”的流量调度和负载均衡​.

3. **Anycast与EDNS扩展**

Anycast路由：部分CDN运营商在全球部署相同IP的多个节点，利用BGP Anycast技术使得用户请求自动路由到网络拓扑上“最近”的节点，增强访问的网络路径效率与容灾能力​.

EDNS Client Subnet（EDNS-CS）：传统DNS仅看到发起查询的递归DNS服务器IP，难以准确判断终端用户位置；EDNS-CS协议在DNS请求中携带部分客户端IP前缀，使权威DNS能更细粒度地进行地理定位与节点选取，大幅提升了基于DNS的智能调度精度​.



## 为什么加了CDN之后网站的自签名证书也被信任了？

> 在启用 CDN 后，终端用户看到的并不是您在源站（origin）上配置的自签名证书，而是 CDN 边缘节点（edge）所出示的、由受信任 CA 签发的“边缘证书”.也就是说，浏览器与 CDN 边缘之间的 TLS 握手完全独立于您源站和自签名证书的存在，源站的自签名证书仅用于 CDN 与源站之间的“后端”加密连接，不会暴露给最终用户浏览器​.


**CDN 模式下的 TLS 终止**

- **DNS/CNAME 指向**
    当您为域名启用 CDN 后，通常会在 DNS 中将该域名的 CNAME 记录指向 CDN 运营商提供的专用域名，本地递归 DNS 随后会将解析权交给 CDN 供应商的权威 DNS，实现请求切入 CDN 网络​.

- **边缘节点出示证书**
    用户发起 HTTPS 请求时，浏览器直接与就近的 CDN 边缘节点建立 TLS 连接，边缘节点会出示由受信任 CA（如 Let's Encrypt、DigiCert 等）签发的“边缘证书”，而非您源站的自签名证书​.

- **源站连接加密**
    在边缘节点接收并缓存用户流量后，CDN 再以 HTTPS（或 HTTP，根据配置）向源站发起请求.此时，您可以在源站使用自签名证书（或 Cloudflare Origin CA 自签名证书），仅保证 CDN 与源站之间的加密传输，且该证书对终端用户浏览器不可见​.

### SSL/TLS 加密模式对自签名证书的影响

以 Cloudflare 为例，常见的四种 SSL/TLS 模式对自签名证书的处理策略如下：

- **Flexible**：浏览器 ↔ CDN 边缘 使用 HTTPS；CDN 边缘 ↔ 源站 使用 HTTP，不接触证书验证.

- **Full**：浏览器 ↔ CDN 边缘 使用 HTTPS；CDN 边缘 ↔ 源站 使用 HTTPS，但不验证源站证书的 CA 链和域名匹配，可使用自签名证书​.
    Cloudflare Docs

- **Full (strict)**：浏览器 ↔ CDN 边缘 使用 HTTPS；CDN 边缘 ↔ 源站 使用 HTTPS，严格验证源站证书是否由受信任 CA 签发且域名匹配，不支持自签名证书​.
    Cloudflare Docs

- **Off**：关闭 HTTPS，加密支持完全关闭.

若您选择 Full 或 Flexible 模式，即使源站使用自签名证书，CDN 也不会在边缘层对其进行验证，仍会正常转发和缓存内容；而用户浏览器只会看到 CDN 边缘提供的受信任证书，因此不会出现“不受信任”警告​.

> 为什么浏览器会信任? 浏览器内置了受信任的根证书列表，CDN 边缘出示的证书链会完整地链接到某个系统信任根，而您的自签名证书则不在此列表内，因而只有源站连接可被 CDN 信任，而非终端浏览器​.CDN 则作为“可信中间人”，它信任自签名证书以加密与源站的通信，而浏览器仅信任 CDN 边缘的 CA 签发证书，二者互不干扰，有效隔离了自签名的风险.


### 如何开启Full (Strict)模式？


​要在 Cloudflare 上启用 Full (Strict) 模式，以确保 CDN 与源站之间的通信既加密又验证证书的有效性，请按照以下步骤操作：​

✅ 步骤 1：确保源站配置了有效的 SSL/TLS 证书

在启用 Full (Strict) 模式之前，您的源站必须安装一个有效且受信任的 SSL/TLS 证书.​您可以选择以下方式之一：​

    使用公共 CA 颁发的证书：如 Let's Encrypt、DigiCert、GlobalSign 等.

    使用 Cloudflare Origin CA 证书：这是 Cloudflare 提供的免费证书，专为与其边缘节点通信设计.​

确保证书未过期，且域名匹配正确.如果使用 Cloudflare Origin CA 证书，请在源站服务器上正确安装，并配置服务器（如 Nginx、Apache）以使用该证书.​

✅ 步骤 2：在 Cloudflare 仪表板中启用 Full (Strict) 模式
```
登录到您的 Cloudflare 仪表板.

选择您要配置的站点.

在左侧菜单中，点击 “SSL/TLS”.

在 “概览（Overview）” 标签下，找到 “SSL/TLS 加密模式（SSL/TLS encryption mode）”.

选择 “Full (Strict)” 模式.​
```

更改后，Cloudflare 会立即应用此设置.​建议等待几分钟，然后通过浏览器访问您的网站，确保一切正常运行.​

🔗 注意事项

如果源站使用的是自签名证书或过期的证书，启用 Full (Strict) 模式后，Cloudflare 将无法建立连接，用户可能会看到 526 错误.

确保源站服务器的时间设置正确，以避免因时间不一致导致的证书验证失败.

## DNSSEC是什么？

DNSSEC（Domain Name System Security Extensions，域名系统安全扩展）是一组为 DNS 协议设计的安全机制，旨在通过数字签名验证 DNS 数据的真实性和完整性，防止域名解析过程中的数据篡改和伪造.

1. DNSSEC 的工作原理

DNSSEC 通过引入以下关键机制来增强 DNS 的安全性：​

- 数字签名（RRSIG 记录）：​每个 DNS 记录集（如 A、MX、CNAME 等）都会生成一个对应的数字签名，确保记录在传输过程中未被篡改.​

- 公钥发布（DNSKEY 记录）：​用于存储验证数字签名所需的公钥.​这些公钥本身也通过上级域的签名进行验证，形成信任链.​

- 委派签名者（DS 记录）：上级域使用 DS 记录存储下级域的 DNSKEY 记录的摘要，确保公钥的真实性.

- 不存在性证明（NSEC/NSEC3 记录）：用于明确指示某个 DNS 记录不存在，防止攻击者伪造不存在的记录.

通过这些机制，DNSSEC 建立了一条从根域开始的信任链，逐级验证每个域的 DNS 数据，确保其未被篡改且来源可信.

2. DNSSEC 的局限性

- 不加密数据内容：DNSSEC 仅对 DNS 数据进行签名验证，并不加密查询和响应内容，因此无法防止数据被监听.

- 部署复杂性：​实施 DNSSEC 需要域名注册商、DNS 服务提供商和客户端解析器的共同支持，部署和维护相对复杂.​

- 性能影响：​由于引入了额外的签名验证过程，DNSSEC 可能会增加 DNS 查询的响应时间和系统资源消耗.​

3. DNSSEC 的优势

- 防止 DNS 欺骗和缓存投毒：​通过验证 DNS 数据的真实性，DNSSEC 能有效防止攻击者伪造 DNS 响应，将用户引导至恶意网站.​

- 增强互联网基础设施安全性：​作为互联网信任体系的一部分，DNSSEC 为其他安全协议（如 DANE）提供基础支持.​

## CDN的位置选择

Netlify在考虑到CDN成本以及可用性的情况下选择了以下这些地区以保证全球大部分访客访问他们的服务都能有不错的连接性和访问速度。

```
欧洲中部（德国法兰克福）
南美（巴西圣保罗）
美东（美国弗吉尼亚）
美西（美国旧金山）
亚洲（新加坡）
大洋洲（澳大利亚悉尼）
```
那么Netlify为什么会选择把CDN节点放到这些地区呢？

1.弗吉尼亚，美东的弗吉尼亚被誉为“全球数据中心之都"，美国政府对这个地区的网络投入非常大，使得弗吉尼亚的全球互联（美国本土、欧洲以及到南美洲）优秀。

2.旧金山，面向亚太和美西的访客。需要注意的是美西对亚太的网络连接比较优秀，但是到南美不太理想，甚至还有丢包的情况。

3.法兰克福，面向欧洲用户，德国法兰克福或者荷兰阿姆斯特丹都是不错的选择。

4.新加坡，亚太地区数据中心的枢纽，到印度、日本、越南、香港、中国移动的联通性都不错。

5.悉尼，土澳出了名的国际互联不太好，悉尼节点主要是服务本地和周边。

6.圣保罗，南美市场。


## 常见CDN的IP列表

> 需要注意的是有些CDN的回源IP并不用作节点IP，比如Cloudflare的回源IP仅作回源IP使用，如果要获取Cloudflare的节点IP，可前往https://bgp.tools/as/13335#prefixes。而有些CDN的回源IP同时被用作CDN节点，比如BunnyCDN和Gcore CDN。

Cloudflare
```
# https://www.cloudflare.com/ips-v4
103.21.244.0/22
103.22.200.0/22
103.31.4.0/22
104.16.0.0/13
104.24.0.0/14
108.162.192.0/18
131.0.72.0/22
141.101.64.0/18
162.158.0.0/15
172.64.0.0/13
173.245.48.0/20
188.114.96.0/20
190.93.240.0/20
197.234.240.0/22
198.41.128.0/17

# https://www.cloudflare.com/ips-v6
2400:cb00::/32
2405:8100::/32
2405:b500::/32
2606:4700::/32
2803:f800::/32
2a06:98c0::/29
2c0f:f248::/32
```
Gcore
```
https://api.gcore.com/cdn/public-ip-list
```
BunnyCDN
```
https://api.bunny.net/system/edgeserverlist
https://api.bunny.net/system/edgeserverlist/plain
```
Cloudfront
```
https://d7uri8nf7uskq.cloudfront.net/tools/list-cloudfront-ips
https://files.imunify360.com/static/whitelist/v2/cloudfront-cdn.txt
```
CDN77
```
https://files.imunify360.com/static/whitelist/v2/cdn77.txt
```
Fastly
```
https://api.fastly.com/public-ip-list
```
Keycdn
```
https://www.keycdn.com/shield-prefixes.json
```
quic.cloud
```
https://quic.cloud/ips
```
Google CDN
```
https://files.imunify360.com/static/whitelist/v2/google-cdn.txt
```
CacheFly
```
https://cachefly.cachefly.net/ips/cdn.txt
```
Akaima
```
https://techdocs.akamai.com/origin-ip-acl/docs/update-your-origin-server
```
---
**Done.**
