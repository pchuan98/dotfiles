#!/bin/bash
# set -exo
set -e

# The script is used to install arch linux.
# Author: chuan
# Version: 1.0
# Date: September 14, 2023
# Description: Arch installation script for testing. This script will install a pure arch system.

##############################################################################################################################

path="$(realpath "$0")"
name="$(basename "$path")"
dir="$(dirname "$path")"
parent="$(dirname "$dir")"

source $parent/common.sh

##############################################################################################################################
# environment:
# who: 
# command: 
# description:

detect_system(){
    platform_size=$(cat /sys/firmware/efi/fw_platform_size)

    if [ "$platform_size" -eq 64 ]; then
        echo "${OK} The platform size is 64."
    else
        color "You must set UEFI mode." $red
        echo "${ERROR} The platform size is not 64. Exiting..."
        exit 1
    fi

    systemctl stop reflector.service
    timedatectl set-ntp true

    sed -i "s/^#\?Color\s\?$/Color/g" /etc/pacman.conf
    sed -i "s/^#\?ParallelDownloads.*$/ParallelDownloads = 5/g" /etc/pacman.conf
    sed -i "1i\Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch" /etc/pacman.d/mirrorlist

    pacman -Sy
}

##############################################################################################################################

disk(){
    tput clear
    box $(lsblk)
    color "Please ensure that the disk which you want to install.\n" $yellow

    read -p "Please enter the hard disk address: " device_path &&  cfdisk $device_path

    box $(fdisk -l $device_path)

    read -e -i "$device_path" -p "Please enter the swap path: " swap_path
    read -e -i "$device_path" -p "Please enter the /boot address: " boot_path
    read -e -i "$device_path" -p "Please enter the / address: " btrfs_path

    if swapon -s | grep -q "$swap_path"; then
        swapoff "$swap_path"
    fi

    mkswap $swap_path
    mkfs.fat -F32 $boot_path
    mkfs.btrfs -f -L ARCH $btrfs_path

    mkdir -p /mnt/arch

    mount -t btrfs -o compress=zstd $btrfs_path /mnt/arch

    btrfs subvolume create /mnt/arch/@
    btrfs subvolume create /mnt/arch/@home
    btrfs subvolume list -p /mnt/arch

    umount /mnt/arch

    mount -t btrfs -o subvol=/@,compress=zstd $btrfs_path /mnt/arch
    mkdir /mnt/arch/home
    mount -t btrfs -o subvol=/@home,compress=zstd $btrfs_path /mnt/arch/home
    swapon $swap_path
    mkdir /mnt/arch/boot
    mount $boot_path /mnt/arch/boot

    pacstrap /mnt/arch base base-devel linux linux-firmware python
    pacstrap /mnt/arch btrfs-progs iwd vim sudo zsh zsh-completions neovim wget openssh dhcpcd btop

    genfstab -U /mnt/arch > /mnt/arch/etc/fstab
}

##############################################################################################################################

base_config(){
    src="/root/dotfiles"
    dst="/mnt/arch/root/dotfiles"

    if [ -d "$folder_path" ]; then
        rm -rf $dst
        cp -r $src $dst

        arch-chroot /mnt/arch /root/dotfiles/scripts/install/arch.sh base_config_run
    else
        echo "${ERROR} The folder does not exist.Please move the dotfiles folder to the root directory: /root/dotfiles"
        exit 1
    fid
}

