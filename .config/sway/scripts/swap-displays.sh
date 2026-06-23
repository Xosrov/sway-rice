#!/bin/bash
# Physically rearrange the monitors in the coordinate space, like dragging the
# boxes in wdisplays. The focused monitor trades places with its neighbour:
#   right : move the focused monitor one slot to the right
#   left  : move the focused monitor one slot to the left
# with wrap-around at the ends (e.g. right-swapping the right-most monitor moves
# it to the left-most slot). The whole row is re-laid out left->right with no
# gaps, then the workspace groups are re-applied to follow the new order.
#
# Usage: swap-displays.sh left|right
set -u

DIR="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$DIR" in
	left | right) ;;
	*) echo "usage: swap-displays.sh left|right" >&2; exit 1 ;;
esac

outputs_json=$(swaymsg -t get_outputs)

# Active outputs sorted left->right by physical X: "<name> <width>" per line.
mapfile -t rows < <(
	jq -r '
		[.[] | select(.active == true)]
		| sort_by(.rect.x)
		| .[] | "\(.name) \(.rect.width)"
	' <<<"$outputs_json"
)
n=${#rows[@]}
[ "$n" -lt 2 ] && exit 0

names=(); widths=()
for r in "${rows[@]}"; do
	read -r nm w <<<"$r"
	names+=("$nm"); widths+=("$w")
done

focused=$(jq -r '.[] | select(.focused == true) | .name' <<<"$outputs_json")
[ -z "$focused" ] && exit 0

# Index of the focused output in the left->right order.
i=-1
for idx in "${!names[@]}"; do
	[ "${names[idx]}" = "$focused" ] && i=$idx && break
done
[ "$i" -lt 0 ] && exit 0

# Neighbour index, wrapping around the ends.
if [ "$DIR" = right ]; then
	j=$(((i + 1) % n))
else
	j=$(((i - 1 + n) % n))
fi

# Swap the two outputs in the ordering.
tmp="${names[i]}";  names[i]="${names[j]}";   names[j]="$tmp"
tmp="${widths[i]}"; widths[i]="${widths[j]}"; widths[j]="$tmp"

# Re-lay the whole row left->right starting at x=0, top-aligned.
x=0
for idx in "${!names[@]}"; do
	swaymsg "output ${names[idx]} pos $x 0" >/dev/null
	x=$((x + widths[idx]))
done

# Re-apply workspace groups to follow the new physical order, keep focus.
bash "$SCRIPT_DIR/output-manager.sh"
swaymsg "focus output $focused" >/dev/null 2>&1
