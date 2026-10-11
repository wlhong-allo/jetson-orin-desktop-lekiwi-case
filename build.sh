#!/usr/bin/env bash
# Build script: render Jetson_Orin_NX_Case.scad -> STL files for Bambu Lab slicer.
#
# Usage:
#   ./build.sh            # render both base + cover into ./out_v11
#   ./build.sh base       # render only the base
#   ./build.sh cover      # render only the cover
#   ./build.sh gui        # open the GUI for editing
#
# OpenSCAD snapshot cask on Apple Silicon has a broken arm64 Qt slice,
# so we force the x86_64 slice via Rosetta (`arch -x86_64`).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCAD_FILE="$SCRIPT_DIR/Jetson_Orin_NX_Case.scad"
OUT_DIR="$SCRIPT_DIR/out_v11"
mkdir -p "$OUT_DIR"

OPENSCAD_APP="/opt/homebrew/Caskroom/openscad@snapshot/2026.10.08/OpenSCAD.app"
OPENSCAD_BIN="$OPENSCAD_APP/Contents/MacOS/OpenSCAD"

if [[ ! -x "$OPENSCAD_BIN" ]]; then
  echo "OpenSCAD binary not found at: $OPENSCAD_BIN"
  echo "Install with: brew install --cask openscad@snapshot"
  exit 1
fi

# Force x86_64 slice (arm64 Qt slice is broken in this snapshot build).
run_oscad() { arch -x86_64 "$OPENSCAD_BIN" "$@"; }

# Render quality. $fn is set per-cylinder in the .scad; this is the global fallback.
RENDER_ARGS=(--render
  --imgsize=2048,2048
  --projection=o
  --hardwarnings
  --check-parameters=true
  --check-parameter-ranges=true)

render_part() {
  local part="$1"
  local cap
  cap="$(tr '[:lower:]' '[:upper:]' <<<"${part:0:1}")${part:1}"
  local out="$OUT_DIR/Jetson_Orin_NX_Case_${cap}_v11.stl"
  echo "==> Rendering $part -> $out"
  run_oscad "${RENDER_ARGS[@]}" \
    -D "part=\"$part\"" \
    -o "$out" \
    "$SCAD_FILE"
  echo "    done: $(ls -lh "$out" | awk '{print $5}')"
}

case "${1:-all}" in
  all)
    render_part base
    render_part cover
    ;;
  base|cover)
    render_part "$1"
    ;;
  gui)
    open -a "$OPENSCAD_APP" "$SCAD_FILE"
    ;;
  *)
    echo "Unknown target: $1"
    echo "Usage: $0 [all|base|cover|gui]"
    exit 1
    ;;
esac

echo "==> Done. Import the STLs into Bambu Studio / OrcaSlicer."
