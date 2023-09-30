{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;
{
  imports = [ ./hardware.nix ];

  services.xserver.videoDrivers = [ "amdgpu" ];

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
    };

    tools.diagnostics = enabled;
    tools.sensors = enabled;
  };

  system.stateVersion = "23.05";
}