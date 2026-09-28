#!/bin/bash
# Screenshot to the Pictures dir and the clipboard, with a notification.
# Usage: screenshot.sh [full|region]
#   full   : all outputs (default)
#   region : select with slurp; Esc cancels without saving anything
set -u

dir="$(xdg-user-dir PICTURES 2>/dev/null)"
[ -n "$dir" ] && [ "$dir" != "$HOME" ] || dir="$HOME/Pictures"
mkdir -p "$dir"
file="$dir/screenshot-$(date +%Y%m%d-%H%M%S).png"

case "${1:-full}" in
	region)
		geom=$(slurp) || exit 0
		grim -g "$geom" "$file" || exit 1
		;;
	*)
		grim "$file" || exit 1
		;;
esac

wl-copy --type image/png <"$file"
notify-send -t 3000 -i "$file" "Screenshot saved" "$file"
