{
  self,
  ...
}:

{
  perSystem =
    { pkgs, ... }:
    {
      packages = import "${self}/packages.nix" { inherit pkgs; };
    };
}
