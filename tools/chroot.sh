#!/bin/bash

source tools/color.sh

print_space=$"======================"

iso_name=$(ls iso/)

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

sudo cp /usr/bin/qemu-aarch64-static mnt/usr/bin/        
sudo cp /usr/bin/qemu-arm-static mnt/usr/bin/   

sudo service binfmt-support start
sudo rm -rf mnt/etc/resolv.conf
sudo echo nameserver 8.8.8.8 >> mnt/etc/resolv.conf

if [[ "$1" == "y" ]]; then
  echo $print_space
  MESSAGE="UPDATE ISO - YES" ; blue_echo
  echo $print_space
  sudo chroot mnt/ bin/bash << "EOT" 
  sudo apt-get update && sudo apt-get upgrade -y
  sudo /etc/init.d/ssh restart 
EOT
  MESSAGE="COMPLETE UPDATE ISO" ; green_echo

else
  echo $print_space
  MESSAGE="SKIP UPDATE ISO" ; green_echo
  echo $print_space
fi

if [[ $2 == "y" ]]; then
  MESSAGE="ADD SKRIPT - YES" ; green_echo
  echo $print_space
  sudo cp scripts/$3 mnt/root/
  sudo chroot mnt/ bin/bash ./root/$3 
  MESSAGE="SKRIPT COMPLETE" ; green_echo
else
  MESSAGE="SKRIPT SKIP" ; green_echo
  echo $print_space
fi

sed -i 's/^#//g' mnt/etc/ld.so.preload

sudo umount mnt/{dev/pts,dev,sys,proc,boot,}

sudo losetup -d /dev/loop0
sudo kpartx -ds /dev/loop0

