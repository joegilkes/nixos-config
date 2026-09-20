{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.services.desktop.addons.xdg-portal;
in
{
  options.services.desktop.addons.xdg-portal = with types; {
    enable = mkBoolOpt false
      "Whether to enable xdg-open via portals in the desktop environment.";
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}