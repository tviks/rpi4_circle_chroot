#!/bin/bash

iso_name=$(ls iso/)
iso_size=$(ls -lh iso/ | ls -lh iso/ | cut -d' ' -f5 | cut -c -1)


echo ISO NAME
echo $iso_name

echo ISO SIZE
echo $iso_size


if [[ $iso_size > 4 ]]; then
  echo "ADD SPACE"
  dd if=/dev/zero bs=1M count=1024 >> iso/$iso_name  

else
  echo "SKIP ADD SPACE"
fi


loop_dev=$(sudo kpartx -v -a iso/$iso_name | grep add | cut -d' ' -f3 | sed -n '2p' | cut -c -5)

echo LOOP DEVICE NAME
echo "$loop_dev"

sudo parted -s /dev/$loop_dev resizepart 2

sudo losetup -d /dev/loop0
sudo kpartx -ds /dev/loop0

loop_dev=$(sudo kpartx -v -a iso/$iso_name | grep add | cut -d' ' -f3 | sed -n '2p' | cut -c -5)

sudo e2fsck -f /dev/mapper/"$loop_dev"p2
sudo resize2fs /dev/mapper/"$loop_dev"p2

sudo losetup -d /dev/loop0
sudo kpartx -ds /dev/loop0

