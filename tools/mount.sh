#!/bin/bash

source tools/color.sh

iso_name=$(ls iso/ | cut -d' ' -f2 | sed -n '1p')

#echo $iso_name

#dd if=/dev/zero bs=1M count=1024 >> $iso_name

loop_dev=$(sudo kpartx -v -a iso/$iso_name | grep add | cut -d' ' -f3 | sed -n '2p' | cut -c -5)
#loop_dev="add map loop0p1 (252:0): 0 524288 linear 7:0 2048 add map loop0p2 (252:1): 0 8149534 linear 7:0 526336"

#echo "$loop_dev"


sudo mount -o rw /dev/mapper/"$loop_dev"p2  mnt/
sudo mount -o rw /dev/mapper/"$loop_dev"p1 mnt/boot/

sudo mount --bind /dev mnt/dev/
sudo mount --bind /sys mnt/sys/
sudo mount --bind /proc mnt/proc/
sudo mount --bind /dev/pts mnt/dev/pts

sed -i 's/^/#/g' mnt/etc/ld.so.preload

sudo cp /usr/bin/qemu-arm-static mnt/usr/bin/        
sudo rm -rf mnt/etc/resolv.conf
sudo echo nameserver 8.8.8.8 >> mnt/etc/resolv.conf

sudo service binfmt-support start

echo "DONE"; green_echo



