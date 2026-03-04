{...}: {
  perSystem = {pkgs, ...}: {
    packages = let
      python = pkgs.python3.withPackages (ps: [
        ps.pillow
        ps.numpy
      ]);
    in
      pkgs.writeShellScriptBin "crop-transparency" ''
        #!${python}/bin/python

        import os
        from PIL import Image

        def crop_to_alpha_bbox(input_folder="."):
            output_folder = os.path.join(input_folder, "output")
            os.makedirs(output_folder, exist_ok=True)

            for filename in os.listdir(input_folder):
                if not filename.lower().endswith((".png", ".jpg", ".jpeg", ".webp", ".tiff")):
                    continue

                path = os.path.join(input_folder, filename)
                try:
                    img = Image.open(path).convert("RGBA")
                except Exception as e:
                    print(f"Skipping {filename}: {e}")
                    continue

                # Extract alpha channel
                alpha = img.split()[-1]

                # Compute bounding box of non-zero alpha pixels
                bbox = alpha.getbbox()
                if bbox is None:
                    print(f"No visible pixels in {filename}, skipping.")
                    continue

                # Crop to alpha bounding box
                cropped = img.crop(bbox)

                # Replace transparency with black
                background = Image.new("RGBA", cropped.size, (0, 0, 0, 255))  # black background
                flattened = Image.alpha_composite(background, cropped).convert("RGB")

                # Save as PNG
                output_path = os.path.join(output_folder, os.path.splitext(filename)[0] + ".png")
                flattened.save(output_path, "PNG")

                print(f"Processed: {filename} → {output_path}")

        if __name__ == "__main__":
            crop_to_alpha_bbox(".")
      '';
  };
}
