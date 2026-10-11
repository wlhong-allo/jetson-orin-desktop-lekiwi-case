#!/usr/bin/env bash
# Build script: render Jetson_Orin_NX_Case.scad -> STL files.
#
# Usage (from repo root):
#   ./scripts/build.sh            # render both base + cover into ./stl
#   ./scripts/build.sh base       # render only the base
#   ./scripts/build.sh cover      # render only the cover
#   ./scripts/build.sh gui        # open the GUI for editing
#
# OpenSCAD resolution:
#   1. `openscad` on PATH (Linux, Homebrew, MacPorts, etc.)
#   2. Homebrew snapshot cask: /opt/homebrew/Caskroom/openscad@snapshot/<ver>/OpenSCAD.app
#
# On Apple Silicon, the arm64 Qt slice in some OpenSCAD snapshot builds is broken.
# Set USE_ROSETTA=1 (or auto-detected) to force the x86_64 slice via Rosetta.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCAD_FILE="$SCRIPT_DIR/../cad/Jetson_Orin_NX_Case.scad"
OUT_DIR="$SCRIPT_DIR/../stl"
mkdir -p "$OUT_DIR"

# --- Locate OpenSCAD ---------------------------------------------------------
OPENSCAD_BIN=""
OPENSCAD_APP=""

if command -v openscad >/dev/null 2>&1; then
  OPENSCAD_BIN="$(command -v openscad)"
elif [[ -d /opt/homebrew/Caskroom/openscad@snapshot ]]; then
  # Pick the newest installed snapshot version.
  SNAP_DIR="$(ls -d /opt/homebrew/Caskroom/openscad@snapshot/*/ | sort -V | tail -1)"
  OPENSCAD_APP="${SNAP_DIR%/}OpenSCAD.app"
  OPENSCAD_BIN="$OPENSCAD_APP/Contents/MacOS/OpenSCAD"
fi

if [[ -z "$OPENSCAD_BIN" || ! -x "$OPENSCAD_BIN" ]]; then
  echo "OpenSCAD not found."
  echo "Install with one of:"
  echo "  brew install openscad           # stable"
  echo "  brew install --cask openscad@snapshot   # macOS snapshot"
  echo "  sudo apt install openscad        # Debian/Ubuntu"
  exit 1
fi

# --- Rosetta workaround (Apple Silicon snapshot builds) ----------------------
USE_ROSETTA="${USE_ROSETTA:-auto}"
run_oscad() {
  if [[ "$USE_ROSETTA" == "1" ]]; then
    arch -x86_64 "$OPENSCAD_BIN" "$@"
  elif [[ "$USE_ROSETTA" == "auto" ]] && [[ "$OPENSCAD_APP" == *"/openscad@snapshot/"* ]] && [[ "$(uname -m)" == "arm64" ]]; then
    arch -x86_64 "$OPENSCAD_BIN" "$@"
  else
    "$OPENSCAD_BIN" "$@"
  fi
}

# --- Render -----------------------------------------------------------------
RENDER_ARGS=(--render
  --imgsize=2048,2048
  --projection=o
  --hardwarnings
  --check-parameters=true
  --check-parameter-ranges=true)

render_part() {
  local part="$1"
  local out="$OUT_DIR/${part}.stl"
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
    if [[ -n "$OPENSCAD_APP" ]]; then
      open -a "$OPENSCAD_APP" "$SCAD_FILE"
    else
      "$OPENSCAD_BIN" "$SCAD_FILE"
    fi
    ;;
  *)
    echo "Unknown target: $1"
    echo "Usage: $0 [all|base|cover|gui]"
    exit 1
    ;;
esac

echo "==> Done. Import the STLs from ./stl into Bambu Studio / OrcaSlicer / PrusaSlicer."
