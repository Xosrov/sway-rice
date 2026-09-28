#!/bin/bash
# Reconcile clamshell state, then re-apply the workspace layout.
#
# Wired via `exec_always`, so it runs on startup AND on every `swaymsg reload`.
# A reload re-applies the config's `output` directives and re-enables any output
# that was disabled at runtime — so a clamshell `output eDP-1 disable` (set by
# lid-close.sh) would otherwise come back on. output-manager.sh reads the real
# lid switch and re-disables the laptop panel when the lid is closed and an
# external is present (the same rule it applies on every output hotplug).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/output-manager.sh"
