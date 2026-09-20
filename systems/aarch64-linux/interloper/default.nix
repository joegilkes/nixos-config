{ pkgs, config, lib, channel, ...}:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });
{
  imports = [
    ../../../configuration.nix
    ./hardware.nix
    ./traefik.nix
    ./ddclient.nix
  ];

  nixpkgs.config.allowBroken = true;

  networking.hostName = "interloper";

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

  programs.git.enable = true;
  programs.misc.enable = true;

  hardware.networking.enable = true;

  services.authelia.enable = true;
  services.avahi.enable = true;
  services.glances.enable = true;
  services.redis.servers."".enable = true;
  services.redis.servers."".databases = 1;
  services.traefik.enable = true;
  services.openssh.enable = true;
  services.openssh.allowPasswordAuth = false;

  security.gpg.enable = true;
  security.keyring.enable = true;

  system.fonts.enable = true;
  system.locale.enable = true;
  system.time.enable = true;
  system.kb.enable = true;

  system.stateVersion = "25.05";
  home-manager.users.joe.home.stateVersion = "25.05";
}