#####################################################################################################################
#
#   apps_install-1.0-debian.sh
#
#   Author : Spyridakis Christos
#   Create Date : 3/05/2017
#   Email : spyridakischristos@gmail.com
#
#
#   Description : Install some of my favorites (and in my personal point of view usefull) applications in a 
#				  Debian based system (Tested on Ubuntu Unity 16.04). This script is free software ; please make
#				  sure to read the manual of each application before install or use it. I am not responsible for 
#				  any damage  
#
#
#   Additional Comments: For some Applications, their description is based on official's application description 
#
#
####################################################################################################################

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

#Update and upgrade system
upe(){
    sudo apt-get autoclean
    sudo apt-get autoremove
    sudo apt-get -y update --fix-missing
    sudo apt-get -y upgrade 
    #echo "System update and upgrade completed!\n"
}

contentCreate(){
    sudo apt-get -y install blender                                    #3D modeling tool
    #sudo apt-get -y install Kdenlive                                  #Video Editing Software
    #sudo apt-get -y install krita                                     #Photo Editing Software

    #Gimp - Photo Editing Software
    sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp
    sudo apt-get update -y
    sudo apt-get -y install gimp

    #TODO : Lightworks
}

codeDeveloping(){
    sudo apt-get -y install git                                        #Version control system
    sudo apt-get -y install vim                                        #Vim terminal text editor
    #sudo apt-get -y install emacs                                     #Emacs terminal text editor
    #sudo apt-get -y install eclipse                                   #IDE
    #sudo apt-get -y install netbeans                                  #IDE

    #Android Studio
    #sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
}

enginnering(){
    sudo apt-get -y install filezilla                                   #File transfer application
    sudo apt-get -y install arduino arduino-core                        #Arduino IDE
    sudo apt-get -y install virtualbox                                  #Virtual Machine
    sudo apt-get -y install phpmyadmin
    #sudo apt-get -y install logisim                                    #logic circuits design
    #sudo apt-get -y install eagle                                      #Schematics and pcb design tool
    #sudo apt-get -y install fritzing                                   #Schematics and pcb design tool
    #sudo apt-get -y install guake                                      #One key(drop-down) terminal
    #sudo apt-get -y install qreator                                    #Create qr codes GUI
    #sudo apt-get -y install qrencode                                   #Create qr codes Terminal
    #sudo apt-get -y install zim                                        #Notes create
    #sudo apt-get -y install kexi                                       #All in one Sql gui

    #Octave (Matlab linux alternative)
    sudo add-apt-repository -y ppa:octave/stable                           
    sudo apt-get -y update
    sudo apt-get -y install octave

    #Postgresql Server and Client
    sudo apt-get -y install pgadmin3
    sudo apt-get install -y postgresql postgresql-contrib               
    apt-cache search postgres             
    #Postgresql Server configuration steps:
        #1) sudo -u postgres psql postgres  #Connect to db postgres via psql as user postgres
        #2) \password postgres              #Change pass for postgres user
}

files(){
    sudo apt-get -y install system-config-samba                         #Share files on LAN
    sudo apt-get -y install pdfshuffler                                 #Pdf editor (Merge, remove pages, etc)
    sudo apt-get -y install meld                                        #Diff GUI programm (For both Files & Folders)
    #sudo apt-get -y install dolphin                                    #File Browser
    #sudo apt-get -y install bluefish                                   #Text editor

    #Sublime text editor
    sudo add-apt-repository -y ppa:webupd8team/sublime-text-3              
    sudo apt-get update -y
    sudo apt-get -y install sublime-text-installer
    #sudo apt-get -y install subliminal

    #Atom text editor
    sudo add-apt-repository -y ppa:webupd8team/atom                        
    sudo apt-get update -y
    sudo apt-get -y install atom
}

games(){
    sudo apt-get install -y hedgewars                                   #Worms game
}

