{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.oversteer;
in
{
  options.pluskinda.apps.oversteer = with types; {
    enable = mkBoolOpt false "Whether or not to enable Oversteer.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      oversteer
    ];
  };
}