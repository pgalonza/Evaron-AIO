#!/bin/bash

set -o errexit
set -o xtrace
set -o pipefail

# ── Helpers ────────────────────────────────────────────────────────────────────

die() {
    echo "ERROR: $*" >&2
    exit 1
}

partition_suffix() {
    local dev="$1"
    if [[ $dev =~ [0-9]$ ]]; then
        echo "p"
    fi
}

# ── Device Detection ───────────────────────────────────────────────────────────

sudo parted -l 2>/dev/null || true

read -r -p "Select device (e.g. sdb, mmcblk0): " DEVICE_BLOCK
DEVICE_PATH="/dev/$DEVICE_BLOCK"

[[ -b "$DEVICE_PATH" ]] || die "$DEVICE_PATH is not a block device"

DEVICE_MODEL=$(sudo parted "$DEVICE_PATH" unit B print 2>/dev/null | grep -i "model" || echo "unknown")
DEVICE_SIZE=$(sudo blockdev --getsize64 "$DEVICE_PATH")

echo "Selected: $DEVICE_PATH ($DEVICE_MODEL, $((DEVICE_SIZE / 1024**3)) GiB)"
read -r -p "WARNING: All data on $DEVICE_PATH will be destroyed. Type YES to continue: " CONFIRM
[[ "$CONFIRM" == "YES" ]] || die "Aborted by user"

# ── EmuNAND Size ───────────────────────────────────────────────────────────────

read -r -p "EmuNAND size in GB: " EMUNAND_SIZE_GB
EMUNAND_SIZE_BYTES=$((EMUNAND_SIZE_GB * 1024**3))

[[ $EMUNAND_SIZE_BYTES -gt 0 ]] || die "EmuNAND size must be positive"
[[ $EMUNAND_SIZE_BYTES -lt $DEVICE_SIZE ]] || die "EmuNAND size ($EMUNAND_SIZE_GB GiB) exceeds or equals SD card size ($((DEVICE_SIZE / 1024**3)) GiB)"

# ── Partition Constants ────────────────────────────────────────────────────────

OFFSET=$((1024**2))                    # 1 MiB
CLUSTER_SIZE=$((64 * 1024))           # 64 KiB
CLUSTER_SECTORS=$((CLUSTER_SIZE / 512))
SUFFIX=$(partition_suffix "$DEVICE_BLOCK")

# ── Destroy Existing Partitions ────────────────────────────────────────────────

sudo umount "${DEVICE_PATH}${SUFFIX}1" 2>/dev/null || true
sudo umount "${DEVICE_PATH}${SUFFIX}2" 2>/dev/null || true
sudo parted --script "$DEVICE_PATH" rm 1 2>/dev/null || true
sudo parted --script "$DEVICE_PATH" rm 2 2>/dev/null || true

# ── Create Partitions ──────────────────────────────────────────────────────────

PART1_END=$((DEVICE_SIZE - EMUNAND_SIZE_BYTES - (OFFSET * 2)))

sudo parted --script "$DEVICE_PATH" unit B mkpart primary fat32 "${OFFSET}B" "${PART1_END}B"
sudo parted --script "$DEVICE_PATH" set 1 lba on

PART2_START=$((DEVICE_SIZE - EMUNAND_SIZE_BYTES - OFFSET))
PART2_END=$((DEVICE_SIZE - OFFSET))

sudo parted --script "$DEVICE_PATH" unit B mkpart primary "${PART2_START}B" "${PART2_END}B"
sudo sfdisk --part-type "$DEVICE_PATH" 2 E0

# ── Format ─────────────────────────────────────────────────────────────────────

sudo partprobe "$DEVICE_PATH"
sync

sudo mkfs.vfat -s "$CLUSTER_SECTORS" -F 32 -R 3318 -n "SWITCH SD" "${DEVICE_PATH}${SUFFIX}1"

echo "Done. SD card is ready."