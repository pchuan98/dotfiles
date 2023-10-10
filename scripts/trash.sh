##############################################################################################################################
# ███████╗██╗  ██╗ █████╗ ███╗   ███╗██████╗ ██╗     ███████╗███████╗
# ██╔════╝╚██╗██╔╝██╔══██╗████╗ ████║██╔══██╗██║     ██╔════╝██╔════╝
# █████╗   ╚███╔╝ ███████║██╔████╔██║██████╔╝██║     █████╗  ███████╗
# ██╔══╝   ██╔██╗ ██╔══██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝  ╚════██║
# ███████╗██╔╝ ██╗██║  ██║██║ ╚═╝ ██║██║     ███████╗███████╗███████║
# ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝╚══════╝

# select task and run
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

# current path
script_path="$(realpath "$0")"

# current directory
script_directory="$(dirname "$script_path")"

# current file name
script_name="$(basename "$script_path")"

# current parent directory
script_parent_directory="$(dirname "$script_directory")"