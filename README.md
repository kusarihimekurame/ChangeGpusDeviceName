# ChangeGpusDeviceName

English | 简体中文

---

## Introduction / 简介

A PowerShell tool that changes the GPU DeviceDesc registry value, allowing some AMD GPUs to be detected as an NVIDIA GeForce RTX 4090.

This tool was created to enable Ray Tracing in Zenless Zone Zero on AMD GPUs.

一个用于修改显卡 DeviceDesc 注册表值的 PowerShell 工具，可将部分 AMD 显卡伪装为 NVIDIA GeForce RTX 4090。

本工具主要用于让 AMD 显卡能够在《绝区零（Zenless Zone Zero）》中开启光线追踪（Ray Tracing）。

---

## Features / 功能

* Automatically backs up the original DeviceDesc value
* Changes DeviceDesc to NVIDIA GeForce RTX 4090
* Restores the original GPU name at any time
* Simple menu-driven interface
* No third-party dependencies

---

* 自动备份原始 DeviceDesc 值
* 将 DeviceDesc 修改为 NVIDIA GeForce RTX 4090
* 随时恢复原始显卡名称
* 菜单式操作界面
* 无第三方依赖

---

## Requirements / 运行要求

* Windows 10 / Windows 11
* PowerShell 5.1 or later
* Administrator privileges

---

* Windows 10 / Windows 11
* PowerShell 5.1 及以上版本
* 管理员权限

---

## Usage / 使用方法

Run PowerShell as Administrator:

以管理员身份运行 PowerShell：

```powershell
.\ChangeGpusDeviceName.ps1
```

```powershell
.\ChangeGpusDeviceName_CN.ps1
```

Menu:

菜单：

```text
1. Switch to NVIDIA mode
2. Restore original GPU name
3. Exit
```

---

## How It Works / 工作原理

When switching:

* The current DeviceDesc value is backed up to DeviceDesc_Backup.
* DeviceDesc is changed to NVIDIA GeForce RTX 4090.

When restoring:

* The original value is read from DeviceDesc_Backup.
* DeviceDesc is restored.

---

切换时：

* 当前 DeviceDesc 自动备份到 DeviceDesc_Backup。
* DeviceDesc 修改为 NVIDIA GeForce RTX 4090。

恢复时：

* 从 DeviceDesc_Backup 读取原始值。
* 恢复原来的 DeviceDesc。

---

## Warning / 风险提示

This tool modifies registry entries under:

本工具会修改以下注册表项：

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum

Incorrect usage may cause driver-related issues.

Use at your own risk.

---

错误操作可能导致驱动异常或设备识别问题。

使用本工具即表示您愿意自行承担相关风险。

建议在使用前创建系统还原点或备份注册表。

---

## Disclaimer / 免责声明

This project is provided for educational and research purposes only.

The author is not responsible for any damage, data loss, or system issues caused by the use of this software.

---

本项目仅供学习与研究使用。

作者不对因使用本工具造成的任何损失承担责任。

---

## License

MIT License
