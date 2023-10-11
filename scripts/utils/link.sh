#!/bin/bash

set -e

DOTFIRE_DIR=/home/chuan/dotfiles
CONFIG_DIR=/home/chuan/.config
HOME=/home/chuan

mkdir -p $CONFIG_DIR

# link folders
ln -sf $DOTFIRE_DIR/alacritty $CONFIG_DIR
ln -sf $DOTFIRE_DIR/hypr $CONFIG_DIR
ln -sf $DOTFIRE_DIR/lazygit $CONFIG_DIR
ln -sf $DOTFIRE_DIR/waybar $CONFIG_DIR
ln -sf $DOTFIRE_DIR/nvim $CONFIG_DIR
ln -sf $DOTFIRE_DIR/yazi $CONFIG_DIR

# link files
ln -sf $DOTFIRE_DIR/zsh/init.zsh $HOME/.zshrc
