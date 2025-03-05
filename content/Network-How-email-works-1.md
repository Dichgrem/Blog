+++
title = "电子邮件是如何工作的:SPF/DKIM/DMARC"
date = 2024-02-20

[taxonomies]
tags = ["网络艺术"]
+++

前言 在互联网的日常使用中，电子邮件作为一项基础服务扮演着重要的角色。尽管在过去几十年里出现了各种新型的通讯方式，但电子邮件仍然保持着其不可替代的地位。了解电子邮件的工作原理，有助于更好地理解这一基础服务是如何运作的。

<!-- more -->

## 一. 基于协议的传输



与许多其他基于协议的应用一样，电子邮件依赖于一系列协议来进行传输和交换。而基于协议的应用一般不会轻易地被历史淘汰：在过去的几十年里，基于 HTTP 上层的网站，以及技术更新换代了好几波，但底层的协议依然还是 HTTP（HTTPS）。基于 BitTorrent 协议的文件交换协议，和基于SMTP（Simple Mail Transfer Protocol）的电子邮件传输便是其中之一。



## 二. 邮件发送的流程



电子邮件的发送过程可以简单地描述为以下几个步骤：

- 用户在邮件客户端（例如Gmail）中撰写并发送一封邮件。
- 邮件客户端使用SMTP协议将邮件发送到相应的邮件服务器。
- 通过DNS查询MX记录找到接收方的邮件服务器。
- 发送邮件服务器使用SMTP协议将邮件传递给接收方的邮件服务器。
- 接收方的邮件服务器将邮件存储在相应的邮箱中，供用户查看。

为了确保通信安全，电子邮件的发送还引入了一些安全机制，如SPF、DKIM和DMARC。

- SPF（Sender Policy Framework）用于验证发件人的身份，防止发件人伪造。
- DKIM（DomainKeys Identified Mail）通过数字签名验证邮件的真实性。
- DMARC（Domain-based Message Authentication, Reporting, and Conformance）结合了SPF和DKIM，提供了更严格的邮件验证机制。

## 三.具体流程



假设用户 [a@gmail.com](mailto:a@gmail.com) 发送一封邮件到 [b@qq.com](mailto:b@qq.com)，会执行如下的流程。

**1.查询 MX 记录**

当我们在 Gmail 网页上撰写一封邮件，并点击发送按钮之后。Gmail 会用自己的内部协议链接 Gmail 的 Outgoing SMTP 邮件服务器。

Outgoing SMTP 验证用户权限，然后将邮件以 MIME 格式发送到发送队列中。

Gmail SMTP 服务器会通过 DNS 查询到域名 `qq.com` MX（Mail Exchanger） 记录(`dig MX qq.com`)，找到邮件服务器的 IP 所在。

在 Linux 下也可以通过 `dig mx qq.com` 来查询到。这一步在对应到自建的邮件服务器的时候，就是通过配置 DNS 的 MX 记录来实现的。

一般情况下会配置一个 A 记录 `mx.example.com` 指向服务器的 IP 地址。然后再配置一个 [[MX 记录]]，`@` 全部域名的 MX 请求全部转发给 `mx.example.com`。



**2.SMTP 发送**



当 Gmail 的服务器找到 QQ 邮箱的 IP 地址之后，邮件就会通过 SMTP（Simple Mail Transfer Protocol ） 协议连接服务器的连接，尝试发送给 QQ 的服务器。



为了简化理解，SMTP 传输的时候就直接声明，我 [a@gmail.com](mailto:a@gmail.com) ，我要发送邮件到 [b@qq.com](mailto:b@qq.com) ，内容是某某某。QQ 邮箱的服务器接收到 Gmail 的邮件之后，再根据用户名决定发给具体谁的邮箱。

这中间会发现不存在任何验证发送方身份的过程，这也就意味着任何人都可以伪装一个任意的发送邮箱以一个伪装的邮箱发送邮件。SMTP 最早是建立在相互信任的基础之上的，所以也给后面的恶意使用留下了一些漏洞，为了修复这个漏洞发明了 SPF。



**3.SPF 验证**



上文提到过 SMTP 协议发送邮件的过程中没有验证发送方，这也就意味着发信方可以任意指定发件人邮箱地址，这会存在一些安全问题。

具体来说，本来我的 Gmail 邮箱是 `a@gmail.com`，假如有不法分子，就可以利用这个漏洞，伪装成自己是 `a@gmail.com` 给别人发送邮件。

[[SPF]] 的目的就是为了防止伪造发信人。



- SPF 的原理

SPF 的实现原理非常简单，就是通过添加一条 DNS 记录。

如果邮件服务器收到一封来自主机 `1.1.1.1` 的邮件，并且发件人是 `a@gmai.com`，为了确认发件人，邮件服务器就会去查询 `gmail.com` 的 SPF 记录。如果域名设置了 SPF 记录，允许 `1.1.1.1` 的 IP 地址发送邮件，那么收件的邮件服务器就会认为邮件是合法的，否则就会退信。

