#!/bin/bash
# Lock the session, at most once. Several triggers can fire together (idle
# timeout, before-sleep, lid close, the keybinding), and a second swaylock fails
# with "Cannot lock an already locked session". `-f` returns only once the lock
# is held, so swayidle's before-sleep (-w) waits for it before suspending.
pgrep -xu "$USER" swaylock >/dev/null && exit 0
exec swaylock -f
