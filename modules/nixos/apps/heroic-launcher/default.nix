{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.heroic-launcher;
in
{
  options.pluskinda.apps.heroic-launcher = with types; {
    enable = mkBoolOpt false "Whether or not to enable Heroic Launcher.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ heroic ]; };
}