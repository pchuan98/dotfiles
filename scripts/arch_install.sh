#!/bin/bash
set -e
# This is a Bash script header
# Author: chuan
# Version: 1.0
# Date: September 14, 2023
# Description: Config arch linx.

# 参考 https://github.com/JaKooLit/Hyprland-v4

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

install(){
    software_package="$1"

    # 检查软件是否已经安装
    if yay -Q "$software_package" >/dev/null 2>&1; then
        color_echo "Installed(yay) - $software_package" $green
    elif pacman -Q "$software_package" >/dev/null 2>&1; then
        color_echo "Installed(pacman) - $software_package" $green
    else
        yay -S --noconfirm "$software_package"
        if [ $? -eq 0 ]; then
            color_echo "Installed(yay) - $software_package" $green
        else
            color_echo "Error(yay) - $software_package" $red
            sudo pacman -S --noconfirm "$software_package"

            if [ $? -eq 0 ]; then
                color_echo "Installed(pacman) - $software_package" $green
            else
                color_echo "Error(pacman) - $software_package" $red
            fi
        fi
    fi
}

##############################################################################################################################

# add an user
task01(){
    # set time
    timedatectl set-local-rtc true
    timedatectl set-ntp true

    read -p "input your name:-> " user_input

    useradd -m -G wheel -s /bin/bash $user_input
    echo -e "971226\n971226" | passwd $user_input
    EDITOR=nvim visudo
}

# config pacman and install some software
task02(){
    cn='i\
[archlinuxcn]\
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch\
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch\
Server = https://mirrors.hit.edu.cn/archlinuxcn/$arch\
Server = https://repo.huaweicloud.com/archlinuxcn/$arch\
'
    sed -i "1$cn" /etc/pacman.conf

    sed -i "s/^#\?Color\s\?$/Color/g" /etc/pacman.conf
    sed -i "s/^#\?ParallelDownloads.*$/ParallelDownloads = 5/g" /etc/pacman.conf
    sed -i "1i\Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch" /etc/pacman.d/mirrorlist

    pacman -Syyu
    pacman -S --noconfirm --needed archlinuxcn-keyring archlinux-keyring
    pacman -S --noconfirm --needed git linux-headers
    pacman -S --noconfirm --needed yay

    git config --system user.email "1114003209@qq.com"
    git config --system user.name "pchuan98"
    git config --system credential.helper store

    git config --system init.defaultBranch master
    git config --system pager.branch false
    git config --system pager.diff false
    git config --system pager.log false

    git config --system merge.tool vimdiff 
    git config --system mergetool.vimdiff.path nvim
}

# install core software
# tldr 
# alacritty rofi
# hyprland waybar
# zsh zsh-syntax-highlighting zsh-autosuggestions
# gtk gtk2 gtk3 gtk4 gtkmm gtkmm3 gtkmm-4.0
##################################################################################################
task03(){


    # 基础功能
    yay -S rust wayland rofi alacritty hyprland dunst waybar

    # 驱动软件

    # 字体

    # 输入法

    # 常用软件

    # 备份软件

}


# 美化使用
task02(){
    # sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"  
}

if [ "$#" -eq 0 ]; then
    color_echo "Please slecte you chioce:" $white
    color_echo "1) Add User" $yellow

    read -p "-> " user_input

    # Check the user's input and perform different actions
    if [ "$user_input" -eq 1 ]; then
        task01
    # Add your code for action 1 here
    elif [ "$user_input" -eq 2 ]; then
        task_arch
    elif [ "$user_input" -eq 3 ]; then
        task_config
    else
        color_echo "Invalid input. Please enter 1,2,3." $red
    fi

elif [ "$#" -eq 1 ]; then
    # Get the first argument
    argument="$1"

    # Perform actions based on the argument
    case "$argument" in
        "1")
            task01
            ;;
        "2")

            ;;
        "3")

            ;;
    *)
        color_echo "Invalid input. Please enter 1,2,3." $red
        ;;
    esac
else
    color_echo "Invalid input." $red
fi
