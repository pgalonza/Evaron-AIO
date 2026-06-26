#!/bin/bash

set -o errexit
set -o xtrace
set -o pipefail

# ── Configuration ──────────────────────────────────────────────────────────────

TMP_DIR="./tmp"
BUILD_DIR="./build"
BUILD_ULTRAHAND_DIR="./packages"
SRC_ASSETS_DIR="./assets"
SRC_HEKATE_DIR="./hekate"
SRC_ATMOSPHERE="./atmosphere"
SRC_HOMEBREW="./homebrew"
SRC_OVERLAY="./overlay"

UNZIP_COMMAND="unzip -o"
DOWNLOAD_COMMAND="curl --remote-name --fail --output-dir $TMP_DIR --location"

# Versions (bump here to update)
HEKATE_VERSION="6.5.3"
NYX_VERSION="1.9.3"
ULTRA_VERSION="3.0-R2"
EZREMOTE_VERSION="1.14"
BREEZE_VERSION="beta108.4c"
ULTRAHAND_VERSION=2.5.1
OVL_SYSMODULES_VERSION=1.5.3
NX_OVLLOADER_VERSION=2.0.2
SYS_PATCH_VERSION=1.6.2.3
STATUS_MONITOR_OVERLAY_VERSION="1.4.1%2Br2"
DBI_VERSION=902ru
EDIZON_OVERLAY_VERSION=1.0.15

# Additional packages (set to true to enable)
ADDITIONAL_PACKAGES=false

# ── Cleanup ────────────────────────────────────────────────────────────────────

cleanup() {
    rm -rf "$TMP_DIR"
}

# ── Prepare Functions ──────────────────────────────────────────────────────────

prepare_hekate() {
    $DOWNLOAD_COMMAND "https://github.com/CTCaer/hekate/releases/download/v${HEKATE_VERSION}/hekate_ctcaer_${HEKATE_VERSION}_Nyx_${NYX_VERSION}.zip"
    $UNZIP_COMMAND "$TMP_DIR/hekate_ctcaer_*.zip" -d "$BUILD_DIR"
}

prepare_ultra() {
    $DOWNLOAD_COMMAND "https://github.com/Ultra-NX/UltraNX/releases/download/${ULTRA_VERSION}/Ultra.zip"
    $UNZIP_COMMAND "$TMP_DIR/Ultra.zip" -d "$BUILD_DIR"
}

prepare_scripts() {
    $DOWNLOAD_COMMAND "https://raw.githubusercontent.com/Atmosphere-NX/Atmosphere/master/utilities/insert_splash_screen.py"
    git clone git@github.com:friedkeenan/switch-logo-patcher.git
    git clone git@github.com:zqb-all/convertfb.git
}

prepare_overlays() {
    $DOWNLOAD_COMMAND https://github.com/ppkantorski/Ultrahand-Overlay/releases/download/v${ULTRAHAND_VERSION}/ovlmenu.ovl
    cp -f $TMP_DIR/ovlmenu.ovl $BUILD_DIR/switch/.overlays/ovlmenu.ovl

    $DOWNLOAD_COMMAND https://github.com/ppkantorski/ovl-sysmodules/releases/download/v${OVL_SYSMODULES_VERSION}/ovlSysmodules.ovl
    cp -f $TMP_DIR/ovlSysmodules.ovl $BUILD_DIR/switch/.overlays/ovlSysmodules.ovl

    $DOWNLOAD_COMMAND https://github.com/ppkantorski/nx-ovlloader/releases/download/v${NX_OVLLOADER_VERSION}/nx-ovlloader.zip
    $UNZIP_COMMAND $TMP_DIR/nx-ovlloader.zip -d $BUILD_DIR

    #https://github.com/impeeza/sys-patch/
    $DOWNLOAD_COMMAND https://github.com/borntohonk/sys-patch/releases/download/v${SYS_PATCH_VERSION}/sys-patch-v${SYS_PATCH_VERSION}.zip
    $UNZIP_COMMAND $TMP_DIR/sys-patch.zip -d $BUILD_DIR

    $DOWNLOAD_COMMAND https://github.com/ppkantorski/Status-Monitor-Overlay/releases/download/v{STATUS_MONITOR_OVERLAY_VERSION}/Status-Monitor-Overlay.ovl
    cp -f $TMP_DIR/Status-Monitor-Overlay.ovl $BUILD_DIR/switch/.overlays/Status-Monitor-Overlay.ovl

}

