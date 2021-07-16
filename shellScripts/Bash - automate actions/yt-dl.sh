#!/bin/sh
#####################################################################################################################
#
#   Author : Spyridakis Christos
#   Created Date : 16/7/2021
#   Last Updated : 16/7/2021
#   Email : spyridakischristos@gmail.com
#
#   Description : 
#       Use youtube-dl to download video, audio or playlist
#
####################################################################################################################

video(){
    echo "Download video from URL: ${1}"
    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 --embed-thumbnail $1
}

video_list(){
    echo "Download video playlist from URL: ${1}"
    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 --embed-thumbnail -o "%(autonumber)s-%(title)s.%(ext)s" --yes-playlist $1
}

audio(){
    echo "Download audio from URL: ${1}"
    youtube-dl --extract-audio --embed-thumbnail --audio-format mp3 $1
}

audio_list(){
    echo "Download audio playlist from URL: ${1}"
    youtube-dl --extract-audio --embed-thumbnail --audio-format mp3 --yes-playlist $1
}

while :
do
    case "$1" in
        -a | --audio)       audio $2        ;   shift ; shift ;;
        -v | --video)       video $2        ;   shift ; shift ;;
        -A | --audio-list)  audio_list $2   ;   shift ; shift ;;
        -V | --video-list)  video_list $2   ;   shift ; shift ;;

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