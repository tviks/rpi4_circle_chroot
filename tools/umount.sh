#!/bin/bash

#sed -i 's/^#//g' mnt/etc/ld.so.preload

sudo umount mnt/dev
sudo umount mnt/dev/pts
sudo umount mnt/proc
sudo umount mnt/sys
sudo umount mnt/run

sudo umount mnt/boot
sudo umount mnt/

sudo kpartx -d /dev/loop0

