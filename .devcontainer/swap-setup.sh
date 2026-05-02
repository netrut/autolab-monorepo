#!/bin/bash
# ============================================================
# Swap Memory Setup — runs on every Codespace start/restart
# ============================================================
# Allocates 8GB swap on /tmp (separate 44GB disk, not root)
# Prevents OOM kills during Next.js/Turbopack compilation
# ============================================================

SWAP_FILE=/tmp/swapfile
SWAP_SIZE=8G

# Create swap file if it doesn't exist (e.g. after full rebuild)
if [ ! -f "$SWAP_FILE" ]; then
    echo "[swap] Creating ${SWAP_SIZE} swap file at ${SWAP_FILE}..."
    fallocate -l $SWAP_SIZE $SWAP_FILE 2>/dev/null || \
        dd if=/dev/zero of=$SWAP_FILE bs=1M count=8192 status=none
    chmod 600 $SWAP_FILE
    mkswap $SWAP_FILE > /dev/null
    echo "[swap] Swap file created."
fi

# Enable swap if not already active
if ! swapon --show | grep -q "$SWAP_FILE"; then
    swapon $SWAP_FILE
    echo "[swap] Swap enabled."
else
    echo "[swap] Swap already active."
fi

# Tune kernel memory settings (requires root, skip if not available)
if [ "$(id -u)" = "0" ]; then
    sysctl -w vm.swappiness=60 > /dev/null
    sysctl -w vm.vfs_cache_pressure=50 > /dev/null
else
    sudo sysctl -w vm.swappiness=60 > /dev/null 2>&1 || true
    sudo sysctl -w vm.vfs_cache_pressure=50 > /dev/null 2>&1 || true
fi

echo "[swap] Done. $(free -h | grep Swap)"
