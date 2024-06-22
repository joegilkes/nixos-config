{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.coolercontrol;
in
{
  options.pluskinda.apps.coolercontrol = with types; {
    enable = mkBoolOpt false "Whether or not to enable Coolercontrol.";
  };

  config = mkIf cfg.enable { programs.coolercontrol = enabled; };
}