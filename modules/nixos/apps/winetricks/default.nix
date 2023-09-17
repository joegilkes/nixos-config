{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.apps.winetricks;
in
{
  options.pluskinda.apps.winetricks = with types; {
    enable = mkBoolOpt false "Whether or not to enable Winetricks.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ winetricks ]; };
}