有了 SPF 记录之后，如果有人想要伪装成 `a@gmail.com` 他既不能修改 gmail.com 的 DNS 解析，也无法伪造 IP 地址，就有效的防止了伪装。



- SPF 的语法 

在自建邮件服务器的时候，经常会让我们设置一个 TXT 记录，配置值为 `v=spf1 mx ~all`，这表示的意思是允许当前域名的 MX 记录对应的 IP 地址。

下面再举个非常常见的例子：

````
v=spf1 a mx ip4:173.10.10.10 -all
````

表示允许当前域名配置的 A 记录，MX 记录的 IP 地址，以及一个额外的 IP 进行发信。



- SPF 存在的问题 

SPF 机制可以有效地规避了发送邮件方伪造发件人的问题。但实际使用的时候，如果你使用多个邮箱，然后设置了其中 [c@163.com](mailto:c@163.com) 邮箱自动转发到 [a@gmail.com](mailto:a@gmail.com) 中。


那么这个时候如果 `b@qq.com` QQ 邮箱发送了一封邮件到 `c@163.com` 邮箱，163 邮箱原封不动地将邮件转发到 Gmail 邮箱，这个时候发件人是 `b@qq.com`，但是 Gmail 回去查询 qq.com 的 SPF 记录，但会发现并不包含 163 邮箱的 IP 地址，会误判转发的邮件；所以又诞生了 DKIM。



**4.DKIM**



DKIM (DomainKeys Identified Mail) 的缩写，允许发送者通过在邮件的 header 中包含一段数字签名来验证邮件。DKIM 使用公私密钥来确保邮件内容是从授信的邮件服务器发送的。

还是利用上面的例子，因为我们把所有发送到 163 邮箱的邮件都转发到了 Gmail 邮箱，所以来自 QQ 邮箱的邮件在验证 SPF 时会失败。

那么在 DKIM 中，发送邮件的服务器，比如 QQ 邮箱，会使用公私钥对邮件内容进行签名，并将签名和邮件内容一起发送。当 Gmail 收到从 163 邮箱转发过来的 QQ 邮箱邮件的时候，就会去查询 `qq.com` 的 DNS 记录，拿到公钥。然后使用公钥和签名来验证邮件内容。如果验签不通过，则将邮件判定为伪造。



**5.DMARC**



经过了 SPF 和 DKIM 的保证,是不是就可以完美的发送接收邮件了?其实并不能，我们通过邮件后台来看一下邮件的原始文本。

````
MIME-Version: 1.0
Return-Path: xxx@fake.com
DKIM-Signature: d=fake.com,b=adceabkekd12
Date: Tue, 22 Mar 2022 06:37:58 +0000
Content-Type: multipart/alternative;
 boundary="--=_RainLoop_587_997816661.1647931078"
From: admin@a.com
Message-ID: <a67d96a38592cdad46cca89e98dda26d@techfm.club>
Subject: Seems it works
To: "Somebody" <a@gmail.com>


----=_RainLoop_587_997816661.1647931078
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

~~

----=_RainLoop_587_997816661.1647931078
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html><html><head><meta http-equiv=3D"Content-Type" content=3D"t=
ext/html; charset=3Dutf-8" /></head><body><div data-html-editor-font-wrap=
per=3D"true" style=3D"font-family: arial, sans-serif; font-size: 13px;"><=
br>~~<signature></signature></div></body></html>

----=_RainLoop_587_997816661.1647931078--

````

SPF 解决了接收方验证发件人域名 SPF 记录内 IP 地址从而验证发件人的问题。但是因为 SPF 定义的发件人是 RFC5321 协议中规定的 Return-Path，而 DKIM 在邮件头中直接包含了域名，只要使用该域名的公钥验证通过即可。



而现在的邮件服务给用户展示的发件人都是 From 字段，而不是 SPF 的 `Return-Path`，也不是 DKIM 的 `DKIM-Sginatur: d=`，所以攻击者可以通过伪造这两个字段，发送如上的邮件，完美通过 SPF 和 DKIM 检查，因为 SPF 检查 `Return-Path` 而 DKIM 验证的 `d=` 也是 `fake.com` 所以最终用户看到的发件人却是 `admin@q.com`。



所以就诞生了 DMARC。DMARC 结合了 SPF 和 DKIM，规定了 `Return-Path` 和 `DKIM-Signature: d=` 两个至少需要有一个与 From 头对应，否则判定为失败。



当邮件服务器接收到邮件时，先验证 DKIM，SPF，然后再根据 DMARC 的配置检查。这样就能确保最终用户看到的 `From` 字段和 SPF、DKIM 认证的发件人一致了。




