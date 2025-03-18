+++
title = "乱七八糟:GFS项目考量笔记"
date = 2025-03-18

[taxonomies]
tags = ["乱七八糟"]
+++

前言 最近nekoray项目归档,考量新的singbox前端时发现这个项目不错,不过在Arch linux中运行有一些小问题,这里做个总结。

<!-- more -->

## 安装最新版:

安装gui-for-singbox的时候发现仓库的1.9.2版本release被作者删除,无法安装,于是：

- 在AUR仓库中下载**aur-gui-for-singbox.tar.gz**,解压进入aur-gui-for-singbox目录;
- **更改.SRCINFO文件**,使其版本号为最新;
- **使用makepkg -si构建并安装**这个包,缺少的png图片可以直接下载并放进目录;
- 如果有错误**刷新密钥环**（sudo pacman-key --refresh-keys）;

## 无法打开/无法使用TUN模式:
- 安装成功,进入``/opt/gui-for-singbox``,运行``sudo chown -R your_username:your_group /opt/gui-for-singbox``,使其可以被非root用户启动;
- 执行``sudo setcap cap_net_bind_service,cap_net_admin,cap_dac_override=+ep /opt/gui-for-singbox/your_executable``命令,并在设置-内核中点击盾牌-钥匙图标,使Tun模式可以有特权运行。

## 免密码运行TUN模式:

- 检查 polkit 服务是否正在运行
```
systemctl status polkit
```
- 若返回状态为除 active (running) 之外的结果,运行
```
sudo systemctl enable --now polkit
```
- 创建 polkit 策略
```
sudo vi /etc/polkit-1/rules.d/99-nopassword.rules
```
- 添加以下内容并保存退出
```
polkit.addRule(function (action, subject) {
  if (
    (action.id == "org.freedesktop.resolve1.set-domains" ||
      action.id == "org.freedesktop.resolve1.set-default-route" ||
      action.id == "org.freedesktop.resolve1.set-dns-servers") &&
    subject.local &&
    subject.active &&
    subject.isInGroup("wheel")
  ) {
    return polkit.Result.YES;
  }
});
```
- 将当前用户添加至 wheel 组中,注意Debian 与衍生系统需要先创建 wheel 组,然后运行：
```
sudo usermod -G wheel 当前用户
```
- 重新加载 polkit 使更改生效
```
sudo systemctl restart polkit
```

---
**Done.**