media(){
    sudo apt-get -y install vlc browser-plugin-vlc                      #VLC player
    sudo apt-get -y install tomahawk                                    #Music player
    #sudo apt-get -y install clementine                                 #Music player

    #KODI media center
    sudo apt-get -y install software-properties-common                  
    sudo add-apt-repository -y ppa:team-xbmc/ppa
    sudo apt-get update -y
    sudo apt-get -y install kodi
}

net() {
    sudo apt-get -y install skype
    sudo apt-get -y install chromium-browser
}

pentest(){
    sudo apt-get -y install linssid                                     #Wireless access points informations
    sudo apt-get -y install etherape                                    #Network mapping tool 
    sudo apt-get -y install wireshark                                   #Network packages tool
    sudo apt-get -y install aircrack-ng                                 #Network tool
    sudo apt-get -y install nmap                                        #Network mapping tool
    sudo apt-get -y install zenmap                                      #GUI Network mapping tool
    sudo apt-get -y install john                                        #Decrypt passwords, hashes etc...  
    sudo apt-get -y install macchanger                                  #Change Mac address
    sudo apt-get -y install cmatrix                                     #Just for fun xD, matrix style on terminal
}

system(){
    sudo apt-get -y install software-properties-common                 #Extra softwate packages install
    sudo apt-get remove unity-lens-shopping                            #Unity Dash search remove
    sudo apt-get -y install network-manager                            #Network-Manager
    sudo apt-get -y install gparted                                    #Partition-editing application
    sudo apt-get -y install htop                                       #Interactive process viewer
    sudo apt-get -y install synergy                                    #Mouse and Keyboard sharing Software
    sudo apt-get -y install dconf-tools                                #Low-level configuration system for GSettings
    sudo apt-get -y install evince                                     #Pdf viewer 
    sudo apt-get -y install expect                                     #Automate events
    sudo apt-get -y install hardinfo                                   #System usefull informations
    sudo apt-get -y install openvpn                                    #VPN configuring                         
    sudo apt-get -y install caffeine                                   #Easily enable/disable screensaver applet
    sudo apt-get -y install psensor                                    #System Temps
    sudo apt-get -y install parcellite                                 #Clipboard manager Applet
    sudo apt-get -y install indicator-multiload                        #Graphical system load indicator for CPU, ram, etc
    sudo apt-get -y install alarm-clock-applet                         #Alarm clock 
    sudo apt-get -y install gnome-system-monitor                       #System Monitor
    sudo apt-get -y install unity-tweak-tool                           #GUI customization tool
    sudo apt-get -y install gnome-tweak-tool                           #GUI customization tool
    #sudo apt-get -y install xsensors lm-sensors                       #Sensors (Use $sensors-detect)
    #sudo apt-get -y install openjdk-8-jdk
    #sudo apt-get -y install wallch                                    #Wallpaper Clock
    
    #Numix theme
    sudo add-apt-repository -y ppa:numix/ppa                              
    sudo apt-get update -y
    sudo apt-get -y install numix-gtk-theme numix-icon-theme-circle numix-wallpaper-notd
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

etc(){
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


#MAIN
while :
do
    case "$1" in
        -c | --content) 	upe ; contentCreate ;   shift ;;
        -d | --develop)     upe ; codeDeveloping ;  shift ;;
        -e | --enginnering) upe ; enginnering ;     shift ;;
        -f | --files)       upe ; files ;           shift ;;
        -g | --games)       upe ; games ;           shift ;;
        -h | --help)        	  helpMenu ;        exit 0;;
        -m | --media)       upe ; media ;           shift ;;
        -n | --net)         upe ; net ;             shift ;;
        -p | --pentest)     upe ; pentest ;         shift ;;
        -s | --system)      upe ; system ;          shift ;;

        -F | --Full)        upe ; full ; break ;; 

        -L | --Light)       upe ; light ; shift ;;

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
upe
etc
