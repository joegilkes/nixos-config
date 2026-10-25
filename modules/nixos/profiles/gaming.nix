{ config, lib, ... }:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

let 
  cfg = config.profiles.gaming;
in
{
  options.profiles.gaming = with types; {
    enable = mkBoolOpt false "Whether or not to enable gaming apps.";
  };

  config = mkIf cfg.enable {
    programs = {
      bottles = enabled;
      bs-manager = enabled;
      gamemode = enabled;
      heroic-launcher = enabled;
      lutris = enabled;
      mangohud = enabled;
      oversteer = enabled;
      prismlauncher = enabled;
      protonup-qt = enabled;
      r2modman = enabled;
      # star-citizen = enabled; # disabled while there is a lix bug with npins dependency fetching
      steam = enabled;
      steamtinkerlaunch = enabled;
      ultrastar = enabled;
      winetricks = enabled;
      ffbtools = enabled;
    };
    services.sunshine = enabled;

    nix.settings = {
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    };
  };
}