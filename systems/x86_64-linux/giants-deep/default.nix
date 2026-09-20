{ pkgs, config, lib, channel, ...}:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });
{
  imports = [
    ../../../configuration.nix
    ./hardware.nix
    "${(import ../../../npins).quadlet-nix.outPath}/nixos-module.nix"
    ./zed.nix
    ./homepage.nix
    # ./nextcloud.nix
    ./dawarich.nix
    ./calibre-web-automated.nix
  ];

  networking.hostName = "giants-deep";

  nix = {
    # Use Lix instead of Nix
    useLix = true;

    extra-substituters = {
      "ssh-ng://builder".key = "timber-hearth:P0qnfshi3IsdI0gMkeFn3o1kik55uWpBqHaiYVC8UQY=";
    };
  };

  profiles.common.enable = true;
  profiles.htpc.enable = true;
  profiles.nas.enable = true;
  profiles.tuning.enable = true;

  services.openssh.allowPasswordAuth = false;
  services.samba = {
    serverName = "NAS";
    privateShareDirs = {
      backups = "/mnt/gabbro/backups";
      media = "/mnt/gabbro/media";
      storage = "/mnt/gabbro/storage";
    };
    publicShareDirs = {
      public = "/mnt/gabbro/public";
    };
  };

  user.extraGroups = [ "jellyfin" "calibre" ];

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