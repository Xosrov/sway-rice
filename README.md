# Sway Rice

Combination of full Sway desktop with rice and dots.

# Prerequisites

## Ubuntu (26.04) / Debian

```bash
sudo apt install \
    meson ninja-build pkg-config build-essential git scdoc golang-go \
    libwayland-dev wayland-protocols libxkbcommon-dev libxkbregistry-dev \
    libcairo2-dev libpango1.0-dev libpixman-1-dev libdrm-dev libglib2.0-dev \
    libgdk-pixbuf-2.0-dev libgtkmm-3.0-dev libgtk-layer-shell-dev libsigc++-2.0-dev libepoxy-dev \
    libxcb1-dev libxcb-composite0-dev libxcb-dri3-dev libxcb-ewmh-dev libxcb-icccm4-dev \
    libxcb-present-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-res0-dev \
    libxcb-shm0-dev libxcb-xfixes0-dev libxcb-xinput-dev libxcb-errors-dev xwayland \
    hwdata libdisplay-info-dev libliftoff-dev libinput-dev libudev-dev libseat-dev \
    libegl1-mesa-dev libgles2-mesa-dev libgbm-dev libvulkan-dev \
    glslang-tools glslang-dev liblcms2-dev \
    libpcre2-dev libpam0g-dev \
    libpulse-dev libwireplumber-0.5-dev libjack-jackd2-dev libsndio-dev \
    libpipewire-0.3-dev playerctl libmpdclient-dev libgps-dev \
    pipewire pipewire-pulse wireplumber pavucontrol \
    libdbusmenu-gtk3-dev libupower-glib-dev libsystemd-dev libnl-3-dev \
    libnl-genl-3-dev libevdev-dev libfftw3-dev liburfkill-glib-dev \
    libfontconfig1-dev libpng-dev \
    sddm qt6-base-dev qt6-declarative-dev qt6-svg-dev qt6-virtualkeyboard-dev qt6-multimedia-dev \
    python3 gtk2-engines-murrine gnome-themes-extra cava
```

## openSUSE Tumbleweed

```bash
sudo zypper install \
    meson ninja pkgconf-pkg-config gcc gcc-c++ git scdoc go \
    wayland-devel wayland-protocols-devel libxkbcommon-devel libxkbcommon-x11-devel \
    cairo-devel pango-devel libpixman-1-0-devel libdrm-devel glib2-devel \
    gdk-pixbuf-devel gtkmm3-devel gtk-layer-shell-devel libsigc++2-devel libepoxy-devel \
    libxcb-devel xcb-util-devel xcb-util-wm-devel xcb-util-image-devel \
    xcb-util-keysyms-devel xcb-util-renderutil-devel xcb-util-cursor-devel \
    xcb-util-errors-devel xwayland \
    hwdata libdisplay-info-devel libliftoff-devel libinput-devel libudev-devel \
    seatd-devel Mesa-libEGL-devel Mesa-libGLESv2-devel libgbm-devel \
    vulkan-devel vulkan-headers glslang-devel lcms2-devel \
    pcre2-devel pam-devel \
    libpulse-devel wireplumber-devel libjack-devel sndio-devel \
    pipewire-devel playerctl libmpdclient-devel gpsd-devel \
    pipewire pipewire-pulseaudio wireplumber pavucontrol \
    libdbusmenu-gtk3-devel libupower-glib-devel systemd-devel \
    libnl3-devel libevdev-devel fftw3-devel liburfkill-glib-devel \
    fontconfig-devel libpng16-devel \
    sddm-qt6 qt6-base-devel qt6-declarative-devel qt6-svg-devel \
    qt6-virtualkeyboard-devel qt6-virtualkeyboard-imports \
    qt6-multimedia-devel qt6-multimedia-imports \
    python3 gtk2-engine-murrine gnome-themes-extra cava
```

## Arch Linux

```bash
sudo pacman -S \
    meson ninja base-devel git scdoc go \
    wayland wayland-protocols libxkbcommon \
    cairo pango pixman libdrm glib2 gdk-pixbuf2 gtkmm3 gtk-layer-shell \
    libsigc++ libepoxy \
    libxcb xcb-util xcb-util-wm xcb-util-image xcb-util-keysyms \
    xcb-util-renderutil xcb-util-cursor xcb-util-errors xorg-xwayland \
    hwdata libdisplay-info libliftoff libinput systemd-libs seatd \
    mesa vulkan-icd-loader vulkan-headers glslang lcms2 \
    pcre2 pam \
    libpulse wireplumber jack2 sndio libpipewire playerctl libmpdclient gpsd \
    pipewire pipewire-pulse pavucontrol \
    libdbusmenu-gtk3 upower libnl libevdev fftw \
    fontconfig libpng \
    sddm qt6-base qt6-declarative qt6-svg qt6-virtualkeyboard \
    qt6-multimedia qt6-multimedia-ffmpeg \
    python gnome-themes-extra cava

# gtk-engine-murrine and urfkill are in the AUR
yay -S gtk-engine-murrine urfkill-git
```

Follow instructions in src/README.md.

## Generic

Install JetBrains Mono Nerd fonts from https://www.nerdfonts.com/font-downloads
- Move .ttfs to ~/.fonts/
- Run fc-cache -fv

same for https://fonts.google.com/noto/specimen/Noto+Sans

Change fonts using the `pango-list` tool if you cant find your font

# Post-Setup

```bash
sudo chch -s $(which fish)
```

- Install clipse
- Add ~/.local/bin to path: `fish_add_path /home/amiryazdi/.local/bin/`

## Organizational
```bash
sudo zypper in opi tailscale
sudo systemctl enable tailscaled
opi install vscode teams
```

Configure /etc/hostname