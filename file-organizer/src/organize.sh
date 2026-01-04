#!/bin/bash

# ================================
# File Organizer Tool
# Automatically organizes files by type
# ================================

# Enable nullglob (prevents errors if no files found)
shopt -s nullglob

# Declare file type groups
declare -A FILE_TYPES=(
  ["Videos"]="mp4 mkv avi mov flv"
  ["Images"]="jpg jpeg png gif bmp webp"
  ["Audio"]="mp3 wav flac aac"
  ["Documents"]="pdf doc docx txt xls xlsx ppt pptx"
  ["Archives"]="zip tar gz rar 7z"
  ["Scripts"]="sh py js java c cpp"
)

# Create folders if they don't exist
for folder in "${!FILE_TYPES[@]}"; do
  mkdir -p "$folder"
done

mkdir -p Others

# Move files based on extension
for file in *.*; do
  moved=false
  ext="${file##*.}"

  for folder in "${!FILE_TYPES[@]}"; do
    for type in ${FILE_TYPES[$folder]}; do
      if [[ "$ext" == "$type" ]]; then
        mv "$file" "$folder/"
        moved=true
        break
      fi
    done
    $moved && break
  done

  if [ "$moved" = false ]; then
    mv "$file" Others/
  fi
done

echo "✅ Files organized successfully."

