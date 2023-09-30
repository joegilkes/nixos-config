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
      browsers = enabled;
      creative = enabled;
      development = enabled;
      emulation = enabled;
      gaming = enabled;
      media = enabled;
      social = enabled;
      tuning = enabled;
    };
  };

  system.stateVersion = "23.05";
}