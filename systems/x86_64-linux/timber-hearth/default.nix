{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;
{
  imports = [ ./hardware.nix ];

  networking.hostName = "timber-hearth";

  pluskinda = {
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
  };

  services.xserver = {
    layout = mkForce "us";
  };

  system.stateVersion = "23.05";
}