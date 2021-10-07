#!/bin/bash

sudo sed -i 's/APT::Periodic::Update-Package-Lists "1";/APT::Periodic::Update-Package-Lists "0";/g' /etc/apt/apt.conf.d/20auto-upgrades

sudo rfkill unblock wifi

sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install hostapd dnsmasq net-tools -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent

sudo systemctl unmask hostapd
sudo systemctl enable hostapd

#sudo rm -rf /etc/dhcpcd.conf
sudo echo "interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant" >> /etc/dhcpcd.conf  

sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig

sudo echo "interface=wlan0 # Listening interface
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
                # Pool of IP addresses served via DHCP
domain=wlan     # Local wireless DNS domain
address=/gw.wlan/192.168.4.1
                # Alias for this router" >> /etc/dnsmasq.conf

sudo echo "interface=wlan0
bridge=br0
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
ssid=Circle
wpa_passphrase=circlewifi" >> /etc/hostapd/hostapd.conf

sudo sed -i 's/#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd

sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g'  /etc/sysctl.d/routed-ap.conf

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

iptables-restore < /etc/iptables.ipv4.nat

sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd