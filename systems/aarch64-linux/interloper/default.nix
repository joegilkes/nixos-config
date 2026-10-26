{ lib, ...}:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

{
  imports = [
    ../../../configuration.nix
    ./hardware.nix
    ./auth.nix
  ];

  nixpkgs.config.allowBroken = true;

  networking.hostName = "interloper";
  hardware.networking.enable = true;

  programs = {
    git = enabled;
    misc = enabled;
  };

  services = {
    avahi = enabled;
    # glances = enabled;
    openssh = {
      enable = true;
      allowPasswordAuth = false;
    };
  };

  security = {
    gpg = enabled;
    keyring = enabled;
  };

  system = {
    fonts = enabled;
    locale = enabled;
    time = enabled;
    kb = enabled;
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
    extra-substituters = {
      "ssh-ng://builder".key = "timber-hearth:P0qnfshi3IsdI0gMkeFn3o1kik55uWpBqHaiYVC8UQY=";
    };
    buildMachines = [ {
      hostName = "builder";
      system = "aarch64-linux";
      protocol = "ssh-ng";
      maxJobs = 12;
      speedFactor = 1;
      supportedFeatures = [ "big-parallel" ];
    } ];
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
      fallback = true
      connect-timeout = 5
    '';
  };

  system.stateVersion = "25.05";
  home-manager.users.joe.home.stateVersion = "25.05";
}