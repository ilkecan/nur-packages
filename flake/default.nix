{
  inputs,
  ...
}:

{
  imports = [
    inputs.git-hooks-nix.flakeModule

    ./per-system
    ./systems.nix
  ];
}
