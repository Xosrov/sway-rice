#!/bin/bash
# Assign workspaces to outputs based on the currently *active* outputs.
#
# Model (laptop = eDP-1, always the leftmost logical group when it is on):
#   1 active output  : 1-9 on it
#   2 active outputs : 1-4 on the left group, 5-9 on the right group
#   3 active outputs : 1-3 / 4-6 / 7-9 across left -> right
#
# The logical left->right order is: laptop first (if active), then the
# external monitors sorted by physical X position. swap-displays.sh changes
# the real output positions, so this script just follows physical X.
#
# Because sway only reads a workspace's output priority at *creation* time
# (see src/sway tree/workspace.c), existing workspaces are relocated with an
# explicit `move workspace to output`, which updates priority dynamically.
#
# Usage:
#   output-manager.sh            re-apply the whole layout (move existing wss)
#   output-manager.sh place <ws> place a single (focused) workspace
set -u

INTERNAL="eDP-1"
STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}"
LOCK_FILE="$STATE_DIR/sway-output-manager.lock"

# Serialise concurrent invocations (the watcher fires several per hotplug).
exec 9>"$LOCK_FILE"
flock 9

# Populate `order` (array of output names, left -> right logical order).
compute_order() {
	local outputs_json internal_active
	outputs_json=$(swaymsg -t get_outputs)

	internal_active=$(jq -r --arg n "$INTERNAL" \
		'[.[] | select(.name == $n and .active == true)] | length' \
		<<<"$outputs_json")

	# Active, non-internal outputs sorted by physical X (tie-break: name).
	mapfile -t externals < <(
		jq -r --arg n "$INTERNAL" '
			[.[] | select(.active == true and .name != $n)]
			| sort_by(.rect.x, .name)
			| .[].name
		' <<<"$outputs_json"
	)

	# Order: laptop first (if on), then externals by physical position.
	order=()
	[ "${internal_active:-0}" -ge 1 ] && order+=("$INTERNAL")
	order+=("${externals[@]}")
}

# Populate the associative array `target` (workspace number -> output name).
compute_targets() {
	unset target
	declare -gA target
	local n=${#order[@]} g w base extra idx take
	local -a groups ws slice
	case $n in
		0) return ;;
		1) groups=("1 2 3 4 5 6 7 8 9") ;;
		2) groups=("1 2 3 4" "5 6 7 8 9") ;;
		3) groups=("1 2 3" "4 5 6" "7 8 9") ;;
		*)
			# 4+ outputs: spread as evenly as possible, extras to the left.
			ws=(1 2 3 4 5 6 7 8 9)
			base=$((9 / n)); extra=$((9 % n)); idx=0
			groups=()
			for ((g = 0; g < n; g++)); do
				take=$base
				[ "$g" -lt "$extra" ] && take=$((take + 1))
				slice=("${ws[@]:idx:take}")
				groups+=("${slice[*]}")
				idx=$((idx + take))
			done
			;;
	esac
	for ((g = 0; g < n; g++)); do
		for w in ${groups[g]}; do
			target[$w]="${order[g]}"
		done
	done
}

# Re-apply the whole layout: move every existing workspace to its target.
apply_all() {
	compute_order
	if [ ${#order[@]} -eq 0 ]; then
		# Nothing is on — make sure the laptop comes back.
		swaymsg "output $INTERNAL enable" >/dev/null
		return
	fi
	compute_targets

	local focused wsname wsout tgt moved=0
	focused=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .name')

	while IFS=$'\t' read -r wsname wsout; do
		tgt="${target[$wsname]:-}"
		[ -z "$tgt" ] && continue
		[ "$wsout" = "$tgt" ] && continue
		swaymsg "workspace number $wsname; move workspace to output $tgt" >/dev/null
		moved=1
	done < <(swaymsg -t get_workspaces | jq -r '.[] | "\(.name)\t\(.output)"')

	# Restore focus only if we shuffled things around.
	[ "$moved" = 1 ] && [ -n "$focused" ] && \
		swaymsg "workspace number $focused" >/dev/null
}

# Place a single workspace, but only if it is the focused one. This lets a
# workspace created by $mod+N follow to its target monitor, while empty
# auto-created workspaces are left alone (no relocation cascades).
place_one() {
	local wsname="$1" tgt cur foc
	[ -z "$wsname" ] && return
	compute_order
	[ ${#order[@]} -eq 0 ] && return
	compute_targets

	tgt="${target[$wsname]:-}"
	[ -z "$tgt" ] && return

	read -r cur foc < <(
		swaymsg -t get_workspaces |
		jq -r --arg n "$wsname" '.[] | select(.name == $n) | "\(.output) \(.focused)"'
	)
	[ -z "${cur:-}" ] && return          # workspace does not exist
	[ "${foc:-false}" = "true" ] || return
	[ "$cur" = "$tgt" ] && return
	swaymsg "workspace number $wsname; move workspace to output $tgt" >/dev/null
}

case "${1:-}" in
	place) place_one "${2:-}" ;;
	*)     apply_all ;;
esac
