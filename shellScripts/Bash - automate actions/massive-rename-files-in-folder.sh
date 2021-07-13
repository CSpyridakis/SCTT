#!/bin/bash

PRE="img"
EXT="png"

i=0 ; 
for file in `find . -name \*.${EXT} | sort -V` ; do  
    ((i=i+1))
    echo "${file} ${PRE}-$i.${EXT}"
    mv -f ${file} ${PRE}-$i.${EXT}
done