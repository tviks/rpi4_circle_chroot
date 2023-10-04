#!/bin/bash


sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install hostapd dnsmasq net-tools -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent

sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl unmask dnsmasq
sudo systemctl enable dnsmasq


#sudo rm -rf /etc/dhcpcd.conf
sudo echo "interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant" >> /etc/dhcpcd.conf  

sudo echo "# Enable IPv4 routing
net.ipv4.ip_forward=1" >> /etc/sysctl.d/routed-ap.conf



sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

sudo echo "interface=wlan0 # Listening interface
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
domain=wlan
address=/gw.wlan/192.168.4.1" >> /etc/dnsmasq.conf

sudo echo "country_code=GB
interface=wlan0
ssid=Circle
hw_mode=g
channel=7
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=circlewifi
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP" >> /etc/hostapd/hostapd.conf

sudo sed -i 's/#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd


sudo echo "sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo netfilter-persistent save
sudo rfkill unblock wlan" >> before.sh

sudo chmod +x before.sh

sudo systemctl reboot