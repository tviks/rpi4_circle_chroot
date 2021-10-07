#!/bin/bash

sudo apt-get update

sudo apt-get install network-manager -y

sudo rm -rf /etc/netplan/50-cloud-init.yaml

sudo echo "# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    eth0:
      dhcp4: true
      optional: true
  wifis:
    wlan0:
      dhcp4: true
      optional: true
      access-points:
        "Circle":
          password: "circlewifi"
          mode: ap" >> /etc/netplan/50-cloud-init.yaml

sudo netplan generate