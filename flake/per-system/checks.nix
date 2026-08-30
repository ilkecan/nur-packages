{
  lib,
  self,
  ...
}:

{
  perSystem =
    {
      config,
      lib',
      pkgs,
      ...
    }:
    {
      checks = {
        health-check = import ./checks/health-check.nix {
          inherit
            config
            lib
            lib'
            pkgs
            self
            ;
        };
      }
      // lib.mapAttrs' (name: lib.nameValuePair "${name}-package") config.packages;
    };
}
