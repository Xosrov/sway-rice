#!/bin/bash
# Apply workspace→output assignments based on how many external monitors are active.
#
#   0 external : all workspaces on laptop (eDP-1)
#   1 external : 1-4 on laptop, 5-9 on external
#   2 external: 1-4 on ext1, 5-9 on ext2, laptop screen OFF

INTERNAL="eDP-1"

# Sorted list of active non-internal outputs for stable ext1/ext2 ordering
mapfile -t EXTERNALS < <(
    swaymsg -t get_outputs |
    jq -r '.[] | select(.active == true and (.name | test("^eDP") | not)) | .name' |
)
EXT_COUNT=${#EXTERNALS[@]}

case $EXT_COUNT in
    2)
        for i in 1 2 3 4; do swaymsg "workspace $i output ${EXTERNALS[0]}"; done
        for i in 5 6 7 8 9; do swaymsg "workspace $i output ${EXTERNALS[1]}"; done
        swaymsg "output $INTERNAL disable"
        ;;
    1)
        for i in 1 2 3 4; do swaymsg "workspace $i output $INTERNAL"; done
        for i in 5 6 7 8 9; do swaymsg "workspace $i output ${EXTERNALS[0]}"; done
        swaymsg "output $INTERNAL enable"
        ;;
    *)
        for i in $(seq 1 9); do swaymsg "workspace $i output $INTERNAL"; done
        swaymsg "output $INTERNAL enable"
        ;;
esac
