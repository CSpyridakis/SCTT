#!/bin/bash

# Raspberry Pi 2B
# See https://peyanski.com/how-to-install-home-assistant-supervised-official-way/#SMART_HOME_Getting_Started_Actionable_Guide

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






