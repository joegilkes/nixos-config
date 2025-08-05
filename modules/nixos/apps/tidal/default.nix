{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.tidal;
in
{
  options.pluskinda.apps.tidal = with types; {
    enable = mkBoolOpt false "Whether or not to enable Tidal-HiFi.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      tidal-hifi
    ];
  };
}