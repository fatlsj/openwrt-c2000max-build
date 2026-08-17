#!/bin/bash
# ============================================================
# diy-part1.sh - Pre-build customization (run before feeds update)
# Add custom package sources, clone external repos, etc.
# ============================================================
set -e

echo "=========================================="
echo " diy-part1.sh - Adding custom package feeds"
echo "=========================================="

# Add custom feed sources to feeds.conf.default if not already present
add_feed() {
    local feed_name="$1"
    local feed_url="$2"
    local feed_branch="$3"
    if ! grep -q "src-git ${feed_name}" feeds.conf.default; then
        echo "src-git ${feed_name} ${feed_url};${feed_branch}" >> feeds.conf.default
        echo "  + Added feed: ${feed_name}"
    else
        echo "  - Feed already exists: ${feed_name}"
    fi
}

add_feed "openclash" "https://github.com/vernesong/OpenClash.git" "master"
add_feed "qmodem" "https://github.com/FUjr/QModem.git" "main"
add_feed "modem" "https://github.com/Siriling/5G-Modem-Support.git" "main"
add_feed "kenzo" "https://github.com/kenzok8/openwrt-packages.git" "master"
add_feed "small" "https://github.com/kenzok8/small.git" "master"
add_feed "luci_tailscale" "https://github.com/asvow/luci-app-tailscale.git" "main"

echo ""
echo "diy-part1.sh completed."
