{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.star-citizen;
in
{
  options.pluskinda.apps.star-citizen = with types; {
    enable = mkBoolOpt false "Whether or not to enable Star Citizen.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ star-citizen ];
  };
}