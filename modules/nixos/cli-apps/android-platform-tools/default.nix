{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.android-platform-tools;
in
{
  options.programs.android-platform-tools = with types; {
    enable = mkBoolOpt false "Whether or not to enable Android Platform Tools (adb/fastboot).";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.android-tools ];
    user.extraGroups = [ "adbusers" ];
  };
}