#!/bin/bash

# Download and install a debian based OS for example you can download and install raspios
# !!! IMPORTANT YOU HAVE TO REPLACE YOUR DEVICE FILE !!!
# wget https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-04-07/2022-04-04-raspios-bullseye-armhf-lite.img.xz
# unxz 2022-04-04-raspios-bullseye-armhf-lite.img.xz
# sudo dd if=2022-04-04-raspios-bullseye-armhf-lite.img of=[PUT HERE YOUR DEVICE FILE!] status=progress bs=1M
 
# See https://www.home-assistant.io/installation/raspberrypi for complete instructions

# Install dependencies
sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt-get install -y python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev libjpeg-dev zlib1g-dev autoconf build-essential libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata

# Create an account
sudo useradd -rm homeassistant -G dialout,gpio,i2c

# Create the virtual environment
sudo mkdir /srv/homeassistant
sudo chown homeassistant:homeassistant /srv/homeassistant

sudo -u homeassistant -H -s
cd /srv/homeassistant
python3 -m venv .
source bin/activate

python3 -m pip install wheel

pip3 install homeassistant

hass

# Now you can visit http://homeassistant.local:8123

