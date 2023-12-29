{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.sidequest;
in
{
  options.pluskinda.apps.sidequest = with types; {
    enable = mkBoolOpt false "Whether or not to enable Sidequest.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ sidequest ]; };
}