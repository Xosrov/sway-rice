#!/bin/bash
# Reconcile clamshell state, then re-apply the workspace layout.
#
# Wired via `exec_always`, so it runs on startup AND on every `swaymsg reload`.
# A reload re-applies the config's `output` directives and re-enables any output
# that was disabled at runtime — so a clamshell `output eDP-1 disable` (set by
# lid-close.sh) would otherwise come back on. Here we read the real lid switch
# and re-disable the laptop panel when the lid is closed and an external is
# present, mirroring lid-close.sh's rule.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

lid_closed() {
    grep -qi closed /proc/acpi/button/lid/*/state 2>/dev/null
}

EXT_COUNT=$(
    swaymsg -t get_outputs |
    jq '[.[] | select(.active == true and (.name | test("^eDP") | not))] | length'
)

# Keep the laptop panel off across reloads while clamshelled with an external.
# (With no external we never disable the only display — lid-close.sh locks instead.)
if lid_closed && [ "${EXT_COUNT:-0}" -ge 1 ]; then
    swaymsg "output eDP-1 disable"
fi

bash "$SCRIPT_DIR/output-manager.sh"
