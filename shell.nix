let
  pkgs = import (fetchTarball "channel:nixos-20.09") { config = {}; overlays = []; };
  terraform = pkgs.terraform.withPlugins (p: [
    p.null
    p.external
    p.google
  ]);
in
pkgs.mkShell {
  buildInputs = [ terraform ];
}
