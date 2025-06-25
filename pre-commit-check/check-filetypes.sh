#!/bin/bash

# Path to the extension list relative to this script
EXT_FILE="$(dirname "${BASH_SOURCE[0]}")/../forbidden-extensions.txt"

# Check required tools
if ! command -v grep >/dev/null || ! command -v paste >/dev/null; then
  echo "[ERROR] Required tools (grep, paste) not found."
  exit 1
fi

# Check if extension list exists and looks valid
if [ ! -f "$EXT_FILE" ]; then
  echo "[ERROR] Forbidden extensions list not found: $EXT_FILE"
  exit 1
fi

COUNT=$(wc -l < "$EXT_FILE")
if [ "$COUNT" -lt 2 ]; then
  echo "[ERROR] Forbidden extensions list seems too short to be valid."
  exit 1
fi

# Create regex pattern
REGEX=$(grep -vE '^\s*#|^\s*$' "$EXT_FILE" | tr -d '\r' | tr '\n' '|' | sed 's/|$//')

if [ -z "$REGEX" ]; then
  echo "[ERROR] No usable extensions found in $EXT_FILE"
  exit 1
fi

# Check files
FOUND=0
for FILE in "$@"; do
  if [[ "$FILE" =~ \.($REGEX)$ ]]; then
    echo "[ERROR] Forbidden file type detected: $FILE"
    FOUND=1
  fi
done

exit $FOUND
