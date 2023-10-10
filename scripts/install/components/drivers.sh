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
