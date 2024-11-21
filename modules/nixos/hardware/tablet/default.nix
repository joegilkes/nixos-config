{ options, config, pkgs, lib, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.hardware.tablet;
in
{
  options.pluskinda.hardware.tablet = with types; {
    enable = mkBoolOpt false "Whether or not to enable drawing tablet support.";
  };

  config = mkIf cfg.enable { 
    hardware.opentabletdriver = enabled; 
  };
}