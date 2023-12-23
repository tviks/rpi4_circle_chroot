#!/bin/bash

sudo adduser ubuntu --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "ubuntu:qweqwe2" | sudo chpasswd

sudo usermod -aG sudo ubuntu 

check_string=$(cat /etc/sudoers | tail -n 1)

if [[ $check_string != "ubuntu ALL=(ALL:ALL) ALL" ]]; then
    echo "Add ubuntu to sudoers"
    echo 'ubuntu ALL=(ALL:ALL) ALL' >> /etc/sudoers
    sudo echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    echo "Done"
else
    echo "Skip add ubuntu to sudoers"
fi