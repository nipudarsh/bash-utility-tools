#!/bin/bash

TARGET="${1:-.}"
HASH_FILE=".duplicate_hashes.log"
DUPLICATES=".duplicates.list"

> "$HASH_FILE"
> "$DUPLICATES"

echo "🔍 Scanning for duplicates in: $TARGET"

find "$TARGET" -type f ! -path "*/.trash/*" | while read -r FILE; do
  HASH=$(sha256sum "$FILE" | awk '{print $1}')

  if grep -q "$HASH" "$HASH_FILE"; then
    echo "$FILE" >> "$DUPLICATES"
  else
    echo "$HASH|$FILE" >> "$HASH_FILE"
  fi
done

echo "✅ Scan complete."
echo "📄 Duplicate list saved to $DUPLICATES"

