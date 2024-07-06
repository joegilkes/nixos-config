{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;
{
  imports = [ ./hardware.nix ];

  networking.hostName = "attlerock";

  pluskinda = {
    hardware.surface = enabled;

    nix = {
      # Overwritten by Lix, use nix_2_18_upstream to go back
      # package = pkgs.nixVersions.stable;

      extra-substituters = {
        "ssh://joe@timber-hearth".key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJuGmKSUGo325hD/w/uWN2sBQklwkG06K4v3fsB11O3 joe@timber-hearth";
      };
    };
    networking.extraHosts = ''
      192.168.0.36 timber-hearth
    '';

    suites = {
      common = enabled;
      desktop = enabled;
      browsers = enabled;
      development = enabled;
      media = enabled;
    };

    cli-apps.android-platform-tools.enable = mkForce false;

    desktop.gnome.wallpaper.dark = pkgs.pluskinda.wallpapers.contour_sunrise_bi;
    desktop.gnome.extensions = with pkgs; [ gnomeExtensions.gjs-osk ];
  };

  system.stateVersion = "24.05";
}