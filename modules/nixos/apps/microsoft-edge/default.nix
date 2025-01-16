{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.microsoft-edge;
in
{
  options.pluskinda.apps.microsoft-edge = with types; {
    enable = mkBoolOpt false "Whether or not to enable Microsoft Edge.";
  };

  config =
    mkIf cfg.enable { 
      environment.systemPackages = with pkgs; [ microsoft-edge ];
    };
}