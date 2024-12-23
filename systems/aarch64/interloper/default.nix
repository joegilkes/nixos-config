{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;
{
  imports = [ ./hardware.nix ];

  networking.hostName = "interloper";

  pluskinda = {
    # Use CppNix rather than Lix until build server is connected.
    nix = {
      enable = true;
      package = pkgs.nixVersions.stable_upstream;
    };

    cli-apps = {
      flake = enabled;
    };

    tools = {
      git = enabled;
      misc = enabled;
      rpi = enabled;
    };

    hardware = {
      networking = enabled;
    };

    services = {
      avahi = enabled;
      openssh = enabled;
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
  };

  system.stateVersion = "25.05";
}