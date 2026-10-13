#!/bin/bash
# No arguments: show the usual app menu, wrapping the selected command.
# With arguments: launch that command in a private, nested Sway instance.
set -eu

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

if [ "$#" -eq 0 ]; then
    exec fuzzel --prompt='Nested > ' \
        --launch-prefix="\"$SCRIPT_DIR/nested-app.sh\"" --terminal='kitty -e'
fi

if [ -z "${WAYLAND_DISPLAY:-}" ]; then
    echo 'nested-app: launch this from an existing Wayland session.' >&2
    exit 1
fi

SESSION_DIR=$(mktemp -d "${XDG_RUNTIME_DIR:-/tmp}/sway-nested.XXXXXXXX")
trap 'rm -rf -- "$SESSION_DIR"' EXIT
export SWAY_NESTED_STARTUP="$SESSION_DIR/start.sh"

# Serialize argv as Bash words, preserving spaces, quotes and literal shell
# characters from desktop entries. The app is launched only after nested Sway
# has set its own WAYLAND_DISPLAY, DISPLAY and SWAYSOCK.
{
    cat <<'START'
#!/bin/bash
# Stop the nested compositor when its last app window closes. Watching windows
# rather than the launcher PID also supports apps that fork into the background.
(
    swaymsg -m -t subscribe '["window"]' | while IFS= read -r event; do
        if jq -e '.change == "close"' >/dev/null <<<"$event" &&
            swaymsg -t get_tree | jq -e '
                [.. | objects | select(.type? == "con" and
                    (.app_id? != null or .window? != null))] | length == 0
            ' >/dev/null; then
            swaymsg exit >/dev/null
            break
        fi
    done
) &
START
    printf '%q ' "$@"
    cat <<'START'

status=$?
if [ "$status" -ne 0 ]; then
    command -v notify-send >/dev/null &&
        notify-send 'Nested app failed' "Application exited with status $status."
    swaymsg exit >/dev/null
fi
START
} > "$SWAY_NESTED_STARTUP"

# Keep the parent's WAYLAND_DISPLAY for the backend connection. A private
# D-Bus session prevents D-Bus activation from launching apps on the desktop.
# Clear parent IPC/activation identifiers and let nested Sway supply DISPLAY.
# GLES2 avoids imposing the outer session's HDR/Vulkan renderer on nesting.
env -u SWAYSOCK -u I3SOCK -u DISPLAY -u XDG_ACTIVATION_TOKEN \
    -u DESKTOP_STARTUP_ID WLR_BACKENDS=wayland WLR_WL_OUTPUTS=1 \
    WLR_RENDERER=gles2 \
    dbus-run-session -- sway --config "$SCRIPT_DIR/../nested-config"
