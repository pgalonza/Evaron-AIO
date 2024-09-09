#!/bin/bash

set -o errexit
set -o xtrace

TMP_DIR="./tmp"
BUILD_DIR="./build"
SRC_ASSETS_DIR="./assets"
SRC_HEKATE_DIR="./hekate"
SRC_ATMOSPHERE="./atmosphere"
SRC_HOMEBREW="./homebrew"

UNZIP_COMMAND="unzip -o"

prepare_hekate() {
    curl -O -L https://github.com/CTCaer/hekate/releases/download/v6.2.1/hekate_ctcaer_6.2.1_Nyx_1.6.3.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/hekate_ctcaer_*.zip -d $BUILD_DIR
}

prepare_atmosphere() {
    curl -O -L https://github.com/Atmosphere-NX/Atmosphere/releases/download/1.7.1/atmosphere-1.7.1-master-39c201e37+hbl-2.4.4+hbmenu-3.6.0.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/atmosphere-*.zip -d $BUILD_DIR

    curl -O -L https://github.com/Atmosphere-NX/Atmosphere/releases/download/1.7.1/fusee.bin --output-dir $TMP_DIR
    cp $TMP_DIR/fusee.bin $BUILD_DIR/bootloader/payloads/fusee.bin
}

prepare_evaron_atmosphere() {
    curl -O -L https://github.com/pgalonza/ns-Atmosphere/releases/download/0.1.0/atmosphere-1.7.0-notbranch-dd29b60c3-hbl-2.4.4+hbmenu-3.6.0.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/atmosphere-*.zip -d $BUILD_DIR

    curl -O -L https://github.com/pgalonza/ns-Atmosphere/releases/download/0.1.0/fusee.bin --output-dir $TMP_DIR
    cp $TMP_DIR/fusee.bin $TMP_DIR/bootloader/payloads/fusee.bin
}

prepare_deepsea() {
    curl -O -L https://github.com/Team-Neptune/DeepSea/releases/download/v4.11.0/deepsea-advanced_v4.11.0.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/deepsea-advanced_*.zip -d $BUILD_DIR
}

prepare_kefir() {
    curl -O -L https://github.com/rashevskyv/kefir/releases/download/746/kefir746.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/kefir_*.zip -d $BUILD_DIR
}

prepare_gnx() {
    curl -O -L https://github.com/vncsmnl/GNX/releases/download/18.1.0-02/2024.07.06.GNX.v18.1.0-02.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/*.GNC.*.zip -d $BUILD_DIR
}

prepare_ultra() {
    curl -O -L https://github.com/Ultra-NX/Ultra/releases/download/2.2-R4%2B/Ultra.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/Ultra.zip -d $BUILD_DIR
}

prepare_next() {
    curl -O -L https://codeberg.org/vampitech/NeXT/releases/download/3.20/NeXT.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/Next.zip -d $BUILD_DIR
}

prepare_shallowsea() {
    curl -O -L https://codeberg.org/carcaschoi/Shallowsea/releases/download/v2.23.0/ShallowSea-ams.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/ShallowSea-*.zip -d $BUILD_DIR
}

prepare_4ifir() {
    curl -O -L https://github.com/rashevskyv/4IFIR/releases/download/24.08.16.08/4IFIR-Wizard-update-24.08.16.08.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/4IFIR-*.zip -d $BUILD_DIR
}

prepare_hats() {
    curl -O -L https://www.mediafire.com/file_premium/p6vnazz54xwl31n/HATS-1.71-5.zip/file --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/HATS-*.zip -d $BUILD_DIR
}

prepare_santa_atmo() {
    curl -O -L https://santa-atmo.ru/nintendo/atmo-1.7.1-150624.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/atmo-*.zip -d $BUILD_DIR
}

prepare_venom() {
    curl -O -L https://github.com/CatcherITGF/NX-Venom/releases/download/4.9.1/NXVenom.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/NXVenom.zip -d $BUILD_DIR
}

prepare_switchcraft() {
    curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/OC_Switchcraft_EOS_1.4.1_atmosphere_1.7.1.zip
    curl -O -L OC_Switchcraft_EOS_*.zip --output-dir $TMP_DIR
}

prepare_scripts() {
    curl -O -L https://raw.githubusercontent.com/Atmosphere-NX/Atmosphere/master/utilities/insert_splash_screen.py --output-dir $TMP_DIR
    git clone git@github.com:friedkeenan/switch-logo-patcher.git
    git clone git@github.com:zqb-all/convertfb.git
}

