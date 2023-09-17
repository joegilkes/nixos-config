{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.apps.protontricks;
in
{
  options.pluskinda.apps.protontricks = with types; {
    enable = mkBoolOpt false "Whether or not to enable Protontricks.";
  };

  config = mkIf cfg.enable { 
    environment.systemPackages = with pkgs; [ protontricks ]; 
  };
}