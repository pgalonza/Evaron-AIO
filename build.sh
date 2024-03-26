#!/bin/bash

set -o errexit
set -o xtrace

TMP_DIR="./tmp"
BUILD_DIR="./build"
SRC_BOOT_DIR="./bootloader"
SRC_HEKATE_DIR="./hekate"
SRC_ATMOSPHERE="./atmosphere"
SRC_HOME_MENU="./home-menu"
SRC_HOMEBREW="./homebrew"

prepare_hekate() {
    curl -O -L https://github.com/CTCaer/hekate/releases/download/v6.1.0/hekate_ctcaer_6.1.0_Nyx_1.6.0.zip --output-dir $TMP_DIR
    unzip $TMP_DIR/hekate_ctcaer_*.zip -d $BUILD_DIR
}

prepare_atmosphere() {
    curl -O -L https://github.com/Atmosphere-NX/Atmosphere/releases/download/1.6.2/atmosphere-1.6.2-master-f7bf379cf+hbl-2.4.4+hbmenu-3.6.0.zip --output-dir $TMP_DIR
    unzip $TMP_DIR/atmosphere-*.zip -d $BUILD_DIR
}

prepare_deapsea() {
    curl -O -L https://github.com/Team-Neptune/DeepSea/releases/download/v4.9.0/deepsea-advanced_v4.9.0.zip --output-dir $TMP_DIR
    unzip $TMP_DIR/deepsea-advanced_*.zip -d $BUILD_DIR
}

prepare_sigpatches() {
    curl -O -L https://sigmapatches.su/sigpatches.zip --output-dir $TMP_DIR
    unzip $TMP_DIR/sigpatches.zip -d $BUILD_DIR
}

prepare_syspatch() {
    curl -O -L https://sigmapatches.su/sys-patch.zip --output-dir $TMP_DIR
    unzip $TMP_DIR/sys-patch.zip -d $BUILD_DIR
}

prepare_sx_gear() {
    curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/SX_Gear_v1.1.zip --output-dir $TMP_DIR
    unzip $TMP_DIR/SX_Gear_*.zip -d $BUILD_DIR
}

prepare_payload() {
    curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/Lockpick_RCM.zip --output-dir $TMP_DIR
    unzip $TMP_DIR/Lockpick_RCM.zip -d $BUILD_DIR/bootloader/payloads/

    curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/mod_chip_toolbox.zip --output-dir $TMP_DIR
    unzip $TMP_DIR/mod_chip_toolbox.zip -d $BUILD_DIR/bootloader/payloads/
}

prepare_homebrew() {
    mkdir $BUILD_DIR/switch/DBI
    curl -O -L https://github.com/rashevskyv/dbi/releases/download/658/DBI.nro --output-dir $TMP_DIR
    cp $TMP_DIR/DBI.nro $BUILD_DIR/switch/DBI/


    mkdir $BUILD_DIR/switch/linkalho
    curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/linkalho-v2.0.1.zip --output-dir $TMP_DIR
    unzip $TMP_DIR/linkalho-*.zip -d $BUILD_DIR/switch/linkalho

}

patch_atmosphere() {
    cp $SRC_ATMOSPHERE/exosphere.ini $BUILD_DIR/exosphere.ini
    cp -f $SRC_ATMOSPHERE/config/override_config.ini $BUILD_DIR/atmosphere/config/override_config.ini
    cp -f $SRC_ATMOSPHERE/config/system_settings.ini $BUILD_DIR/atmosphere/config/system_settings.ini
    cp -f $SRC_ATMOSPHERE/hosts/* $BUILD_DIR/atmosphere/hosts
    curl -O -L https://github.com/Atmosphere-NX/Atmosphere/releases/download/1.6.2/fusee.bin --output-dir $TMP_DIR
    cp $TMP_DIR/fusee.bin $BUILD_DIR/bootloader/payloads/fusee.bin
}

patch_hekate() {
    cp $BUILD_DIR/hekate_ctcaer_*.bin $BUILD_DIR/payload.bin
    rm $BUILD_DIR/hekate_ctcaer_*.bin
    cp $SRC_HEKATE_DIR/hekate_ipl.ini $BUILD_DIR/bootloader/hekate_ipl.ini
}

patch_home_menu() {
    mkdir $BUILD_DIR/games
    curl -O -L "https://f38d61784492.hosting.myjino.ru/NintendoSwitch/hbmenu_0104444444440000.zip" --output-dir $TMP_DIR
    unzip $TMP_DIR/hbmenu_*zip -d $BUILD_DIR/games/
}

patch_homebrew() {
    cp $SRC_HOMEBREW/dbi/dbi.config $BUILD_DIR/switch/DBI/dbi.config
    mkdir $BUILD_DIR/config/aio-switch-updater
    cp $SRC_HOMEBREW/aio-switch-updater/custom_packs.json $BUILD_DIR/aio-switch-updater/custom_packs.json
}


mkdir $TMP_DIR $BUILD_DIR
prepare_deapsea
prepare_sigpatches
prepare_sx_gear
prepare_payload
prepare_homebrew

patch_atmosphere
patch_hekate
patch_home_menu
patch_homebrew

