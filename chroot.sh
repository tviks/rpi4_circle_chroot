#!/bin/bash
echo $1
echo $2

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

sudo cp /usr/bin/qemu-aarch64-static mnt/usr/bin/        

sudo service binfmt-support start
echo $print_space
echo "DONE"
echo $print_space
sudo rm -rf mnt/etc/resolv.conf
sudo echo nameserver 8.8.8.8 >> mnt/etc/resolv.conf

if [[ "$1" == "y" ]]; then
  echo $print_space
  echo "UPDATE ISO - YES"
  echo $print_space
  sudo chroot mnt/ bin/bash << "EOT" 
  sudo apt-get update && sudo apt-get upgrade -y 
EOT

else
  echo $print_space
  echo "SKIP UPDATE ISO"
  echo $print_space
fi

if [[ $2 == "wifi" ]]; then
  echo "WIFI AP - YES"
    sudo cp scripts/wifi_ap.sh mnt/root/
    sudo chroot mnt/ bin/bash ./root/wifi_ap.sh

else
  echo "WIFI AP - NO"
fi


sudo umount mnt/{dev/pts,dev,sys,proc,boot,}

sudo losetup -d /dev/loop0
sudo kpartx -ds /dev/loop0

