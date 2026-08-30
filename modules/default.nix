{lib, ...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    packages.default = pkgs.symlinkJoin {
      name = "my-bins";
      paths = lib.pipe config.packages [
        (lib.filterAttrs (n: _: n != "default"))
        lib.attrValues
      ];
    };
  };
}
