{  options, config, pkgs, lib, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.hardware.tablet;
in
{
  options.hardware.tablet = with types; {
    enable = mkBoolOpt false "Whether or not to enable drawing tablet support.";
  };

  config = mkIf cfg.enable { 
    hardware.opentabletdriver = enabled; 
  };
}