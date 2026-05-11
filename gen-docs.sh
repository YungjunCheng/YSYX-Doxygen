#!/usr/bin/env bash
# Generate NEMU documentation with Doxygen + Graphviz
# Usage: ./gen-docs.sh [open]
#   open — open the generated docs in a browser after generation

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOXYFILE="$SCRIPT_DIR/Doxyfile"
OUTPUT_DIR="$SCRIPT_DIR/docs"

# Check dependencies
for cmd in doxygen dot; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: $cmd not found. Install with:"
    echo "  sudo pacman -S doxygen graphviz"
    exit 1
  fi
done

# Clean previous output
if [ -d "$OUTPUT_DIR" ]; then
  echo "Cleaning previous docs..."
  rm -rf "$OUTPUT_DIR"
fi

# Generate
echo "Running Doxygen..."
(cd "$SCRIPT_DIR" && doxygen "$DOXYFILE" 2>&1 | tail -5)

echo ""
echo "Done. Output: $OUTPUT_DIR/html/index.html"

# Optionally open in browser
if [ "${1:-}" = "open" ]; then
  xdg-open "$OUTPUT_DIR/html/index.html" 2>/dev/null || \
    echo "Open manually: $OUTPUT_DIR/html/index.html"
fi
