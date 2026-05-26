#!/bin/bash
# Clamshell-aware lid close handler.
# With 2+ active external monitors: disable laptop screen and stay running.
# Otherwise: lock normally.

EXT_COUNT=$(
    swaymsg -t get_outputs |
    jq '[.[] | select(.active == true and (.name | test("^eDP") | not))] | length'
)

if [ "$EXT_COUNT" -ge 2 ]; then
    swaymsg "output eDP-1 disable"
else
    swaylock -f
fi
