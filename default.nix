# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{
  pkgs ? import <nixpkgs> { },
}:

let
  inherit (pkgs.lib)
    assertMsg
    attrNames
    concatStringsSep
    importTOML
    mapAttrs
    subtractLists
    warnOnInstantiate
    ;

  modules = import ./modules;

  packages = pkgs.lib.packagesFromDirectoryRecursive {
    callPackage = pkgs.newScope packages;
    directory = ./pkgs;
  };
  upstreamStatus = importTOML ./upstream-status.toml;

  missingFromToml = subtractLists (attrNames upstreamStatus) (attrNames packages);

  warnIfUpstreamed =
    name: pkg:
    let
      us = upstreamStatus.${name};
    in
    if us.merged or false then
      let
        msg = "`pkgs.nur.repos.ilkecan.${name}` has been upstreamed to nixpkgs and the NUR package will be removed after NixOS ${us.removal} EOL.";
      in
      if pkgs ? ${name} then
        warnOnInstantiate "Please use `pkgs.${name}`. ${msg}" pkgs.${name}
      else
        warnOnInstantiate msg pkg
    else
      pkg;
in
assert assertMsg (missingFromToml == [ ]) ''
  Missing `upstream-status.toml` entries for: ${concatStringsSep ", " missingFromToml}
  Add a (possibly empty) `[name]` section for each directory under `./pkgs`.
'';
{
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  inherit modules; # modules
  overlays = import ./overlays; # nixpkgs overlays

  # ... as well as `xxxModules`, see: https://github.com/nix-community/NUR/pull/1101
  flakeModules = modules.flake;
  homeModules = modules.homeManager;
  nixosModules = modules.nixos;
}
// mapAttrs warnIfUpstreamed packages
