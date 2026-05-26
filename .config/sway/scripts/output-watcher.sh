#!/bin/bash
# Subscribe to sway output events and re-apply layout on every change.
# Restarts automatically if the IPC connection drops (e.g. sway reload).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

while true; do
    swaymsg -t subscribe '["output"]' | while IFS= read -r _; do
        sleep 0.5  # let the output finish initializing
        bash "$SCRIPT_DIR/output-manager.sh"
    done
    sleep 1
done
