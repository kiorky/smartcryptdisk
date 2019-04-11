#!/bin/bash
set -ex
cd "$(dirname $0)"
cp -vf passphrase-from-usb /sbin
cp -vf hooks/* /usr/share/initramfs-tools/hooks
KEY_HOSTNAME=${KEY_HOSTNAME:-$(hostname)}
KEYS_ROOT=${KEYS_ROOT:-/luks-keys}
KEYS_DEVICE=${KEYS_DEVICE:-/dev/disk/by-label/USBBOOT}
MAIN_KEY=${MAIN_KEY:-${1}}
SKIP_INITRAMFS=${SKIP_INITRAMFS-}
if [ "x$MAIN_KEY" = "x" ];then
    # try to get it from crypttab
    if [ -e /etc/crypttab ];then
        device=$(grep passphrase-from-usb /etc/crypttab \
            | egrep -v "^#"|awk '{print $1}'|sed -re "s/_.*//g")
    fi
    if [ "x$device" != "x" ];then
        MAIN_KEY="${device}_key"
    fi
fi
if [ "x$MAIN_KEY" = "x" ];then
    echo nokey >&2
    exit 1
fi
sed -i -r \
 -e "s/__KEY__/$MAIN_KEY/g" \
 -e "s/__HOSTNAME__/$KEY_HOSTNAME/g" \
 -e 's!__KEYS_ROOT__!'$KEYS_ROOT'!g' \
 -e 's!__KEYS_DEVICE__!'$KEYS_DEVICE'!g' \
 /sbin/passphrase-from-usb

if [ "x$SKIP_INITRAMFS" = "x" ];then
    # update-initramfs -uv 2>&1 | egrep "passdev|passphrase"
    update-initramfs -uv
fi
