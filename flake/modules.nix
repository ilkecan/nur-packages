{
  lib,
  lib',
  self,
  ...
}:

{
  flake.modules = import "${self}/modules" { inherit lib lib'; };
}
