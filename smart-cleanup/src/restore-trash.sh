#!/bin/bash

LOG=".trash/trash.log"

[[ -f "$LOG" ]] || { echo "❌ No trash log found"; exit 1; }

while IFS='|' read -r ORIGINAL TRASHED; do
  mkdir -p "$(dirname "$ORIGINAL")"
  mv "$TRASHED" "$ORIGINAL"
done < "$LOG"

rm -rf .trash

echo "♻️ All files restored successfully."
