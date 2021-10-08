#!/bin/bash

source tools/color.sh

iso_name=$(ls iso/ | cut -d' ' -f2 | sed -n '1p')
iso_size=$(ls -lh iso/ | cut -d' ' -f2 | cut -c -4 | sed -n '1p' | cut -c -1)

print_space=$"======================"

echo ISO NAME
echo $iso_name
echo ISO SIZE
echo $iso_size

if [[ $iso_size < 3 ]]; then
  echo $print_space
  echo "ADD SPACE"; blue_echo
  echo $print_space
  dd if=/dev/zero bs=1M count=1024 >> iso/$iso_name 

else
  echo $print_space
  echo "SKIP ADD SPACE"; blue_echo
  echo $print_space
fi


loop_dev=$(sudo kpartx -v -a iso/$iso_name | grep add | cut -d' ' -f3 | sed -n '2p' | cut -c -5)
echo "RESIZE FILESYSTEM"; blue_echo
sudo parted /dev/"$loop_dev" ---pretend-input-tty << EOF
resizepart 2 -1s
quit
EOF

sudo losetup -d /dev/$loop_dev
sudo kpartx -ds /dev/$loop_dev

loop_dev=$(sudo kpartx -v -a iso/$iso_name | grep add | cut -d' ' -f3 | sed -n '2p' | cut -c -5)

sudo e2fsck -f /dev/mapper/"$loop_dev"p2 > /dev/null 2>&1 &
sudo resize2fs /dev/mapper/"$loop_dev"p2 > /dev/null 2>&1 &

echo "COMPLETE RESIZE FILESYSTEM"; blue_echo

sudo losetup -d /dev/$loop_dev
sudo kpartx -ds /dev/$loop_dev

