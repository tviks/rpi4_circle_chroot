#!/bin/bash

source tools/color.sh

iso_name=$(ls iso/ | cut -d' ' -f2)
iso_size=$(ls -lh iso/ | cut -d' ' -f2 | cut -c -4 | sed -n '1p' | cut -c -1)

print_space=$"======================"

echo ISO NAME
echo $iso_name
echo ISO SIZE
echo $iso_size

if [[ $iso_size < 6 ]]; then
  echo $print_space
  echo "ADD SPACE"; blue_echo
  echo $print_space
  dd if=/dev/zero bs=1024M count=10 >> iso/$iso_name 

else
  echo $print_space
  echo "SKIP ADD SPACE"; blue_echo
  echo $print_space
fi


loop_dev=$(sudo kpartx -v -a iso/$iso_name | awk '{print $3}')
echo "RESIZE FILESYSTEM"; blue_echo
sudo parted /dev/"$(echo $loop_dev | cut -c -5)" ---pretend-input-tty << EOF
resizepart 2 -1s
quit
EOF

sudo e2fsck -f /dev/mapper/"$(echo $loop_dev | cut -c -5)"p2 > /dev/null 2>&1 &
sudo resize2fs /dev/mapper/"$(echo $loop_dev | cut -c -5)"p2 > /dev/null 2>&1 &

echo "COMPLETE RESIZE FILESYSTEM"; blue_echo

sudo losetup -d /dev/$(echo $loop_dev | cut -c -5)
sudo kpartx -ds /dev/$(echo $loop_dev | cut -c -5)

