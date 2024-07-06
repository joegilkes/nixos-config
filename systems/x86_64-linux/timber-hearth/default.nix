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
      creative = enabled;
      development = enabled;
      emulation = enabled;
      gaming = enabled;
      media = enabled;
      social = enabled;
      tuning = enabled;
      vr = enabled;
    };

    desktop.gnome.wallpaper.dark = pkgs.pluskinda.wallpapers.contour_bi_x3_test;

    apps.blender.gpuType = "amd";
    apps.keymapp = enabled;
    tools.diagnostics.gpuType = "amd";
    tools.usb-modeswitch = enabled;

    apps.star-citizen.location = "/beluga/Games/star-citizen";
  };

  # Enable this system as a local shared Nix store.
  nix.sshServe = {
    enable = true;
    keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILFz8ePAZAOD3JZh5AY+25dW+4L1dL4dnJ3JbvOxpqqi root@attlerock" ];
  };

  environment.sessionVariables = {
    RADV_PERFTEST = "gpl";
  };

  system.stateVersion = "23.05";
}