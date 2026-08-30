{
  perSystem = {pkgs, ...}: {
    packages.tmux-sessionizer = pkgs.callPackage ./_tmux-sessionizer.nix {};
  };
}
