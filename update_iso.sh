#!/bin/bash

iso_name=$(ls iso/)

echo $iso_name

dd if=/dev/zero bs=1M count=1024 >> $iso_name

loop_dev=$(sudo kpartx -v -a iso/$iso_name | grep add | cut -d' ' -f3 | sed -n '2p' | cut -c -5)

echo "$loop_dev"

sudo parted -s /dev/loop0 resizepart 2

sudo e2fsck -f /dev/mapper/$loop_devp2
sudo resize2fs /dev/mapper/$loop_devp2

sudo losetup -d /dev/loop0
sudo kpartx -ds /dev/loop0

