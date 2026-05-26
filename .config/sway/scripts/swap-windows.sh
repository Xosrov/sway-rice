#!/bin/bash
# dwm-style zoom: swap focused window with the main (first tiling leaf) window.
# If focused is already main, swap with the second window instead.

TREE=$(swaymsg -t get_tree)

FOCUSED=$(echo "$TREE" | jq '.. | objects | select(.focused == true) | .id')

# All tiling leaf node IDs in the focused workspace, in tree order (left→right)
LEAVES=$(echo "$TREE" | jq -r '
  first(
    .. | objects |
    select(.type == "workspace") |
    select(any(.. | objects; .focused == true))
  ) |
  [.. | objects | select(.type == "con" and (.nodes | length) == 0) | .id] |
  .[]
')

FIRST=$(echo "$LEAVES" | head -1)
SECOND=$(echo "$LEAVES" | sed -n '2p')

if [ "$FOCUSED" = "$FIRST" ]; then
    [ -n "$SECOND" ] && swaymsg "swap container with con_id $SECOND"
else
    [ -n "$FIRST" ] && swaymsg "swap container with con_id $FIRST"
fi
