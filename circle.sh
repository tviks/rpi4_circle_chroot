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
    sudo tools/mount.sh
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