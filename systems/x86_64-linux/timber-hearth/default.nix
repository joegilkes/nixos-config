{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;
{
  imports = [ ./hardware.nix ];

  networking.hostName = "timber-hearth";

  pluskinda = {
    nix = {
       # Overwritten by Lix, use nix_2_18_upstream to go back
      package = pkgs.nixVersions.stable;

      extra-substituters = {
      "https://nix-gaming.cachix.org".key = "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=";
      # Lix cache doesn't seem to be working yet?
      "https://cache.lix.systems".key = "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=";
      };
    };

    suites = {
      common = enabled;
      desktop = enabled;
      benchmarking = enabled;
      browsers = enabled;
      compchem = enabled;
      creative = enabled;
      development = enabled;
      emulation = enabled;
      gaming = enabled;
      media = enabled;
      social = enabled;
      tuning = enabled;
      vr = enabled;
    };

    desktop.gnome = {
      extensions = [ pkgs.gnomeExtensions.tiling-shell ]; # Settings included but not applied.
      wallpaper.dark = pkgs.pluskinda.wallpapers.contour_bi_x3_test;
      enableExperimentalVRR = true;
    };

    apps = {
      blender.gpuType = "amd";
      keymapp = enabled;
      microsoft-edge = enabled;
      star-citizen.location = "/beluga/Games/star-citizen";
    };

    tools = {
      diagnostics.gpuType = "amd";
      usb-modeswitch = enabled;
    };

    hardware.tablet = enabled;

    services = {
      glances = enabled;
      openssh.allowPasswordAuth = false;
      virtualisation = enabled;
    };
  };

  # Enable this system as a local shared Nix store.
  pluskinda.services.sshServe = {
    enable = true;
    write = true;
    trusted = true;
    protocol = "ssh-ng";
    keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILFz8ePAZAOD3JZh5AY+25dW+4L1dL4dnJ3JbvOxpqqi root@attlerock" ];
  };
  nix.extraOptions = ''
    secret-key-files = /home/${config.pluskinda.user.name}/.nixos-cache-secrets/cache-priv-key.pem
  '';

  environment.sessionVariables = {
    RADV_PERFTEST = "gpl";
  };

  system.stateVersion = "23.05";
}