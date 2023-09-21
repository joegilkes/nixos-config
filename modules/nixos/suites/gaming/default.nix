{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.suites.gaming;
in
{
  options.pluskinda.suites.gaming = with types; {
    enable = mkBoolOpt false "Whether or not to enable gaming apps.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      apps = {
        bottles = enabled;
        gamemode = enabled;
        gamescope = enabled;
        lutris = enabled;
        prismlauncher = enabled;
        protontricks = enabled;
        steam = enabled;
        steamtinkerlaunch = enabled;
        winetricks = enabled;
      };

      cli-apps = {
        proton = enabled;
        wine = enabled;
      };

      services = {
        sunshine = enabled;
      };
    };
  };
}