{
  config,
  lib,
  ...
}: {
  perSystem = {
    self',
    pkgs,
    ...
  }: {
    packages.default = pkgs.symlinkJoin {
      name = "my-bins";
      paths = lib.attrValues (lib.filterAttrs (n: v: n != "default") self'.packages);
    };
  };
}
