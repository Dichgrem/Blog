+++
title = "乱七八糟:Windows常用操作"
date = 2024-05-24

[taxonomies]
tags = ["乱七八糟","Windows"]
+++

前言 Windows操作系统作为全球最为普及的桌面操作系统之一，其用户界面的设计非常经典，但存在许多不足之处，本篇记录一些常用脚本。

<!-- more -->

## **Windows11跳过联网激活 & 使用本地账号**


开机之前，先断网，然后输入Shift+F10，会弹出命令行界面，并输入
``
oobe\BypassNRO.cmd：
``
回车之后会重启，之后就可以跳过联网了，选择
``
I don't have internet
``
即可。

## 激活windows

```
irm https://get.activated.win | iex
```

## **Win11关闭自动更新**

1.按Win+I打开Windows设置页面。

2.单击“更新和安全”>“Windows更新”，然后在右侧详情页中选择“暂停更新7天”选项即可在此后7天内关闭Windows更新。

3.使用脚本彻底关闭更新
```
::Windows auomatic updates
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AutoInstallMinorUpdates /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoUpdate /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AUOptions /t REG_DWORD /d 4 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 4 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v DisableWindowsUpdateAccess /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v ElevateNonAdmins /t REG_DWORD /d 0 /f
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoWindowsUpdate /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\Internet Communication Management\Internet Communication" /v DisableWindowsUpdateAccess /t REG_DWORD /d 0 /f
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate /v DisableWindowsUpdateAccess /t REG_DWORD /d 0 /f
sc stop wuauserv
sc config wuauserv start=disabled
sc stop WaaSMedicSvc
sc config WaaSMedicSvc start=disabled
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\InstallService\State /v AutoUpdateLastSuccessTime /t REG_SZ /d "2100-01-01T00:00:00+08:00" /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v PauseFeatureUpdatesStartTime /t REG_SZ /d "2100-01-01T00:00:00Z" /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v PauseQualityUpdatesStartTime /t REG_SZ /d "2100-01-01T00:00:00Z" /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v PauseUpdatesExpiryTime /t REG_SZ /d "2100-01-01T00:00:00Z" /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v PauseFeatureUpdatesEndTime /t REG_SZ /d "2100-01-01T00:00:00Z" /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v PauseQualityUpdatesEndTime /t REG_SZ /d "2100-01-01T00:00:00Z" /f
```
将以上命令保存为.bat文件，运行即可。
```
::Windows auomatic updates
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AutoInstallMinorUpdates /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoUpdate /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AUOptions /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 4 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v DisableWindowsUpdateAccess /t REG_DWORD /d 1 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v ElevateNonAdmins /t REG_DWORD /d 1 /f
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoWindowsUpdate /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\Internet Communication Management\Internet Communication" /v DisableWindowsUpdateAccess /t REG_DWORD /d 1 /f
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate /v DisableWindowsUpdateAccess /t REG_DWORD /d 1 /f
sc config wuauserv start=auto
sc start wuauserv
sc config WaaSMedicSvc start=auto
sc start WaaSMedicSvc
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\InstallService\State /v AutoUpdateLastSuccessTime /t REG_SZ /d "2000-01-01T00:00:00+08:00" /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v PauseFeatureUpdatesStartTime /t REG_SZ /d "2000-01-01T00:00:00Z" /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v PauseQualityUpdatesStartTime /t REG_SZ /d "2000-01-01T00:00:00Z" /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v PauseUpdatesExpiryTime /t REG_SZ /d "2000-01-01T00:00:00Z" /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v PauseFeatureUpdatesEndTime /t REG_SZ /d "2000-01-01T00:00:00Z" /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings /v PauseQualityUpdatesEndTime /t REG_SZ /d "2000-01-01T00:00:00Z" /f
pause
```
以上为恢复更新的脚本。

## **使用CMD恢复完整右键菜单**

Win11的`显示更多选项`怎么设置才能将其关闭,并恢复成Win10的状态呢？系统内置的命令提示符（CMD）可以帮助我们完成这一任务，另外请注意，此操作仅适用于CMD，并不适用于Windows PowerShell。