prepare_sigpatches() {
    # curl -O -L https://sigmapatches.su/sigpatches.zip --output-dir $TMP_DIR
    # $UNZIP_COMMAND $TMP_DIR/sigpatches.zip -d $BUILD_DIR

    curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/Hekate+AMS-package3-sigpatches-1.7.1-cfw-18.1.0V2.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/Hekate+AMS-package3-sigpatches*.zip -d $BUILD_DIR
}

prepare_overlays() {
    # curl -O -L https://sigmapatches.su/sys-patch.zip --output-dir $TMP_DIR
    # curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/sys-patch-1.5.1.zip --output-dir $TMP_DIR
    curl -O -L https://github.com/impeeza/sys-patch/releases/download/v1.5.2/sys-patch-1.5.2-88297f8.zip --output-dir $TMP_DIR
    # $UNZIP_COMMAND $TMP_DIR/sys-patch-*.zip -d $BUILD_DIR
    $UNZIP_COMMAND $TMP_DIR/sys-patch-*.zip -d $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/sys-patch.zip -d $BUILD_DIR
    rm $BUILD_DIR/atmosphere/contents/420000000000000B/flags/boot2.flag

    curl -O -L https://github.com/WerWolv/nx-ovlloader/releases/download/v1.0.7/nx-ovlloader.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/nx-ovlloader.zip -d $BUILD_DIR
    curl -O -L https://github.com/ppkantorski/Ultrahand-Overlay/releases/download/v1.7.2/ovlmenu.ovl --output-dir $TMP_DIR
    cp -f $TMP_DIR/ovlmenu.ovl $BUILD_DIR/switch/.overlays/ovlmenu.ovl
}

prepare_sx_gear() {
    curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/SX_Gear_v1.1.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/SX_Gear_*.zip -d $BUILD_DIR
}

prepare_payload() {
    # curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/Lockpick_RCM.zip --output-dir $TMP_DIR
    # $UNZIP_COMMAND $TMP_DIR/Lockpick_RCM.zip -d $BUILD_DIR/bootloader/payloads/

    # curl -O -L https://sigmapatches.su/Lockpick_RCM_v1.9.12.zip --output-dir $TMP_DIR
    # $UNZIP_COMMAND $TMP_DIR/Lockpick_RCM_v1.9.12.zip -d $TMP_DIR/

    curl -O -L https://github.com/Decscots/Lockpick_RCM/releases/download/v1.9.12/Lockpick_RCM.bin --output-dir $TMP_DIR
    cp $TMP_DIR/Lockpick_RCM.bin $BUILD_DIR/bootloader/payloads/

    curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/mod_chip_toolbox.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/mod_chip_toolbox.zip -d $BUILD_DIR/bootloader/payloads/
}

prepare_homebrew() {
    mkdir $BUILD_DIR/switch/DBI
    # curl -O -L https://github.com/rashevskyv/dbi/releases/download/658/DBI.nro --output-dir $TMP_DIR
    # cp $TMP_DIR/DBI.nro $BUILD_DIR/switch/DBI/
    curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/DBI.694.ru.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/DBI.694.ru.zip -d $BUILD_DIR/switch/DBI/

    mkdir $BUILD_DIR/switch/linkalho
    curl -O -L https://f38d61784492.hosting.myjino.ru/NintendoSwitch/linkalho-v2.0.1.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/linkalho-*.zip -d $BUILD_DIR/switch/linkalho

    mkdir $BUILD_DIR/switch/sigpatch-updater
    curl -O -L https://bitbucket.org/e1ite007/sigpatch-updater/downloads/sigpatch-updater.nro --output-dir $TMP_DIR
    cp $TMP_DIR/sigpatch-updater.nro $BUILD_DIR/switch/sigpatch-updater/

    mkdir $BUILD_DIR/switch/atmo-pack-updater
    curl -O -L https://github.com/PoloNX/AtmoPackUpdater/releases/download/2.0.1/AtmoPackUpdater.nro --output-dir $TMP_DIR
    cp $TMP_DIR/AtmoPackUpdater.nro $BUILD_DIR/switch/atmo-pack-updater/

    curl -O -L https://github.com/HamletDuFromage/aio-switch-updater/releases/download/2.23.2/aio-switch-updater.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/aio-switch-updater.zip -d $BUILD_DIR
}

