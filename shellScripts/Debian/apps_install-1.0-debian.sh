#!/bin/sh
#####################################################################################################################
#
#   apps_install-1.0-debian.sh
#
#   Author : Spyridakis Christos
#   Create Date : 3/05/2017
#   Last Update : 7/12/2018
#   Email : spyridakischristos@gmail.com
#
#
#   Description : Install some of my favorites (and in my personal point of view usefull) applications in a 
#			Debian based system (Tested on Ubuntu Unity 16.04). This script is free software ; please make
#			sure to read the manual of each application before install or use it. I am not responsible for 
#			any damage  
#
#
#   Additional Comments: 
#			1)For some Applications, their description is based on official application's description 
#			2)There are the following main "functions" :
#					a) __ADDREP - Use it in order to execute command "sudo add-apt-repository -y" and afterwards update system
#					b) __INST - Use it in order to execute command "sudo apt-get -y install"
#					c) __GET - TODO: Download applications from official site
#
####################################################################################################################

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

helpMenu(){
    echo "Usage: $0 [Option]... [Option]... "
    echo "Usage: $0 -F"
    echo "Usage: $0 -L [Option]... [Option]... "
    echo "Install some of my favorites (and in my personal point of view usefull) applications in a Debian based system"
    echo 
    echo "-c, --content 			video and photo editing programs"
	echo "-d, --develop 			code developing applications"
	echo "-e, --enginnering 		some enginnering tools"
	echo "-f, --files 			file managers etc..."
	echo "-g, --games 			some linux games"
	echo "-h, --help 			show this help page"
	echo "-m, --media 			media players (music, video, etc...)"
	echo "-n, --net 			browsers and social apps"
	echo "-p, --pentest 			some penetration testing tools"
	echo "-s, --system 			system tools"
	echo "-F, --Full 			install all applications"
	echo "-L, --Light 			install only basic tools"
}

#Install app 
__INST(){
	for app in "$@" 
	do
		sudo apt-get -y install ${app} || echo && echo "${app} : ${red}Installation FAILED${reset}"
	done
}

#Add repository
__ADDREP(){
	sudo add-apt-repository -y ${1}
	sudo apt-get -y update --fix-missing
	#echo "Repo added"
}

#Update and upgrade system
__UPDG(){
    sudo apt-get -y update --fix-missing
    sudo apt-get -y upgrade 
    sudo apt-get -y autoclean
    sudo apt-get -y autoremove
    #echo "System update and upgrade completed!"
}

#Update system
__UPD(){  
    sudo apt-get -y update --fix-missing
    #echo "Update"
}

__GET(){
	echo TODO
}

#Print some interesting informations at the end
__INFO(){
	echo "${yellow}SCRIPT RESULTS:${reset}"

	#TODO: print applications with 
	#Installation Error 
	#if [[ ${#array[@]} > 0 ]]
	#then 
	#	echo "There is a problem with the installation of the following tools"
	#	for app in "${array[@]}"
	#	do
    #		echo "$app"
	#	done
	#fi

	echo "Installation Completed! You may want to install also:"
	echo "1) Teamviewer"
	echo "2) Xampp or/and Tomcat"
	echo "3) Vmware"
	echo "4) Android Studio"
	echo "5) IDEs of Jetbrains"
	echo "6) Slack"
	echo "7) VNC"
	echo "8) Viber"
}

contentCreate(){
    __INST blender                                    #3D modeling tool
    #__INST kdenlive                                  #Video Editing Software
    #__INST krita                                     #Photo Editing Software

    #Gimp - Photo Editing Software
    __ADDREP ppa:otto-kesselgulasch/gimp
    __INST gimp

    #TODO : Lightworks
}

codeDeveloping(){
    __INST git                                        #Version control system
    __INST vim                                        #Vim terminal text editor
    #__INST emacs                                     #Emacs terminal text editor
    #__INST eclipse                                   #IDE
    #__INST netbeans                                  #IDE

    #Android Studio ?extra?
    #__INST libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
}

enginnering(){
    __INST filezilla                                   #File transfer application
    __INST arduino arduino-core                        #Arduino IDE
    __INST virtualbox                                  #Virtual Machine
    __INST phpmyadmin                                  #Administration tool for MySQL and MariaDB
    #__INST logisim                                    #logic circuits design
    #__INST eagle                                      #Schematics and pcb design tool
    #__INST fritzing                                   #Schematics and pcb design tool
    #__INST guake                                      #One key(drop-down) terminal
    #__INST qreator                                    #Create qr codes GUI
    #__INST qrencode                                   #Create qr codes Terminal
    #__INST zim                                        #Notes create
    #__INST kexi                                       #All in one Sql gui

    #Octave (Matlab linux alternative)
    __ADDREP ppa:octave/stable
    __INST octave

    #Postgresql Server and Client
    __INST pgadmin3 postgresql postgresql-contrib           
    apt-cache search postgres             
    #Postgresql Server configuration steps:
        #1) sudo -u postgres psql postgres  #Connect to db postgres via psql as user postgres
        #2) \password postgres              #Change pass for postgres user
}

