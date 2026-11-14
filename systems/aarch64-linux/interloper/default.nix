{ config, lib, ...}:

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

  # Somehow this has been set at some point and now can't be unset easily.
  users.users."joe".uid = mkForce 1001;

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

  # Enable this system as a local shared Nix store - allows timber-hearth to 
  # fetch already built packages when building this system.
  services.sshServe = {
    enable = true;
    write = true;
    trusted = true;
    protocol = "ssh-ng";
    keys = [
      # Shared remote-builder key used by the local system configurations.
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILFz8ePAZAOD3JZh5AY+25dW+4L1dL4dnJ3JbvOxpqqi root@attlerock"
    ];
  };

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
      secret-key-files = /home/${config.user.name}/.nixos-cache-secrets/cache-priv-key.pem
    '';
  };

  system.stateVersion = "25.05";
  home-manager.users.joe.home.stateVersion = "25.05";
}