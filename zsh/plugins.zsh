##############################################################################################################
# specify symbol
# ⋙ ▷ → ▶ ► ▸
# ⋘ ◁ ← ◀ ◄ ◂
# ƒ ↔ ⇔ ⇄ ⇺ ⇹ ⇋ ⇌ ⇼ ⇀
# 💧🦉👀👁️🦴🎈⚙️🚀🛸🚩🛎️❄️⚡🔥❤️❗❓➡️
##############################################################################################################


##############################################################################################################
#
#    ███████╗██╗███╗   ██╗██╗████████╗
#    ╚══███╔╝██║████╗  ██║██║╚══██╔══╝
#      ███╔╝ ██║██╔██╗ ██║██║   ██║
#     ███╔╝  ██║██║╚██╗██║██║   ██║
#    ███████╗██║██║ ╚████║██║   ██║
#    ╚══════╝╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝
#

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
zinit ice blockf atpull'zinit creinstall -q .'

# source "$HOME/zsh/tools/benchmark.zsh"

##############################################################################################################

##############################################################################################################
#
#     ██████╗ ██████╗ ███╗   ███╗██████╗ ██╗     ███████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
#    ██╔════╝██╔═══██╗████╗ ████║██╔══██╗██║     ██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
#    ██║     ██║   ██║██╔████╔██║██████╔╝██║     █████╗     ██║   ██║██║   ██║██╔██╗ ██║███████╗
#    ██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝     ██║   ██║██║   ██║██║╚██╗██║╚════██║
#    ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ███████╗███████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
#     ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
#
# zsh-completions

zinit light zsh-users/zsh-completions
autoload compinit
compinit

##############################################################################################################

##############################################################################################################
#
#    ██████╗  ██████╗ ██╗    ██╗███████╗██████╗ ██╗     ███████╗██╗   ██╗███████╗██╗     ██╗ ██████╗ ██╗  ██╗
#    ██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔══██╗██║     ██╔════╝██║   ██║██╔════╝██║    ███║██╔═████╗██║ ██╔╝
#    ██████╔╝██║   ██║██║ █╗ ██║█████╗  ██████╔╝██║     █████╗  ██║   ██║█████╗  ██║    ╚██║██║██╔██║█████╔╝ 
#    ██╔═══╝ ██║   ██║██║███╗██║██╔══╝  ██╔══██╗██║     ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║     ██║████╔╝██║██╔═██╗ 
#    ██║     ╚██████╔╝╚███╔███╔╝███████╗██║  ██║███████╗███████╗ ╚████╔╝ ███████╗███████╗██║╚██████╔╝██║  ██╗
#    ╚═╝      ╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝  ╚═══╝  ╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═╝
#
# themes and colors

# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


[[ ! -f $dir/p10k.zsh ]] || source $dir/p10k.zsh

# https://github.com/trapd00r/LS_COLORS
# https://zdharma-continuum.github.io/zinit/wiki/LS_COLORS-explanation/
# note : yay -S vivid
zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

##############################################################################################################

##############################################################################################################
#
#    ███████╗███╗   ██╗██╗██████╗ ██████╗ ███████╗████████╗
#    ██╔════╝████╗  ██║██║██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
#    ███████╗██╔██╗ ██║██║██████╔╝██████╔╝█████╗     ██║
#    ╚════██║██║╚██╗██║██║██╔═══╝ ██╔═══╝ ██╔══╝     ██║
#    ███████║██║ ╚████║██║██║     ██║     ███████╗   ██║
#    ╚══════╝╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝     ╚══════╝   ╚═╝
#

# zi snippet OMZP::git
zi snippet OMZP::sudo
zi snippet OMZP::dotenv
##############################################################################################################

##############################################################################################################
# 
#    ███████╗███████╗███████╗
#    ██╔════╝╚══███╔╝██╔════╝
#    █████╗    ███╔╝ █████╗
#    ██╔══╝   ███╔╝  ██╔══╝
#    ██║     ███████╗██║
#    ╚═╝     ╚══════╝╚═╝
# 
# https://github.com/junegunn/fzf

zinit ice from"gh-r" as"command"
zinit light junegunn/fzf-bin

# arcticicestudio/nord-vim
export FZF_DEFAULT_OPTS="
    --color fg:#D8DEE9
    --color fg+:#D8DEE9

    --color hl:#616E88
    --color hl+:#81A1C1

    --color header:#616E88
    --color info:#81A1C1
    --color spinner:#81A1C1

    --color pointer:#81A1C1
    --color marker:#81A1C1
    --color prompt:#81A1C1

    --layout=reverse
    --margin 1

    --min-height 30
    --height 40

    --prompt='  '
    --pointer='⚙️'
    --info=inline
    --border rounded"

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'

##############################################################################################################

##############################################################################################################
# 
#    ███████╗███████╗███████╗              ████████╗ █████╗ ██████╗ 
#    ██╔════╝╚══███╔╝██╔════╝              ╚══██╔══╝██╔══██╗██╔══██╗
#    █████╗    ███╔╝ █████╗      █████╗       ██║   ███████║██████╔╝
#    ██╔══╝   ███╔╝  ██╔══╝      ╚════╝       ██║   ██╔══██║██╔══██╗
#    ██║     ███████╗██║                      ██║   ██║  ██║██████╔╝
#    ╚═╝     ╚══════╝╚═╝                      ╚═╝   ╚═╝  ╚═╝╚═════╝ 
# 
# https://github.com/Aloxaf/fzf-tab#zinit