**步骤1.** 按**Win+S**打开搜索框，输入**cmd**并以管理员身份运行命令提示符。

**步骤2.** 输入以下命令并按**Enter**键执行。

```
reg add HKCU\Software\Classes\CLSID{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /ve /d “” /f
```
或者
```
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
taskkill /f /im explorer.exe 
start explorer.exe
```
注意：如果您想要重新打开Win11新样式的右键菜单的话，以同样的方式在命令提示符中执行此命令：
```
reg delete "HKCU\Software\Classes\CLSID{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
```


## **Win11添加开机自启动项方法**

选择“开始”按钮 ，然后滚动查找你希望在启动时运行的应用。

右键单击该应用，选择“更多”，然后选择“打开文件位置”。此操作会打开保存应用快捷方式的位置。如果没有“打开文件位置”选项，这意味着该应用无法在启动时运行。

文件位置打开后，按win+ R，键入“shell:startup”，然后选择“确定”。这将打开“启动”文件夹。

将该应用的快捷方式从文件位置复制并粘贴到“启动”文件夹中,即添加启动项成功。

## Windows 指定时间服务器&&开机自动校准

- 打开日期和时间设置：
右键点击任务栏上的时间，选择 "调整日期/时间"。
在 日期和时间 窗口中，点击 "互联网时间" 标签。

- 选择时间服务器：
点击 "更改设置…" 按钮。
在弹出的对话框中，勾选**同步时钟与 Internet 时间服务器**，然后在 "服务器" 输入框中填写你想要的时间服务器，例如：
time.windows.com（微软默认服务器）
time.nist.gov（美国国家标准技术研究院的时间服务器）
pool.ntp.org（一个公共的 NTP 时间服务器池）

- 应用更改：点击 "更新现在"，然后 "确定" 保存设置。

Windows 会默认每隔一段时间（大约一周）同步时间，但如果你想确保系统在开机时自动同步时间，可以通过以下方法：

- 打开任务计划程序：
在开始菜单中搜索 "任务计划程序" 并打开。
- 创建新任务：
在右侧点击 "创建基本任务"。
输入任务名称（例如：“时间同步”），点击 下一步。
- 选择触发器：
选择 "当计算机启动时"，然后点击 下一步。
- 设置操作：
选择 "启动程序"，点击 下一步。
在 "程序或脚本" 中输入 cmd，在 "添加参数" 中输入：
```
/c w32tm /resync
```
这条命令会在开机时触发 Windows 时间服务同步。
- 完成设置：点击 完成，即可。

- 如果有linux/win双系统，可以让 Windows 使用 UTC 作为硬件时钟时间：
```
# 在 Windows 中以管理员权限运行命令提示符，执行：
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /t REG_DWORD /d 1 /f
```

## 调整网络优先级

- 查看当前优先级（PowerShell/管理员）
```
Get-NetIPInterface
```
你会看到类似：
```
IfIndex  InterfaceMetric   InterfaceAlias
-------  --------------   --------------
15       25              Wi-Fi
3        15              以太网

# InterfaceMetric 值越小，优先级越高。
```
- 修改网络优先级

将有线网络（以太网） 设为更高优先级（值更小）：
```
Set-NetIPInterface -InterfaceIndex 3 -InterfaceMetric 10
```
- 将 WiFi 设为更低优先级：
```
Set-NetIPInterface -InterfaceIndex 15 -InterfaceMetric 25
```
- 重启网络
```
Restart-NetAdapter -Name "以太网"
```
这样，当网线插入时，Windows 会优先使用有线网络；断开网线后，自动切换到 WiFi。


- 如需永久设置，可修改注册表：

Win + R 输入 regedit 打开注册表编辑器，进入路径：
```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces
```
在 Interfaces 里找到你的有线网卡和无线网卡（可以根据 IP 或 MAC 地址确认）。

- 创建/修改 Metric 值：
```
有线网卡（Ethernet）：设为 10
无线网卡（WiFi）：设为 25
```
重启电脑生效。

---
**Done.**