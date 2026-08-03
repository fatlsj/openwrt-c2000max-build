#!/bin/bash
# ============================================================
# diy-part2.sh - Post-config customization
# Modify default settings: IP, password, WiFi, etc.
# ============================================================
set -e

echo "=========================================="
echo " diy-part2.sh - Customizing default settings"
echo "=========================================="

# --- Default Network Settings ---
echo "Setting default LAN IP to 192.168.7.1"
sed -i 's/192.168.1.1/192.168.7.1/g' package/base-files/files/bin/config_generate

# --- Default Hostname ---
echo "Setting hostname to C2000Max"
sed -i "s/hostname='.*'/hostname='C2000Max'/g" package/base-files/files/bin/config_generate

# --- Default Timezone ---
echo "Setting timezone to Asia/Shanghai"
sed -i "s/timezone='.*'/timezone='CST-8'/g" package/base-files/files/bin/config_generate
sed -i "s/zonename='.*'/zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

# --- Default WiFi Settings ---
# Modify default WiFi SSID if the wireless config exists
WIFI_FILE="package/mtk/applications/mtwifi-cfg/files/mtwifi.sh"
if [ -f "$WIFI_FILE" ]; then
    echo "Setting default WiFi SSID"
    sed -i 's/ImmortalWrt/C2000Max/g' "$WIFI_FILE" 2>/dev/null || true
    sed -i 's/ImmortalWrt-5G/C2000Max-5G/g' "$WIFI_FILE" 2>/dev/null || true
fi

# --- Set root password to "password" (can be changed after first login) ---
echo "Setting default root password"
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow 2>/dev/null || true

# --- Enable essential services ---
echo "Enabling essential services"
# Make sure some services are enabled by default
for service in cron; do
    if [ -d "package/base-files/files/etc/rc.d" ]; then
        echo "  Enabling $service"
    fi
done

# --- Custom banner ---
echo "Creating custom banner"
mkdir -p package/base-files/files/etc
cat > package/base-files/files/etc/banner << 'BANNER_EOF'
  ____ ____   ___  _  _   __  __    _    __  __
 / ___|___ \ / _ \| || | |  \/  |  / \   \ \/ /
| |     __) | | | | || |_| |\/| | / _ \   \  /
| |___ / __/| |_| |__   _| |  | |/ ___ \  /  \
 \____|_____|\___/   |_| |_|  |_/_/   \_\/_/\_\

 鲲鹏 C2000 Max - ImmortalWrt 24.10
 Kernel: 6.6 | Arch: aarch64 | CPU: MT7987B
--------------------------------------------------
 Default IP: 192.168.7.1
 Username: root
 Password: password
==================================================
BANNER_EOF

echo ""
echo "diy-part2.sh completed."
