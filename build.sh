#!/bin/bash

set -o errexit
set -o xtrace

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

ADDITIONAL_PACKAGES=false

prepare_hekate() {
     $DOWNLOAD_COMMAND https://github.com/CTCaer/hekate/releases/download/v6.5.3/hekate_ctcaer_6.5.3_Nyx_1.9.3.zip
     $UNZIP_COMMAND $TMP_DIR/hekate_ctcaer_*.zip -d $BUILD_DIR
}

prepare_ultra() {
    $DOWNLOAD_COMMAND https://github.com/Ultra-NX/UltraNX/releases/download/3.0-R2/Ultra.zip
    $UNZIP_COMMAND $TMP_DIR/Ultra.zip -d $BUILD_DIR
}

prepare_scripts() {
    $DOWNLOAD_COMMAND https://raw.githubusercontent.com/Atmosphere-NX/Atmosphere/master/utilities/insert_splash_screen.py
    git clone git@github.com:friedkeenan/switch-logo-patcher.git
    git clone git@github.com:zqb-all/convertfb.git
}

prepare_overlays() {

}

prepare_payload() {
    $DOWNLOAD_COMMAND https://f38d61784492.hosting.myjino.ru/NintendoSwitch/mod_chip_toolbox.zip
    $UNZIP_COMMAND $TMP_DIR/mod_chip_toolbox.zip -d $BUILD_DIR/bootloader/payloads/
}

prepare_homebrew() {
    mkdir $BUILD_DIR/switch/ezremote-client || true
    $DOWNLOAD_COMMAND https://github.com/cy33hc/switch-ezremote-client/releases/download/1.14/ezremote-client.nro
    cp -f $TMP_DIR/ezremote-client.nro $BUILD_DIR/switch/ezremote-client/ezremote-client.nro
}

prepare_emulators() {
    $DOWNLOAD_COMMAND https://www.ppsspp.org/files/Switch/Release_PPSSPP_Standalone_11.09.2024.7z
    7z x $TMP_DIR/Release_PPSSPP_Standalone_*.7z -o"$BUILD_DIR" -aoa
    rm $BUILD_DIR/README.txt $BUILD_DIR/LICENSE.txt

    $DOWNLOAD_COMMAND https://buildbot.libretro.com/stable/1.21.0/nintendo/switch/libnx/RetroArch.7z
    7z x $TMP_DIR/RetroArch.7z -o"$BUILD_DIR" -aoa
}

prepare_cheat() {
    $DOWNLOAD_COMMAND https://github.com/tomvita/Breeze-Beta/releases/download/beta108.4c/Breeze.zip
    $UNZIP_COMMAND $TMP_DIR/Breeze.zip -d $BUILD_DIR
}

patch_atmosphere() {
    if [[ $ADDITIONAL_PACKAGES == true ]]; then
        cp -f $SRC_ATMOSPHERE/exosphere.ini $BUILD_DIR/exosphere.ini
        cp -f $SRC_ATMOSPHERE/config/override_config.ini $BUILD_DIR/atmosphere/config/override_config.ini
        cp -f $SRC_ATMOSPHERE/config/system_settings.ini $BUILD_DIR/atmosphere/config/system_settings.ini
    fi
}

