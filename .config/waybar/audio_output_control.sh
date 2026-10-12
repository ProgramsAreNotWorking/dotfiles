#!/usr/bin/env bash

set -u

human_output_name() {
    local name="$1"
    local lower
    lower="$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]')"

    case "$lower" in
        *hdmi*) printf 'HDMI' ;;
        *bluetooth*|*bluez*) printf 'Bluetooth' ;;
        *headphone*|*headset*|*earbud*|*auricular*) printf 'Auriculares' ;;
        *usb*) printf 'USB: %s' "$name" ;;
        *analog*|*built-in*|*built_in*|*speaker*|*altavoz*) printf 'Altavoces internos' ;;
        *) printf '%s' "$name" ;;
    esac
}

case "${1:-}" in
    volume)
        current="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null \
            | awk '{ printf "%d", ($2 * 100) + 0.5 }')"
        [ -n "$current" ] || exit 1
        values="$(seq 0 100 | awk -v current="$current" \
            '{ printf "%s%s\n", ($1 == current ? "● " : "  "), $1 "%%" }')"
        selected="$(printf '%s\n' "$values" | fuzzel --dmenu \
            --prompt="Volumen [$current%] > " --width=20 2>/dev/null \
            | sed -n 's/[^0-9]*\([0-9][0-9]*\)%.*/\1/p')"
        [ -n "$selected" ] && wpctl set-volume @DEFAULT_AUDIO_SINK@ "${selected}%"
        ;;
    output)
        outputs="$(wpctl status -n 2>/dev/null | awk '
            /Sinks:/ { in_sinks=1; next }
            /Sources:/ { in_sinks=0 }
            in_sinks && /[0-9]+\./ {
                line=$0
                match(line, /[0-9]+\./)
                id=substr(line, RSTART, RLENGTH - 1)
                line=substr(line, RSTART + RLENGTH)
                sub(/^[[:space:]]+/, "", line)
                sub(/[[:space:]]+\[vol:.*$/, "", line)
                printf "%s\t%s\n", line, id
            }')"
        [ -n "$outputs" ] || exit 1
        friendly_outputs="$(while IFS=$'\t' read -r name id; do
            printf '%s\t%s\n' "$(human_output_name "$name")" "$id"
        done <<< "$outputs")"
        selected="$(printf '%s\n' "$friendly_outputs" | cut -f1 \
            | fuzzel --dmenu --prompt="Salida de audio > " \
            --width=55 2>/dev/null)"
        [ -n "$selected" ] || exit 0
        id="$(printf '%s\n' "$friendly_outputs" | awk -F '\t' -v name="$selected" \
            '$1 == name { print $2; exit }')"
        case "$id" in
            ''|*[!0-9]*) exit 1 ;;
            *) wpctl set-default "$id" ;;
        esac
        ;;
    volume_down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
    volume_up) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ;;
    mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
    *) exit 2 ;;
esac
