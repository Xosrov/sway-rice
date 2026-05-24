# Sway Rice

Combination of full Sway desktop with rice and dots.

# Prerequisites

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

- Install copyq from https://github.com/hluk/CopyQ/releases
- Add ~/.local/bin to path: `fish_add_path /home/amiryazdi/.local/bin/`

## Organizational
```bash
sudo zypper in opi tailscale
sudo systemctl enable tailscaled
opi install vscode teams
```

Configure /etc/hostname