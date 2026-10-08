#!/usr/bin/env bash
# Rebuilds gfx/ and common/ from the four source repositories, which must sit next to
# this one. The bundle holds no code of its own: every file is a byte copy of a file in
# one of them, and this script is the only way those files get here.
#
#   Sharp Terrain Without Advanced Shaders   ../ck3-lowspec-terrain-fix
#   Real Snow Without Advanced Shaders       ../ck3-lowspec-real-snow
#   Better Water Without Advanced Shaders    ../ck3-lowspec-water
#   Smooth Zoom Transitions                  ../ck3-zoom-transition-fix
#
# The order matters for one file only: Real Snow is a single sharp_terrain_options.fxh
# with the snow option switched on, and it replaces Sharp Terrain's copy here exactly as
# it does in a playset where it sits below Sharp Terrain. Any other path present in two
# sources is an error.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$(dirname "$ROOT")"
SOURCES=(ck3-lowspec-terrain-fix ck3-lowspec-real-snow ck3-lowspec-water ck3-zoom-transition-fix)
REPLACEABLE="gfx/FX/sharp_terrain_options.fxh"

for s in "${SOURCES[@]}"; do
	[ -d "$SRC/$s" ] || { echo "Missing source repository: $SRC/$s" >&2; exit 1; }
done

declare -A owner
for s in "${SOURCES[@]}"; do
	while IFS= read -r f; do
		if [ -n "${owner[$f]:-}" ] && [ "$f" != "$REPLACEABLE" ]; then
			echo "Conflict: $f is in both ${owner[$f]} and $s" >&2
			exit 1
		fi
		owner[$f]=$s
	done < <(cd "$SRC/$s" && find gfx common -type f 2>/dev/null | sort)
done

rm -rf "$ROOT/gfx" "$ROOT/common"
for f in $(printf '%s\n' "${!owner[@]}" | sort); do
	mkdir -p "$ROOT/$(dirname "$f")"
	cp "$SRC/${owner[$f]}/$f" "$ROOT/$f"
	printf '%-58s <- %s\n' "$f" "${owner[$f]}"
done

echo
for s in "${SOURCES[@]}"; do
	printf '%-26s %s  %s\n' "$s" "$(git -C "$SRC/$s" rev-parse --short HEAD)" "$(grep -h '^version=' "$SRC/$s/descriptor.mod")"
done
