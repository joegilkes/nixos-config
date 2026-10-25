{ pkgs, config, lib, ...}:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

{
  imports = [
    ../../../configuration.nix
    ./hardware.nix
    "${(import ../../../npins).musnix.outPath}/default.nix"
  ];

  networking.hostName = "timber-hearth";

  profiles = {
    common = enabled;
    desktop = enabled;
    benchmarking = enabled;
    browsers = enabled;
    creative = enabled;
    development = enabled;
    emulation = enabled;
    gamedev = enabled;
    gaming = enabled;
    media = enabled;
    social = enabled;
    tuning = enabled;
  };

  programs = {
    keymapp = enabled;
    microsoft-edge = enabled;
    usb-modeswitch = enabled;

    blender.gpuType = "amd";
    diagnostics.gpuType = "amd";
    star-citizen.location = "/beluga/Games/star-citizen";
  };

  services = {
    desktop.gnome = {
      extensions = [ pkgs.gnomeExtensions.tiling-shell ]; # Settings included but not applied.
      wallpaper.dark = pkgs.wallpapers.contour_bi_x3_test;
      enableExperimentalVRR = true;
    };
    openssh.allowPasswordAuth = false;

    glances = enabled;
    virtualisation = enabled;
  };

  hardware.tablet.enable = true;

  user.extraGroups = [ "optical" ];
  users.groups.optical = {};

  environment.sessionVariables = {
    RADV_PERFTEST = "gpl";
  };

  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 ];
  };


  # Enable this system as a local shared Nix store.
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
    useLix = true;
    extra-substituters = {
      "https://nix-gaming.cachix.org".key = "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=";
    };
    extraOptions = ''
      secret-key-files = /home/${config.user.name}/.nixos-cache-secrets/cache-priv-key.pem
    '';
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "23.05";
  home-manager.users.joe.home.stateVersion = "23.05";
}