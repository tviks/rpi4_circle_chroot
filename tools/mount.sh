#!/bin/bash

source tools/color.sh

iso_name=$(ls iso/ | cut -d' ' -f2)

#echo $iso_name

#dd if=/dev/zero bs=1M count=1024 >> $iso_name

loop_dev=$(sudo kpartx -v -a iso/$iso_name | awk '{print $3}' | cut -c -5)
#loop_dev="add map loop0p1 (252:0): 0 524288 linear 7:0 2048 add map loop0p2 (252:1): 0 8149534 linear 7:0 526336"

#echo "$loop_dev"

sudo service binfmt-support start

sudo mount /dev/mapper/"$loop_dev"p2 mnt/
sudo mount /dev/mapper/"$loop_dev"p1  mnt/boot

sudo cp /usr/bin/qemu-arm-static mnt/usr/bin

sudo mount -o bind /dev mnt/dev
sudo mount -o bind /dev/pts mnt/dev/pts
sudo mount -o bind /proc mnt/proc
sudo mount -o bind /sys mnt/sys
sudo mount -o bind /run mnt/run
sudo cp /etc/network/interfaces mnt/etc/network/interfaces
sudo cp /etc/resolv.conf mnt/etc/resolv.conf
sudo echo ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-static:' > /proc/sys/fs/binfmt_misc/register
sudo chroot mnt/

echo "DONE"; green_echo



