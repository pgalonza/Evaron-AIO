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
DOWNLOAD_COMMAND="curl --remote-name --fail --output-dir $TMP_DIR --location"

prepare_hekate() {
    $DOWNLOAD_COMMAND https://github.com/CTCaer/hekate/releases/download/v6.2.1/hekate_ctcaer_6.2.1_Nyx_1.6.3.zip
    $UNZIP_COMMAND $TMP_DIR/hekate_ctcaer_*.zip -d $BUILD_DIR
}

prepare_atmosphere() {
    $DOWNLOAD_COMMAND https://github.com/Atmosphere-NX/Atmosphere/releases/download/1.7.1/atmosphere-1.7.1-master-39c201e37+hbl-2.4.4+hbmenu-3.6.0.zip
    $UNZIP_COMMAND $TMP_DIR/atmosphere-*.zip -d $BUILD_DIR

    $DOWNLOAD_COMMAND https://github.com/Atmosphere-NX/Atmosphere/releases/download/1.7.1/fusee.bin
    cp $TMP_DIR/fusee.bin $BUILD_DIR/bootloader/payloads/fusee.bin
}

prepare_evaron_atmosphere() {
    $DOWNLOAD_COMMAND https://github.com/pgalonza/ns-Atmosphere/releases/download/0.1.0/atmosphere-1.7.0-notbranch-dd29b60c3-hbl-2.4.4+hbmenu-3.6.0.zip
    $UNZIP_COMMAND $TMP_DIR/atmosphere-*.zip -d $BUILD_DIR

    $DOWNLOAD_COMMAND https://github.com/pgalonza/ns-Atmosphere/releases/download/0.1.0/fusee.bin
    cp $TMP_DIR/fusee.bin $TMP_DIR/bootloader/payloads/fusee.bin
}

prepare_deepsea() {
    $DOWNLOAD_COMMAND https://github.com/Team-Neptune/DeepSea/releases/download/v4.11.0/deepsea-advanced_v4.11.0.zip
    $UNZIP_COMMAND $TMP_DIR/deepsea-advanced_*.zip -d $BUILD_DIR
}

prepare_kefir() {
    $DOWNLOAD_COMMAND https://github.com/rashevskyv/kefir/releases/download/746/kefir746.zip
    $UNZIP_COMMAND $TMP_DIR/kefir_*.zip -d $BUILD_DIR
}

