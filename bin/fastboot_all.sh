#!/bin/bash

usage(){
    echo "$0 [boot] [images_path]"
}


FASTBOOT_FLASH_CMD='fastboot flash'

# ?? avoid quick flashing problem?
sanity_check() {
    case "$?" in
        0)
            sleep 2
            ;;
        *)
            echo "** Error Detected, abort!"
            exit 2
            ;;
    esac
}

pr_info(){
    echo "*** " $1 " ***"
}

# safe fastboot flash: check possible errors, error exit, sanity delay and etc.
safe_fastflash (){
    if [ $# -lt 2 ]; then
        echo "** Internal Error: safe_fastflash requires at least two arguments."
        exit 3
    fi

    target="$1"
    image="$2"

    $FASTBOOT_FLASH_CMD "$target" "$image"
    sanity_check
}

# default images settings
BOOT_IMG="boot.img"
USERDATA_IMG="userdata.img"
SYSTEM_IMG="system.img"
PERSIST_IMG="persist.img"
RECOVERY_IMG="recovery.img"

# extended area
#
# Add a new product with special images settings
case "$TARGET_PRODUCT" in
    "u10")
        # default images setting is OK
        echo > /dev/null
        ;;
    "u20")
        USERDATA_IMG="$USERDATA_IMG.ext4.spa"
        SYSTEM_IMG="$SYSTEM_IMG.ext4.spa"
        ;;
    "msm7627a")
        USERDATA_IMG="$USERDATA_IMG.ext4"
        SYSTEM_IMG="$SYSTEM_IMG.ext4"
        PERSIST_IMG="$PERSIST_IMG.ext4"
        ;;
    "tr761")
        BOOT_IMG="boot.2knand.img"
        USERDATA_IMG="userdata.2knand.img"
        SYSTEM_IMG="system.2knand.img"
        PERSIST_IMG="persist.2knand.img"
        RECOVERY_IMG="recovery.2knand.img"
        ;;
    *)
        echo "*** Have you sourced the envsetup.sh and choosecombo-ed? Aborted!"
        exit -1
        ;;
esac

flash_all(){
    # do the real flashing
    safe_fastflash boot $BOOT_IMG
    safe_fastflash userdata $USERDATA_IMG
    safe_fastflash system $SYSTEM_IMG
    safe_fastflash persist $PERSIST_IMG
    safe_fastflash recovery $RECOVERY_IMG
}

flash_single(){
    case $TARGET_IMAGE in
        "boot")
            safe_fastflash boot $BOOT_IMG
            ;;
        *)
            echo "Unsupported partitions. Only boot is supported for now."
            exit 5
            ;;
    esac
}

################ main ################
echo "Ha, so you are lazy....fastboot-flash-all!!!!"

# parameter parsing
case $# in
    0)
        echo "WARNING: '$OUT' will be used. ALL will be flashed."
        echo "Normally you should give the path to out directory as argument "      \
            "a common one is '.' or '`pwd`'."
        usage
        OUT_DIR="$OUT"
        ;;
    1)
        OUT_DIR="$1"
        ;;
    2)
        TARGET_IMAGE="$1"
        OUT_DIR="$2"
        ;;
    *)
        echo "Too many arguments."
        usage
        exit 4
        ;;
esac

if [ ! -d "$OUT_DIR" ]; then
    echo "You Fool, \"$OUT_DIR\" is __not__ a directory."
    exit 1
fi

cd $OUT_DIR
if [ -z "$TARGET_IMAGE" ]; then
    flash_all
else
    flash_single
fi

fastboot reboot
adb wait-for-device
echo "Hu. Done."
