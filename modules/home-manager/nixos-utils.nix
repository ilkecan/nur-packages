{
  nixosUtils,
}:

{
  # Home Manager has no equivalent of the NixOS `utils` module argument.
  _module.args = { inherit nixosUtils; };
}
