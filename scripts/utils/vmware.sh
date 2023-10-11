#!/bin/bash

set -e

# This is a Bash script header
# Author: chuan
# Version: 1.0
# Date: October 10, 2023
# Description: Config arch linx.

##############################################################################################################################

path="$(realpath "$0")"
name="$(basename "$path")"
dir="$(dirname "$path")"
parent="$(dirname "$dir")"

source $parent/common.sh

##############################################################################################################################

# virtual box using to set proxy
task_virtual_proxy(){
    host_ip=$(awk '/nameserver/ {split($2, a, "."); print a[1]"."a[2]"."a[3]".1"}' /etc/resolv.conf)
    port=10809
    # note 这里是不起作用的，原因还不知道
    export ALL_PROXY="http://$host_ip:$port"
    export http_proxy="http://$host_ip:$port"
    export https_proxy="http://$host_ip:$port"
    git config --global https.proxy "http://$host_ip:$port"
    git config --global http.proxy "http://$host_ip:$port"
}

# vmware
task_virtual_driver(){
    sudo pacman -S --noconfirm open-vm-tools xf86-video-vmware
    sudo systemctl enable --now  vmtoolsd.service
    sudo vmware-toolbox-cmd timesync enable
    sudo hwclock --hctosys --localtime

    sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak
    sudo sed -i "s/^MODULES=().*$/MODULES=(vsock vmw_vsock_vmci_transport vmw_balloon vmw_vmci vmwgfx)/g" /etc/mkinitcpio.conf

    # note 这里要根据安装的内核设置
    sudo mkinitcpio -p linux
}

task_host(){
    # https://gitlab.com/ineo6/hosts/-/raw/master/next-hosts
    echo "must use"
}

##############################################################################################################################
# ███╗   ███╗ █████╗ ██╗███╗   ██╗
# ████╗ ████║██╔══██╗██║████╗  ██║
# ██╔████╔██║███████║██║██╔██╗ ██║
# ██║╚██╔╝██║██╔══██║██║██║╚██╗██║
# ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║
# ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝

case "$1" in
    "proxy")
        task_virtual_proxy
        ;;
    "driver")
        task_virtual_driver
        ;;
    *)
        color "Please slecte you chioce:" $white
        color "1) Set proxy with virtualbox" $yellow
        color "2) Install virtualbox driver" $yellow
        ;;
esac
##############################################################################################################################