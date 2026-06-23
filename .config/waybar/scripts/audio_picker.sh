#!/usr/bin/env bash
# Waybar audio right-click: choose default sink or source via rofi (PipeWire / wpctl).
# Setting the default node makes WirePlumber reroute existing streams automatically.

declare -A choice_map
lines=()
prev=""

# Parse `wpctl status` into:  type \t id \t default(0/1) \t description
while IFS=$'\t' read -r type id def desc; do
    [[ -z "$id" ]] && continue
    if [[ -n "$prev" && "$type" != "$prev" ]]; then
        lines+=("─────────────────────────────────────────")
    fi
    prev="$type"
    [[ "$def" == "1" ]] && mark=" ★ " || mark="   "
    [[ "$type" == "sink" ]] && label="${mark}[OUT] $desc" || label="${mark}[IN]  $desc"
    lines+=("$label")
    choice_map["$label"]="$type:$id"
done < <(wpctl status | awk '
    /Sinks:/   { mode = "sink";   next }
    /Sources:/ { mode = "source"; next }
    /Filters:|Streams:|Devices:|Clients:/ { mode = ""; next }
    /^[^[:space:]]/ { mode = "" }   # top-level section header (Audio/Video/Settings)
    mode != "" && match($0, /[0-9]+\. /) {
        def  = ($0 ~ /\*/) ? 1 : 0
        id   = substr($0, RSTART, RLENGTH); gsub(/[^0-9]/, "", id)
        name = substr($0, RSTART + RLENGTH)
        sub(/\[vol:.*$/, "", name)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", name)
        print mode "\t" id "\t" def "\t" name
    }
')

chosen=$(printf '%s\n' "${lines[@]}" | rofi -dmenu -p "󰎆 Audio" -no-custom \
    -theme-str 'window {width: 650px;} listview {lines: 14;}')
[[ -z "$chosen" ]] && exit 0

target="${choice_map[$chosen]}"
[[ -z "$target" ]] && exit 0  # separator line

type="${target%%:*}"
id="${target#*:}"
desc="${chosen#*] }"  # strip "[OUT] " / "[IN]  " prefix

case "$type" in
    sink)
        wpctl set-default "$id"
        wpctl set-mute "$id" 0
        notify-send -t 2000 "Audio output" "$desc"
        ;;
    source)
        wpctl set-default "$id"
        wpctl set-mute "$id" 0
        notify-send -t 2000 "Audio input" "$desc"
        ;;
esac
