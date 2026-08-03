# 鲲鹏 C2000 Max — ImmortalWrt 固件编译

基于 [padavanonly/immortalwrt-mt798x-6.6](https://github.com/padavanonly/immortalwrt-mt798x-6.6) `mt798x-mt799x-6.6-mtwifi` 分支，使用 GitHub Actions 云端自动编译。

## 硬件参数

| 项目 | 参数 |
|------|------|
| 设备 | 鲲鹏 C2000 Max (NRadio C2000-788) |
| SoC | MediaTek MT7987B (ARM Cortex-A53, aarch64) |
| RAM / Flash | 512MB DDR / 32MB SPI NAND |
| WiFi | WiFi 7 BE3600 (MT7992, 闭源驱动) |
| 5G 模组 | 海思巴龙 MT5700M-CN |
| 网口 | 1× 2.5G WAN/LAN |
| 存储 | TF 卡槽（固件启动必需） |

## 预装功能

| 功能 | 插件 |
|------|------|
| 🌐 科学上网 | OpenClash |
| 🛡️ 广告过滤 | AdGuard Home |
| 📁 NAS/共享 | Samba4, Aria2, FileBrowser, DiskMan |
| 📶 5G 管理 | QModem, luci-app-modem |
| 🔧 网络工具 | DDNS, UPnP, Turbo ACC, Wake-on-LAN |
| 📊 系统 | htop, ttyd 终端, 流量统计, 自动重启 |

**后台地址**: `http://192.168.7.1` | **用户名**: `root` | **密码**: `password`

## 快速开始（云编译）

### 1. Fork 本仓库

点击右上角 **Fork** 按钮，将仓库复制到你的 GitHub 账号下。

### 2. 触发编译

1. 进入你 fork 的仓库 → **Actions** 标签页
2. 左侧选择 **Build C2000 Max Firmware**
3. 右侧点击 **Run workflow** → 绿色 **Run workflow** 按钮
4. 等待编译完成（约 2-3 小时）

### 3. 下载固件

编译完成后：
1. 进入 Actions 中完成的 workflow run
2. 页面底部 **Artifacts** → 点击 **C2000Max-ImmortalWrt-Firmware** 下载
3. 解压得到固件文件

## 刷入 C2000 Max

### 准备工作
- 一张 TF 卡（建议 8GB 以上）
- 读卡器（方式一）或直接 TF 卡插入设备（方式二）

### 方式一：使用 Rufus 写入（Windows）

1. 下载 [Rufus](https://rufus.ie/)
2. TF 卡插入读卡器连接电脑
3. 打开 Rufus，选择 TF 卡 → 选择下载的固件镜像
4. 点击"开始"写入
5. 完成后将 TF 卡插入 C2000 Max

### 方式二：在设备上直接制作（无需读卡器）

1. TF 卡插入 C2000 Max
2. 进入原厂后台 → 更多 → 启动盘制作
3. 上传解压后的固件文件
4. 完成制作后，设置 SD 卡优先启动

### 启动 OpenWrt

1. 进入原厂后台 → 系统启动设置 → 选择 **SD 卡优先**
2. 重启设备
3. 等待 2-3 分钟，WiFi 信号出现
4. 访问 `http://192.168.7.1`

## 自定义配置

### 修改预装插件

编辑 `configs/c2000max-packages.seed`，添加或删除 `CONFIG_PACKAGE_*=y` 行。

常用插件名参考：
```ini
# 代理工具
CONFIG_PACKAGE_luci-app-passwall=y         # PassWall
CONFIG_PACKAGE_luci-app-ssr-plus=y         # SSR-Plus
CONFIG_PACKAGE_luci-app-openclash=y        # OpenClash

# 广告过滤
CONFIG_PACKAGE_luci-app-adguardhome=y      # AdGuard Home

# NAS
CONFIG_PACKAGE_luci-app-samba4=y           # Samba 文件共享
CONFIG_PACKAGE_luci-app-aria2=y            # Aria2 下载
CONFIG_PACKAGE_luci-app-transmission=y     # BT 下载

# 5G 模组
CONFIG_PACKAGE_qmodem=y                    # QModem
CONFIG_PACKAGE_luci-app-modem=y            # 模组管理界面

# 网络
CONFIG_PACKAGE_luci-app-ddns=y             # 动态 DNS
CONFIG_PACKAGE_luci-app-upnp=y             # UPnP

# 工具
CONFIG_PACKAGE_luci-app-ttyd=y             # Web 终端
CONFIG_PACKAGE_luci-app-filebrowser=y      # 文件浏览器
```

### 修改默认设置

编辑 `diy-part2.sh`，可修改：
- 默认 LAN IP（默认 `192.168.7.1`）
- WiFi SSID（默认 `C2000Max` / `C2000Max-5G`）
- root 密码
- 时区
- 开机自启服务

### 添加第三方插件源

编辑 `diy-part1.sh`，使用 `add_feed` 函数添加：
```bash
add_feed "插件名" "https://github.com/xxx/yyy.git" "分支名"
```

## 项目结构

```
.
├── .github/workflows/build.yml    # GitHub Actions 编译流程
├── configs/
│   └── c2000max-packages.seed      # 自定义软件包选择
├── diy-part1.sh                    # 编译前：添加第三方软件源
├── diy-part2.sh                    # 编译后：修改默认设置
├── feeds.conf.default              # Feeds 软件源配置
└── README.md
```

## 技术参数

| 项目 | 值 |
|------|-----|
| 源码 | padavanonly/immortalwrt-mt798x-6.6 |
| 分支 | mt798x-mt799x-6.6-mtwifi |
| 基础配置 | defconfig/mt7987_mt7992.config |
| 内核版本 | Linux 6.6 |
| 目标平台 | mediatek/filogic |
| CPU 架构 | aarch64_cortex-a53 |
| WiFi 方案 | MT7992 闭源驱动 (mtwifi) |

## 常见问题

**Q: 编译失败怎么办？**
A: 重新触发 Run workflow，勾选 "Clean build" 选项清除缓存。如果仍失败，检查 `configs/c2000max-packages.seed` 中的包名是否正确。

**Q: 固件太大怎么办？**
A: 删除 `c2000max-packages.seed` 中不需要的包，减少预装插件。

**Q: 如何切换回原厂系统？**
A: 在原厂后台 → 系统启动设置 → 选择内部存储优先，重启即可。

**Q: 如何获得更新？**
A: 源码更新后，在你的 fork 仓库中 Sync fork，然后重新触发编译。

## 参考资源

- [ImmortalWrt-mt798x 项目](https://github.com/padavanonly/immortalwrt-mt798x-6.6)
- [OpenClash](https://github.com/vernesong/OpenClash)
- [QModem](https://github.com/FUjr/QModem)
- [5G Modem Support](https://github.com/Siriling/5G-Modem-Support)
- [恩山论坛 C2000 Max 固件](https://www.right.com.cn/forum/thread-8465085-1-1.html)
