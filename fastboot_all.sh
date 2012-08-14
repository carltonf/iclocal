#!/bin/bash

echo "Ha, so you are lazy....fastboot-flash-all!!!!"

if [ $# -lt 1 ]; then
    echo "WARNING: '$OUT' will be used."
    echo "Normally you should give the path to out directory as argument, a common one is `pwd`."
    OUT_DIR="$OUT"
else
    OUT_DIR="$1"
fi

if [ ! -d "$OUT_DIR" ]; then
    echo "You Fool, \"$OUT_DIR\" is __not__ a directory."
    exit 1
fi

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

cd $OUT_DIR
if [ $TARGET_PRODUCT = 'u20' ]; then
    USERDATA_IMG="$USERDATA_IMG.ext4.spa"
    SYSTEM_IMG="$SYSTEM_IMG.ext4.spa"
elif [ $TARGET_PRODUCT = 'u10' ]; then
    # default images setting is OK
    echo > /dev/null
elif [ $TARGET_PRODUCT = 'msm7627a' ]; then
    USERDATA_IMG="$USERDATA_IMG.ext4"
    SYSTEM_IMG="$SYSTEM_IMG.ext4"
    PERSIST_IMG="$PERSIST_IMG.ext4"
else
    echo "*** Have you sourced the envsetup.sh? Aborted!"
    exit -1
fi

# do the real flashing
safe_fastflash boot $BOOT_IMG
safe_fastflash userdata $USERDATA_IMG
safe_fastflash system $SYSTEM_IMG
safe_fastflash persist $PERSIST_IMG
safe_fastflash recovery $RECOVERY_IMG

fastboot reboot
adb wait-for-device
echo "Hu. Done."
