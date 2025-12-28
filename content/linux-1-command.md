+++
title = "Linux-命令行操控"
date = 2023-07-20

[taxonomies]
tags = ["Linux"]
+++

前言 本文基于常见发行版（systemd + NetworkManager + PipeWire/ PulseAudio / ALSA）,目标是把常见的桌面/笔记本硬件（Wi-Fi、蓝牙、亮度、音量）通过命令行可复现、可理解地组织起来。

<!-- more -->

# Wifi 控制

现代桌面大多使用 NetworkManager 管理网络，`nmcli` 是其命令行接口。`nmcli` 能列出可用网络、连接/断开、创建配置文件（包括 WPA/WPA2/PSK、enterprise）等。相比直接编辑 wpa_supplicant 配置，`nmcli` 更安全、统一，能与 GUI 保持一致。

### 常用命令

列出接口及设备状态：

```bash
nmcli device status
```

列出附近 Wi-Fi（SSID、信号强度、安全类型）：

```bash
nmcli device wifi list
```

交互式连接（会提示输入密码）：

```bash
nmcli device wifi connect "wifi-2.4G" --ask
```

不交互式连接（将密码放在命令里 — 注意安全风险）：

```bash
nmcli device wifi connect "wifi-2.4G" password "your_password"
```

基于已有配置文件连接（例如创建一个保存的 connection 名称）：

```bash
# 创建连接（自动选择设备）
nmcli connection add type wifi ifname wlan0 con-name my-home ssid "wifi-2.4G" \
  wifi-sec.key-mgmt wpa-psk wifi-sec.psk "your_password"

# 启用连接
nmcli connection up my-home
```

断开或禁用接口：

```bash
# 断开当前连接
nmcli device disconnect wlan0

# 禁用设备（软禁用）
nmcli device set wlan0 managed no
```

查看连接详情：

```bash
nmcli -f all connection show my-home
nmcli device show wlan0
```

---

# 蓝牙控制

Linux 上常见蓝牙栈为 BlueZ（蓝牙守护 `bluetoothd`），`bluetoothctl` 提供交互式 CLI。音频设备通常通过 BlueZ + PulseAudio（或 PipeWire）进行音频路由；配对/信任步骤必须完成才能稳定连接音频/键盘/鼠标等设备。

### 一、蓝牙服务与模块启用/禁用

启用蓝牙服务（systemd）：

```bash
sudo systemctl enable --now bluetooth.service
```

打开蓝牙适配器电源：

```bash
bluetoothctl power on
```

打开配对代理（用于交互式配对）并设置为默认：

```bash
bluetoothctl agent on
bluetoothctl default-agent
```

开启可发现（让其它设备能扫描到）：

```bash
bluetoothctl discoverable on
```

重启蓝牙服务（排错常用）：

```bash
sudo systemctl restart bluetooth
sudo journalctl -u bluetooth -f
```

> 注意：某些发行版在使用 PipeWire 做音频时还需要 `pipewire` / `wireplumber` 正确运行，否则音频通道（A2DP/HFP）无法建立。

### 二、查看设备与状态

```bash
# 列出本机所有蓝牙适配器
bluetoothctl list

# 查看本地适配器详细状态
bluetoothctl show

# 查看已配对设备
bluetoothctl paired-devices

# 查看某个设备详情（包括 UUID、已连接服务）
bluetoothctl info AA:BB:CC:DD:EE:FF
```

### 三、交互式配对与连接

交互式步骤（在 `bluetoothctl` 提示符下）：

```bash
$ bluetoothctl
[bluetooth]# power on
[bluetooth]# agent on
[bluetooth]# default-agent
[bluetooth]# scan on
# 等待几秒，看到目标设备（并记录 MAC）
[bluetooth]# pair AA:BB:CC:DD:EE:FF
# 如果是需要 PIN 的设备，会提示配对码；确认或输入即可
[bluetooth]# trust AA:BB:CC:DD:EE:FF    # 使系统信任设备（开机后自动连接）
[bluetooth]# connect AA:BB:CC:DD:EE:FF
[bluetooth]# exit
```

### 四、断开与删除设备

断开连接：

```bash
bluetoothctl disconnect AA:BB:CC:DD:EE:FF
```

删除配对信息（“忘记设备”）：

```bash
bluetoothctl remove AA:BB:CC:DD:EE:FF
```

### 五、蓝牙软/硬封锁

查看封锁状态：

```bash
rfkill list bluetooth
```

封锁（禁用）：

```bash
sudo rfkill block bluetooth
```

解封（启用）：

```bash
sudo rfkill unblock bluetooth
```

如果设备被**硬封锁**（硬件开关），软件方法无效，需要物理开关或 BIOS 设置。


### 六、音频输出切换

