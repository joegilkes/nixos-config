{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.calibre;
in
{
  options.pluskinda.apps.calibre = with types; {
    enable = mkBoolOpt false "Whether or not to enable Star Citizen.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ calibre ]; };
}