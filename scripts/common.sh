#!/bin/bash

set -e

# Common method for all scripts
# Author: chuan
# Version: 1.0
# Date: October 10, 2023
# Description: Config arch linx.

##############################################################################################################################

##############################################################################################################
# ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
# ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
# ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
# ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
# ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
# ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

LOG="install-$(date +%d-%H%M%S)_hypr-pkgs.log"

install(){
    software_package="$1"

    if yay -Q "$software_package" >/dev/null 2>&1; then
        echo "${OK} Installed(yay) - $software_package" 
    elif pacman -Q "$software_package" >/dev/null 2>&1; then
        echo "${OK} Installed(pacman) - $software_package"
    else
        yay -S --noconfirm "$software_package"
        if [ $? -eq 0 ]; then
            echo "${OK} Installed(yay) - $software_package" 
        else
            echo "${ERROR} Error(yay) - $software_package"
            sudo pacman -S --noconfirm "$software_package"

            if [ $? -eq 0 ]; then
                echo "${OK} Installed(pacman) - $software_package"
            else
                echo "${ERROR} Error(pacman) - $software_package"
            fi
        fi
    fi
}

##############################################################################################################
#  ██████╗ ██████╗ ██╗      ██████╗ ██████╗
# ██╔════╝██╔═══██╗██║     ██╔═══██╗██╔══██╗
# ██║     ██║   ██║██║     ██║   ██║██████╔╝
# ██║     ██║   ██║██║     ██║   ██║██╔══██╗
# ╚██████╗╚██████╔╝███████╗╚██████╔╝██║  ██║
#  ╚═════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝

black="\e[30m"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
magenta="\e[35m"
cyan="\e[36m"
white="\e[37m"

end="\e[0m"

color(){
    local text="$1"  # The text to print
    local color="$2" # The color code (e.g., 31 for red, 32 for green, 33 for yellow, etc.)
    echo -e "${color}${text}${end}"  # Use ANSI escape sequences to set and reset color
}

##############################################################################################################

splitline="------------------------------------------------------------------------"

box(){
    msg="$1"
    echo "$splitline"
    echo -e "$msg"
    echo "$splitline"
}

##############################################################################################################
write_once(){
    file="$1"
    line="$2"

    if ! grep -qF -- "$line" "$file"; then
        echo "$line" >> "$file"
    fi
}