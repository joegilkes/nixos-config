{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.ultrastar;
in
{
  options.pluskinda.apps.ultrastar = with types; {
    enable = mkBoolOpt false "Whether or not to enable Ultrastar Deluxe.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      ultrastardx
    ];
  };
}