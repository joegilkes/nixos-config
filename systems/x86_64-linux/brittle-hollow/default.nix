{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;
{
  imports = [ ./hardware.nix ];

  networking.hostName = "brittle-hollow";

  pluskinda = {
    suites = {
      common = enabled;
      desktop = enabled;
      browsers = enabled;
      development = enabled;
      gaming = enabled;
      media = enabled;
      social = enabled;
    };
  };

  system.stateVersion = "23.05";
}