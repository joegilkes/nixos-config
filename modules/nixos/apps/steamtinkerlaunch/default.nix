{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.steamtinkerlaunch;
in
{
  options.programs.steamtinkerlaunch = with types; {
    enable = mkBoolOpt false "Whether or not to enable SteamTinkerLaunch.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ steamtinkerlaunch ]; };
}