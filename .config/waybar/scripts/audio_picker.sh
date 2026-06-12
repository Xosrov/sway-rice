#!/usr/bin/env bash
# Waybar pulseaudio right-click: choose default sink or source via rofi.

DEFAULT_SINK=$(pactl get-default-sink)
DEFAULT_SOURCE=$(pactl get-default-source)

declare -A choice_map
lines=()

# ── Sinks ──────────────────────────────────────────────────────────────
while IFS=$'\t' read -r name desc; do
    [[ -z "$name" ]] && continue
    [[ "$name" == "$DEFAULT_SINK" ]] && mark=" ★ " || mark="   "
    label="${mark}[OUT] $desc"
    lines+=("$label")
    choice_map["$label"]="sink:$name"
done < <(pactl list sinks | awk '
    /^\s*Name:/        { name = $NF }
    /^\s*Description:/ { sub(/^\s*Description: */, ""); print name "\t" $0 }
')

lines+=("─────────────────────────────────────────")

# ── Sources (skip monitor loopbacks) ───────────────────────────────────
while IFS=$'\t' read -r name desc; do
    [[ -z "$name" ]] && continue
    [[ "$name" == *.monitor ]] && continue
    [[ "$name" == "$DEFAULT_SOURCE" ]] && mark=" ★ " || mark="   "
    label="${mark}[IN]  $desc"
    lines+=("$label")
    choice_map["$label"]="source:$name"
done < <(pactl list sources | awk '
    /^\s*Name:/        { name = $NF }
    /^\s*Description:/ { sub(/^\s*Description: */, ""); print name "\t" $0 }
')

chosen=$(printf '%s\n' "${lines[@]}" | rofi -dmenu -p "󰎆 Audio" -no-custom \
    -theme-str 'window {width: 650px;} listview {lines: 14;}')
[[ -z "$chosen" ]] && exit 0

target="${choice_map[$chosen]}"
[[ -z "$target" ]] && exit 0  # separator line

type="${target%%:*}"
name="${target#*:}"
desc="${chosen#*] }"  # strip "[OUT] " / "[IN]  " prefix

case "$type" in
    sink)
        pactl set-default-sink "$name"
        # Move all active playback streams to the new sink
        pactl list short sink-inputs | awk '{print $1}' | while read -r idx; do
            pactl move-sink-input "$idx" "$name"
        done
        # Unmute selected sink, mute all others
        pactl list short sinks | awk '{print $2}' | while read -r sink; do
            if [[ "$sink" == "$name" ]]; then
                pactl set-sink-mute "$sink" 0
            else
                pactl set-sink-mute "$sink" 1
            fi
        done
        notify-send -t 2000 "Audio output" "$desc"
        ;;
    source)
        pactl set-default-source "$name"
        # Move all active capture streams to the new source
        pactl list short source-outputs | awk '{print $1}' | while read -r idx; do
            pactl move-source-output "$idx" "$name"
        done
        # Unmute selected source, mute all others (skip monitor loopbacks)
        pactl list short sources | awk '{print $2}' | while read -r src; do
            [[ "$src" == *.monitor ]] && continue
            if [[ "$src" == "$name" ]]; then
                pactl set-source-mute "$src" 0
            else
                pactl set-source-mute "$src" 1
            fi
        done
        notify-send -t 2000 "Audio input" "$desc"
        ;;
esac
