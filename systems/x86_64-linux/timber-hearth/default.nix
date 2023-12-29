{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;
{
  imports = [ ./hardware.nix ];

  networking.hostName = "timber-hearth";

  pluskinda = {
    nix.extra-substituters = {
      "https://nix-gaming.cachix.org".key = "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=";
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
    };

    tools.diagnostics.gpuType = "amd";
    tools.usb-modeswitch = enabled;

    apps.star-citizen.location = "/beluga/Games/star-citizen";
  };

  services.xserver = {
    layout = mkForce "us";
  };

  system.stateVersion = "23.05";
}