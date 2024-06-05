#!/bin/bash

# Input arguments will be stored here
VM_NAME="Linux"
VM_TYPE="Linux_64" # To find available run: VBoxManage list ostypes

declare VM_CPUs=5
declare VM_MEM=8192
declare VM_VRAM=12
declare VM_DISK=20480

VM_ETH_AD=`ip link show | grep "state UP" | head -n 1 | tr -d ' ' | cut -d ':' -f 2`
declare VM_BASE_DIR="${HOME}/vboxmanage_dir"
declare ISO_FILE=""

function VM_BASE_FOLDER(){ echo "${VM_BASE_DIR}/VirtualBox_VMs" ; }
function VM_Virtual_Media_path(){ echo "${VM_BASE_DIR}/VirtualBox" ;}
function VM_MEDIA_FILE(){ echo "$(VM_Virtual_Media_path)/${VM_NAME}.vdi" ; }

NEW_VM=false
LIST_VM=false
START_VM=false
STOP_VM=false
REMOVE_VM=false
GET_VM_IP=false

# ===============================================================================================

CLR_RED='\033[0;31m'
CLR_GREEN='\033[0;32m'
CLR_YELLOW='\033[0;33m'
CLR_BOLD_WHITE='\033[1;37m'
CLR_RST='\033[0m'

# DEBUG prints
function echo_r(){ echo -e "${CLR_RED}$@${CLR_RST}"; }
function echo_g(){ echo -e "${CLR_GREEN}$@${CLR_RST}"; }
function echo_y(){ echo -e "${CLR_YELLOW}$@${CLR_RST}"; }
function exec(){
    export PS4='> '
    set -x
    "$@"
    { set +x; } 2>/dev/null  
    echo
}

