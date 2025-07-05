+++
title = "Windows系列(4):封装与全自动安装"
date = 2024-05-29

[taxonomies]
tags = ["Windows"]
+++

前言 由于厂商默认安装windows家庭版导致各种问题频发,这里作者封装了一个开箱即用的，全自动安装，激活和优化的Windows11镜像。
<!-- more -->

**Dich-OS base on zh-cn_windows_11_business_23h2**

**实现了以下功能**:

- [x] 绕过 Windows 11 要求检查(TPM/安全启动等)
- [x] 允许在没有互联网连接的情况下安装 Windows 11
- [x] 随机生成的计算机名称,例如:DESKTOP-ZFAH8Z2
- [x] 在OOBE阶段自动激活Windows(专业工作站版本)
- [x] 禁用 Windows 更新*
- [x] 删除了默认应用程序*
- [x] 禁用 Windows Defender
- [x] 在 Windows 11 中使用经典菜单，而不是二级菜单
- [x] 始终显示文件扩展名
- [x] 打开文件资源管理器到'此电脑'而不是'快速访问'
- [x] 任务栏中隐藏搜索框,Task view 和小部件 
- [x] 用户密码不会过期
- [x] 强化 ACL
- [x] 禁用快速启动
- [x] 启用长路径
- [x] 启用远程桌面服务 (RDP)
- [x] 阻止 Windows Update 重新启动您的计算机* 
- [x] 阻止设备 BitLocker 加密
- [x] 删除空 C:\Windows.old 文件夹 
- [x] 自动将ISO中的Source\$OEM$\Setup\Scripts\Files文件夹中的软件放到桌面*
- [x] 保留Windows 安装过程中以交互方式对磁盘进行分区 
- [x] 保留在 Windows 安装过程中以交互方式添加本地（“脱机”）用户

**PS**:
- 禁用自动更新是创建一个名为 PauseWindowsUpdate 的计划任务,一次又一次地暂停更新一周.如果要运行 Windows 更新一次,请单击 “设置”中的“恢复更新 ”.

- 删除默认应用程序,但保留了记事本,照片,PowerShell,Windows Terminal ,Windows Media Player (classic) ,Calculator , Clock , Xbox Apps(游戏手柄用)

- 这会创建一个计划任务,诱使 Windows 认为设备一直在使用中,即使更新也不会突然关机.

- 可以将要用的软件安装包放入该文件夹中,会自动放到桌面.

**感谢以下项目**:

- [unattend-generator](https://github.com/cschneegans/unattend-generator/)

- [HEU_KMS_Activator](https://github.com/zbezj/HEU_KMS_Activator)

- [Microsoft-Activation-Scripts](https://github.com/massgravel/Microsoft-Activation-Scripts)

**SHA-256:5920ca1b839c2823cad5223cdff39671784d98d18da03fa4377a362ad480ce54**

**下载链接：**[这里](https://drive.google.com/file/d/1CWXtHJRmDaGYVV7k9mRsn1cDxIwomavO/view?usp=drive_link)
