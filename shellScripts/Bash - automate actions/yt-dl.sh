#!/bin/sh
#####################################################################################################################
#
#   Author : Spyridakis Christos
#   Created Date : 16/7/2021
#   Last Updated : 8/8/2021
#   Email : spyridakischristos@gmail.com
#
#   Description : 
#       Use youtube-dl to download video, audio or playlist
#
####################################################################################################################
helpMenu() {
    echo "Usage: $0 [Option]... [Option]... "
    echo "Use youtube-dl to download video, audio or playlist"
    echo 
    echo "[Options] :"
    echo "  -h, --help              This help menu"
    echo "  -a, --audio             Download only audio to mp3"
    echo "  -v, --video             Download video to mp4"
    echo "  -A, --audio-list        Download only audio list to mp3"
    echo "  -V, --video-list        Download video list to mp4"
}

video() {
    echo "Download video from URL: ${1}"
    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 --embed-thumbnail $1
}

video_list() {
    echo "Download video playlist from URL: ${1}"
    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 --embed-thumbnail -o "%(autonumber)s-%(title)s.%(ext)s" --yes-playlist $1
}

audio() {
    echo "Download audio from URL: ${1}"
    youtube-dl --extract-audio --embed-thumbnail --audio-format mp3 $1
}

audio_list() {
    echo "Download audio playlist from URL: ${1}"
    youtube-dl --extract-audio --embed-thumbnail --audio-format mp3 --yes-playlist $1
}

while :
do
    case "$1" in
        -h | --help)        helpMenu        ;   exit 0 ;;
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