{
  lib,
  lib',
}:

{
  flake = import ./flake;
  homeManager = import ./home-manager { inherit lib lib'; };
  nixos = import ./nixos;
}
