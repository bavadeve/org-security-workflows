#!/bin/bash

EXT_FILE="$(dirname "${BASH_SOURCE[0]}")/../forbidden-extensions.txt"

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

REGEX=$(paste -sd'|' "$EXT_FILE")
echo "[INFO] Checking for forbidden extensions: .$REGEX"

FOUND=0
for FILE in "$@"; do
  if [[ "$FILE" =~ \.($REGEX)$ ]]; then
    echo "[ERROR] Forbidden file type detected: $FILE"
    FOUND=1
  fi
done

exit $FOUND
