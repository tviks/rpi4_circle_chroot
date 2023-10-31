#!/bin/bash


Help()
{
   # Display Help
   echo "CIRCLE CHROOT RPI ISO"
   echo
   echo "Syntax: circle.sh [-h] operation_name"
   echo
   echo "operations:"
   echo "list     List avalible iso"
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

pwd=$(pwd)
iso_name=$(ls iso/ | cut -d' ' -f2)
iso_size=$(ls -lh iso/ | cut -d' ' -f2 | cut -c -4 | sed -n '1p')

if [[ $1 == "list" ]]; then
    output_log "YELLOW" "List ISO"
    echo ""
    colorText "YELLOW" "Img name - "$iso_name
    colorText "YELLOW" "Img size - "$iso_size
    colorText "YELLOW" "Img path - "$pwd"/iso/"

elif [[ $1 == "space" ]]; then
    output_log "YELLOW" "Adding space"

    sudo service binfmt-support restart

    colorText "YELLOW" "Img name - "$iso_name
    colorText "YELLOW" "Img size - "$iso_size
    colorText "GREEN" "Input add space size in Mb"

    read input

    if [[ $input ]] && [ $input -eq $input 2>/dev/null ]
    then
        colorText "YELLOW" "Adding ""$input""Mb in img file"
        dd if=/dev/zero bs=1M count=$input >> iso/$iso_name
        colorText "GREEN" "Done"
        echo ""
        colorText "YELLOW" "New img spec:"
        colorText "YELLOW" "Img name - "$iso_name
        iso_size=$(ls -lh iso/ | cut -d' ' -f2 | cut -c -4 | sed -n '1p')
        colorText "YELLOW" "Img size - "$iso_size


        output_log "YELLOW" "RESIZE FILESYSTEM"
        loop_dev=$(sudo kpartx -v -a iso/$iso_name | awk '{print $3}' | cut -c -5 | sed -n '1p')
        colorText "YELLOW" "Loop dev - "$loop_dev

        sudo parted /dev/$loop_dev ---pretend-input-tty << EOF
resizepart 2 -1s
quit
EOF

        sudo losetup -d /dev/$loop_dev
        sudo e2fsck -fy /dev/mapper/$loop_dev"p2" #> /dev/null 2>&1 &
        sleep 2
        sudo resize2fs /dev/mapper/$loop_dev"p2" #> /dev/null 2>&1 &

        colorText "GREEN" "COMPLETE RESIZE FILESYSTEM"

        while [[ "$loop_dev" != '' ]]
        do
        sleep 2
        sudo kpartx -d /dev/$loop_dev
        loop_dev=$(ls /dev/mapper/ | awk '{print $1}' |  sed -n '2p' | cut -c -5)

        sudo service binfmt-support stop
        done

        stty sane
        exit
    else
        colorText "RED" "$input is not an integer or not defined"
        stty sane
        exit
    fi

elif [[ $1 == "mount" ]]; then
    
    output_log "YELLOW" "MOUNT FILE SYSTEM"

    sudo service binfmt-support restart

    loop_dev=$(sudo kpartx -v -a iso/$iso_name | awk '{print $3}' | cut -c -5 | sed -n '1p')
    sudo mount /dev/mapper/$loop_dev"p2" mnt/
    sudo mount /dev/mapper/$loop_dev"p1" mnt/boot
    sudo cp /usr/bin/qemu-arm-static mnt/usr/bin
    sudo rm -rf mnt/etc/resolv.conf
    #sudo echo nameserver 8.8.8.8 >> mnt/etc/resolv.conf
    sudo mount -o bind /dev mnt/dev
    sudo mount -o bind /dev/pts mnt/dev/pts
    sudo mount -o bind /proc mnt/proc
    sudo mount -o bind /sys mnt/sys
    sudo cp /etc/resolv.conf mnt/etc/resolv.conf

elif [[ $1 == "umount" ]]; then
    
    output_log "YELLOW" "UMOUNT FILE SYSTEM"

    loop_dev=$(ls /dev/mapper/ | awk '{print $1}' |  sed -n '2p' | cut -c -5)

    while [[ "$loop_dev" != '' ]]
    do
    sudo umount mnt/dev
    sudo umount mnt/dev/pts
    sudo umount mnt/proc
    sudo umount mnt/sys
    sudo umount mnt/run
    sudo umount mnt/boot
    sudo umount mnt/
    sleep 2
    sudo kpartx -d /dev/$loop_dev
    sudo service binfmt-support stop
    loop_dev=$(ls /dev/mapper/ | awk '{print $1}' |  sed -n '2p' | cut -c -5)
    done

elif [[ $1 == "chroot" ]]; then
    
    output_log "YELLOW" "RUN CHROOT"

    sudo service binfmt-support restart

    loop_dev=$(sudo kpartx -v -a iso/$iso_name | awk '{print $3}' | cut -c -5 | sed -n '1p')
    sudo mount /dev/mapper/$loop_dev"p2" mnt/
    sudo mount /dev/mapper/$loop_dev"p1" mnt/boot
    sudo cp /usr/bin/qemu-arm-static mnt/usr/bin
    sudo rm -rf mnt/etc/resolv.conf
    #sudo echo nameserver 8.8.8.8 >> mnt/etc/resolv.conf
    sudo mount -o bind /dev mnt/dev
    sudo mount -o bind /dev/pts mnt/dev/pts
    sudo mount -o bind /proc mnt/proc
    sudo mount -o bind /sys mnt/sys
    sudo cp /etc/resolv.conf mnt/etc/resolv.conf
    sudo chroot mnt/
    
else
    
    output_log "RED" "UNKNOWN FLAG plese type -h - options"    
fi
