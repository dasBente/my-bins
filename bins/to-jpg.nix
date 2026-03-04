{...}: {
  perSystem = {pkgs, ...}: {
    packages.to-jpg = pkgs.writeShellScriptBin "to-jpg" ''
      #!{pkgs.bash}/bin/bash
      set -euo pipefail

      readonly QUALITY="90"
      readonly OUTPUT_SUBDIR="jpg"

      show_usage() {
      ${pkgs.coreutils}/bin/echo "Usage: $0 <source_directory>"
      ${pkgs.coreutils}/bin/echo "Converts all image files in <source_directory> to JPEG (quality $QUALITY),"
      ${pkgs.coreutils}/bin/echo "saving them in <source_directory>/$OUTPUT_SUBDIR."
      exit 1
      }

      # Check if a source directory was provided
      if [ $# -lt 1 ]; then
      show_usage
      fi

      SRC_DIR=$(${pkgs.coreutils}/bin/realpath "$1")

      # Validate path
      if [ ! -d "$SRC_DIR" ]; then
      ${pkgs.coreutils}/bin/echo "Error: Source directory '$SRC_DIR' does not exist." >&2
      exit 1
      fi

      OUT_DIR="$SRC_DIR/$OUTPUT_SUBDIR"

      ${pkgs.coreutils}/bin/echo "Source Directory: $SRC_DIR"
      ${pkgs.coreutils}/bin/echo "Output Directory: $OUT_DIR (JPEG Quality: $QUALITY)"
      ${pkgs.coreutils}/bin/echo "---"

      ${pkgs.coreutils}/bin/mkdir -p "$OUT_DIR"

      # Convert all files except those already in the output dir
      ${pkgs.findutils}/bin/find "$SRC_DIR" -maxdepth 1 -type f -print0 | while IFS= read -r -d $'\0' INPUT_FILE; do
      BASENAME=$(${pkgs.coreutils}/bin/basename "$INPUT_FILE")
      EXT=$(${pkgs.coreutils}/bin/echo "$BASENAME" | ${pkgs.gnused}/bin/sed 's/.*\.//')

      # Skip output directory or already jpg files
      if [[ "$EXT" =~ ^(jpg|jpeg|JPG|JPEG)$ ]]; then
      continue
      fi

      OUTPUT_FILE="$OUT_DIR/''${BASENAME%.*}.jpg"

      ${pkgs.imagemagick}/bin/magick "$INPUT_FILE" -quality "$QUALITY" "$OUTPUT_FILE"
      ${pkgs.coreutils}/bin/echo "→ Converted: $BASENAME → $OUTPUT_SUBDIR/''${BASENAME%.*}.jpg"
      done
    '';
  };
}
