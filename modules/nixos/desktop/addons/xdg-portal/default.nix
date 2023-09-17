{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.desktop.addons.xdg-portal;
in
{
  options.pluskinda.desktop.addons.xdg-portal = with types; {
    enable = mkBoolOpt false
      "Whether to enable xdg-open via portals in the desktop environment.";
  };

  config = mkIf cfg.enable {
    xdg.portals = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}