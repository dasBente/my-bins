# rebuilds default flake in dotfiles and prints errors in a readable way.
# rebuild [commit msg]
#
# source: https://www.youtube.com/watch?v=CwfKlX3rA6E
{...}: {
  perSystem = {pkgs, ...}: {
    packages.rebuild = pkgs.writeShellScriptBin "rebuild" ''
      #!${pkgs.bash}/bin/bash
      set -e
      pushd ~/projects/dotfiles

      ${pkgs.alejandra}/bin/alejandra . &>/dev/null

      echo "NixOS Rebuilding..."

      sudo nixos-rebuild switch --flake .# &> nixos.switch.log || \
      	(cat nixos.switch.log | grep --color error && false)

      gen=$(nixos-rebuild list-generations | grep current)

      popd
    '';
  };
}
