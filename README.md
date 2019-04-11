# autodecrypt disk at book (luks)
tool to decrypt disk from a key contained on a ``USBBOOT`` labeled part on a removable media.

If the key isnt found, it will fallback to keyboard input challenge

This is for debian/ubuntu style initramfs and install to survive upgrades:
 - a mkinitrd hook to survive upgrades.
 - a tool in the initramfs to decrypt the disk
