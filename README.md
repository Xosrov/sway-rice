# Sway Rice

Combination of full Sway desktop with rice and dots.

Everything runs on the distro's packages; `src/` only holds the few pieces no
distro ships (clipboard manager, themes, icons, session wrapper) — see
[src/README.md](src/README.md).

# Prerequisites

## Packages

What each package is for (names verified against openSUSE Tumbleweed,
Ubuntu 26.04 and Arch):

| Purpose                           | openSUSE Tumbleweed                                                                                         | Ubuntu 26.04                                                                                                                                    | Arch                                              |
|-----------------------------------|-------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------|
| Compositor                        | `sway` `sway-branding-upstream` `swaynag`                                                                   | `sway`                                                                                                                                          | `sway`                                            |
| Wallpaper, lock, idle             | `swaybg` `swaylock` `swayidle`                                                                              | `swaybg` `swaylock` `swayidle`                                                                                                                  | `swaybg` `swaylock` `swayidle`                    |
| X11 apps                          | `xwayland`                                                                                                  | `xwayland`                                                                                                                                      | `xorg-xwayland`                                   |
| Portals (file pickers, sharing)   | `xdg-desktop-portal-wlr` `xdg-desktop-portal-gtk`                                                           | `xdg-desktop-portal-wlr` `xdg-desktop-portal-gtk`                                                                                               | `xdg-desktop-portal-wlr` `xdg-desktop-portal-gtk` |
| Keyring + SSH agent               | `gnome-keyring` `gcr-ssh-agent`                                                                             | `gnome-keyring` `gcr4`                                                                                                                          | `gnome-keyring` `gcr-4`                           |
| Polkit agent (GUI auth prompts)   | `lxqt-policykit`                                                                                            | `lxqt-policykit`                                                                                                                                | `lxqt-policykit`                                  |
| Audio                             | `pipewire` `pipewire-pulseaudio` `wireplumber`                                                              | `pipewire` `pipewire-pulse` `wireplumber`                                                                                                       | `pipewire` `pipewire-pulse` `wireplumber`         |
| Bar, launcher                     | `waybar` `fuzzel`                                                                                           | `waybar` `fuzzel`                                                                                                                               | `waybar` `fuzzel`                                 |
| Notifications                     | `mako` `libnotify-tools`                                                                                    | `mako-notifier` `libnotify-bin`                                                                                                                 | `mako` `libnotify`                                |
| Terminal, shell                   | `kitty` `fish`                                                                                              | `kitty` `fish`                                                                                                                                  | `kitty` `fish`                                    |
| Screenshots                       | `grim` `slurp` `wl-clipboard`                                                                               | `grim` `slurp` `wl-clipboard`                                                                                                                   | `grim` `slurp` `wl-clipboard`                     |
| Brightness / media keys           | `brightnessctl` `playerctl`                                                                                 | `brightnessctl` `playerctl`                                                                                                                     | `brightnessctl` `playerctl`                       |
| Script + waybar helpers           | `jq` `sensors` `htop` `ncdu` `bluez` `NetworkManager-tui`                                                   | `jq` `lm-sensors` `htop` `ncdu` `bluez` `network-manager`                                                                                       | `jq` `lm_sensors` `htop` `ncdu` `bluez` `bluez-utils` `networkmanager` |
| File manager                      | `nemo`                                                                                                      | `nemo`                                                                                                                                          | `nemo`                                            |
| GTK theme engine + icon cache     | `gtk2-engine-murrine` `gtk2-metatheme-adwaita` `gtk3-tools`                                                 | `gtk2-engines-murrine` `gnome-themes-extra` `libgtk-3-bin`                                                                                      | `gnome-themes-extra` `gtk-update-icon-cache` + AUR `gtk-engine-murrine` |
| Login screen (SDDM theme)         | `sddm-qt6` `libQt6Svg6` `qt6-virtualkeyboard` `qt6-virtualkeyboard-imports` `qt6-multimedia` `qt6-multimedia-imports` | `sddm` `libqt6svg6` `qt6-virtualkeyboard-plugin` `libqt6multimedia6` `qml6-module-qtmultimedia` `qml6-module-qtquick-controls` `qml6-module-qtquick-effects` `libxcb-cursor0` | `sddm` `qt6-svg` `qt6-virtualkeyboard` `qt6-multimedia-ffmpeg` |
| Building `src/` extras            | `git` `go` `meson` `ninja` `python3` `wget`                                                                 | `git` `golang-go` `meson` `ninja-build` `python3` `wget`                                                                                        | `git` `go` `meson` `ninja` `python` `wget`        |

