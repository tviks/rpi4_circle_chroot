#!/bin/bash


Help()
{
   # Display Help
   echo "CIRCLE CHROOT RPI ISO"
   echo
   echo "Syntax: circle.sh [-h] operation_name"
   echo
   echo "operations:"
   echo "download     Download and unziping raspbian iso."
   echo "space        Add free space to iso"
   echo "chroot       Exetude your script"
   echo
   echo "   usage    circle.sh chroot [y] [use_script] [name_script]"
   echo "         y - update and upgrade system [n, y]"
   echo "         y - use you script [n, y]"
   echo "         name_script - name script in folder 'scripts/'"
   echo
   echo "mount        Mounting filesystem"
   echo "umount       Umounting filesystem"
   echo
}

while getopts ":h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
   esac
done

source tools/color.sh



print_space=$"======================"

if [[ $1 == "download" ]]; then
    echo $print_space
    echo "DOWNLOAD ISO AND TOOLS"; green_echo
    echo $print_space
    sudo tools/get_iso.sh

elif [[ $1 == "space" ]]; then
    echo $print_space
    MESSAGE="ADDING SPACE" ; blue_echo
    echo $print_space
    sudo tools/update_iso.sh
    MESSAGE="ADDING SPACE COMPLETE" ; green_echo

elif [[ $1 == "mount" ]]; then
    echo $print_space
    MESSAGE="MOUNTING..." ; blue_echo
    echo $print_space

    sudo service binfmt-support restart

    iso_name=$(ls iso/ | cut -d' ' -f2)
    loop_dev=$(sudo kpartx -v -a iso/$iso_name | awk '{print $3}')
    sudo mount /dev/mapper/"$(echo $loop_dev | cut -c -5)"p2 mnt/
    sudo mount /dev/mapper/"$(echo $loop_dev | cut -c -5)"p1 mnt/boot
    sudo cp /usr/bin/qemu-arm-static mnt/usr/bin
    sudo rm -rf mnt/etc/resolv.conf
    sudo echo nameserver 8.8.8.8 >> mnt/etc/resolv.conf
    sudo mount -o bind /dev mnt/dev
    sudo mount -o bind /dev/pts mnt/dev/pts
    sudo mount -o bind /proc mnt/proc
    sudo mount -o bind /sys mnt/sys
    sudo mount -o bind /run mnt/run
    sudo cp /etc/network/interfaces mnt/etc/network/interfaces
    sudo cp /etc/resolv.conf mnt/etc/resolv.conf
    sudo echo ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-static:' > /proc/sys/fs/binfmt_misc/register
    sudo chroot mnt/
    MESSAGE="COMPLETE MOUNT" ; green_echo

elif [[ $1 == "umount" ]]; then
    echo $print_space
    MESSAGE="UMOUNTING..." ; blue_echo
    echo $print_space
    sudo tools/umount.sh
    MESSAGE="COMPLETE UMOUNT" ; green_echo

elif [[ $1 == "chroot" ]]; then
    echo $print_space
    MESSAGE="START CHROOT SCRIPT" ; blue_echo
    echo $print_space
    sudo tools/chroot.sh "$2" "$3" "$4"
    MESSAGE="COMPLETE CHROOT SCRIPT" ; green_echo
else
    echo $print_space
    MESSAGE="WRONG OPTION" ; red_echo
    MESSAGE="use -h to see operations" ; blue_echo
fi