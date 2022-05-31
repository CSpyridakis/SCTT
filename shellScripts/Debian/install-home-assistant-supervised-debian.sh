#!/bin/bash

# Raspberry Pi 2B
# See https://peyanski.com/how-to-install-home-assistant-supervised-official-way/#SMART_HOME_Getting_Started_Actionable_Guide

# Download and install a debian based OS for example you can download and install raspios
# !!! IMPORTANT YOU HAVE TO REPLACE YOUR DEVICE FILE !!!
# wget https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-04-07/2022-04-04-raspios-bullseye-armhf-lite.img.xz
# unxz 2022-04-04-raspios-bullseye-armhf-lite.img.xz
# sudo dd if=2022-04-04-raspios-bullseye-armhf-lite.img of=[PUT HERE YOUR DEVICE FILE!] status=progress bs=1M

# ============================================================================================================
# Use LAN Cable or Disable Wi-Fi randomization during the Home Assistant Supervised installation
echo -e "[connection] \nwifi.mac-address-randomization=1\n[device]\nwifi.scan-rand-mac-address=no" | sudo tee -a /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf

# ============================================================================================================
# Install Home Assistant Supervised dependencies
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install jq wget curl avahi-daemon udisks2 libglib2.0-bin network-manager dbus apparmor -y
sudo apt --fix-broken install
sudo reboot

# ============================================================================================================
# Install Docker 
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# check if docker is installed
# docker --version

# ============================================================================================================
# Install Agent for Home Assistant OS
RELEASE_VER="1.2.2"
wget https://github.com/home-assistant/os-agent/releases/download/${RELEASE_VER}/os-agent_${RELEASE_VER}_linux_armv7.deb
sudo dpkg -i os-agent_${RELEASE_VER}_linux_armv7.deb

# if get response from this command everything works
# gdbus introspect --system --dest io.hass.os --object-path /io/hass/os

# ============================================================================================================
# Official Home Assistant Supervised installer
wget https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
sudo dpkg -i homeassistant-supervised.deb


# ============================================================================================================
# Extra

# If you have a problem with apparmor then run this
# mv /boot/cmdline.txt /boot/cmdline.txt.bu && echo "`cat /boot/cmdline.txt` apparmor=1 security=apparmor" | sudo tee -o /boot/cmdline.txt 



