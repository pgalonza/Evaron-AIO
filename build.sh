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
    $DOWNLOAD_COMMAND https://github.com/CTCaer/hekate/releases/download/v6.2.2/hekate_ctcaer_6.2.2_Nyx_1.6.4.zip
    $UNZIP_COMMAND $TMP_DIR/hekate_ctcaer_*.zip -d $BUILD_DIR
}

prepare_atmosphere() {
    $DOWNLOAD_COMMAND https://github.com/Atmosphere-NX/Atmosphere/releases/download/1.8.0-prerelease/atmosphere-1.8.0-master-c6014b533+hbl-2.4.4+hbmenu-3.6.0.zip
    $UNZIP_COMMAND $TMP_DIR/atmosphere-*.zip -d $BUILD_DIR

    $DOWNLOAD_COMMAND https://github.com/Atmosphere-NX/Atmosphere/releases/download/1.8.0-prerelease/fusee.bin
    cp $TMP_DIR/fusee.bin $BUILD_DIR/bootloader/payloads/fusee.bin
}

prepare_evaron_atmosphere() {
    $DOWNLOAD_COMMAND https://github.com/pgalonza/ns-Atmosphere/releases/download/0.1.0/atmosphere-1.7.0-notbranch-dd29b60c3-hbl-2.4.4+hbmenu-3.6.0.zip
    $UNZIP_COMMAND $TMP_DIR/atmosphere-*.zip -d $BUILD_DIR

    $DOWNLOAD_COMMAND https://github.com/pgalonza/ns-Atmosphere/releases/download/0.1.0/fusee.bin
    cp $TMP_DIR/fusee.bin $BUILD_DIR/bootloader/payloads/fusee.bin
}

prepare_deepsea() {
    $DOWNLOAD_COMMAND https://github.com/Team-Neptune/DeepSea/releases/download/v4.11.0/deepsea-advanced_v4.11.0.zip
    $UNZIP_COMMAND $TMP_DIR/deepsea-advanced_*.zip -d $BUILD_DIR

    $DOWNLOAD_COMMAND https://github.com/pgalonza/ns-Atmosphere/releases/download/0.2.0/fusee.bin
    cp $TMP_DIR/fusee.bin $BUILD_DIR/bootloader/payloads/fusee.bin

    # rm -rf $BUILD_DIR/atmosphere/contents/420000000000000E /config/sys-ftpd
    rm -rf $BUILD_DIR/atmosphere/contents/420000000000000F $BUILD_DIR/config/sys-ftpd-10k
}

prepare_kefir() {
    $DOWNLOAD_COMMAND https://github.com/rashevskyv/kefir/releases/download/758/kefir758.zip
    $UNZIP_COMMAND $TMP_DIR/kefir_*.zip -d $BUILD_DIR
}

prepare_gnx() {
    $DOWNLOAD_COMMAND https://github.com/vncsmnl/GNX/releases/download/19.0.1-01/2024.12.23.GNX.19.0.1-01.zip
    $UNZIP_COMMAND $TMP_DIR/*.GNC.*.zip -d $BUILD_DIR
}

prepare_ultra() {
    $DOWNLOAD_COMMAND https://github.com/Ultra-NX/UltraNX/releases/download/2.3-R3/Ultra.zip
    $UNZIP_COMMAND $TMP_DIR/Ultra.zip -d $BUILD_DIR
}

prepare_next() {
    $DOWNLOAD_COMMAND https://codeberg.org/vampitech/NeXT/releases/download/3.33/NeXT.zip
    $UNZIP_COMMAND $TMP_DIR/Next.zip -d $BUILD_DIR
}

prepare_shallowsea() {
    $DOWNLOAD_COMMAND https://codeberg.org/carcaschoi/Shallowsea/releases/download/v2.24.2/ShallowSea-ams.zip
    $UNZIP_COMMAND $TMP_DIR/ShallowSea-*.zip -d $BUILD_DIR
}

prepare_4ifir() {
    $DOWNLOAD_COMMAND https://github.com/rashevskyv/4ifir-checker/raw/1631819/github/4IFIR.zip
    $UNZIP_COMMAND $TMP_DIR/4IFIR-*.zip -d $BUILD_DIR
}

prepare_hats() {
    $DOWNLOAD_COMMAND https://www.mediafire.com/file_premium/rg6pbf52fvgp4fo/HATS-1.8.0-V1.3.zip/file
    $UNZIP_COMMAND $TMP_DIR/HATS-*.zip -d $BUILD_DIR
}

prepare_santa_atmo() {
    $DOWNLOAD_COMMAND https://santa-atmo.ru/nintendo/atmo-1.8.0-161024.zip
    $UNZIP_COMMAND $TMP_DIR/atmo-*.zip -d $BUILD_DIR
}

prepare_venom() {
    $DOWNLOAD_COMMAND https://github.com/CatcherITGF/NX-Venom/releases/download/5.2.0/NXVenom.zip
    $UNZIP_COMMAND $TMP_DIR/NXVenom.zip -d $BUILD_DIR
}

prepare_overclock() {
    if [[ $ADDITIONAL_PACKAGES == true ]]
    then
        # alternative source > https://f38d61784492.hosting.myjino.ru/NintendoSwitch/OC_Switchcraft_EOS-1.5.0-atmosphere-1.8.0-prerelease.zip
        mkdir $TMP_DIR/Switchcraft
        $DOWNLOAD_COMMAND https://github.com/halop/OC-Switchcraft-EOS/releases/download/1.5.0/OC_Switchcraft_EOS.1.5.0.-.atmosphere.1.8.0.prerelease.zip
        $UNZIP_COMMAND $TMP_DIR/OC_Switchcraft_EOS_*.zip $TMP_DIR/Switchcraft
        rm $TMP_DIR/Switchcraft/Copy_to_SD/switch/.overlays/ovlmenu.ovl
        cp -rf $TMP_DIR/Switchcraft/Copy_to_SD/* $BUILD_DIR

        mkdir $TMP_DIR/Ultra
        $DOWNLOAD_COMMAND https://github.com/Ultra-NX/Ultra-Tuner/releases/download/19-R1/Ultra-Tuner.zip
        $UNZIP_COMMAND $TMP_DIR/OC_Switchcraft_EOS_*.zip $TMP_DIR/Ultra
        cp -rf "$TMP_DIR/Ultra/switch/.packages/Ultra Tuner" "$BUILD_DIR/switch/.packages/Ultra Tuner"

        $DOWNLOAD_COMMAND https://github.com/masagrator/FPSLocker/releases/download/2.1.0/FPSLocker.ovl
        cp -f $TMP_DIR/FPSLocker.ovl $BUILD_DIR/switch/.overlays/FPSLocker.ovl
    fi

    # alternative source > https://github.com/retronx-team/sys-clk/releases/download/2.0.1/sys-clk-2.0.1.zip
    $DOWNLOAD_COMMAND https://f38d61784492.hosting.myjino.ru/NintendoSwitch/sys-clk_1.1.4_eos.zip
    $UNZIP_COMMAND $TMP_DIR/sys-clk_*.zip -d $BUILD_DIR

    $DOWNLOAD_COMMAND https://github.com/masagrator/ReverseNX-RT/releases/download/2.1.0/ReverseNX-RT-ovl.ovl
    cp -f $TMP_DIR/ReverseNX-RT-ovl.ovl $BUILD_DIR/switch/.overlays/ReverseNX-RT-ovl.ovl
}

prepare_scripts() {
    $DOWNLOAD_COMMAND https://raw.githubusercontent.com/Atmosphere-NX/Atmosphere/master/utilities/insert_splash_screen.py
    git clone git@github.com:friedkeenan/switch-logo-patcher.git
    git clone git@github.com:zqb-all/convertfb.git
}

prepare_sigpatches() {
    # alternative source > https://sigmapatches.su/sigpatches.zip
    # $UNZIP_COMMAND $TMP_DIR/sigpatches.zip -d $BUILD_DIR
    $DOWNLOAD_COMMAND https://f38d61784492.hosting.myjino.ru/NintendoSwitch/Hekate+AMS-package3-sigpatches-1.8.0P2-cfw-19.0.0_V4.zip
    $UNZIP_COMMAND $TMP_DIR/Hekate+AMS-package3-sigpatches-*.zip -d $BUILD_DIR
}

prepare_overlays() {
    if [[ $ADDITIONAL_PACKAGES == true ]]
    then
        $DOWNLOAD_COMMAND https://github.com/nedex/QuickNTP/releases/download/1.2.8-1/quickntp-1.2.8-1.zip
        $UNZIP_COMMAND $TMP_DIR/quickntp-*.zip -d $BUILD_DIR
    fi

    # alternative source > https://sigmapatches.su/sys-patch.zip
    # alternative source > https://github.com/impeeza/sys-patch/releases/download/v1.5.2/sys-patch-1.5.2-88297f8.zip
    $DOWNLOAD_COMMAND https://github.com/borntohonk/sys-patch/releases/download/v1.5.6/sys-patch.zip
    $UNZIP_COMMAND $TMP_DIR/sys-patch.zip -d $BUILD_DIR
    rm $BUILD_DIR/atmosphere/contents/420000000000000B/flags/boot2.flag

    $DOWNLOAD_COMMAND https://github.com/ppkantorski/nx-ovlloader/releases/download/v1.0.9/nx-ovlloader.zip
    $UNZIP_COMMAND $TMP_DIR/nx-ovlloader.zip -d $BUILD_DIR

    $DOWNLOAD_COMMAND https://github.com/ppkantorski/Ultrahand-Overlay/releases/download/v1.8.2/ovlmenu.ovl
    cp -f $TMP_DIR/ovlmenu.ovl $BUILD_DIR/switch/.overlays/ovlmenu.ovl

    $DOWNLOAD_COMMAND https://github.com/ppkantorski/ovl-sysmodules/releases/download/v1.3.2/ovlSysmodules.ovl
    cp -f $TMP_DIR/ovlSysmodules.ovl $BUILD_DIR/switch/.overlays/ovlSysmodules.ovl

    $DOWNLOAD_COMMAND https://github.com/masagrator/SaltyNX/releases/download/1.2.0/SaltyNX-1.2.0.zip
    $UNZIP_COMMAND $TMP_DIR/SaltyNX-*.zip -d $BUILD_DIR

    # alternative source > https://github.com/ppkantorski/Status-Monitor-Overlay/releases/download/v1.1.4%2B/Status-Monitor-Overlay.ovl
    # cp -f $TMP_DIR/Status-Monitor-Overlay.ovl $BUILD_DIR/switch/.overlays/Status-Monitor-Overlay.ovl
    $DOWNLOAD_COMMAND https://github.com/masagrator/Status-Monitor-Overlay/releases/download/1.1.7a/Status-Monitor-Overlay.zip
    $UNZIP_COMMAND $TMP_DIR/Status-Monitor-Overlay.zip -d $BUILD_DIR

    $DOWNLOAD_COMMAND https://github.com/cathery/sys-ftpd/releases/download/1.0.5/sys-ftpd-1.0.5.zip
    $UNZIP_COMMAND $TMP_DIR/sys-ftpd-*.zip -d $BUILD_DIR
    rm $BUILD_DIR/atmosphere/contents/420000000000000E/flags/boot2.flag
}

prepare_sx_gear() {
    $DOWNLOAD_COMMAND https://f38d61784492.hosting.myjino.ru/NintendoSwitch/SX_Gear_v1.1.zip
    $UNZIP_COMMAND $TMP_DIR/SX_Gear_*.zip -d $BUILD_DIR
}

prepare_payload() {
    # alternative source > https://sigmapatches.su/Lockpick_RCM_v1.9.12.zip
    # $UNZIP_COMMAND $TMP_DIR/Lockpick_RCM_v1.9.12.zip -d $TMP_DIR/
    $DOWNLOAD_COMMAND https://github.com/saneki/Lockpick_RCM/releases/download/v1.9.13/Lockpick_RCM.bin
    cp -f $TMP_DIR/Lockpick_RCM.bin -d $BUILD_DIR/bootloader/payloads/Lockpick_RCM.bin

    $DOWNLOAD_COMMAND https://f38d61784492.hosting.myjino.ru/NintendoSwitch/mod_chip_toolbox.zip
    $UNZIP_COMMAND $TMP_DIR/mod_chip_toolbox.zip -d $BUILD_DIR/bootloader/payloads/

    $DOWNLOAD_COMMAND https://github.com/suchmememanyskill/TegraExplorer/releases/download/4.2.0/TegraExplorer.bin
    cp -f $TMP_DIR/TegraExplorer.bin  -d $BUILD_DIR/bootloader/payloads/TegraExplorer.bin
}

prepare_homebrew() {
    if [[ $ADDITIONAL_PACKAGES == true ]]
    then
        mkdir $BUILD_DIR/switch/atmo-pack-updater
        $DOWNLOAD_COMMAND https://github.com/PoloNX/AtmoPackUpdater/releases/download/2.0.1/AtmoPackUpdater.nro
        cp -f $TMP_DIR/AtmoPackUpdater.nro $BUILD_DIR/switch/atmo-pack-updater/AtmoPackUpdater.nro

        mkdir $BUILD_DIR/switch/linkalho
        $DOWNLOAD_COMMAND https://f38d61784492.hosting.myjino.ru/NintendoSwitch/linkalho-v2.0.1.zip
        $UNZIP_COMMAND $TMP_DIR/linkalho-*.zip -d $BUILD_DIR/switch/linkalho

        $DOWNLOAD_COMMAND https://github.com/switchbrew/nx-hbloader/releases/download/v2.4.4/hbl.nsp
        cp $TMP_DIR/hbl.nsp $BUILD_DIR/atmosphere/hbl.nsp

        $DOWNLOAD_COMMAND https://github.com/switchbrew/nx-hbmenu/releases/download/v3.6.0/nx-hbmenu_v3.6.0.zip
        $UNZIP_COMMAND $TMP_DIR/nx-hbmenu_* $BUILD_DIR

        $DOWNLOAD_COMMAND https://github.com/dslatt/nso-icon-tool/releases/download/v0.4.4/nso-icon-tool.nro
        cp -f $TMP_DIR/nso-icon-tool.nro $BUILD_DIR/switch/nso-icon-tool.nro

        $DOWNLOAD_COMMAND https://github.com/J-D-K/JKSV/releases/download/11%2F05%2F2024/JKSV.nro
        cp -f $TMP_DIR/JKSV.nro $BUILD_DIR/switch/JKSV.nro

        mkdir $BUILD_DIR/switch/NX-Shell || true
        $DOWNLOAD_COMMAND https://github.com/joel16/NX-Shell/releases/download/4.01/NX-Shell.nro
        cp -f $TMP_DIR/NX-Shell.nro $BUILD_DIR/switch/NX-Shell/NX-Shell.nro

        $DOWNLOAD_COMMAND https://github.com/mtheall/ftpd/releases/download/v3.2.1/ftpd.nro
        cp -f $TMP_DIR/ftpd.nro $BUILD_DIR/switch/ftpd.nro

        $DOWNLOAD_COMMAND https://github.com/mrdude2478/Tinwoo-Release/releases/download/1.0.27/Tinwoo-Installer.zip
        $UNZIP_COMMAND $TMP_DIR/Tinwoo-Installer.zip $BUILD_DIR

        $DOWNLOAD_COMMAND https://github.com/PoloNX/SimpleModDownloader/releases/download/2.1.0/SimpleModDownloader.nro
        cp -f $TMP_DIR/SimpleModDownloader.nro $BUILD_DIR/switch/SimpleModDownloader.nro

        $DOWNLOAD_COMMAND https://github.com/nadrino/SimpleModManager/releases/download/2.1.2/SimpleModManager.nro
        cp -f $TMP_DIR/SimpleModManager.nro $BUILD_DIR/switch/SimpleModManager.nro

        mkdir $BUILD_DIR/switch/appstore || true
        $DOWNLOAD_COMMAND https://github.com/fortheusers/hb-appstore/releases/download/v2.3.2/appstore.nro
        cp -f $TMP_DIR/appstore.nro $BUILD_DIR/switch/appstore/appstore.nro
    fi

    mkdir $BUILD_DIR/switch/DBI
    $DOWNLOAD_COMMAND https://github.com/rashevskyv/dbi/releases/download/749ru/DBI.nro
    cp -f $TMP_DIR/DBI.nro $BUILD_DIR/switch/DBI/DBI.nro

    $DOWNLOAD_COMMAND https://github.com/HamletDuFromage/aio-switch-updater/releases/download/2.23.2/aio-switch-updater.zip
    $UNZIP_COMMAND $TMP_DIR/aio-switch-updater.zip -d $BUILD_DIR

    mkdir $BUILD_DIR/switch/ezremote-client || true
    $DOWNLOAD_COMMAND https://github.com/cy33hc/switch-ezremote-client/releases/download/1.06/ezremote-client.nro
    cp -f $TMP_DIR/ezremote-client.nro $BUILD_DIR/switch/ezremote-client/ezremote-client.nro
}

prepare_emulators() {
    $DOWNLOAD_COMMAND https://www.ppsspp.org/files/Switch/Release_PPSSPP_Standalone_11.09.2024.7z
    7z x $TMP_DIR/Release_PPSSPP_Standalone_*.7z -o"$BUILD_DIR" -aoa
    rm $BUILD_DIR/README.txt $BUILD_DIR/LICENSE.txt

    $DOWNLOAD_COMMAND https://buildbot.libretro.com/stable/1.20.0/nintendo/switch/libnx/RetroArch.7z
    7z x $TMP_DIR/RetroArch.7z -o"$BUILD_DIR" -aoa
}

prepare_cheat() {
    $DOWNLOAD_COMMAND https://github.com/tomvita/Breeze-Beta/releases/download/beta98a/Breeze.zip
    $UNZIP_COMMAND $TMP_DIR/Breeze.zip -d $BUILD_DIR

    $DOWNLOAD_COMMAND https://github.com/tomvita/EdiZon-SE/releases/download/3.8.37/EdiZon.zip
    $UNZIP_COMMAND $TMP_DIR/EdiZon.zip -d $BUILD_DIR

    # alternative source > https://github.com/ppkantorski/EdiZon-Overlay/releases/download/v1.0.9/ovlEdiZon.ovl
    $DOWNLOAD_COMMAND https://github.com/proferabg/EdiZon-Overlay/releases/download/v1.0.9/ovlEdiZon.ovl
    cp -f $TMP_DIR/ovlEdiZon.ovl $BUILD_DIR/switch/.overlays/ovlEdiZon.ovl
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
    cp -f "$SRC_HOMEBREW/dbi/dbi.config" "$BUILD_DIR/switch/DBI/dbi.config"

    mkdir -p $BUILD_DIR/config/aio-switch-updater
    cp -f "$SRC_HOMEBREW/aio-switch-updater/custom_packs.json" "$BUILD_DIR/config/aio-switch-updater/custom_packs.json"

    mkdir $BUILD_DIR/config/AtmoPackUpdater
    cp -f "$SRC_HOMEBREW/atmo-pack-updater/config.json" "$BUILD_DIR/config/AtmoPackUpdater/config.json"

    mkdir $BUILD_DIR/switch/ezremote-client || true
    cp -f "$SRC_HOMEBREW/ezremote-client/config.ini" "$BUILD_DIR/switch/ezremote-client/config.ini"

}

patch_overlay() {
    cp -f "$SRC_OVERLAY/sys-ftpd/config.ini" "$BUILD_DIR/config/sys-ftpd/config.ini"
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
prepare_deepsea
prepare_sigpatches
prepare_sx_gear
prepare_payload
prepare_homebrew
# prepare_emulators
prepare_overlays
prepare_cheat
prepare_overclock

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