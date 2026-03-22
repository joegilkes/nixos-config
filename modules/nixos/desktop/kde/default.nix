{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.desktop.kde;
in
{
  options.pluskinda.desktop.kde = with types; {
    enable = mkBoolOpt false "Whether or not to use KDE as the desktop environment.";
  };

  config = mkIf cfg.enable {
    services.desktopManager.plasma6 = enabled;
  };
}