# src files for rice

Sway and its companions come from the distro packages (see the main
[README](../README.md)). This directory only holds what distros don't ship:

| Item                   | What                                                               |
|------------------------|--------------------------------------------------------------------|
| `sway-session`         | session wrapper: `WLR_RENDERER=vulkan` (HDR), SSH agent, Java fix  |
| `sway.desktop`         | SDDM session entry that runs `sway-session`                        |
| `clipse`               | clipboard manager (built from source; on Arch use the AUR package) |
| `catppuccin-gtk`       | GTK theme                                                          |
| `xapp-symbolic-icons`  | `xsi-*` icons Nemo >= 6.6 needs for its toolbar/sidebar            |
| `sddm-astronaut-theme` | login screen theme                                                 |

## Initial Setup

Clone the sources:
```bash
bash setup.sh
```

## Build

```bash
# clipse is my clipboard manager
cd clipse
go mod tidy
make wayland
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
cd ..
```

## Debugging

Sway (nested, in a window, with the repo's configs)
```bash
XDG_CONFIG_HOME=$PWD/../.config WLR_BACKENDS=wayland sway
```

sddm
```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme-custom/
```

## System Install

```bash
# Session: same file name as the package's sway.desktop, so SDDM shows a single
# "Sway" entry and the /usr/local one (our wrapper) wins
sudo install -Dm755 sway-session /usr/local/bin/sway-session
sudo install -Dm644 sway.desktop /usr/local/share/wayland-sessions/sway.desktop

cd clipse
sudo install -m 755 clipse /usr/local/bin
cd ..

cd catppuccin-gtk
python3 install.py macchiato yellow
cd ..

# XApp symbolic icons — per-user install, no root needed
cd xapp-symbolic-icons
meson setup build --prefix="$HOME/.local" && ninja -C build install
gtk-update-icon-cache -f -t ~/.local/share/icons/hicolor
cd ..

# Theme
cd sddm-astronaut-theme
sudo cp -r sddm-astronaut-theme-custom/Fonts/* /usr/share/fonts/
echo "[Theme]
Current=sddm-astronaut-theme-custom" | sudo tee /etc/sddm.conf
sudo mkdir -p /etc/sddm.conf.d
echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf
sudo cp -r sddm-astronaut-theme-custom /usr/share/sddm/themes/
cd ..
```
