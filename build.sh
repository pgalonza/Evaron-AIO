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

UNZIP_COMMAND="unzip -o"

prepare_hekate() {
    curl -O -L https://github.com/CTCaer/hekate/releases/download/v6.1.1/hekate_ctcaer_6.1.1_Nyx_1.6.1.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/hekate_ctcaer_*.zip -d $BUILD_DIR
}

prepare_atmosphere() {
    curl -O -L https://github.com/Atmosphere-NX/Atmosphere/releases/download/1.7.0-prerelease/atmosphere-1.7.0-master-35d93a7c4+hbl-2.4.4+hbmenu-3.6.0.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/atmosphere-*.zip -d $BUILD_DIR
}

prepare_deesea() {
    curl -O -L https://github.com/Team-Neptune/DeepSea/releases/download/v4.9.0/deepsea-advanced_v4.9.0.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/deepsea-advanced_*.zip -d $BUILD_DIR
}

prepare_kefir() {
    curl -O -L https://github.com/rashevskyv/kefir/releases/download/734/kefir734.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/kefir_*.zip -d $BUILD_DIR
}

prepare_gnx() {
    curl -O -L https://github.com/vncsmnl/GNX/releases/download/18.0.1-00/2024.03.30.GNX.v18.0.1-00.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/*.GNC.*.zip -d $BUILD_DIR
}

prepare_ultra() {
    curl -O -L https://github.com/Ultra-NX/Ultra/releases/download/2.1-RC3/Ultra.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/Ultra.zip -d $BUILD_DIR
}

prepare_next() {
    curl -O -L https://codeberg.org/vampitech/NeXT/releases/download/3.11/NeXT.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/Next.zip -d $BUILD_DIR
}

prepare_shallowsea) {
    curl -O -L https://codeberg.org/carcaschoi/Shallowsea/releases/download/v2.22.1/ShallowSea-ams.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/ShallowSea-*.zip -d $BUILD_DIR
}

prepare_shallowsea) {
    curl -O -L https://github.com/rashevskyv/4IFIR/releases/download/24.04.13.07/4IFIR-Wizard-update-*.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/4IFIR-*.zip -d $BUILD_DIR
}

prepare_scripts() {
    curl -O -L https://raw.githubusercontent.com/Atmosphere-NX/Atmosphere/master/utilities/insert_splash_screen.py --output-dir $TMP_DIR
    git clone git@github.com:friedkeenan/switch-logo-patcher.git
}

prepare_sigpatches() {
    curl -O -L https://sigmapatches.su/sigpatches.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/sigpatches.zip -d $BUILD_DIR
}

prepare_syspatch() {
    curl -O -L https://sigmapatches.su/sys-patch.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/sys-patch.zip -d $BUILD_DIR
}

prepare_sx_gear() {
    curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/SX_Gear_v1.1.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/SX_Gear_*.zip -d $BUILD_DIR
}

prepare_payload() {
    # curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/Lockpick_RCM.zip --output-dir $TMP_DIR
    # $UNZIP_COMMAND $TMP_DIR/Lockpick_RCM.zip -d $BUILD_DIR/bootloader/payloads/

    curl -O -L https://sigmapatches.su/Lockpick_RCM_v1.9.12.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/Lockpick_RCM_v1.9.12.zip -d $TMP_DIR/
    cp $TMP_DIR/Lockpick_RCM.bin $BUILD_DIR/bootloader/payloads/

    curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/mod_chip_toolbox.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/mod_chip_toolbox.zip -d $BUILD_DIR/bootloader/payloads/
}

prepare_homebrew() {
    mkdir $BUILD_DIR/switch/DBI
    curl -O -L https://github.com/rashevskyv/dbi/releases/download/658/DBI.nro --output-dir $TMP_DIR
    cp $TMP_DIR/DBI.nro $BUILD_DIR/switch/DBI/


    mkdir $BUILD_DIR/switch/linkalho
    curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/linkalho-v2.0.1.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/linkalho-*.zip -d $BUILD_DIR/switch/linkalho

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
    $UNZIP_COMMAND $TMP_DIR/hbmenu_*zip -d $BUILD_DIR/games/
}

patch_homebrew() {
    cp $SRC_HOMEBREW/dbi/dbi.config $BUILD_DIR/switch/DBI/dbi.config
    mkdir $BUILD_DIR/config/aio-switch-updater
    cp $SRC_HOMEBREW/aio-switch-updater/custom_packs.json $BUILD_DIR/config/aio-switch-updater/custom_packs.json
}


mkdir $TMP_DIR $BUILD_DIR
prepare_deesea
prepare_sigpatches
prepare_sx_gear
prepare_payload
prepare_homebrew
prepare_syspatch

patch_atmosphere
patch_hekate
patch_home_menu
patch_homebrew

cd ./build && zip -r ../Evaron-AIO.zip *