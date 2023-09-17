{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.steamtinkerlaunch;
in
{
  options.pluskinda.apps.steamtinkerlaunch = with types; {
    enable = mkBoolOpt false "Whether or not to enable SteamTinkerLaunch.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ steamtinkerlaunch ]; };
}