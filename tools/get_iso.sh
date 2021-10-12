#!/bin/bash

source tools/color.sh

iso=$(ls iso/download/ | grep 2021-05-07-raspios-buster-armhf-lite.zip)

echo $iso

if [[ "$iso" == "ubuntu-20.04.3-preinstalled-server-arm64+raspi.img.xz" ]]; then
  MESSAGE="ISO DOWNLOADED" ; green_echo 
  MESSAGE="UNZIPING" ; blue_echo
  unzip iso/download/ubuntu-20.04.3-preinstalled-server-arm64+raspi.img.xz -d iso/
  MESSAGE="UNZIPING COMPLETE" ; green_echo
else
  MESSAGE="DOWLOAD ISO, PLEASE WAIT" ; blue_echo
  wget -P iso/download/ https://cdimage.ubuntu.com/releases/20.04.3/release/ubuntu-20.04.3-preinstalled-server-arm64+raspi.img.xz
  MESSAGE="UNZIPING" ; blue_echo
  unzip iso/download/2021-05-07-raspios-buster-armhf-lite.zip -d iso/
  MESSAGE="UNZIPING COMPLETE" ; green_echo
fi



