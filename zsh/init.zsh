##############################################################################################################
# 
#    ██╗  ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██████╗ 
#    ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██║████╗  ██║██╔══██╗
#    █████╔╝ █████╗   ╚████╔╝ ██████╔╝██║██╔██╗ ██║██║  ██║
#    ██╔═██╗ ██╔══╝    ╚██╔╝  ██╔══██╗██║██║╚██╗██║██║  ██║
#    ██║  ██╗███████╗   ██║   ██████╔╝██║██║ ╚████║██████╔╝
#    ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ 
#
# remove a word from the cursor to the beginning of the line
bindkey '^H' backward-kill-word

# home & end
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# arrow
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word


##############################################################################################################

##############################################################################################################
#
#    ███████╗███╗   ██╗██╗   ██╗██╗██████╗  ██████╗ ███╗   ██╗███╗   ███╗███████╗███╗   ██╗████████╗
#    ██╔════╝████╗  ██║██║   ██║██║██╔══██╗██╔═══██╗████╗  ██║████╗ ████║██╔════╝████╗  ██║╚══██╔══╝
#    █████╗  ██╔██╗ ██║██║   ██║██║██████╔╝██║   ██║██╔██╗ ██║██╔████╔██║█████╗  ██╔██╗ ██║   ██║
#    ██╔══╝  ██║╚██╗██║╚██╗ ██╔╝██║██╔══██╗██║   ██║██║╚██╗██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║
#    ███████╗██║ ╚████║ ╚████╔╝ ██║██║  ██║╚██████╔╝██║ ╚████║██║ ╚═╝ ██║███████╗██║ ╚████║   ██║
#    ╚══════╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝
#

export DOTFILES_DIR="/home/chuan/dotfiles"
export ZSH_CONFIG_DIR="/home/chuan/dotfiles/zsh"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CONFIG_DIRS="/etc/xdg"
export XDG_DATA_DIRS="/usr/local/share:/usr/share:/var/lib/flatpak/exports/share:$XDG_DATA_HOME/flatpak/exports/share"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

cmdline=$(cat /proc/cmdline)

if [[ $cmdline == *"vmlinuz-linux"* ]]; then
  echo "Current System IS VMWARE."
  host_ip=$(awk '/nameserver/ {split($2, a, "."); print a[1]"."a[2]"."a[3]".1"}' /etc/resolv.conf)
  port=10809
  export ALL_PROXY="http://$host_ip:$port"
  export http_proxy="http://$host_ip:$port"
  export https_proxy="http://$host_ip:$port"
elif [[ $cmdline == *"WSL_ROOT_INIT"* ]]; then
  echo "Current System IS WSL."
  host_ip=$(cat /etc/resolv.conf |grep "nameserver" |cut -f 2 -d " ")
  port=10809
  export ALL_PROXY="http://$host_ip:$port"
  export http_proxy="http://$host_ip:$port"
  export https_proxy="http://$host_ip:$port"

  cd $(dirname $DOTFILES_DIR)
else
  # export ALL_PROXY="http://$host_ip:$port"
  # export http_proxy="http://$host_ip:$port"
  # export https_proxy="http://$host_ip:$port"
fi

export EDITOR=nvim

##############################################################################################################

##############################################################################################################
#
#     █████╗ ██╗     ██╗ █████╗ ███████╗███████╗███████╗
#    ██╔══██╗██║     ██║██╔══██╗██╔════╝██╔════╝██╔════╝
#    ███████║██║     ██║███████║███████╗█████╗  ███████╗
#    ██╔══██║██║     ██║██╔══██║╚════██║██╔══╝  ╚════██║
#    ██║  ██║███████╗██║██║  ██║███████║███████╗███████║
#    ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
#

# enhance
alias cleanram="sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'"
alias trim_all="sudo fstrim -va"

alias mtar='tar -zcvf' # mtar <archive_compress>
alias utar='tar -zxvf' # utar <archive_decompress> <file_list>
alias uz='unzip' # uz <archive_decompress> -d <dir>

alias mkdir="mkdir -p"

# package manager

if [ -f /etc/os-release ]; then
    source /etc/os-release

    if [[ $NAME == "Arch Linux" ]]; then
        alias pai="pacman -Slq | fzf -m --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk \"{print \$2}\")' | xargs -ro sudo pacman -S"
        alias par="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"
        alias pas="pacman -Q |  fzf --multi --preview 'pacman -Qi {1}'"

        alias yi="yay -Slq | fzf -m --preview 'cat <(yay -Si {1}) <(yay -Fl {1} | awk \"{print \$2}\")' | xargs -ro  yay -S"
        alias yr="yay -Qq | fzf --multi --preview 'yay -Qi {1}' | xargs -ro yay -Rns"
        alias ys="yay -Q |  fzf --preview 'yay -Qi {1}'"
    elif [[ $NAME == "Ubuntu" ]]; then
        echo "This is Ubuntu. Please wait some times."
    else
        echo "Unsupported operating system: $NAME"
    fi
