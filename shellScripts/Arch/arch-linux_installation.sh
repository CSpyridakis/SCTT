#!/bin/bash
################################################################################################################
#
#   arch-linux_installation.sh
#
#   Author : Spyridakis Christos
#   Created Date : 14/7/2019
#   Last Updated : 2/10/2019
#   Email : spyridakischristos@gmail.com
#
#
#   Description: 
#       Both personal instructions, based on arch linux wiki and some forums, and commands needed to install 
#       arch linux on my system. This script is free and open source software ; please
#       make sure to read the documentation of each application before install or use it. I am not responsible  
#       for any damage.     
#
#   More informations:
#       This guide includes my personal notes for arch linux installation, please visit arch linux wiki
#       for a complete installation guide: https://www.archlinux.org/
#
#
################################################################################################################
#
#
# ______________________________________________________________________________________________________________
#
#           ___   _   _   ____    _____   ____    _   _    ____   _____   ___    ___    _   _   ____  
#          |_ _| | \ | | / ___|  |_   _| |  _ \  | | | |  / ___| |_   _| |_ _|  / _ \  | \ | | / ___|
#           | |  |  \| | \___ \    | |   | |_) | | | | | | |       | |    | |  | | | | |  \| | \___ \
#           | |  | |\  |  ___) |   | |   |  _ <  | |_| | | |___    | |    | |  | |_| | | |\  |  ___) |
#          |___| |_| \_| |____/    |_|   |_| \_\  \___/   \____|   |_|   |___|  \___/  |_| \_| |____/ 
#
# ______________________________________________________________________________________________________________
#
# Step -1: 
#   *If you want to use arch as dual boot with windows disable fast boot. Install windows if you have a blank
#    hard drive and log in windows.
#
#    Press "Windows key" -> Goto "Control Panel" -> Goto "Power Options" -> Goto "Choose what the power buttons  
#    do" -> Press "Change settings that are currently unavailable" -> Disable "Turn on fast startup" -> Save 
#    changes
#
#
#   *Disable also secure boot from bios/uefi.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 0: 
#   *Download iso and signature files from here: 
#       https://www.archlinux.org/download/
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 1:
#   *Verify signature: 
#       $ gpg --keyserver-options auto-key-retrieve --verify archlinux-version-x86_64.iso.sig
#          
#   *If you get this kind of error message:
#       gpg: assuming signed data in `archlinux-2019.07.01-x86_64.iso'
#       gpg: Signature made Δευ 01 Ιούλ 2019 06:07:38 μμ EEST using RSA key ID 9741E8AC
#       gpg: Can't check signature: public key not found
#
#       *Then run the commands appearing below, replacing RSA_key_ID with RSA key that you get from previous command:
#
#           $ gpg --no-default-keyring --keyring vendors.gpg --keyserver pgp.mit.edu --recv-key RSA_key_ID
#
#           $ gpg --verify --verbose --keyring vendors.gpg archlinux-version-x86_64.iso.sig
#   
#           *It may appears this kind of output:
#               gpg: assuming signed data in `./archlinux-2019.07.01-x86_64.iso'
#               gpg: Signature made Δευ 01 Ιούλ 2019 06:07:38 μμ EEST using RSA key ID 9741E8AC
#               gpg: using PGP trust model
#               gpg: Good signature from "Pierre Schmitz <pierre@archlinux.de>"
#               gpg: WARNING: This key is not certified with a trusted signature!
#               gpg:          There is no indication that the signature belongs to the owner.
#               Primary key fingerprint: 4AA4 767B BC9C 4B1D 18AE  28B7 7F2D 434B 9741 E8AC
#               gpg: binary signature, digest algorithm SHA256
#   
#           *Don't worry that it is a good but not certified signature! It's ok!
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 2:
#   *Create a live media, e.g. bootable USB using the commands of this section or find out an other way here:  
#    https://wiki.archlinux.org/index.php/USB_flash_installation_media
#   
#       *Find out USB name and umount it.
#           $ lsblk
#       
#       *Create the bootable USB, change X of sdX with the desired driver's letter:
#           $ sudo dd bs=4M if=path/to/archlinux.iso of=/dev/sdX status=progress oflag=sync
#
#       *Afterwards (when you would like to use the USB again as a media drive) run the command below and then
#        repartition and reformate the drive. Change X of sdX with driver's letter.
#           
#           $ sudo wipefs --all /dev/sdX
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 3:
#   *Check if there is an internet connection just by using your ethernet cable:
#       $ ip addr show
#
#   *Otherwise run this command to connect to one of the available access points:
#       $ wifi-menu
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Step 4: 
#       *Verify EFI support (In my case, i want to install arch in dual boot alongside windows in uefi mode).
#       In case that efi directory is not found you are in legacy mode.
#           $ ls /sys/firmware/efi/efivars
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 5:
#   *Change default root password:
#       $ sudo passwd root
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 6:
#   *Check if ssh is enabled:
#       $ systemctl status sshd
#
#   *If it is disabled enable it by running:
#       $ systemctl start sshd
#
#   Note: This step is optional, you have to do it only if you want to run the installation through ssh 
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 7:
#   *Update the system clock
#       $ timedatectl set-ntp true
# 
#   Note: Check it by executing 
#   $ timedatectl status
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 8:
#   *Two partitions are mantatory, 'swap' and 'root' partition - and EFI if UEFI is enabled - (For rendandancy, you 
#    could also have 'home', or other partitions as well). For a dual boot system (where windows are already 
#    installed), just add them alongside existing partitions. If they are not exist create them using fdisk, 
#    cfdisk or whichever tool you want, format them as needed and activate swap.
#       
#       $ fdisk -l                                      #Show devices
#       $ cfdisk                                        #Create partitions
#       $ mkfs.ext4 -L "Linux filesystem" /dev/sdXN     #Format root partionion in ext4 (replace XN with device name)               
#       
#       $ mkswap -L "Linux Swap" /dev/sdXN              #Initialize swap
#       $ swapon /dev/sdXN                              #Activate swap on XN device
#
#   Make sure that swap is activated by running "free -h" and see if total number of memory in swap is not zero.
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 9:
#   *Mount root partition to /mnt
#       
#       $ mount /dev/sdXN /mnt      #(Replace XN with device name) 
#
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 10:
#   *Install arch linux on root partition
#
#       $ pacstrap /mnt base base-devel             #base is for arch installation
#                                                   #base-devel includes tools needed for building
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 11:
#   *Generate fstab
#
#       $ genfstab -U -p /mnt >> /mnt/etc/fstab
#
#   Note: You could inspect fstab file by running
#       $ cat /mnt/etc/fstab
# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 12:
#   *Change root 
#       
#       $ arch-chroot /mnt
# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 13:
#   *Set timezone and generate /etc/adjtime
#       
#       $ ln -sf /usr/share/zoneinfo/Region/City /etc/localtime         # (Replace Region and City with your location) 
#       $ hwclock --systohc
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 14:
#   *Set up localization:
#
#       $ vi /etc/locale.gen                                # Open /etc/locale.gen and uncomment needed locales
#       $ locale-gen                                        # Generate locales
#       $ echo "LANG=en_US.UTF-8" > /etc/locale.conf        # Create the locale.conf
#       $ # TODO Create the vconsole.conf
#       
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 15:
#   *Set up hostname (execute commands of this section in your machine)
#       
#       $ TEMP_HOSTNAME="HOSTNAME"                      # Replace HOSTNAME with your hostname
#       $ echo "${TEMP_HOSTNAME}" >> /etc/hostname      # Just adds on the first line your hostname
#
#       # Adds needed content on /etc/hosts file
#       $ echo -e "\
#          \r127.0.0.1 \t localhost \n \
#          \r::1 \t\t localhost \n \
#          \r127.0.1.1 \t ${TEMP_HOSTNAME}.localdomain \t ${TEMP_HOSTNAME}" \
#          >> /etc/hosts
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 16:
#   *Just for sure generate the initial RAM disk
#
#       $ mkinitcpio -p linux
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 17:
#   *Change password
#   
#       $ passwd
# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 18:
#   *If UEFI is enabled mount EFI partition.
#       
#       $ mkdir -p /boot/efi
#       $ mount /dev/sdXN /boot/efi                  # Replace XN with device name
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 19:
#   *Install bootloader. I want to use GRUB in UEFI mode. 
#   NOTE: if you want to use legacy mode please check out arch wiki.
#
#       $ pacman -Sy grub efibootmgr dosfstools os-prober mtools
#       $ grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub --recheck #--debug
#
#       *If the following error is presented, then exit chroot execute the following command, chroot again
#       and rerun command
#
#           ERROR MESSAGE:
#           ---
#           EFI variables are not supported on this system.
#           EFI variables are not supported on this system.
#           ---
#
#           COMMANDS:
#           ---
#           $ exit
#           $ modprobe efivarfs
#           $ arch-chroot /mnt
#           ---
#
#       Then continue:
#
#       $ os-prober
#       $ grub-mkconfig -o /boot/grub/grub.cfg
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 20:
#   *Install some basic packages
#       $ pacman -S iw wpa_supplicant dialog networkmanager network-manager-applet wireless_tools net-tools
#       $ pacman -S openssh linux-lts linux-headers sudo git wget 
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 21:
#   *Exit and reboot
#
#       $ exit
#       # umount -R /mnt
#       $ reboot
# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 22:
#   *If there is not internet connection after reboot, check out if you have ip address.
#
#       $ ip addr show
#
#   Check out which one of the devices you want to use and replace DEVICE_NAME with its name.
#
#       $ systemctl enable dhcpcd@DEVICE_NAME
#       $ systemctl start dhcpcd@DEVICE_NAME
#       $ ip link set DEVICE_NAME up
#   
#   In case that there is a name resolve error add on the top of the "/etc/resolv.conf" these lines.
#
#       nameserver 8.8.8.8
#       nameserver 8.8.4.4
#       
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 23:
#   Create your daily user
#
#       $ useradd -m -g users -G wheel -s /bin/bash USERNAME    #Change USERNAME
#       $ passwd USERNAME                                       #Change user's password
#
#
#       Problem:
#       USERNAME is not in the sudoers file. 
#       
#       Solution 1 (Best):
#           $ groupadd sudo                         # Only if it does not exist
#           $ usermod -a -G sudo USERNAME
#           $ EDITOR=nano visudo                    # Uncomment %sudo  ALL=(ALL) ALL
#           $ chmod 0440 /etc/sudoers               # It may not needed
#           $ reboot
#
#       Solution 2:
#           $ EDITOR=nano visudo                    # Add this line: "USERNAME  ALL=(ALL) ALL"
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# Step 24:
#   *Install some packages that i personaly need

    #Microcode (Read arch wiki for more info)
    sudo pacman -S amd-ucode            #Microcode (about stability and security of processor) intel-ucode for intel cpus
    sudo mount /dev/sdXN /boot/efi
    sudo os-prober
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    sudo umount /boot/efi

    sudo pacman -S xorg-server xorg-apps xorg-xinit xorg-twm xterm xorg-xclock           #Xorg server (for desktop enviroment)

    #KDE Plasma desktop enviroment
    sudo pacman -S plasma plasma-wayland-session                
    #echo "exec startkde" >> ~/.xinitrc

    sudo pacman -S gdm
    sudo systemctl enable gdm 

    sudo pacman -S bash-completion

    sudo pacman -S firefox chromium

    sudo pacman -S nautilus dolphin nemo
    
    sudo pacman -S pulseaudio pulseaudio-alsa pavucontrol 
    sudo pacman -S gnome-terminal flashplugin vlc unzip unrar p7zip pidgin skype deluge smplayer audacious qmmp gimp xfburn thunderbird gedit gnome-system-monitor

    sudo pacman -S a52dec faac faad2 flac jasper lame libdca libdv libmad libmpeg2 libtheora libvorbis libxv wavpack x264 xvidcore gstreamer0.10-plugins

    sudo pacman -S libreoffice

    sudo pacman -S Faenza-icon-theme numix-themes

	#Bluetooth
    sudo pacman -S bluez bluez-utils
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service

    #Update system
    sudo pacman –Syu



