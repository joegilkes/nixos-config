{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;
{
  imports = [ ./hardware.nix ];

  networking.hostName = "attlerock";

  pluskinda = {
    hardware.surface = enabled;

    suites = {
      common = enabled;
      desktop = enabled;
      browsers = enabled;
      development = enabled;
      media = enabled;
    };

    cli-apps.android-platform-tools.enable = mkForce false;

    desktop.gnome.wallpaper.dark = pkgs.pluskinda.wallpapers.contour_sunrise_bi;
  };

  system.stateVersion = "24.05";
}