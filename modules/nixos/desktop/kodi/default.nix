{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.desktop.kodi;
in
{
  options.pluskinda.desktop.kodi = with types; {
    enable = mkBoolOpt false "Whether to enable the Kodi client as the desktop environment.";
  };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        desktopManager.kodi = {
          enable = true;
          package = pkgs.kodi.withPackages ( pkgs: with pkgs; [
            jellyfin
            pvr-hts
          ]);
        };
        displayManager.lightdm.greeter.enable = false;
      };
      displayManager.autoLogin = {
        enable = true;
        user = "kodi";
      };
    };

    users.extraUsers.kodi.isNormalUser = true;
  };
}