{
  lib,
  lib',
}:

let
  inherit (lib.modules) importApply;
  inherit (lib') nixosUtils;
in
{
  byedpi = importApply ./byedpi.nix { inherit nixosUtils; };
  nixos-utils = importApply ./nixos-utils.nix { inherit nixosUtils; };
  omp = ./omp.nix;
  scopebuddy = ./scopebuddy.nix;
  xdg-bin-file = ./xdg-bin-file.nix;
}
