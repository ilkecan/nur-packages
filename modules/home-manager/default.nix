{
  lib,
  lib',
}:

let
  inherit (lib.modules) importApply;
  inherit (lib') nixosUtils;
in
{
  nixos-utils = importApply ./nixos-utils.nix { inherit nixosUtils; };
  scopebuddy = ./scopebuddy.nix;
  xdg-bin-file = ./xdg-bin-file.nix;
}