prepare_payload() {
    $DOWNLOAD_COMMAND "https://f38d61784492.hosting.myjino.ru/NintendoSwitch/mod_chip_toolbox.zip"
    $UNZIP_COMMAND "$TMP_DIR/mod_chip_toolbox.zip" -d "$BUILD_DIR/bootloader/payloads/"
}

prepare_homebrew() {
    mkdir -p "$BUILD_DIR/switch/ezremote-client"
    $DOWNLOAD_COMMAND "https://github.com/cy33hc/switch-ezremote-client/releases/download/${EZREMOTE_VERSION}/ezremote-client.nro"
    cp -f "$TMP_DIR/ezremote-client.nro" "$BUILD_DIR/switch/ezremote-client/ezremote-client.nro"

    DOWNLOAD_COMMAND "https://github.com/Ultra-NX/Ultra-Resources/releases/download/Homebrews/AIO.zip"
    $UNZIP_COMMAND "$TMP_DIR/AIO.zip" -d "$BUILD_DIR"

    mkdir $BUILD_DIR/switch/DBI
    $DOWNLOAD_COMMAND https://github.com/Ultra-NX/Ultra-Resources/releases/download/Homebrews/DBI.RU.zip
    UNZIP_COMMAND "$TMP_DIR/DBI.RU.zip" -d "$TMP_DIR"
    cp -f $TMP_DIR/DBI.nro $BUILD_DIR/switch/DBI/DBI.nro
}

prepare_cheat() {
    $DOWNLOAD_COMMAND "https://github.com/tomvita/Breeze-Beta/releases/download/${BREEZE_VERSION}/Breeze.zip"
    $UNZIP_COMMAND "$TMP_DIR/Breeze.zip" -d "$BUILD_DIR"

    $DOWNLOAD_COMMAND https://github.com/proferabg/EdiZon-Overlay/releases/download/v${EDIZON_OVERLAY_VERSION}/ovlEdiZon.ovl
    cp -f $TMP_DIR/ovlEdiZon.ovl $BUILD_DIR/switch/.overlays/ovlEdiZon.ovl
}

prepare_mariko() {
    echo "prepare_mariko: not implemented yet"
}

# ── Patch Functions ────────────────────────────────────────────────────────────

patch_atmosphere() {
    if [[ $ADDITIONAL_PACKAGES == true ]]; then
        cp -f "$SRC_ATMOSPHERE/exosphere.ini" "$BUILD_DIR/exosphere.ini"
        cp -f "$SRC_ATMOSPHERE/config/override_config.ini" "$BUILD_DIR/atmosphere/config/override_config.ini"
        cp -f "$SRC_ATMOSPHERE/config/system_settings.ini" "$BUILD_DIR/atmosphere/config/system_settings.ini"
    fi
}

patch_hekate() {
    if [[ $ADDITIONAL_PACKAGES == true ]]; then
        cp "$BUILD_DIR/hekate_ctcaer_*.bin" "$BUILD_DIR/bootloader/update.bin" 2>/dev/null || true
        cp -f "$SRC_HEKATE_DIR/hekate_ipl.ini" "$BUILD_DIR/bootloader/hekate_ipl.ini"
    fi

    cp "$BUILD_DIR/hekate_ctcaer_*.bin" "$BUILD_DIR/payload.bin" 2>/dev/null || true
    rm -f "$BUILD_DIR/hekate_ctcaer_*.bin"
    mkdir -p "$BUILD_DIR/bootloader/res"
    cp "$SRC_HEKATE_DIR/bootscreen/"* "$BUILD_DIR/bootloader/res/"
}

patch_home_menu() {
    mkdir -p "$BUILD_DIR/games"
    $DOWNLOAD_COMMAND "https://github.com/cy33hc/switch-ezremote-client/releases/download/${EZREMOTE_VERSION}/ezremote-client.nsp"
    cp -f "$TMP_DIR/ezremote-client.nsp" "$BUILD_DIR/games/ezremote-client.nsp"
}

