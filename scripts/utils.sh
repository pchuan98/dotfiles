#!/bin/bash
set -e
# This is a Bash script header
# Author: chuan
# Version: 1.0
# Date: September 14, 2023
# Description: Tools for using arch linux.

##############################################################################################################################

# color
black="\e[30m"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
magenta="\e[35m"
cyan="\e[36m"
white="\e[37m"

end="\e[0m"

color_echo(){
    local text="$1"  # The text to print
    local color="$2" # The color code (e.g., 31 for red, 32 for green, 33 for yellow, etc.)
    echo -e "${color}${text}${end}"  # Use ANSI escape sequences to set and reset color
}

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
}

if [ "$#" -eq 0 ]; then
    color_echo "Please slecte you chioce:" $white
    color_echo "1) Set proxy with virtualbox" $yellow
    color_echo "2) Install virtualbox driver" $yellow
    read -p "-> " user_input

    # Check the user's input and perform different actions
    if [ "$user_input" -eq 1 ]; then
        task_virtual_proxy
    elif [ "$user_input" -eq 2 ]; then
        task_virtual_driver
    else
        color_echo "Invalid input. Please enter 1,2..." $red
    fi
else
    color_echo "Invalid input." $red
fi