prepare_gnx() {
    $DOWNLOAD_COMMAND https://github.com/vncsmnl/GNX/releases/download/18.1.0-02/2024.07.06.GNX.v18.1.0-02.zip
    $UNZIP_COMMAND $TMP_DIR/*.GNC.*.zip -d $BUILD_DIR
}

prepare_ultra() {
    $DOWNLOAD_COMMAND https://github.com/Ultra-NX/Ultra/releases/download/2.2-R4%2B/Ultra.zip
    $UNZIP_COMMAND $TMP_DIR/Ultra.zip -d $BUILD_DIR
}

prepare_next() {
    $DOWNLOAD_COMMAND https://codeberg.org/vampitech/NeXT/releases/download/3.20/NeXT.zip
    $UNZIP_COMMAND $TMP_DIR/Next.zip -d $BUILD_DIR
}

prepare_shallowsea() {
    $DOWNLOAD_COMMAND https://codeberg.org/carcaschoi/Shallowsea/releases/download/v2.23.0/ShallowSea-ams.zip
    $UNZIP_COMMAND $TMP_DIR/ShallowSea-*.zip -d $BUILD_DIR
}

prepare_4ifir() {
    $DOWNLOAD_COMMAND https://github.com/rashevskyv/4ifir-checker/raw/9791c36/github/4IFIR.zip
    $UNZIP_COMMAND $TMP_DIR/4IFIR-*.zip -d $BUILD_DIR
}

prepare_hats() {
    $DOWNLOAD_COMMAND https://www.mediafire.com/file_premium/p6vnazz54xwl31n/HATS-1.71-5.zip/file
    $UNZIP_COMMAND $TMP_DIR/HATS-*.zip -d $BUILD_DIR
}

prepare_santa_atmo() {
    $DOWNLOAD_COMMAND https://santa-atmo.ru/nintendo/atmo-1.7.1-150624.zip
    $UNZIP_COMMAND $TMP_DIR/atmo-*.zip -d $BUILD_DIR
}

prepare_venom() {
    $DOWNLOAD_COMMAND https://github.com/CatcherITGF/NX-Venom/releases/download/4.9.1/NXVenom.zip
    $UNZIP_COMMAND $TMP_DIR/NXVenom.zip -d $BUILD_DIR
}

prepare_switchcraft() {
    # $DOWNLOAD_COMMAND https://f38d61784492.hosting.myjino.ru/NintendoSwitch/OC_Switchcraft_EOS-1.5.0-atmosphere-1.8.0-prerelease.zip
    $DOWNLOAD_COMMAND https://github.com/halop/OC-Switchcraft-EOS/releases/download/1.5.0/OC_Switchcraft_EOS.1.5.0.-.atmosphere.1.8.0.prerelease.zip
    $UNZIP_COMMAND $TMP_DIR/OC_Switchcraft_EOS_*.zip $BUILD_DIR
}

prepare_scripts() {
    $DOWNLOAD_COMMAND https://raw.githubusercontent.com/Atmosphere-NX/Atmosphere/master/utilities/insert_splash_screen.py
    git clone git@github.com:friedkeenan/switch-logo-patcher.git
    git clone git@github.com:zqb-all/convertfb.git
}

prepare_sigpatches() {
    # $DOWNLOAD_COMMAND https://sigmapatches.su/sigpatches.zip
    # $UNZIP_COMMAND $TMP_DIR/sigpatches.zip -d $BUILD_DIR

    $DOWNLOAD_COMMAND https://f38d61784492.hosting.myjino.ru/NintendoSwitch/Hekate+AMS-package3-sigpatches-1.8.0P2-cfw-19.0.0_V4.zip
    $UNZIP_COMMAND $TMP_DIR/Hekate+AMS-package3-sigpatches-*.zip -d $BUILD_DIR
}

prepare_overlays() {
    # $DOWNLOAD_COMMAND https://sigmapatches.su/sys-patch.zip
    # $DOWNLOAD_COMMAND https://github.com/impeeza/sys-patch/releases/download/v1.5.2/sys-patch-1.5.2-88297f8.zip
    $DOWNLOAD_COMMAND https://f38d61784492.hosting.myjino.ru/NintendoSwitch/sys-patch-1.5.2.zip
    $UNZIP_COMMAND $TMP_DIR/sys-patch-*.zip -d $BUILD_DIR
    rm $BUILD_DIR/atmosphere/contents/420000000000000B/flags/boot2.flag

    $DOWNLOAD_COMMAND https://github.com/ppkantorski/nx-ovlloader/releases/download/v1.0.8/nx-ovlloader.zip
    $UNZIP_COMMAND $TMP_DIR/nx-ovlloader.zip -d $BUILD_DIR

    $DOWNLOAD_COMMAND https://github.com/ppkantorski/Ultrahand-Overlay/releases/download/v1.8.1/ovlmenu.ovl
    cp -f $TMP_DIR/ovlmenu.ovl $BUILD_DIR/switch/.overlays/ovlmenu.ovl

    # $DOWNLOAD_COMMAND https://github.com/ppkantorski/EdiZon-Overlay/releases/download/v1.0.9/ovlEdiZon.ovl
    $DOWNLOAD_COMMAND https://github.com/proferabg/EdiZon-Overlay/releases/download/v1.0.9/ovlEdiZon.ovl
    cp -f $TMP_DIR/ovlEdiZon.ovl $BUILD_DIR/switch/.overlays/ovlEdiZon.ovl

    $DOWNLOAD_COMMAND https://github.com/ppkantorski/ovl-sysmodules/releases/download/v1.3.1%2B/ovlSysmodules.ovl
    cp -f $TMP_DIR/ovlSysmodules.ovl $BUILD_DIR/switch/.overlays/ovlSysmodules.ovl


    $DOWNLOAD_COMMAND https://github.com/masagrator/SaltyNX/releases/download/0.9.4/SaltyNX-0.9.4.zip
    $UNZIP_COMMAND $TMP_DIR/SaltyNX-*.zip -d $BUILD_DIR

    $DOWNLOAD_COMMAND https://github.com/ppkantorski/Status-Monitor-Overlay/releases/download/v1.1.4%2B/Status-Monitor-Overlay.ovl
    cp -f $TMP_DIR/Status-Monitor-Overlay.ovl $BUILD_DIR/switch/.overlays/Status-Monitor-Overlay.ovl

    $DOWNLOAD_COMMAND https://github.com/masagrator/FPSLocker/releases/download/2.0.3/FPSLocker.ovl
    cp -f $TMP_DIR/FPSLocker.ovl $BUILD_DIR/switch/.overlays/FPSLocker.ovl
}

prepare_sx_gear() {
    $DOWNLOAD_COMMAND https://f38d61784492.hosting.myjino.ru/NintendoSwitch/SX_Gear_v1.1.zip
    $UNZIP_COMMAND $TMP_DIR/SX_Gear_*.zip -d $BUILD_DIR
}

prepare_payload() {
    $DOWNLOAD_COMMAND https://f38d61784492.hosting.myjino.ru/NintendoSwitch/Lockpick_RCM_1_9_13.bin
    cp -f $TMP_DIR/Lockpick_RCM_*.bin -d $BUILD_DIR/bootloader/payloads/Lockpick_RCM.bin

    # $DOWNLOAD_COMMAND https://sigmapatches.su/Lockpick_RCM_v1.9.12.zip
    # $UNZIP_COMMAND $TMP_DIR/Lockpick_RCM_v1.9.12.zip -d $TMP_DIR/

    $DOWNLOAD_COMMAND https://f38d61784492.hosting.myjino.ru/NintendoSwitch/mod_chip_toolbox.zip
    $UNZIP_COMMAND $TMP_DIR/mod_chip_toolbox.zip -d $BUILD_DIR/bootloader/payloads/

    $DOWNLOAD_COMMAND https://github.com/suchmememanyskill/TegraExplorer/releases/download/4.2.0/TegraExplorer.bin
    cp -f $TMP_DIR/TegraExplorer.bin  -d $BUILD_DIR/bootloader/payloads/TegraExplorer.bin
}

prepare_homebrew() {
    mkdir $BUILD_DIR/switch/DBI
    $DOWNLOAD_COMMAND https://github.com/rashevskyv/dbi/releases/download/716ru/DBI.nro
    cp -f $TMP_DIR/DBI.nro $BUILD_DIR/switch/DBI/DBI.nro

    # $DOWNLOAD_COMMAND https://f38d61784492.hosting.myjino.ru/NintendoSwitch/DBI.694.ru.zip
    # $UNZIP_COMMAND $TMP_DIR/DBI.694.ru.zip -d $BUILD_DIR/switch/DBI/

    mkdir $BUILD_DIR/switch/linkalho
    $DOWNLOAD_COMMAND https://f38d61784492.hosting.myjino.ru/NintendoSwitch/linkalho-v2.0.1.zip
    $UNZIP_COMMAND $TMP_DIR/linkalho-*.zip -d $BUILD_DIR/switch/linkalho

    mkdir $BUILD_DIR/switch/atmo-pack-updater
    $DOWNLOAD_COMMAND https://github.com/PoloNX/AtmoPackUpdater/releases/download/2.0.1/AtmoPackUpdater.nro
    cp -f $TMP_DIR/AtmoPackUpdater.nro $BUILD_DIR/switch/atmo-pack-updater/AtmoPackUpdater.nro

    $DOWNLOAD_COMMAND https://github.com/HamletDuFromage/aio-switch-updater/releases/download/2.23.2/aio-switch-updater.zip
    $UNZIP_COMMAND $TMP_DIR/aio-switch-updater.zip -d $BUILD_DIR

    # $DOWNLOAD_COMMAND https://github.com/switchbrew/nx-hbloader/releases/download/v2.4.4/hbl.nsp
    # cp $TMP_DIR/hbl.nsp $BUILD_DIR/atmosphere/hbl.nsp

    # $DOWNLOAD_COMMAND https://github.com/switchbrew/nx-hbmenu/releases/download/v3.6.0/nx-hbmenu_v3.6.0.zip
    # $UNZIP_COMMAND $TMP_DIR/nx-hbmenu_* $BUILD_DIR

    $DOWNLOAD_COMMAND https://github.com/dslatt/nso-icon-tool/releases/download/v0.4.2/nso-icon-tool.nro
    cp -f $TMP_DIR/nso-icon-tool.nro $BUILD_DIR/switch/nso-icon-tool.nro

    $DOWNLOAD_COMMAND https://github.com/cy33hc/switch-ezremote-client/releases/download/1.05/ezremote-client.nro
    cp -f $TMP_DIR/ezremote-client.nro $BUILD_DIR/switch/ezremote-client.nro

    $DOWNLOAD_COMMAND https://www.ppsspp.org/files/Switch/Release_PPSSPP_Standalone_11.09.2024.7z
    7z x $TMP_DIR/Release_PPSSPP_Standalone_*.7z -o"$BUILD_DIR" -aoa
    rm $BUILD_DIR/README.txt $BUILD_DIR/LICENSE.txt
}

prepare_emulators() {
    $DOWNLOAD_COMMAND https://www.ppsspp.org/files/Switch/Release_PPSSPP_Standalone_11.09.2024.7z
    7z x $TMP_DIR/Release_PPSSPP_Standalone_*.7z -o"$BUILD_DIR" -aoa
    rm $BUILD_DIR/README.txt $BUILD_DIR/LICENSE.txt

    $DOWNLOAD_COMMAND https://buildbot.libretro.com/stable/1.19.1/nintendo/switch/libnx/RetroArch.7z
    7z x $TMP_DIR/RetroArch.7z -o"$BUILD_DIR" -aoa
}

prepare_cheat() {
    $DOWNLOAD_COMMAND https://github.com/tomvita/Breeze-Beta/releases/download/beta95d/Breeze.zip
    $UNZIP_COMMAND $TMP_DIR/Breeze.zip -d $BUILD_DIR

    # $DOWNLOAD_COMMAND https://github.com/proferabg/EdiZon-Overlay/releases/download/v1.0.8/ovlEdiZon.ovl
    # cp -f $TMP_DIR/ovlEdiZon.ovl $BUILD_DIR/switch/.overlays/ovlEdiZon.ovl

    $DOWNLOAD_COMMAND https://github.com/tomvita/EdiZon-SE/releases/download/3.8.37/EdiZon.zip
    $UNZIP_COMMAND $TMP_DIR/EdiZon.zip -d $BUILD_DIR
}

patch_atmosphere() {
    cp -f $SRC_ATMOSPHERE/exosphere.ini $BUILD_DIR/exosphere.ini
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
    $DOWNLOAD_COMMAND "https://f38d61784492.hosting.myjino.ru/NintendoSwitch/hbmenu.nsp"
    cp $TMP_DIR/hbmenu.nsp -d $BUILD_DIR/games/hbmenu.nsp
    $DOWNLOAD_COMMAND "https://f38d61784492.hosting.myjino.ru/NintendoSwitch/hbmenu_19.nsp"
    cp $TMP_DIR/hbmenu_19.nsp -d $BUILD_DIR/games/hbmenu_19.nsp
    $DOWNLOAD_COMMAND https://github.com/cy33hc/switch-ezremote-client/releases/download/1.05/ezremote-client.nsp
    cp -f $TMP_DIR/ezremote-client.nsp $BUILD_DIR/games/ezremote-client.nsp
}

patch_homebrew() {
    cp -f $SRC_HOMEBREW/dbi/dbi.config $BUILD_DIR/switch/DBI/dbi.config
    mkdir -p $BUILD_DIR/config/aio-switch-updater
    cp -f $SRC_HOMEBREW/aio-switch-updater/custom_packs.json $BUILD_DIR/config/aio-switch-updater/custom_packs.json
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
prepare_emulators
prepare_overlays
prepare_cheat

patch_atmosphere
patch_hekate
patch_home_menu
patch_homebrew

cd ./build && zip -r ../Evaron-AIO.zip ./*