### openSUSE Tumbleweed

```bash
sudo zypper install \
    sway sway-branding-upstream swaynag swaybg swaylock swayidle xwayland \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
    gnome-keyring gcr-ssh-agent lxqt-policykit \
    pipewire pipewire-pulseaudio wireplumber \
    waybar fuzzel mako libnotify-tools kitty fish \
    grim slurp wl-clipboard brightnessctl playerctl \
    jq sensors htop ncdu bluez NetworkManager-tui nemo \
    gtk2-engine-murrine gtk2-metatheme-adwaita gtk3-tools \
    sddm-qt6 libQt6Svg6 qt6-virtualkeyboard qt6-virtualkeyboard-imports \
    qt6-multimedia qt6-multimedia-imports \
    git go meson ninja python3 wget
```

`sway-branding-upstream` is picked over openSUSE's default branding, which adds
its own snippets to `/etc/sway/config.d` (included by our config).

### Ubuntu 26.04

```bash
sudo apt install \
    sway swaybg swaylock swayidle xwayland \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
    gnome-keyring gcr4 lxqt-policykit \
    pipewire pipewire-pulse wireplumber \
    waybar fuzzel mako-notifier libnotify-bin kitty fish \
    grim slurp wl-clipboard brightnessctl playerctl \
    jq lm-sensors htop ncdu bluez network-manager nemo \
    gtk2-engines-murrine gnome-themes-extra libgtk-3-bin \
    sddm libqt6svg6 qt6-virtualkeyboard-plugin libqt6multimedia6 \
    qml6-module-qtmultimedia qml6-module-qtquick-controls \
    qml6-module-qtquick-effects libxcb-cursor0 \
    git golang-go meson ninja-build python3 wget
```

Ubuntu 26.04 ships sway 1.11, which has no `output ... hdr` command: the HDR
toggle (`$mod+Alt+h`) does nothing there. Everything else works the same.

### Arch Linux

```bash
sudo pacman -S \
    sway swaybg swaylock swayidle xorg-xwayland \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
    gnome-keyring gcr-4 lxqt-policykit \
    pipewire pipewire-pulse wireplumber \
    waybar fuzzel mako libnotify kitty fish \
    grim slurp wl-clipboard brightnessctl playerctl \
    jq lm_sensors htop ncdu bluez bluez-utils networkmanager nemo \
    gnome-themes-extra gtk-update-icon-cache \
    sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg \
    git go meson ninja python wget

# not in the official repos
yay -S gtk-engine-murrine clipse
```

Then follow [src/README.md](src/README.md) (on Arch, skip building clipse).

## Generic

Install JetBrains Mono Nerd fonts from https://www.nerdfonts.com/font-downloads
- Move .ttfs to ~/.fonts/
- Run fc-cache -fv

same for https://fonts.google.com/noto/specimen/Noto+Sans

Change fonts using the `pango-list` tool if you cant find your font

# Setup

```bash
# dotfiles
cp -r .config/. ~/.config/

# fish as login shell, ~/.local/bin on PATH
chsh -s "$(command -v fish)"
fish -c 'fish_add_path ~/.local/bin'

# waybar's keyboard-state module (caps/num lock) reads /dev/input
sudo usermod -aG input "$USER"

# SSH agent (src/sway-session exports SSH_AUTH_SOCK when this socket exists)
systemctl --user enable --now gcr-ssh-agent.socket

# login manager
#   openSUSE: sudo update-alternatives --set default-displaymanager /usr/lib/X11/displaymanagers/sddm
#   Ubuntu:   sudo dpkg-reconfigure sddm
#   Arch:     sudo systemctl enable sddm
```

Log out and back in (the `input` group only applies to new sessions).

## Organizational
```bash
sudo zypper in opi tailscale
sudo systemctl enable tailscaled
opi install vscode teams
```

Configure /etc/hostname