patch_homebrew() {
    if [[ $ADDITIONAL_PACKAGES == true ]]; then
        cp -f "$SRC_HOMEBREW/dbi/dbi.config" "$BUILD_DIR/switch/DBI/dbi.config"
    fi

    mkdir -p "$BUILD_DIR/config/aio-switch-updater"
    cp -f "$SRC_HOMEBREW/aio-switch-updater/custom_packs.json" "$BUILD_DIR/config/aio-switch-updater/custom_packs.json"

    mkdir -p "$BUILD_DIR/switch/ezremote-client"
    cp -f "$SRC_HOMEBREW/ezremote-client/config.ini" "$BUILD_DIR/switch/ezremote-client/config.ini"
}

patch_overlay() {
    mkdir -p "$BUILD_DIR/switch/.packages"
    cp -rf "$SRC_OVERLAY/ultrahand-overlay/"* "$BUILD_DIR/switch/.packages/"
}

patch_splash_screen_package3() {
    local label="package3"
    convert "$SRC_ASSETS_DIR/bootlogo-${label}.png" -rotate 270 "$TMP_DIR/bootlogo-${label}.png"
    convert "$TMP_DIR/bootlogo-${label}.png" -resize 720x1280 -depth 8 -type TrueColorAlpha "$TMP_DIR/bootlogo-${label}.bmp"

    python3 "$TMP_DIR/insert_splash_screen.py" "$TMP_DIR/bootlogo-${label}.bmp" "$BUILD_DIR/atmosphere/package3"
}

patch_splash_hekate() {
    local label="hekate"
    convert "$SRC_ASSETS_DIR/bootlogo-${label}.png" -rotate 270 "$TMP_DIR/bootlogo-${label}.png"
    convert "$TMP_DIR/bootlogo-${label}.png" -resize 720x1280 -depth 8 -type TrueColorAlpha "$TMP_DIR/bootlogo-${label}.bmp"
    cp -f "$TMP_DIR/bootlogo-${label}.bmp" "$BUILD_DIR/bootloader/bootlogo.bmp"
}

patch_bootlogo_exefs() {
    local label="exefs"
    convert "$SRC_ASSETS_DIR/bootlogo-${label}.png" -rotate 270 "$TMP_DIR/bootlogo-${label}.png"
    convert "$TMP_DIR/bootlogo-${label}.png" -resize 308x350 -depth 8 -type TrueColorAlpha "$TMP_DIR/bootlogo-${label}.bmp"

    mkdir -p "$BUILD_DIR/atmosphere/exefs_patches/bootlogo"
    python3 "$BUILD_DIR/switch-logo-patcher/gen_patches.py" "$BUILD_DIR/atmosphere/exefs_patches/bootlogo" "$TMP_DIR/bootlogo-${label}.bmp"
}

patch_icons() {
    local label="icon"
    mkdir -p "$TMP_DIR/res"
    for png_file in "$SRC_ASSETS_DIR"/icons/*.png; do
        [[ -f "$png_file" ]] || continue
        filename=$(basename "$png_file" .png)
        convert "$png_file" -resize 192x192 -depth 8 -type TrueColorAlpha "$TMP_DIR/res/${label}_${filename}.bmp"
    done
    mkdir -p "$BUILD_DIR/bootloader/res"
    cp -f "$TMP_DIR/res/"*.bmp "$BUILD_DIR/bootloader/res/"
}

# ── Main ───────────────────────────────────────────────────────────────────────

main() {

    mkdir -p "$TMP_DIR" "$BUILD_DIR" "$BUILD_ULTRAHAND_DIR"

    prepare_ultra
    prepare_hekate
    prepare_payload
    prepare_homebrew
    prepare_overlays
    prepare_cheat
    prepare_mariko

    patch_hekate
    patch_atmosphere
    patch_hekate
    patch_home_menu
    patch_homebrew
    patch_overlay

    cd "$BUILD_DIR"
    zip -r ../Evaron-AIO.zip ./*
    cd ../

    cd "$BUILD_ULTRAHAND_DIR"
    mkdir -p ./switch/.packages/
    cp -r ../overlay/ultrahand-overlay/* ./switch/.packages/
    zip -r ../Ultrahand-packages.zip ./*
    cd ../
}

main