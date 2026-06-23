#!/bin/bash
# Force the laptop panel back on, wake every output, and re-apply the layout.
# Used on lid-open and bound to a keyboard shortcut as a manual "fix displays".
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

swaymsg "output eDP-1 enable"
swaymsg "output * power on"
bash "$SCRIPT_DIR/output-manager.sh"