files(){
    __INST system-config-samba samba                   #Share files on LAN (In order to setup user use: sudo smbpasswd -a username)
    __INST pdfshuffler                                 #Pdf editor (Merge, remove pages, etc)
    __INST meld                                        #Diff GUI programm (For both Files & Folders)
    __INST qbittorrent								   #Torrent client
    #__INST dolphin                                    #File Browser
    #__INST bluefish                                   #Text editor

    #Sublime text editor
    __ADDREP ppa:webupd8team/sublime-text-3              
    __INST sublime-text-installer
    #__INST subliminal

    #Atom text editor
    __ADDREP ppa:webupd8team/atom                        
    __INST atom
}

games(){
    __INST hedgewars                                   #Worms game
}

media(){
    __INST vlc browser-plugin-vlc                      #VLC player
    __INST tomahawk                                    #Music player
    #__INST clementine                                 #Music player

    #KODI media center
    __INST software-properties-common                  
    __ADDREP ppa:team-xbmc/ppa
    __INST kodi
}

net() {
    __INST chromium-browser
}

pentest(){
    __INST linssid                                     #Wireless access points informations
    __INST etherape                                    #Network mapping tool 
    __INST wireshark                                   #Network packages tool
    __INST aircrack-ng                                 #Network tool
    __INST nmap                                        #Network mapping tool
    __INST zenmap                                      #GUI Network mapping tool
    __INST john                                        #Decrypt passwords, hashes etc...  
    __INST macchanger                                  #Change Mac address
    __INST cmatrix                                     #Just for fun xD, matrix style on terminal
}

system(){
    #sudo apt-get remove unity-lens-shopping          #Unity Dash search remove
    __INST software-properties-common                 #Extra softwate packages install
    __INST network-manager                            #Network-Manager
    __INST gparted                                    #Partition-editing application
    __INST htop                                       #Interactive process viewer
    __INST synergy                                    #Mouse and Keyboard sharing Software
    __INST dconf-tools                                #Low-level configuration system for GSettings
    __INST evince                                     #Pdf viewer 
    __INST expect                                     #Automate events using expected words tool
    __INST hardinfo                                   #System usefull informations
    __INST openvpn                                    #VPN configuring                         
    __INST caffeine                                   #Easily enable/disable screensaver applet
    __INST psensor                                    #System Temps
    __INST parcellite                                 #Clipboard manager Applet
    __INST indicator-multiload                        #Graphical system load indicator for CPU, ram, etc
    __INST alarm-clock-applet                         #Alarm clock 
    __INST gnome-system-monitor                       #System Monitor
    __INST unity-tweak-tool                           #GUI customization tool
    __INST gnome-tweak-tool                           #GUI customization tool
    __INST clamav clamtk                              #Open source antivirus engine with GUI
    __INST indicator-keylock                          #Num/Caps lock indicator
    __INST tmux                                       #Terminal multiplexer

    #__INST xsensors lm-sensors                       #Sensors (Use $sensors-detect)
    #__INST openjdk-8-jdk
    #__INST wallch                                    #Wallpaper Clock
    #__INST kazam									  #Screen recording
    #__INST bacula									  #Backup System

    #Download manager
    #__ADDREP ppa:plushuang-tw/uget-stable
    #__INST uget
    
	#Python 3.6
    __ADDREP ppa:jonathonf/python-3.6				  
    __INST python3.6

    #Numix theme
    __ADDREP ppa:numix/ppa                              
    __INST numix-gtk-theme numix-icon-theme-circle numix-wallpaper-notd
}

full(){
	contentCreate 
	codeDeveloping 
	enginnering 
	files 
	games
	helpMenu 
	media 
	net 
	pentest
	system 
}

light(){
	files
	media
	net
	system
}


#MAIN
while :
do
    case "$1" in
        -c | --content) 	__UPDG ; contentCreate ;   shift ;;
        -d | --develop)     __UPDG ; codeDeveloping ;  shift ;;
        -e | --enginnering) __UPDG ; enginnering ;     shift ;;
        -f | --files)       __UPDG ; files ;           shift ;;
        -g | --games)       __UPDG ; games ;           shift ;;
        -h | --help)        	     helpMenu ;        exit 0;;
        -m | --media)       __UPDG ; media ;           shift ;;
        -n | --net)         __UPDG ; net ;             shift ;;
        -p | --pentest)     __UPDG ; pentest ;         shift ;;
        -s | --system)      __UPDG ; system ;          shift ;;

        -F | --Full)        __UPDG ; full ; break ;; 

        -L | --Light)       __UPDG ; light ; shift ;;

        --*)
            echo "Unknown option: $1" >&2
            helpMenu
            exit 1
            ;;
        -*)
            echo "Unknown option: $1" >&2
            helpMenu
            exit 1 
            ;;
        *) 
            break
    esac
done
__UPDG
__INFO