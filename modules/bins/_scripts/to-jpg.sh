#!/usr/bin/env bash
# Converts all image files in a directory to JPEG.
#
# The shebang above is only so editors/linters detect bash; the final
# wrapper's shebang (from writeShellApplication) takes precedence.

set -euo pipefail

readonly QUALITY="90"
readonly OUTPUT_SUBDIR="jpg"

show_usage() {
  echo "Usage: $0 <source_directory>"
  echo "Converts all image files in <source_directory> to JPEG (quality $QUALITY),"
  echo "saving them in <source_directory>/$OUTPUT_SUBDIR."
  exit 1
}

if [ "$#" -lt 1 ]; then
  show_usage
fi

SRC_DIR=$(realpath "$1")

if [ ! -d "$SRC_DIR" ]; then
  echo "Error: Source directory '$SRC_DIR' does not exist." >&2
  exit 1
fi

OUT_DIR="$SRC_DIR/$OUTPUT_SUBDIR"

echo "Source Directory: $SRC_DIR"
echo "Output Directory: $OUT_DIR (JPEG Quality: $QUALITY)"
echo "---"

mkdir -p "$OUT_DIR"

while IFS= read -r -d $'\0' INPUT_FILE; do
  BASENAME=${INPUT_FILE##*/}
  EXT=${BASENAME##*.}

  # Skip already-JPEG files; only convert known image formats.
  # Anything else is skipped instead of failing the whole run.
  case "${EXT,,}" in
    jpg | jpeg)
      continue
      ;;
    png | gif | webp | tiff | bmp | heic | avif)
      ;;
    *)
      echo "Skipping $BASENAME (unsupported extension '$EXT')" >&2
      continue
      ;;
  esac

  OUTPUT_FILE="$OUT_DIR/${BASENAME%.*}.jpg"
  magick "$INPUT_FILE" -quality "$QUALITY" "$OUTPUT_FILE"
  echo "→ Converted: $BASENAME → $OUTPUT_SUBDIR/${BASENAME%.*}.jpg"
done < <(find "$SRC_DIR" -maxdepth 1 -type f -print0)
