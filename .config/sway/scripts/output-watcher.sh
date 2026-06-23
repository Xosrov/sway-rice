#!/bin/bash
# Re-apply the output layout in response to sway events.
#   - "output"    events (monitor hotplug, enable/disable): full re-apply.
#   - "workspace" events (init/focus): place that single workspace so a
#     workspace created/visited by the user follows to its target monitor.
# Each subscription auto-restarts if the IPC connection drops (e.g. reload).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}"

# Single-instance guard so we never stack duplicate watchers.
exec 8>"$STATE_DIR/sway-output-watcher.lock"
flock -n 8 || exit 0

# Full re-apply on monitor changes.
while true; do
    swaymsg -t subscribe '["output"]' | while IFS= read -r _; do
        sleep 0.5  # let the output finish initializing
        bash "$SCRIPT_DIR/output-manager.sh"
    done
    sleep 1
done &

# Place individual workspaces as they are created or focused.
while true; do
    swaymsg -t subscribe '["workspace"]' |
        jq -r --unbuffered 'select(.change == "init" or .change == "focus") | .current.name' |
        while IFS= read -r ws; do
            [ -n "$ws" ] && bash "$SCRIPT_DIR/output-manager.sh" place "$ws"
        done
    sleep 1
done
