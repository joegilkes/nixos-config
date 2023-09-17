{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.apps.steam;
in
{
  options.pluskinda.apps.steam = with types; {
    enable = mkBoolOpt false "Whether or not to enable support for Steam.";
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;
    programs.steam.remotePlay.openFirewall = true;

    hardware.steam-hardware.enable = true;

    environment.systemPackages = with pkgs; [
      steam
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    };
  };
}