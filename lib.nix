{
  lib,
}:

let
  lib' = import ./lib { inherit lib lib'; };
in
lib'
