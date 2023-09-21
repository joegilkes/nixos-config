{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.gamescope;
in
{
  options.pluskinda.apps.gamescope = with types; {
    enable = mkBoolOpt false "Whether or not to enable Gamescope.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      gamescope
    ];
  };
}