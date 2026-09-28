#!/bin/bash
# Fetch the parts of the rice that openSUSE doesn't package. Everything else
# (sway, waybar, swaylock, ...) comes from zypper — see packages.txt.

CLIPSE_VERSION=v1.2.1
CATPPUCCIN_GTK_VERSION=v1.0.3
SDDM_ASTRO_THEME_REVISION=8c85b9c
XSI_ICONS_REVISION=2c91ca1

git clone --branch $CLIPSE_VERSION https://github.com/savedra1/clipse.git clipse
git clone --branch $CATPPUCCIN_GTK_VERSION https://github.com/catppuccin/gtk.git catppuccin-gtk
git clone https://github.com/xapp-project/xapp-symbolic-icons.git xapp-symbolic-icons && cd xapp-symbolic-icons && git checkout $XSI_ICONS_REVISION && cd ..
git clone https://github.com/Keyitdev/sddm-astronaut-theme.git sddm-astronaut-theme && cd sddm-astronaut-theme && git checkout $SDDM_ASTRO_THEME_REVISION && cd ../