patch_hekate() {
    if [[ $ADDITIONAL_PACKAGES == true ]]; then
        cp $BUILD_DIR/hekate_ctcaer_*.bin $BUILD_DIR/payload.bin || true
        cp $BUILD_DIR/hekate_ctcaer_*.bin $BUILD_DIR/bootloader/update.bin || true
        rm $BUILD_DIR/hekate_ctcaer_*.bin || true
        cp -f $SRC_HEKATE_DIR/hekate_ipl.ini $BUILD_DIR/bootloader/hekate_ipl.ini
    fi

    cp $SRC_HEKATE_DIR/bootscreen/* $BUILD_DIR/bootloader/res/
}

patch_home_menu() {
    mkdir $BUILD_DIR/games
    $DOWNLOAD_COMMAND https://github.com/cy33hc/switch-ezremote-client/releases/download/1.14/ezremote-client.nsp
    cp -f $TMP_DIR/ezremote-client.nsp $BUILD_DIR/games/ezremote-client.nsp
}

patch_homebrew() {
    if [[ $ADDITIONAL_PACKAGES == true ]]; then
        cp -f "$SRC_HOMEBREW/dbi/dbi.config" "$BUILD_DIR/switch/DBI/dbi.config"
    fi

    mkdir -p $BUILD_DIR/config/aio-switch-updater
    cp -f "$SRC_HOMEBREW/aio-switch-updater/custom_packs.json" "$BUILD_DIR/config/aio-switch-updater/custom_packs.json"

    mkdir $BUILD_DIR/switch/ezremote-client || true
    cp -f "$SRC_HOMEBREW/ezremote-client/config.ini" "$BUILD_DIR/switch/ezremote-client/config.ini"
}

patch_overlay() {
    mkdir $BUILD_DIR/switch/.packages || true
    cp -rf "$SRC_OVERLAY/ultrahand-overlay/"* "$BUILD_DIR/switch/.packages/"
}

patch_splash_screen_package3() {
    label=paskage3
    convert "$SRC_ASSETS_DIR/bootlogo-$label.png" -rotate 270 "$TMP_DIR/bootlogo-$label.png"
    convert $TMP_DIR/bootlogo-$label.png -resize 720x1280 -depth 8 -type TrueColorAlpha $TMP_DIR/bootlogo-$label.bmp

    python3 $TMP_DIR/insert_splash_screen.py $TMP_DIR/bootlogo-$label.bmp $BUILD_DIR/atmosphere/package3
}

patch_splash_hekate() {
    label=hekate
    convert "$SRC_ASSETS_DIR/bootlogo-$label.png" -rotate 270 "$TMP_DIR/bootlogo-$label.png"
    convert $TMP_DIR/bootlogo-$label.png -resize 720x1280 -depth 8 -type TrueColorAlpha $TMP_DIR/bootlogo-$label.bmp
    cp -f $TMP_DIR/bootlogo-$label.bmp $BUILD_DIR/bootloader/bootlogo.bmp
}

patch_bootlogo_exefs() {
    label=exefs
    convert "$SRC_ASSETS_DIR/bootlogo-$label.png"  -rotate 270 "$TMP_DIR/bootlogo-$label.png"
    convert $TMP_DIR/bootlogo-$label.png -resize 308x350 -depth 8 -type TrueColorAlpha $TMP_DIR/bootlogo-$label.bmp

    mkdir -p $BUILD_DIR/atmosphere/exefs_patches/bootlogo
    python3 $BUILD_DIR/switch-logo-patcher/gen_patches.py $BUILD_DIR/atmosphere/exefs_patches/bootlogo $TMP_DIR/bootlogo_$label.bmp
}

patch_icons() {
    label=icon
    mkdir $TMP_DIR/res
    for png_file in "$SRC_ASSETS_DIR"/icons/*.png ; do
        convert "$SRC_ASSETS_DIR/icons/$png_file" -resize 192x192 -depth 8 -type TrueColorAlpha "$TMP_DIR"/res/"$label"_"${png_file%.*}".bmp
    done
    mkdir $BUILD_DIR/bootloader/res
    cp -f $TMP_DIR/res/*.bmp $BUILD_DIR/bootloader/res/
}


mkdir $TMP_DIR $BUILD_DIR $BUILD_ULTRAHAND_DIR
prepare_ultra
prepare_payload
prepare_homebrew
prepare_cheat
prepare_mariko

patch_atmosphere
patch_hekate
patch_home_menu
patch_homebrew
patch_overlay

cd $BUILD_DIR
zip -r ../Evaron-AIO.zip ./*
cd ../

cd $BUILD_ULTRAHAND_DIR
mkdir -p ./switch/.packages/ && cp -r ../overlay/ultrahand-overlay/* ./switch/.packages/
zip -r ../Ultrahand-packages.zip ./*
cd ../