function confirm() {
    read -r -p "${1:-Is this correct? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

# ---------------------------------------------------------------------------------

# Create VM
function create_vm(){
    # Arguments
    vm_name=$1
    vm_type=$2
    vm_base_dir=$3

    exec VBoxManage createvm --name ${vm_name}          \
                    --ostype ${vm_type}                 \
                    --register                          \
                    --basefolder ${vm_base_dir}   
}

# ---------------------------------------------------------------------------------

# Setup VM Properties (to see mods, run: VBoxManage showvminfo ${VM_NAME} )
function setup_vm(){
    # Arguments
    vm_name=$1
    cpu_num=$2
    ram_size=$3
    vram_size=$4
    eth_bridged=$5

    # Command
    exec VBoxManage modifyvm ${vm_name}                 \
                    --cpus ${cpu_num}                   \
                    --memory ${ram_size}                \
                    --vram ${vram_size}                 \
                    --nic1 bridged                      \
                    --bridgeadapter1 ${eth_bridged}
}

# ---------------------------------------------------------------------------------
# Attaching Virtual Media to a VM
# ---------------------------------------------------------------------------------
# 1. Create media
function create_media(){
    # Arguments
    media_file=$1
    disk_size=$2

    # Command
    exec VBoxManage createhd --filename ${media_file}   \
                    --size ${disk_size}                 \
                    --format VDI                        \
                    --variant Standard 
}



# 2. Add a storage controller to be used with that hard disk
function add_storage_cnt(){
    # Arguments
    vm_name=$1

    # Command
    exec VBoxManage storagectl ${vm_name}               \
                        --name 'SATA Controller'        \
                        --add sata                      \
                        --bootable on         
}

# 3. Attach the hard disk to the controller
function attach_hd_to_cnt(){
    # Arguments
    vm_name=$1
    media_file=$2

    # Command
    exec VBoxManage storageattach ${vm_name}            \
                --storagectl 'SATA Controller'          \
                --port 0                                \
                --device 0                              \
                --type hdd                              \
                --medium ${media_file}
}

# ------------------------------------------------------------------
# Install Guest OS
# ------------------------------------------------------------------

# 1. Add an IDE controller for the CD/DVD drive
function add_ide_cnt_for_iso(){
    # Arguments
    vm_name=$1

    # Command
    exec VBoxManage storagectl   ${vm_name}             \
                        --name 'IDE Controller'         \
                        --add ide                       \
                        --controller PIIX4
}

function attach_iso_to_ide_cnt(){
    # Arguments
    vm_name=$1
    iso_file=$2

    # Command
    exec VBoxManage storageattach ${vm_name}            \
            --storagectl 'IDE Controller'               \
            --port 1                                    \
            --device 0                                  \
            --type dvddrive                             \
            --medium ${iso_file}
}

# ------------------------------------------------------------------
function modifyvm(){
    # Arguments
    vm_name=$1

    # Command
    exec VBoxManage modifyvm ${vm_name}                 \
                    --boot1 dvd                         \
                    --boot2 disk                        \
                    --boot3 none                        \
                    --boot4 none
}

# Set RDP access
function setup_rdp(){
    # Arguments
    vm_name=$1

    # Command
    exec VBoxManage modifyvm ${vm_name}                 \
                    --vrde on                           \
                    --vrdemulticon on                   \
                    --vrdeport 10001
}

function os_types(){
    echo_y "[OS types]"
    VBoxManage list ostypes | grep -w "^ID" | tr -s ' ' | cut -d':' -f2
}

function new_vm(){
    # Check that there is not a VM with the same name
    if [ `VBoxManage list vms | grep -w ${VM_NAME} | wc -l` -gt 0 ] ; then 
        echo_r "A VM with the same name already exists..."
        exit 0
    fi
    
    # Create dir if not exists
    if [ ! -d '$(VM_Virtual_Media_path)' ] ; then 
        echo_g "VM Base folder and Media directory do not exist, create them"
        mkdir -p $(VM_BASE_FOLDER)
        mkdir -p $(VM_Virtual_Media_path)
    fi

    # Check that there is not a Media file with the same name
    if [ `ls $(VM_Virtual_Media_path) | grep -w ${VM_NAME} | wc -l` -gt 0 ] ; then
        echo_r "Media image already exists"
        exit 0
    fi

    # TODO: Continue checks like the iso exists, etc...

    # Initialization
    create_vm ${VM_NAME} ${VM_TYPE} $(VM_BASE_FOLDER)       
    setup_vm ${VM_NAME} ${VM_CPUs} ${VM_MEM} ${VM_VRAM} ${VM_ETH_AD}

    # Attaching Virtual Media to a VM
    create_media $(VM_MEDIA_FILE) ${VM_DISK}        # Create media
    add_storage_cnt ${VM_NAME}                      # Add a storage controller to be used with that hard disk
    attach_hd_to_cnt ${VM_NAME} $(VM_MEDIA_FILE)    # Attach the hard disk to the controller

    # Install Guest OS
    add_ide_cnt_for_iso ${VM_NAME}                  # Add an IDE controller for the CD/DVD drive
    attach_iso_to_ide_cnt ${VM_NAME} ${ISO_FILE}
    modifyvm ${VM_NAME}

    # Set RDP access
    setup_rdp ${VM_NAME}

    # Start the headless VM
    # start_vm ${VM_NAME}
}

function get_vm_ip(){
    # Arguments
    vm_name=$1

    # Command
    VBoxManage guestproperty get ${vm_name} "/VirtualBox/GuestInfo/Net/0/V4/IP"
}


function list_vm(){
    # echo_y "[List HDDs]"
    # VBoxManage list hdds

    echo_y "[List VMs]"
    VBoxManage list vms

    echo_y "[List Running VMs]"
    VBoxManage list runningvms
}

function start_vm(){
    # Arguments
    vm_name=$1

    # Command
    VBoxHeadless --startvm ${vm_name} 
}

function stop_vm(){
    # Arguments
    vm_name=$1

    # Command
    VBoxManage controlvm ${vm_name} poweroff
}

# To delete a Media
# vboxmanage list hdds
# Then
# vboxmanage closemedium disk <uuid> --delete
function rm_vm(){
    # Arguments
    vm_name=$1
    media_uuid=$2

    echo " -----------  ${media_uuid} ----------- "
    # Commands
    exec VBoxManage controlvm ${vm_name} poweroff
    exec VBoxManage storageattach ${vm_name} --storagectl 'SATA Controller' --port 0 --device 0 --type hdd --medium none
    exec VBoxManage storageattach ${vm_name} --storagectl 'IDE Controller' --port 1 --device 0 --type hdd --medium none
    exec VBoxManage closemedium disk ${media_uuid} --delete
    exec VBoxManage unregistervm ${vm_name} --delete
    # exec rm -rf $(VM_MEDIA_FILE)
}

# -------------------------------------------------
# PARSE INPUT PARAMETERS
# -------------------------------------------------

while :
do
    case "$1" in
        -b | --base)            VM_BASE_DIR=$2          shift   ;; # FIXME: this is not updated
        -c | --cpus)            VM_CPUs=$2;             shift   ;;
        -d | --disk)            VM_DISK=$2;             shift   ;;
        -e | --eth)             VM_ETH_AD=$2;           shift   ;;
        -i | --iso)             ISO_FILE=$2;            shift   ;;
        -r | --ram)             VM_MEM=$2;              shift   ;;
        -n | --name)            VM_NAME=$2;             shift   ;;
        -t | --type)            VM_TYPE=$2;             shift   ;;
        -v | --vram)            VM_VRAM=$2              shift   ;; # FIXME: this is not updated
        -o | --ostypes)         os_types;               exit 0  ;;
             
             --create)          NEW_VM=true;                    ;;
             --start-vm)        START_VM=true;                  ;;
             --stop-vm)         STOP_VM=true;                   ;;
             --list)            list_vm;                exit 0  ;;
             --get-ip)          GET_VM_IP=true;                 ;;
             --remove)          REMOVE_VM=true;                 ;;

        --*)
            echo "Unknown option: $1" >&2
            help_menu
            exit 1
            ;;
        -*)
            echo "Unknown option: $1" >&2
            help_menu
            exit 1 
            ;;
        *) 
            break
    esac
    shift
