#!/bin/bash

set -e

# Dedicated arch installation and configuration script in wsl2.
# Author: chuan
# Version: 1.0
# Date: October 10, 2023
# Description: Config arch linx.

##############################################################################################################################

path="$(realpath "$0")"
name="$(basename "$path")"
dir="$(dirname "$path")"
parent="$(dirname "$dir")"
pparent="$(dirname "$parent")"

source $pparent/common.sh

##############################################################################################################################

