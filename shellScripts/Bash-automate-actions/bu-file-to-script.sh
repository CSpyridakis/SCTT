#!/bin/bash

OUT_FILE="script-to-files.sh"

function create_file_reproduction(){
    if [[ ! -z ${OUT_FILE} ]] ; then
        for f in $@
        do
            echo "Processing $f file..."
            file_cont=`cat $f | tr "\'" '\`'`
            echo "# __________________________________" >> ${OUT_FILE}
            echo "# ${f}" >> ${OUT_FILE}
            echo "echo '${file_cont}' > ${f} && sed -e \"s/\\\`/'/g\" -i ${f}" >> ${OUT_FILE}
            echo "# ----------------------------------" >> ${OUT_FILE}
        done
    fi;
}

function main(){
    if [ ! -e ${OUT_FILE} ]; then
        echo -e "#!/bin/bash\n" > ${OUT_FILE}
        chmod +x ${OUT_FILE}
    fi

    create_file_reproduction $@
}

# -------------------------------------------------

main $@