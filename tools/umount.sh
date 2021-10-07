#!/bin/bash

sed -i 's/^#//g' mnt/etc/ld.so.preload
sudo umount mnt/{dev/pts,dev,sys,proc,boot,}


sudo losetup -d /dev/loop0
sudo kpartx -ds /dev/loop0
sudo losetup -d /dev/loop1
sudo kpartx -ds /dev/loop1
sudo losetup -d /dev/loop2
sudo kpartx -ds /dev/loop2
sudo losetup -d /dev/loop3
sudo kpartx -ds /dev/loop3
sudo losetup -d /dev/loop4
sudo kpartx -ds /dev/loop4
sudo losetup -d /dev/loop5
sudo kpartx -ds /dev/loop5
sudo losetup -d /dev/loop6
sudo kpartx -ds /dev/loop6