else
    echo "Unable to determine the operating system."
fi

# zsh
alias sz='source ~/.zshrc'

# git && lazygit
alias lg=lazygit
alias gs="git status"
alias gm="git commit -m"

# tools
alias ls="exa --color=auto"
alias l="ls -l"
alias la="ls -la"
alias lt="ls --tree"

alias grep=rg

alias mv='mv -v'
alias cp='cp -vr'
alias rm='rm -vr'

alias cat="bat --color always --plain"
alias grep='grep --color=auto'

alias v=nvim
alias fm=yazi

# Toilet
export TOILET_FONT_DIR=$DOTFILES_DIR/fonts
alias tf1="toilet -t -d $TOILET_FONT_DIR -f ansi_regular"
alias tf2="toilet -t -d $TOILET_FONT_DIR -f ansi_shadow"
alias tf3="toilet -t -d $TOILET_FONT_DIR -f big_ne"
alias tf4="toilet -t -d $TOILET_FONT_DIR -f big_nw"
alias tf5="toilet -t -d $TOILET_FONT_DIR -f big_se"
alias tf6="toilet -t -d $TOILET_FONT_DIR -f blocks"
alias tf7="toilet -t -d $TOILET_FONT_DIR -f electronic"
alias tf8="toilet -t -d $TOILET_FONT_DIR -f varsity"

# quicker
alias ..="cd .."
alias mkgrub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias installed="grep -i installed /var/log/pacman.log"
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e" 

# others
# alias rm='$DOTFILES_DIR/tools/trash.sh'

##############################################################################################################

##############################################################################################################
# ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗███████╗
# ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
# ███████╗██║     ██████╔╝██║██████╔╝   ██║   ███████╗
# ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ╚════██║
# ███████║╚██████╗██║  ██║██║██║        ██║   ███████║
# ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚══════╝

# print all tf fonts
tf() {
  for i in {1..8}; do
    command="tf$i $@"
    eval "$command"
  done
}

##############################################################################################################
#
#     ██████╗ ██████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
#    ██╔═══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
#    ██║   ██║██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║███████╗
#    ██║   ██║██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║╚════██║
#    ╚██████╔╝██║        ██║   ██║╚██████╔╝██║ ╚████║███████║
#     ╚═════╝ ╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
#

#  Manage the read/write/execute permissions that are masked out (i.e. restricted) for newly created files by the user.
#  More information: https://manned.org/umask.
umask 022

# load zsh modules
zmodload zsh/zle
zmodload zsh/zpty
zmodload zsh/complist

# load zsh completions
autoload _vi_search_fix
autoload -Uz colors
autoload -U compinit

# turn on colors
colors

# zsh line editor options
zle -N _vi_search_fix
zle -N _sudo_command_line

# History
HISTFILE="$HOME/.zhistory"
HISTSIZE=10000
SAVEHIST=10000

# Autosuggestion
ZSH_AUTOSUGGEST_USE_ASYNC="true"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor regexp root line)
ZSH_HIGHLIGHT_MAXLENGTH=512
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=$color8,bold"

while read -r opt
do 
  setopt $opt
done <<-EOF
AUTOCD
AUTO_MENU
AUTO_PARAM_SLASH
COMPLETE_IN_WORD
NO_MENU_COMPLETE
HASH_LIST_ALL
ALWAYS_TO_END
NOTIFY
NOHUP
MAILWARN
INTERACTIVE_COMMENTS
NOBEEP
APPEND_HISTORY
SHARE_HISTORY
INC_APPEND_HISTORY
EXTENDED_HISTORY
HIST_IGNORE_ALL_DUPS
HIST_IGNORE_SPACE
HIST_NO_FUNCTIONS
HIST_EXPIRE_DUPS_FIRST
HIST_SAVE_NO_DUPS
HIST_REDUCE_BLANKS
EOF

while read -r opt
do 
  unsetopt $opt
done <<-EOF
FLOWCONTROL
NOMATCH
CORRECT
EQUALS
EOF

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

##############################################################################################################

##############################################################################################################
#
#    ██████╗ ██╗     ██╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗
#    ██╔══██╗██║     ██║   ██║██╔════╝ ██║████╗  ██║██╔════╝
#    ██████╔╝██║     ██║   ██║██║  ███╗██║██╔██╗ ██║███████╗
#    ██╔═══╝ ██║     ██║   ██║██║   ██║██║██║╚██╗██║╚════██║
#    ██║     ███████╗╚██████╔╝╚██████╔╝██║██║ ╚████║███████║
#    ╚═╝     ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝
#

source "$ZSH_CONFIG_DIR/plugins.zsh"

##############################################################################################################
