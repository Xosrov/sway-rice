#!/bin/bash

SWAY_VERSION=v1.12
SWAYBG_VERSION=v1.2.2
SWAYLOCK_VERSION=v1.8.5
WAYBAR_VERSION=v0.15.0
MAKO_VERSION=v1.11.0
WLROOTS_VERSION=0.20
FUZZEL_VERSION=1.14.1
CATPPUCCIN_GTK_VERSION=v1.0.3

# clone main projects
git clone --branch $SWAY_VERSION https://github.com/swaywm/sway.git sway
git clone --branch $SWAYBG_VERSION https://github.com/swaywm/swaybg.git swaybg
git clone --branch $SWAYLOCK_VERSION https://github.com/swaywm/swaylock.git swaylock
git clone --branch $WAYBAR_VERSION https://github.com/Alexays/Waybar.git waybar
git clone --branch $MAKO_VERSION https://github.com/emersion/mako.git mako
git clone --branch $WLROOTS_VERSION https://gitlab.freedesktop.org/wlroots/wlroots.git wlroots
git clone --branch $FUZZEL_VERSION https://codeberg.org/dnkl/fuzzel.git fuzzel
git clone --branch $CATPPUCCIN_GTK_VERSION https://github.com/catppuccin/gtk.git catppuccin-gtk

LIBEVDEV_VERSION=libevdev-1.13.6
JSONC_VERSION=master

cd sway
git apply < ../patches/sway-v1.12.patch
git clone --branch $LIBEVDEV_VERSION https://gitlab.freedesktop.org/libevdev/libevdev.git subprojects/libevdev
git clone --branch $JSONC_VERSION https://github.com/json-c/json-c.git subprojects/json-c
ln -r -s ../wlroots/ subprojects/wlroots
cd ../

cd wlroots
git apply ../patches/wlroots-0.20.patch
cd ../
