+++
title = "Windows二级菜单恢复及设置开机启动"
date = 2023-08-26

[taxonomies]
tags = ["Windows11"]
+++

前言 Windows操作系统作为全球最为普及的桌面操作系统之一，其用户界面的设计非常经典；而win11中的二级菜单令人感到无语，本文教你回到一级菜单。

<!-- more -->

## **使用CMD恢复完整右键菜单**

Win11的`显示更多选项`怎么设置才能将其关闭,并恢复成Win10的状态呢？系统内置的命令提示符（CMD）可以帮助我们完成这一任务，另外请注意，此操作仅适用于CMD，并不适用于Windows PowerShell。

**步骤1.** 按**Win+S**打开搜索框，输入**cmd**并以管理员身份运行命令提示符。

**步骤2.** 输入以下命令并按**Enter**键执行。

```
reg add HKCU\Software\Classes\CLSID{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32 /ve /d “” /f
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