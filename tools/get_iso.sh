#!/bin/bash

source tools/color.sh

iso=$(ls iso/download/ | grep 2021-05-07-raspios-buster-armhf-lite.zip)

echo $iso

if [[ "$iso" == "2021-05-07-raspios-buster-armhf-lite.zip" ]]; then
  MESSAGE="ISO DOWNLOADED" ; green_echo 
  MESSAGE="UNZIPING" ; blue_echo
  unzip iso/download/2021-05-07-raspios-buster-armhf-lite.zip -d iso/
  MESSAGE="UNZIPING COMPLETE" ; green_echo
else
  MESSAGE="DOWLOAD ISO, PLEASE WAIT" ; blue_echo
  wget -P iso/download/ https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-05-28/2021-05-07-raspios-buster-armhf-lite.zip
  MESSAGE="UNZIPING" ; blue_echo
  unzip iso/download/2021-05-07-raspios-buster-armhf-lite.zip -d iso/
  MESSAGE="UNZIPING COMPLETE" ; green_echo
fi



