#!/bin/bash
# Keep waybar running for the whole session.
#
# Waybar is launched here instead of through `bar { swaybar_command waybar }`:
# sway hands its bar a private one-shot Wayland socket and never respawns it,
# so when waybar crashed (it does on monitor hotplug — libwayland list_remove
# assertion) the bar stayed gone until the next reload. Standalone, it can be
# restarted. `swaymsg reload` sends SIGUSR2 (see config) so waybar re-reads its
# own config in place.
exec 7>"${XDG_RUNTIME_DIR:-/tmp}/sway-waybar.lock"
flock -n 7 || exit 0

# Stop once sway is gone, otherwise respawn (rate-limited).
while swaymsg -t get_version >/dev/null 2>&1; do
	waybar 7>&-
	sleep 1
done
