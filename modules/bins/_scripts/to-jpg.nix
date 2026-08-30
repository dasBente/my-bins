{pkgs, ...}:
pkgs.writeShellApplication {
  name = "to-jpg";
  runtimeInputs = with pkgs; [coreutils findutils imagemagick];
  text = builtins.readFile ./to-jpg.sh;
}
