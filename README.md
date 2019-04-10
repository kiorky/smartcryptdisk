# autodecrypt disk at book (luks)
tool to decrypt disk from a key contained on a ``USBBOOT`` labeled part on a removable media.

If the key isnt found, it will fallback to keyboard input challenge

This is for debian/ubuntu style initramfs and install to survive upgrades:
 - a mkinitrd hook to survive upgrades.
 - a tool in the initramfs to decrypt the disk


## notes
To autodetect the first disk (that needs a key), you should have at least one entry in the form in your ``/etc/crypttab``
```
XXX_crypt UUID=1-2-3-4-5 none luks,discard,keyscript=/sbin/passphrase-from-usb
```

By default, the script guess the key for ``XXX_crypt`` as ``$media:/luks-keys/$hostname/XXX.key``.
