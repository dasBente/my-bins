{...}: {
  perSystem = {pkgs, ...}: {
    packages.to-jpg = pkgs.writeShellApplication {
      name = "to-jpg";
      runtimeInputs = [pkgs.coreutils pkgs.findutils pkgs.imagemagick];
      text = builtins.readFile ./_src/to-jpg.sh;
    };
    packages.to-jpg-servicemenu = pkgs.writeTextFile {
      name = "to-jpg-servicemenu";
      destination = "/share/kio/servicemenus/to-jpg.desktop";
      text = ''
        [Desktop Entry]
      '';
    };
  };
}