base_config_run(){
    tput clear
    box "\n # Start base config... #\n"

    echo "$splitline"
    color "-> Config host and user value" $yellow

    hostname="arch" && 
        read -e -i "$hostname" -p "Please enter the hostname: " hostname &&
        echo $hostname > /etc/hostname

    echo "" > /etc/hosts
    echo "127.0.0.1   localhost" >> /etc/hosts
    echo "::1         localhost" >> /etc/hosts
    echo "127.0.1.1   $hostname.localdomain $hostname" >> /etc/hosts

    echo -e "971226\n971226" | passwd root

    echo "$splitline"
    color "-> Config time and locale" $yellow

    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    hwclock --systohc

    sed -i "s/^[#]\+\s*en_US.UTF-8 UTF-8\s*$/en_US.UTF-8 UTF-8/g" /etc/locale.gen
    sed -i "s/^[#]\+\s*zh_CN.UTF-8 UTF-8\s*$/zh_CN.UTF-8 UTF-8/g" /etc/locale.gen
    locale-gen
    echo 'LANG=en_US.UTF-8' >>/etc/locale.conf

    echo "$splitline"
    color "-> Install u-code" $yellow

    cpu_vendor=$(lscpu | grep "Vendor ID" | awk '{print $3}')
    cpu_family=$(lscpu | grep "Family" | awk '{print $2}')

    echo "${NOTE} CPU vendor: $cpu_vendor"

    if [ "$cpu_vendor" == "GenuineIntel" ]; then
        if [ "$cpu_family" == "6" ]; then
            pacman --noconfirm -S intel-ucode
        else
            pacman --noconfirm -S intel-ucode
        fi
    elif [ "$cpu_vendor" == "AuthenticAMD" ]; then
        pacman --noconfirm -S amd-ucode
    else
        color_echo "cant find current cpu version" $red
    fi

    echo "$splitline"
    color "-> Config sshd and others" $yellow

    sed -i "s/^#*\s*PermitRootLogin.*$/PermitRootLogin yes/g" /etc/ssh/sshd_config
    sed -i "s/^#*\w*ClientAliveInterval.*$/ClientAliveInterval 30/g" /etc/ssh/sshd_config
    sed -i "s/^#*\w*ClientAliveCountMax.*$/ClientAliveCountMax 20/g" /etc/ssh/sshd_config

    sed -i "s/^#\?Color\s\?$/Color/g" /etc/pacman.conf
    sed -i "s/^#\?ParallelDownloads.*$/ParallelDownloads = 5/g" /etc/pacman.conf
    sed -i "1i\Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch" /etc/pacman.d/mirrorlist

    systemctl enable sshd
    systemctl enable dhcpcd
    systemctl enable iwd

    echo "$splitline"
    color "-> Grub loading ..." $yellow

    pacman --noconfirm -S grub efibootmgr os-prober
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH

    sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=5 nowatchdog"/' /etc/default/grub
    sed -i '1iGRUB_DISABLE_OS_PROBER=false' /etc/default/grub

    box $(grub-mkconfig -o /boot/grub/grub.cfg)
}

##############################################################################################################################

add_user(){
    tput clear
    box "\n # Add an user... #\n"

    read -p "input your name:-> " user_input

    useradd -m -G wheel -s /bin/bash $user_input
    echo -e "971226\n971226" | passwd $user_input
    EDITOR=nvim visudo
}

config_pacman(){
    if [ "$(id -u)" -ne 0 ]; then
        echo "${ERROR} This func must be run as root."
        exit 1
    fi

    tput clear
    box "\n # Config pacman and install some software... #\n"

    sed -i "s/^#\?Color\s\?$/Color/g" /etc/pacman.conf
    sed -i "s/^#\?ParallelDownloads.*$/ParallelDownloads = 5/g" /etc/pacman.conf
    sed -i "1i\Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch" /etc/pacman.d/mirrorlist

    pacman -Syyu
    pacman -S --noconfirm --needed archlinuxcn-keyring archlinux-keyring
    pacman -S --noconfirm --needed git linux-headers
    pacman -S --noconfirm --needed yay
}

config_git(){
    if [ "$(id -u)" -ne 0 ]; then
        echo "${ERROR} This func must be run as root."
        exit 1
    fi

    tput clear
    box "\n # Config git... #\n"

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

##############################################################################################################################
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

software_install(){
    # compile tools
    for PKG1 in "${base[@]}" "${software[@]}" "${shell[@]}" "${polkit[@]}" "${fonts[@]}" "${ime[@]}" "${tools[@]}" "${others[@]}"; do
        install "$PKG1" 2>&1 | tee -a "$LOG"
        if [ $? -ne 0 ]; then
            echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed, please check the install.log"
            exit 1
        fi
    done
}