{
  pkgs,
}:

let
  inherit (pkgs.lib)
    importTOML
    mapAttrs
    substring
    warnOnInstantiate
    ;

  upstreamStatus = importTOML ./upstream-status.toml;

  packages = pkgs.lib.packagesFromDirectoryRecursive {
    callPackage = pkgs.newScope packages;
    directory = ./packages;
  };

  formatRelease =
    release:
    let
      s = toString release;
    in
    "${substring 0 2 s}.${substring 2 2 s}";
  warnIfUpstreamed =
    name: pkg:
    let
      us = upstreamStatus.${name};
    in
    if us.merged or false then
      let
        msg = "`pkgs.nur.repos.ilkecan.${name}` has been upstreamed to nixpkgs and the NUR package will be removed after NixOS ${formatRelease us.removeAfter} is EOL.";
      in
      if pkgs ? ${name} then
        warnOnInstantiate "Please use `pkgs.${name}`. ${msg}" pkgs.${name}
      else
        warnOnInstantiate msg pkg
    else
      pkg;

in
mapAttrs warnIfUpstreamed packages
