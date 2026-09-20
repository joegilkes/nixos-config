{ pkgs, config, lib, channel, ...}:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });
{
  imports = [
    ../../../configuration.nix
    ./hardware.nix
  ];

  networking.hostName = "brittle-hollow";

  nix = {
    # Use Lix instead of Nix
    useLix = true;

    extra-substituters = {
      "ssh-ng://builder".key = "timber-hearth:P0qnfshi3IsdI0gMkeFn3o1kik55uWpBqHaiYVC8UQY=";
    };
  };

  profiles.common.enable = true;
  profiles.desktop.enable = true;
  profiles.browsers.enable = true;
  profiles.development.enable = true;
  profiles.media.enable = true;
  profiles.social.enable = true;

  services.virtualisation.enable = true;

  services.openssh.settings = {
    AllowTCPForwarding = "yes";
    PermitTunnel = "yes";
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

  user.extraGroups = [ "optical" ];
  users.groups.optical = {};

  system.stateVersion = "23.05";
  home-manager.users.joe.home.stateVersion = "23.05";
}