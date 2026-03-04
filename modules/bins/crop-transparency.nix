{...}: {
  perSystem = {pkgs, ...}: {
    packages.crop-transparency = let
      python = pkgs.python3.withPackages (ps: [
        ps.pillow
        ps.numpy
      ]);
    in
      pkgs.writeShellScriptBin "crop-transparency" ''
        ${python}/bin/python ${./_src/crop-transparency.py} "$@"
      '';
  };
}
