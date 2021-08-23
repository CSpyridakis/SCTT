#!/bin/sh
#####################################################################################################################
#
#   Author : Spyridakis Christos
#   Created Date : 8/8/2021
#   Last Updated : 8/8/2021
#   Email : spyridakischristos@gmail.com
#
#   Description : 
#       Export or restore zsh gnome-terminal color profile to file
#
####################################################################################################################

exportF=0
restoreF=0
fileName=
profileName=

dumpProfiles() {
    dconf dump /org/gnome/terminal/legacy/profiles:/
}

helpMenu() {
    echo "Usage: $0 [Option]... [Option]... "
    echo "Export or restore zsh gnome-terminal color profile to file"
    echo 
    echo "[Options] :"
    echo "  -d, --dump-profiles         Dump all profiles' info"
    echo "  -e, --export                Export profile to file"
    echo "  -f, --file-name             Select filename for export/restore"
    echo "  -h, --help                  Print this help menu and exit"
    echo "  -p, --profile-name          Select profile name for export/restore"
    echo "  -r, --restore               Restore profile from file"
}

exportTheme() {
    profileName=$1
    BUFileName=$2
    dconf dump /org/gnome/terminal/legacy/profiles:/:${profileName}/ > ${BUFileName}.dconf
}

restoreTheme() {
    profileName=$1
    BUFileName=$2
    dconf load /org/gnome/terminal/legacy/profiles:/:${profileName}/ < ${BUFileName}.dconf
}

while :
do
    case "$1" in
        -d | --dump-profiles)  dumpProfiles    ;   exit 1 ;;
        -e | --export)         exportF=1       ;   shift ;;
        -f | --file-name)      fileName=$2     ;   shift  ; shift;;
        -h | --help)           helpMenu        ;   exit 1 ;;
        -p | --profile-name)   profileName=$2  ;   shift  ; shift ;;
        -r | --restore)        restoreF=1      ;   shift ;;

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

if [ ${exportF} -eq 1 ] ; then 
    echo "Export profile [${profileName}] to file {${fileName}.conf}"
    exportTheme ${profileName} ${fileName}
    exit 0
fi

if [ ${restoreF} -eq 1 ] ; then 
    echo "Restore profile [${profileName}] from file {${fileName}.conf}"
    restoreTheme ${profileName} ${fileName}
    exit 0
fi

