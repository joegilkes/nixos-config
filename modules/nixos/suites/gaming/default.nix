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
        mangohud = enabled;
        prismlauncher = enabled;
        protontricks = enabled;
        star-citizen = enabled;
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

    nix.settings = {
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    };
  };
}