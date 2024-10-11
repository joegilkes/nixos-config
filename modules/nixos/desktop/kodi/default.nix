{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.desktop.kodi;
in
{
  options.pluskinda.desktop.kodi = with types; {
    enable = mkBoolOpt false "Whether to enable the Kodi client as the desktop environment."
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.kodi = {
        enable = true;
        package = pkgs.kodi.withPackages ( pkgs: with pkgs; [
          jellyfin
          pvr-hts
        ]);
      };
      displayManager = {
        autoLogin = {
          enable = true;
          user = "kodi";
        };
        lightdm.greeter.enable = false;
      };
    };

    users.extraUsers.kodi.isNormalUser = true;
  };
}