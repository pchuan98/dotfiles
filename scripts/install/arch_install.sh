#!/bin/bash
set -e
# This is a Bash script header
# Author: chuan
# Version: 1.0
# Date: September 14, 2023
# Description: Config arch linx.

# 参考 https://github.com/JaKooLit/Hyprland-v4
# https://blog.cascade.moe/posts/hyprland-configure/
##############################################################################################################################

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

install(){
    software_package="$1"

    # 检查软件是否已经安装
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

LOG="install-$(date +%d-%H%M%S)_hypr-pkgs.log"
##############################################################################################################################

# add an user
task_user(){
    # set time
    timedatectl set-local-rtc true
    timedatectl set-ntp true

    read -p "input your name:-> " user_input

    useradd -m -G wheel -s /bin/bash $user_input
    echo -e "971226\n971226" | passwd $user_input
    EDITOR=nvim visudo
}

# config pacman and install some software
task_pacman(){
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
# xorg-xrdb -> set dpi
##################################################################################################
base=(
    gtk gtk2 gtk3 gtk4 gtkmm gtkmm3 gtkmm-4.0 xorg-xwayland
    glfw-wayland qt6ct qt5ct

    qt5-3d qt5-base qt5-charts qt5-connectivity qt5-datavis3d
    qt5-declarative qt5-doc qt5-examples qt5-gamepad qt5-graphicaleffects
    qt5-imageformats qt5-location qt5-lottie qt5-multimedia qt5-networkauth
    qt5-purchasing qt5-quick3d qt5-quickcontrols qt5-quickcontrols2
    qt5-quicktimeline qt5-remoteobjects qt5-script qt5-scxml qt5-sensors
    qt5-serialbus qt5-serialport qt5-speech qt5-svg qt5-tools qt5-translations
    qt5-virtualkeyboard qt5-wayland qt5-webchannel qt5-webengine qt5-webglplugin
    qt5-websockets qt5-webview qt5-x11extras qt5-xmlpatterns

    qt6-3d qt6-5compat qt6-base qt6-charts qt6-connectivity qt6-datavis3d
    qt6-declarative qt6-doc qt6-examples qt6-grpc qt6-httpserver
    qt6-imageformats qt6-languageserver qt6-location qt6-lottie qt6-multimedia qt6-networkauth
    qt6-positioning qt6-quick3d qt6-quick3dphysics qt6-quickeffectmaker qt6-quicktimeline
    qt6-remoteobjects qt6-scxml qt6-sensors qt6-serialbus qt6-serialport qt6-shadertools
    qt6-speech qt6-svg qt6-tools qt6-translations qt6-virtualkeyboard qt6-wayland
    qt6-webchannel qt6-webengine qt6-websockets qt6-webview

    cliphist wl-clipboard
    wayland hyprland
    sddm-git
    xdg-desktop-portal-hyprland

    xorg-xrdb
)

software=(
    rust alacritty rofi waybar dunst swww swaybg
    thunar thunar-volman tumbler thunar-archive-plugin
)

shell=(zsh zsh-syntax-highlighting zsh-autosuggestions)

polkit=(polkit polkit-qt5 polkit-gnome polkit-kde-agent)

fonts=(
    adobe-source-han-serif-cn-fonts wqy-zenhei
    noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
    ttf-firacode-nerd ttf-dejavu-nerd
)
# https://wiki.archlinux.org/title/Fcitx5
ime=(fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-chinese-addons fcitx5-material-color fcitx5-nord fcitx5-pinyin-moegirl)

tools=(
    # tlp tlp-rdw tlpui
    pipewire wireplumber slurp grim obs-studio
)

others=(tldr ntfs-3g timeshift wget)

task_software(){
    # compile tools
    for PKG1 in "${base[@]}" "${software[@]}" "${shell[@]}" "${polkit[@]}" "${fonts[@]}" "${ime[@]}" "${tools[@]}" "${others[@]}"; do
        install "$PKG1" 2>&1 | tee -a "$LOG"
        if [ $? -ne 0 ]; then
            echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed, please check the install.log"
            exit 1
        fi
    done
}

##########################################################################################################################
# remember to run 'libtool --finish /usr/lib'
# 
#########################################################################################################################


task_driver(){
    # bluetooth

    # network

    # GPU

    # screen

    # voice

    # figure

    # vpn

    # 美化
    echo ""
}

# the driver for amd
task_amd(){
    echo ""
    sudo pacman -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon
}

# the driver for intel
task_intel(){
    echo ""
}

# the driver for nvidia
task_nvidia(){
    echo ""
}
