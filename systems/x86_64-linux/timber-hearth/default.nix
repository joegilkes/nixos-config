{ pkgs, config, lib, channel, ...}:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });
{
  imports = [
    ../../../configuration.nix
    ./hardware.nix
    "${(import ../../../npins).musnix.outPath}/default.nix"
  ];

  networking.hostName = "timber-hearth";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nix = {
    # Use Lix instead of Nix
    useLix = true;


    extra-substituters = {
      "https://nix-gaming.cachix.org".key = "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=";
    };
  };

  profiles.common.enable = true;
  profiles.desktop.enable = true;
  profiles.benchmarking.enable = true;
  profiles.browsers.enable = true;
  profiles.creative.enable = true;
  profiles.development.enable = true;
  profiles.emulation.enable = true;
  profiles.gamedev.enable = true;
  profiles.gaming.enable = true;
  profiles.media.enable = true;
  profiles.social.enable = true;
  profiles.tuning.enable = true;
  profiles.vr.enable = true;

  services.desktop.gnome = {
    extensions = [ pkgs.gnomeExtensions.tiling-shell ]; # Settings included but not applied.
    wallpaper.dark = pkgs.wallpapers.contour_bi_x3_test;
    enableExperimentalVRR = true;
  };

  programs.blender.gpuType = "amd";
  programs.keymapp.enable = true;
  programs.microsoft-edge.enable = true;
  programs.star-citizen.location = "/beluga/Games/star-citizen";

  programs.diagnostics.gpuType = "amd";
  programs.usb-modeswitch.enable = true;

  hardware.tablet.enable = true;

  services.glances.enable = true;
  services.openssh.allowPasswordAuth = false;
  services.virtualisation.enable = true;

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
  nix.extraOptions = ''
    secret-key-files = /home/${config.user.name}/.nixos-cache-secrets/cache-priv-key.pem
  '';

  environment.sessionVariables = {
    RADV_PERFTEST = "gpl";
  };

  user.extraGroups = [ "optical" ];
  users.groups.optical = {};

  networking.firewall = {
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [ 25565 ];
  };

  system.stateVersion = "23.05";
  home-manager.users.joe.home.stateVersion = "23.05";
}