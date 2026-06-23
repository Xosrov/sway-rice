# src files for rice

## Initial Setup

Run the setup script to pull dependencies and set up for building
```bash
bash setup.sh
```

## Build Sway (manual install)

wlroots is a prerequisite, so you need it first
```bash
cd wlroots
meson setup build --buildtype=release  --reconfigure \
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
meson setup build --buildtype=release
ninja -C build
cd ..

# waybar is optional but I'll use it
cd waybar
meson setup build --buildtype=release  --reconfigure -Dtests="disabled"
ninja -C build
cd ..

# fuzzel menu is my choice
cd fuzzel
meson setup build --buildtype=release
ninja -C build
cd ..

# lockscreen — --sysconfdir=/etc so the PAM file lands in /etc/pam.d/ on install
cd swaylock
meson setup build --buildtype=release  --reconfigure --sysconfdir=/etc
ninja -C build
cd ..

# idle
cd swayidle
meson setup build --buildtype=release
ninja -C build
cd ..

# mako is my notification daemon
cd mako
meson setup build --buildtype=release
ninja -C build
cd ..

# clipse is my clipboard manager
cd clipse
go mod tidy
make wayland
cd ..

# Finally build Sway
cd sway
meson setup build --buildtype=release  --reconfigure --force-fallback-for=libevdev,jsonc
ninja -C build
cd ..

# display manager theme
cd sddm-astronaut-theme
# only grab what I want
mkdir -p sddm-astronaut-theme-custom
cp -r Assets/ Components/ Main.qml LICENSE sddm-astronaut-theme-custom/
# download our background
wget -O sddm-astronaut-theme-custom/background.mp4 https://motionbgs.com/dl/hd/4394
# create custom conf with bg
sed 's|Background="Backgrounds/pixel_sakura.gif"|Background="background.mp4"|' Themes/pixel_sakura.conf > sddm-astronaut-theme-custom/pixel_sakura_custom.conf
# use custom conf in metadata
sed "s|^ConfigFile=.*|ConfigFile=pixel_sakura_custom.conf|" metadata.desktop > sddm-astronaut-theme-custom/metadata.desktop
# copy font it needs
mkdir -p sddm-astronaut-theme-custom/Fonts
cp Fonts/ARCADECLASSIC.TTF sddm-astronaut-theme-custom/Fonts/
```

## Debugging

Sway
```bash
GDK_BACKEND=wayland \
XDG_CONFIG_HOME=$PWD/../.config \
WAYLAND_DISPLAY=wayland-1 \
LD_LIBRARY_PATH=$PWD/wlroots/build:$LD_LIBRARY_PATH \
PATH=$PWD/sway/build/sway:$PWD/sway/build/swaybar:$PWD/sway/build/swaymsg:$PWD/sway/build/swaynag:$PWD/swaybg/build:$PWD/waybar/build:$PWD/fuzzel/build:$PWD/swaylock/build:$PWD/mako/build:$PATH \
sway
```

sddm
```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme-custom/
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
cd swayidle
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
cd clipse
sudo install -m 755 clipse /usr/local/bin
cd ..
cd catppuccin-gtk
python3 install.py macchiato yellow
cd ..

# Theme
cd sddm-astronaut-theme
sudo cp -r sddm-astronaut-theme-custom/Fonts/* /usr/share/fonts/
echo "[Theme]
Current=sddm-astronaut-theme-custom" | sudo tee /etc/sddm.conf
echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf
sudo cp -r sddm-astronaut-theme-custom /usr/share/sddm/themes/
cd ..
# create sway.desktop file at /usr/share/wayland-sessions/
echo "[Desktop Entry]
Name=Sway
Comment=An i3-compatible Wayland compositor
Exec=env WLR_RENDERER=vulkan sway
Type=Application" | sudo tee /usr/share/wayland-sessions/sway.desktop
```