done

# -------------------------------------------------------------
# NEW VM
# -------------------------------------------------------------
if $NEW_VM; then
    echo_g "[NEW VM]: Create new VM with the following specs:"
    echo_y "  * [-n] VM_NAME: ${VM_NAME}"
    echo_y "  * [-t] VM_TYPE: ${VM_TYPE}"
    echo_y "  * [-c] VM_CPUs: ${VM_CPUs}"
    echo_y "  * [-r] VM_MEM: ${VM_MEM}"
    echo_y "  * [-v] VM_VRAM: ${VM_VRAM}"
    echo_y "  * [-d] VM_DISK: ${VM_DISK}"
    echo_y "  * [-i] ISO_FILE: ${ISO_FILE}"
    echo_y "  * [-e] VM_ETH_AD: ${VM_ETH_AD}"
    echo_y "  * [-b] VM_BASE_DIR: ${VM_BASE_DIR}"
    echo_y "  * [  ] VM_BASE_FOLDER: $(VM_BASE_FOLDER)"
    echo_y "  * [  ] VM_MEDIA_FILE: $(VM_MEDIA_FILE)"
    echo 

    confirm || exit 0

    new_vm
fi

# -------------------------------------------------------------
# LIST VMS
# -------------------------------------------------------------
if $LIST_VM; then
    list_vm
fi

# -------------------------------------------------------------
# START VM
# -------------------------------------------------------------
if $START_VM; then
    start_vm ${VM_NAME}
fi

# -------------------------------------------------------------
# STOP VM
# -------------------------------------------------------------
if $STOP_VM; then
    stop_vm ${VM_NAME}
fi

# -------------------------------------------------------------
# GET VM IP
# -------------------------------------------------------------
if $GET_VM_IP; then
    get_vm_ip ${VM_NAME}
fi

# -------------------------------------------------------------
# REMOVE VM
# -------------------------------------------------------------
if $REMOVE_VM; then
    # Find media UUID
    media_info=`vboxmanage list hdds | grep -w ${VM_NAME} -B4 -A 3`
    media_uuid="`echo ${media_info} | grep -E '^UUID' | cut -d' ' -f2`"

    echo_g "[MEDIA to remove: UUID=${media_uuid}]"
    echo_y "${media_info}"
    echo 
    confirm || exit 0

    rm_vm ${VM_NAME} ${media_uuid}
fi
