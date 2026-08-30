{lib, ...}: {
  perSystem = {pkgs, ...}: {
    packages.scripts = pkgs.symlinkJoin {
      name = "my-bins-scripts";
      paths = lib.pipe ./_scripts [
        builtins.readDir

        # filter for all nix files in _scripts
        (lib.filterAttrs
          (name: type: type == "regular" && lib.hasSuffix ".nix" name))

        # load derivations and pass parameters
        (lib.mapAttrsToList
          (name: _:
            import "${./_scripts}/${name}" {
              inherit pkgs;
              inherit lib;
            }))
      ];
    };
  };
}
