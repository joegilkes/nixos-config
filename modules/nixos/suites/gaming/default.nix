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
        bs-manager = enabled;
        gamemode = enabled;
        gamescope = enabled;
        heroic-launcher = enabled;
        lutris = enabled;
        mangohud = enabled;
        # nexusmods-app = enabled; # disabled for now due to compilation errors
        oversteer = enabled;
        prismlauncher = enabled;
        protontricks = enabled;
        r2modman = enabled;
        # star-citizen = enabled; # disabled while there is a lix bug with npins dependency fetching
        steam = enabled;
        steamtinkerlaunch = enabled;
        winetricks = enabled;
      };

      cli-apps = {
        ffbtools = enabled;
        proton = enabled;
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