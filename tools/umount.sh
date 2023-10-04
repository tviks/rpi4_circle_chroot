#!/bin/bash

sed -i 's/^#//g' mnt/etc/ld.so.preload

sudo umount mnt/dev
sudo umount mnt/dev/pts
sudo umount mnt/proc
sudo umount mnt/sys
sudo umount mnt/run

sudo iosetup -d /dev/loop0
sudo kpartx -ds /dev/loop0
sudo iosetup -d /dev/loop1
sudo kpartx -ds /dev/loop1
sudo iosetup -d /dev/loop2
sudo kpartx -ds /dev/loop2
sudo iosetup -d /dev/loop3
sudo kpartx -ds /dev/loop3
sudo iosetup -d /dev/loop4
sudo kpartx -ds /dev/loop4
sudo iosetup -d /dev/loop5
sudo kpartx -ds /dev/loop5
sudo iosetup -d /dev/loop6
sudo kpartx -ds /dev/loop6
