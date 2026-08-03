# OpenWrt 项目记忆

## 设备
- 鲲鹏 C2000 Max
- SoC: MediaTek MT7987 (ARM Cortex-A53, aarch64)
- WiFi: WiFi 7 BE3600 (MT799x)
- 5G 模组: 海思巴龙 MT5700M

## 编译方案
- 源码：padavanonly/immortalwrt-mt798x-6.6，分支 mt798x-mt799x-6.6-mtwifi
- 方式：GitHub Actions 云编译（无本地 Docker）
- 内核 6.6 + 闭源 WiFi 驱动

## 功能
- 科学上网：OpenClash
- 广告过滤：AdGuard Home
- NAS：Samba4 + Aria2 + USB 存储
