#!/usr/bin/env bash
# Print waybar JSON for CPU temperature.
# Resolves the CPU thermal zone at runtime from /sys/class/thermal/thermal_zone*/type
# and uses parsed `sensors` output as the tooltip.

set -u

zone=""
# Prefer known CPU thermal-zone type names
for type_file in /sys/class/thermal/thermal_zone*/type; do
    [ -r "$type_file" ] || continue
    case "$(cat "$type_file")" in
        x86_pkg_temp|coretemp|k10temp|zenpower|cpu-thermal|cpu_thermal|CPU)
            zone="${type_file%/type}"
            break
            ;;
    esac
done

# Fall back to acpitz, then the first available zone
if [ -z "$zone" ]; then
    for type_file in /sys/class/thermal/thermal_zone*/type; do
        [ -r "$type_file" ] || continue
        if [ "$(cat "$type_file")" = "acpitz" ]; then
            zone="${type_file%/type}"
            break
        fi
    done
fi
if [ -z "$zone" ]; then
    for d in /sys/class/thermal/thermal_zone*; do
        [ -r "$d/temp" ] && { zone="$d"; break; }
    done
fi

if [ -z "$zone" ] || [ ! -r "$zone/temp" ]; then
    printf '{"text":"N/A","tooltip":"No thermal zone found","class":"unknown"}\n'
    exit 0
fi

temp=$(( $(cat "$zone/temp") / 1000 ))

if   [ "$temp" -lt 40 ]; then icon=""
elif [ "$temp" -lt 55 ]; then icon=""
elif [ "$temp" -lt 70 ]; then icon=""
elif [ "$temp" -lt 80 ]; then icon=""
else                          icon=""
fi

class="normal"
if   [ "$temp" -ge 80 ]; then class="critical"
elif [ "$temp" -ge 70 ]; then class="warning"
fi

sensors_out=$(sensors 2>/dev/null)
[ -z "$sensors_out" ] && sensors_out="sensors command not available"

# Escape for JSON: backslashes, double quotes, then newlines -> \n
tooltip=$(printf '%s' "$sensors_out" \
    | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' \
    | awk 'BEGIN{ORS=""} NR>1{printf "\\n"} {print}')

printf '{"text":"%s %d°C","tooltip":"%s","class":"%s"}\n' \
    "$icon" "$temp" "$tooltip" "$class"