* 现代发行版多用 PipeWire 替代 PulseAudio，但 PipeWire 提供兼容接口，因此 `pactl`（PulseAudio 控制工具）在很多系统仍然可用。
* 蓝牙设备会在连接后生成类似 `bluez_output.XX_XX_XX_XX_XX_XX.a2dp_sink` 的 sink 名称；有时名称会略有差异，建议先查询。

列出 sinks（输出设备）：

```bash
pactl list short sinks
```

设置默认输出为蓝牙耳机（示例）：

```bash
pactl set-default-sink bluez_output.XX_XX_XX_XX_XX_XX.a2dp_sink
```

把当前正在播放的流移动到蓝牙设备：

```bash
pactl list short sink-inputs         # 找到输入编号
pactl move-sink-input <输入编号> bluez_output.XX_XX_XX_XX_XX_XX.a2dp_sink
```

如果使用 PipeWire，遇到连接但没有声音的问题：

* 确保 `wireplumber` 或 `pipewire-media-session` 正常运行。
* 检查 profile（A2DP vs HFP）：A2DP 提供高音质但不可通话，HFP 可通话但质量较低。可通过 `pactl list cards` / `pactl set-card-profile` 调整。

---

# 亮度控制

笔记本屏幕亮度通常由内核暴露的 SysFS 接口 `/sys/class/backlight/*/brightness` 提供，写入该文件需要 root 权限或合适的权限（udev 规则）。桌面显示器、USB 显卡或 Wayland（特别是 wlroots）环境可能不会使用该接口，需要使用专门工具（如 `light`、`brightnessctl`、或 DE/Compositor 提供的接口）。

### 一、SysFS（多数笔记本适用）

查看最大亮度值与当前亮度：

```bash
cat /sys/class/backlight/*/max_brightness
cat /sys/class/backlight/*/brightness
```

设置亮度（需要 root）：

```bash
# 写入数值（0~max_brightness）
echo 5 | sudo tee /sys/class/backlight/*/brightness

# 或者重定向（注意 sudo 的作用域）
sudo sh -c 'echo 5 > /sys/class/backlight/*/brightness'
```

如果遇到 “权限被拒绝”：

* 使用 `sudo tee` 或 `sudo sh -c`；或添加 udev 规则给某个用户写权限。
* 在某些内核/驱动下，背光接口名称可能不同（`intel_backlight`、`amdgpu_bl0` 等）。

### 二、brightnessctl

`brightnessctl` 是一个用户友好、支持百分比与设备选择的工具。

安装：

* Debian/Ubuntu:

```bash
sudo apt install brightnessctl
```

* Arch:

```bash
sudo pacman -S brightnessctl
```

用法示例：

```bash
brightnessctl info       # 显示当前设备信息
brightnessctl get        # 当前亮度
brightnessctl max        # 最大亮度
brightnessctl set +10%   # 增加 10%
brightnessctl set 50%    # 设为 50%
```

---


# 音量控制

Linux 下有几层音量控制：硬件（ALSA）、中间层（PulseAudio / PipeWire）、用户层（桌面音量控制器）。常用命令行工具：`pactl`（PulseAudio / PipeWire）、`pamixer`（PulseAudio 前端）、`amixer`（ALSA 原生）。


### 一、pactl（PulseAudio / PipeWire）

查看 sinks：

```bash
pactl list short sinks
```

查看默认 sink：

```bash
pactl info | grep 'Default Sink'
```

设置默认音量：

```bash
pactl set-sink-volume @DEFAULT_SINK@ 50%
```

增量调节：

```bash
pactl set-sink-volume @DEFAULT_SINK@ +5%
pactl set-sink-volume @DEFAULT_SINK@ -5%
```

静音/取消静音/切换：

```bash
pactl set-sink-mute @DEFAULT_SINK@ 1
pactl set-sink-mute @DEFAULT_SINK@ 0
pactl set-sink-mute @DEFAULT_SINK@ toggle
```

移动播放流（见蓝牙章节）：

```bash
pactl list short sink-inputs
pactl move-sink-input <输入编号> <目标-sink>
```

### 二、amixer（ALSA）

列出通道与当前值：

```bash
amixer sget Master
```

设置音量（绝对 / 相对）：

```bash
amixer sset Master 50%     # 绝对值
amixer sset Master 5%+     # 增加
amixer sset Master 5%-     # 减少
```

静音：

```bash
amixer set Master mute
amixer set Master unmute
amixer set Master toggle
```

> 当使用 PipeWire/PulseAudio 时，`amixer` 仍然可以操作底层硬件，但用户可听到的效果可能被上层音量（PulseWire/PulseAudio）覆盖。

### 三、pamixer（PulseAudio）

简洁的命令行前端，适合脚本：

```bash
pamixer --get-volume
pamixer --set-volume 40
pamixer --increase 5
pamixer --decrease 5
pamixer --toggle-mute
```

---
**Done.**
