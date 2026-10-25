{ pkgs, lib, ...}:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

{
  imports = [
    ../../../configuration.nix
    ./hardware.nix
  ];

  networking.hostName = "attlerock";

  hardware.surface.enable = true;

  profiles = {
    common = enabled;
    desktop = enabled;
    browsers = enabled;
    development = enabled;
    media = enabled;
  };

  programs = {
    xournalpp = enabled;
    microsoft-edge = enabled;
    android-platform-tools.enable = mkForce false;
    fusee-nano = enabled;
  };

  services.desktop.gnome.wallpaper.dark = pkgs.wallpapers.contour_sunrise_bi;
  

  programs.ssh.extraConfig = ''
    Host builder
      HostName timber-hearth.local
      User nix-ssh
      IdentitiesOnly yes
      IdentityFile /root/.ssh/nixremote
      ControlMaster auto
      ControlPath /tmp/ssh-%r@%h:%p
      ControlPersist 120
  '';

  nix = {
    useLix = true;
    extra-substituters = {
      "ssh-ng://builder".key = "timber-hearth:P0qnfshi3IsdI0gMkeFn3o1kik55uWpBqHaiYVC8UQY=";
    };
    buildMachines = [ {
      hostName = "builder";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      maxJobs = 12;
      speedFactor = 2;
      supportedFeatures = [ "big-parallel" "kvm" "nixos-test" ];
    }];
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
      fallback = true
      connect-timeout = 5
    '';
  };

  system.stateVersion = "24.05";
  home-manager.users.joe.home.stateVersion = "24.05";
}