zinit light Aloxaf/fzf-tab

# # disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# # set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# # set list-colors to enable filename colorizing
# # switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' fzf-command fzf

zstyle ':fzf-tab:complete:*' fzf-bindings \
	'ctrl-v:execute-silent({_FTB_INIT_}code "$realpath")' \
    'ctrl-e:execute-silent({_FTB_INIT_}kwrite "$realpath")'

# zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
# zstyle ':fzf-tab:*' accept-line enter

zstyle ':fzf-tab:*' single-group color header

zstyle ':fzf-tab:*' show-group full

FZF_TAB_GROUP_COLORS=(
    $'\033[94m' $'\033[32m' $'\033[33m' $'\033[35m' $'\033[31m' $'\033[38;5;27m' $'\033[36m' \
    $'\033[38;5;100m' $'\033[38;5;98m' $'\033[91m' $'\033[38;5;80m' $'\033[92m' \
    $'\033[38;5;214m' $'\033[38;5;165m' $'\033[38;5;124m' $'\033[38;5;120m'
)
zstyle ':fzf-tab:*' group-colors $FZF_TAB_GROUP_COLORS

zstyle ':fzf-tab:*' fzf-min-height 30

##############################################################################################################

##############################################################################################################
#
#    ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗███████╗
#    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
#    ███████╗██║     ██████╔╝██║██████╔╝   ██║   ███████╗
#    ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ╚════██║
#    ███████║╚██████╗██║  ██║██║██║        ██║   ███████║
#    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚══════╝
#
# https://github.com/Freed-Wu/fzf-tab-source

# zinit light Freed-Wu/fzf-tab-source

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

(($+commands[bat])) || bat() {command cat $@}
(($+commands[mdcat])) || mdcat() {command cat $@}
(($+commands[pygmentize])) || pygmentize() {command cat $@}
(($+commands[delta])) || delta() {command cat $@}
# https://github.com/Freed-Wu/fzf-tab-source/issues/6
(($+commands[less])) && [ -x ~/.lessfilter ] &&
  less() {~/.lessfilter $@ || command less $@} || (($+commands[less])) ||
    less() {command ls -l $@}
(($+commands[finger])) || (($+commands[pinky])) &&
  finger() {command pinky $@} || finger() {command whoami}
(($+commands[pandoc])) || pandoc() {command cat ${@[-1]}}
(($+commands[grc])) || grc() {eval ${@[2,-1]}}
(($+commands[jq])) || jq() {echo ';'}

local dir=${0:h} src line arr ctx flags
for src in $dir/fzf-tab/*.zsh $sources; do
  while read -r line; do
    arr=(${(@s. .)line##\# })
    ctx=${arr[1]}
    if [[ $ctx == ':fzf-tab:'* ]]; then
      break
    fi
  done < $src

  zstyle $ctx fzf-preview "src="\""$src"\"" . $src"

  flags=${arr[2]}
  if [[ -n $flags ]]; then
    zstyle $ctx fzf-flags $flags
  fi
done

##############################################################################################################

##############################################################################################################
#
#    ████████╗ ██████╗  ██████╗ ██╗     ███████╗
#    ╚══██╔══╝██╔═══██╗██╔═══██╗██║     ██╔════╝
#       ██║   ██║   ██║██║   ██║██║     ███████╗
#       ██║   ██║   ██║██║   ██║██║     ╚════██║
#       ██║   ╚██████╔╝╚██████╔╝███████╗███████║
#       ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚══════╝
#

zinit light-mode for \
  hlissner/zsh-autopair \
  zdharma-continuum/fast-syntax-highlighting \
  MichaelAquilina/zsh-you-should-use \
  zsh-users/zsh-autosuggestions 

zinit ice wait'3' lucid
zinit light zsh-users/zsh-history-substring-search

zinit ice wait'2' lucid
zinit light zdharma-continuum/history-search-multi-word

zinit ice wait lucid from"gh-r" as"program" mv"bin/exa* -> exa"
zinit light ogham/exa

zinit ice wait lucid from"gh-r" as"program" mv"*/bat -> bat" atload"export BAT_THEME='Nord'"
zinit light sharkdp/bat

zinit ice wait lucid from"gh-r" as"program" mv"*/fd -> fd"
zinit light sharkdp/fd

zinit ice wait lucid from"gh-r" as"program" mv"*/rg -> rg"
zinit light BurntSushi/ripgrep

# zi ice as'null' from"gh-r" sbin
# zi light ajeetdsouza/zoxide

# zi ice has'zoxide'
# zi light z-shell/zsh-zoxide

export _ZO_ECHO='1'
export _ZO_DATA_DIR=$HOME/.cache/zoxide
export _ZO_FZF_OPTS=$FZF_DEFAULT_OPTS
eval "$(zoxide init zsh)"

##############################################################################################################