{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.ffbtools;
in
{
  options.programs.ffbtools = with types; {
    enable = mkBoolOpt false "Whether or not to enable ffbtools.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = [ 
      pkgs.ffbwrap
    ]; 
  };
}