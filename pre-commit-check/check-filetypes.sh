#!/bin/bash

# Path to the extension list relative to this script
EXT_FILE="$(dirname "${BASH_SOURCE[0]}")/../forbidden-extensions.txt"

# Check shell compatibility
if ! command -v grep >/dev/null || ! command -v paste >/dev/null; then
  echo "[ERROR] This hook requires a Unix-like shell environment (e.g. Git Bash or WSL)."
  exit 1
fi

if [ ! -f "$EXT_FILE" ]; then
  echo "[ERROR] Forbidden extensions list not found at $EXT_FILE"
  exit 1
fi

COUNT=$(wc -l < "$EXT_FILE")
if [ "$COUNT" -lt 2 ]; then
  echo "[ERROR] Forbidden extensions list seems too short to be valid:"
  cat "$EXT_FILE"
  exit 1
fi

CLEANED=$(grep -vE '^\s*#|^\s*$' "$EXT_FILE" | tr -d '\r')

if [ -z "$CLEANED" ]; then
  echo "[ERROR] No usable extensions found in $EXT_FILE"
  exit 1
fi

REGEX=$(printf "%s\n" "$CLEANED" | paste -s -d '|')

echo "[INFO] Checking for forbidden extensions: .$REGEX"

echo "[DEBUG] Compiled regex: \.($REGEX)$"
echo "[DEBUG] Files passed to hook:"
printf '%s\n' "$@"

FOUND=0
for FILE in "$@"; do
  if [[ "$FILE" =~ \.($REGEX)$ ]]; then
    echo "[ERROR] Forbidden file type detected: $FILE"
    FOUND=1
  fi
done

exit $FOUND
