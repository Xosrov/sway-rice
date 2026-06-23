#!/bin/bash
# Clamshell-aware lid close handler.
# With 1+ active external monitor: disable the laptop screen (clamshell) and
# rebalance the workspaces onto the remaining outputs.
# With no external monitor: lock the session.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

EXT_COUNT=$(
    swaymsg -t get_outputs |
    jq '[.[] | select(.active == true and (.name | test("^eDP") | not))] | length'
)

if [ "$EXT_COUNT" -ge 1 ]; then
    swaymsg "output eDP-1 disable"
    bash "$SCRIPT_DIR/output-manager.sh"
else
    swaylock -f
fi
