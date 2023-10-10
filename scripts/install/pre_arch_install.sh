#!/bin/bash
# set -exo
set -e

# This is a Bash script header
# Author: chuan
# Version: 1.0
# Date: September 14, 2023
# Description: Arch installation script for testing. This script will install a pure arch system.

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

task_iso(){
    platform_size=$(cat /sys/firmware/efi/fw_platform_size)

    # Check if the value is equal to 64
    if [ "$platform_size" -eq 64 ]; then
    echo "The platform size is 64."
    else
    echo "The platform size is not 64. Exiting..."
    color_echo "You must set UEFI mode." $yellow
    exit 1  # Exit with a non-zero status code to indicate an error
    fi

    systemctl stop reflector.service
    timedatectl set-ntp true

    sed -i "s/^#\?Color\s\?$/Color/g" /etc/pacman.conf
    sed -i "s/^#\?ParallelDownloads.*$/ParallelDownloads = 5/g" /etc/pacman.conf
    sed -i "1i\Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch" /etc/pacman.d/mirrorlist

    pacman -Sy


    echo "------------------------------------------------------------------------"
    lsblk
    echo "------------------------------------------------------------------------"

    read -p "Please enter the hard disk address: " device_path

    cfdisk $device_path
    clear

    echo "------------------------------------------------------------------------"
    fdisk -l $device_path
    echo "------------------------------------------------------------------------"

    # note 这里我强行设置没有
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

task_arch(){
    script_name=$(basename "${BASH_SOURCE[0]}")
    script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
    dirname=$(dirname $script_dir)

    rm -rf /mnt/arch/root/dotfiles
    cp -r $dirname /mnt/arch/root/dotfiles

    arch-chroot /mnt/arch /bin/bash /root/dotfiles/scripts/${script_name} 3
}

task_config(){
    color_echo "-> config host and user" $green

    echo arch > /etc/hostname

    # hosts
    echo "" > /etc/hosts
    echo "127.0.0.1   localhost" >> /etc/hosts
    echo "::1         localhost" >> /etc/hosts
    echo "127.0.1.1   chuan.localdomain chuan" >> /etc/hosts

    echo -e "971226\n971226" | passwd root

    # time zone
    color_echo "-> config time and locale" $green
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    hwclock --systohc

    # local
    sed -i "s/^[#]\+\s*en_US.UTF-8 UTF-8\s*$/en_US.UTF-8 UTF-8/g" /etc/locale.gen
    sed -i "s/^[#]\+\s*zh_CN.UTF-8 UTF-8\s*$/zh_CN.UTF-8 UTF-8/g" /etc/locale.gen
    locale-gen
    echo 'LANG=en_US.UTF-8' >>/etc/locale.conf

    # microcode
    color_echo "-> Install microcode ..." $green
    cpu_vendor=$(lscpu | grep "Vendor ID" | awk '{print $3}')
    cpu_family=$(lscpu | grep "Family" | awk '{print $2}')

    # install u-code by cpu version
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

    color_echo "-> Config sshd and others" $green
    # 配置远程工具
    sed -i "s/^#*\s*PermitRootLogin.*$/PermitRootLogin yes/g" /etc/ssh/sshd_config
    sed -i "s/^#*\w*ClientAliveInterval.*$/ClientAliveInterval 30/g" /etc/ssh/sshd_config
    sed -i "s/^#*\w*ClientAliveCountMax.*$/ClientAliveCountMax 20/g" /etc/ssh/sshd_config

    sed -i "s/^#\?Color\s\?$/Color/g" /etc/pacman.conf
    sed -i "s/^#\?ParallelDownloads.*$/ParallelDownloads = 5/g" /etc/pacman.conf
    sed -i "1i\Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch" /etc/pacman.d/mirrorlist

    systemctl enable sshd
    systemctl enable dhcpcd
    systemctl enable iwd

    color_echo "-> grub loading ..." $green
    pacman --noconfirm -S grub efibootmgr os-prober
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH

    sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=5 nowatchdog"/' /etc/default/grub
    sed -i '1iGRUB_DISABLE_OS_PROBER=false' /etc/default/grub

    echo "------------------------------------------------------------------------"
    grub-mkconfig -o /boot/grub/grub.cfg
    echo "------------------------------------------------------------------------"
}

if [ "$#" -eq 0 ]; then
    color_echo "Please slecte you chioce:" $white
    color_echo "1) Run in iso" $yellow
    color_echo "2) Run in installer:" $yellow
    color_echo "3) Config arch:" $yellow

    read -p "-> " user_input

    # Check the user's input and perform different actions
    if [ "$user_input" -eq 1 ]; then
        task_iso
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
        "0")
            task_iso
            task_arch
            ;;
        "1")
            task_iso
            ;;
        "2")
            task_arch
            ;;
        "3")
            task_config
            ;;
    *)
        color_echo "Invalid input. Please enter 1,2,3." $red
        ;;
    esac
else
    color_echo "Invalid input." $red
fi
