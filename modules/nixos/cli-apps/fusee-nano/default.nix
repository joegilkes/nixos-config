{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.cli-apps.fusee-nano;
in
{
  options.pluskinda.cli-apps.fusee-nano = with types; {
    enable = mkBoolOpt false "Whether or not to enable fusee-nano.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      fusee-nano
    ];
  };
}