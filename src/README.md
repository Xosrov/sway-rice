# src files for rice

## Initial Setup

Run the setup script to pull dependencies and set up for building
```bash
bash setup.sh
```

## Build Sway


wlroots is a prerequisite, so you need it first
```bash
cd wlroots
meson setup build \
	-Dc_args="-Wno-error" \
	-Dcpp_args="-Wno-error" \
	-Dwayland:tests=false \
	-Dwayland-protocols:tests=false \
	-Dlibdrm:tests=false \
	-Dv4l-utils:doxygen-doc=disabled \
	--wrap-mode=forcefallback
ninja -C build
cd ..

# swaybg is optional but I'll use it
cd swaybg
meson setup build
ninja -C build
cd ..

# waybar is optional but I'll use it
cd waybar
meson setup build -Dtests="disabled"
ninja -C build
cd ..

# fuzzel menu is my choice
cd fuzzel
meson setup build
ninja -C build
cd ..

# lockscreen
cd swaylock
meson setup build
ninja -C build
cd ..

# mako is my notification daemon
cd mako
meson setup build
ninja -C build
cd ..

# Finally build Sway
cd sway
meson setup build --force-fallback-for=libevdev,jsonc
ninja -C build
cd ..
```

## Debugging

```bash
GDK_BACKEND=wayland \
XDG_CONFIG_HOME=$PWD/../.config \
WAYLAND_DISPLAY=wayland-1 \
LD_LIBRARY_PATH=$PWD/wlroots/build:$LD_LIBRARY_PATH \
PATH=$PWD/sway/build/sway:$PWD/sway/build/swaybar:$PWD/sway/build/swaymsg:$PWD/sway/build/swaynag:$PWD/swaybg/build:$PWD/waybar/build:$PWD/fuzzel/build:$PWD/swaylock/build:$PWD/mako/build:$PATH \
sway
```

## System Install

```bash
cd wlroots
sudo ninja -C build install
cd ../
cd swaybg
sudo ninja -C build install
cd ../
cd waybar
sudo ninja -C build install
cd ../
cd swaylock
sudo ninja -C build install
cd ../
cd mako
sudo ninja -C build install
cd ../
cd fuzzel
sudo ninja -C build install
cd ../
cd sway
sudo ninja -C build install
cd ..
cd catppuccin-gtk
python3 install.py macchiato yellow
cd ..
```