prepare_cheat() {
    curl -O -L https://github.com/tomvita/Breeze-Beta/releases/download/beta92f/Breeze.zip --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/Breeze.zip -d $BUILD_DIR

    curl -O -L https://github.com/proferabg/EdiZon-Overlay/releases/download/v1.0.8/ovlEdiZon.ovl --output-dir $TMP_DIR
    cp -f $TMP_DIR/ovlEdiZon.ovl $BUILD_DIR/switch/.overlays/ovlEdiZon.ovl
}

patch_atmosphere() {
    cp $SRC_ATMOSPHERE/exosphere.ini $BUILD_DIR/exosphere.ini
    cp -f $SRC_ATMOSPHERE/config/override_config.ini $BUILD_DIR/atmosphere/config/override_config.ini
    cp -f $SRC_ATMOSPHERE/config/system_settings.ini $BUILD_DIR/atmosphere/config/system_settings.ini
    mkdir $BUILD_DIR/atmosphere/hosts || true
    cp -f $SRC_ATMOSPHERE/hosts/* $BUILD_DIR/atmosphere/hosts
}

patch_hekate() {
    cp $BUILD_DIR/hekate_ctcaer_*.bin $BUILD_DIR/payload.bin || true
    rm $BUILD_DIR/hekate_ctcaer_*.bin || true
    cp -f $SRC_HEKATE_DIR/hekate_ipl.ini $BUILD_DIR/bootloader/hekate_ipl.ini
}

patch_home_menu() {
    mkdir $BUILD_DIR/games
    curl -O -L "https://f38d61784492.hosting.myjino.ru/NintendoSwitch/hbmenu_0104444444440000.zip" --output-dir $TMP_DIR
    $UNZIP_COMMAND $TMP_DIR/hbmenu_*zip -d $BUILD_DIR/games/
}

patch_homebrew() {
    cp $SRC_HOMEBREW/dbi/dbi.config $BUILD_DIR/switch/DBI/dbi.config
    mkdir -p $BUILD_DIR/config/aio-switch-updater
    cp $SRC_HOMEBREW/aio-switch-updater/custom_packs.json $BUILD_DIR/config/aio-switch-updater/custom_packs.json
}

patch_splash_screen_package3() {
    label=paskage3
    convert $SRC_ASSETS_DIR/bootlogo-$label.png -rotate 270 $TMP_DIR/bootlogo-$label.png
    convert $TMP_DIR/bootlogo-$label.png -resize 720x1280 -depth 8 -type TrueColorAlpha $TMP_DIR/bootlogo-$label.bmp

    python3 $TMP_DIR/insert_splash_screen.py $TMP_DIR/bootlogo-$label.bmp $BUILD_DIR/atmosphere/package3
}

patch_splash_hekate() {
    label=hekate
    convert $SRC_ASSETS_DIR/bootlogo-$label.png -rotate 270 $TMP_DIR/bootlogo-$label.png
    convert $TMP_DIR/bootlogo-$label.png -resize 720x1280 -depth 8 -type TrueColorAlpha $TMP_DIR/bootlogo-$label.bmp
    cp -f $TMP_DIR/bootlogo-$label.bmp $BUILD_DIR/bootloader/bootlogo.bmp
}

patch_bootlogo_exefs() {
    label=exefs
    convert $SRC_ASSETS_DIR/bootlogo-$label.png  -rotate 270 $TMP_DIR/bootlogo-$label.png
    convert $TMP_DIR/bootlogo-$label.png -resize 308x350 -depth 8 -type TrueColorAlpha $TMP_DIR/bootlogo-$label.bmp

    mkdir -p $BUILD_DIR/atmosphere/exefs_patches/bootlogo
    python3 $BUILD_DIR/switch-logo-patcher/gen_patches.py $BUILD_DIR/atmosphere/exefs_patches/bootlogo $TMP_DIR/bootlogo_$label.bmp
}

patch_icons() {
    label=icon
    mkdir $TMP_DIR/res
    for png_file in "$SRC_ASSETS_DIR"/icons/*.png ; do
        convert $SRC_ASSETS_DIR/icons/"$png_file" -resize 192x192 -depth 8 -type TrueColorAlpha $TMP_DIR/res/"$label"_"${png_file%.*}".bmp
    done
    mkdir $BUILD_DIR/bootloader/res
    cp -f $TMP_DIR/res/*.bmp $BUILD_DIR/bootloader/res/
}


mkdir $TMP_DIR $BUILD_DIR
prepare_deepsea
prepare_sigpatches
prepare_sx_gear
prepare_payload
prepare_homebrew
prepare_overlays
prepare_cheat

patch_atmosphere
patch_hekate
patch_home_menu
patch_homebrew

cd ./build && zip -r ../Evaron-AIO.zip ./*
