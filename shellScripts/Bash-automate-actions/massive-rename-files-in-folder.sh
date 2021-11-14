#!/bin/bash

DIR=""
PRE="image"
EXT="png"

rename_files(){
    i=0 ; 
    for file in `find ./${DIR} -maxdepth 1 -name \*.${EXT} | sort -V` ; do  
        ((i=i+1))
        echo "mv -f ${file} ./${DIR}${PRE}-$i.${EXT}"
        # mv -f ${file} ./${DIR}/${PRE}-$i.${EXT}
    done
}

while :
do
    case "$1" in
        -d | --dir)         DIR="$2/"  ;   shift ; shift ;;
        -f | --file-name)   PRE="$2"  ;   shift ; shift ;;

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

rename_files