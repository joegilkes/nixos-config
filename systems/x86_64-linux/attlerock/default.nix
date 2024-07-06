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
      package = pkgs.nixVersions.stable;

      extra-substituters = {
        "ssh://builder".key = "timber-hearth:P0qnfshi3IsdI0gMkeFn3o1kik55uWpBqHaiYVC8UQY=";
      };
    };

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

  programs.ssh.extraConfig = ''
    Host builder
      HostName timber-hearth
      User nix-ssh
      IdentitiesOnly yes
      IdentityFile /root/.ssh/nixremote
  '';

  networking.extraHosts = ''
    192.168.0.36 timber-hearth
  '';

  nix = {
    buildMachines = [ {
      hostName = "builder";
      system = "x86_64-linux";
      protocol = "ssh";
      maxJobs = 12;
      speedFactor = 2;
      supportedFeatures = [ "big-parallel" ];
    }];
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  system.stateVersion = "24.05";
}