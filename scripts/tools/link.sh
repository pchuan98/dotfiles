#!/bin/bash

set -e

DOTFIRE_DIR=/home/chuan/dotfiles
CONFIG_DIR=/home/chuan/.config
HOME=/home/chuan

# link dotfiles
ln -sf $DOTFIRE_DIR/alacritty $CONFIG_DIR
ln -sf $DOTFIRE_DIR/hyper $CONFIG_DIR
mkdir -p $CONFIG_DIR/lazygit && ln -sf $DOTFIRE_DIR/lazygit/config.yml $CONFIG_DIR/lazygit/config.yml
ln -sf $DOTFIRE_DIR/waybar $CONFIG_DIR
ln -sf $DOTFIRE_DIR/nvim $CONFIG_DIR
ln -s $DOTFIRE_DIR/yazi $CONFIG_DIR

ln -sf $DOTFIRE_DIR/zsh/zshrc $HOME/.zshrc
