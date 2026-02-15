{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.cli-apps.android-platform-tools;
in
{
  options.pluskinda.cli-apps.android-platform-tools = with types; {
    enable = mkBoolOpt false "Whether or not to enable Android Platform Tools (adb/fastboot).";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.android-tools ];
    pluskinda.user.extraGroups = [ "adbusers" ];
  };
}