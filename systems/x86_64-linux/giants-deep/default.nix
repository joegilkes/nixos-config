{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;
{
  imports = [ 
    ./hardware.nix
    ./homepage.nix
    ./nextcloud.nix
    ./dawarich.nix
  ];

  networking.hostName = "giants-deep";

  pluskinda = {
    nix = {
       # Overwritten by Lix, use nix_2_18_upstream to go back
      package = pkgs.nixVersions.stable;

      extra-substituters = {
        "ssh-ng://builder".key = "timber-hearth:P0qnfshi3IsdI0gMkeFn3o1kik55uWpBqHaiYVC8UQY=";
      };
    };

    suites = {
      common = enabled;
      htpc = enabled;
      nas = enabled;
      tuning = enabled;
    };

    services = {
      openssh.allowPasswordAuth = false;
      samba = {
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
      calibre-web.libraryPath = "/mnt/gabbro/media/Books";
    };

    user.extraGroups = [ "jellyfin" "calibre" ];
  };

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
}