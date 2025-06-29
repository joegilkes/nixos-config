{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;
{
  imports = [ 
    ./hardware.nix
    ./traefik.nix
    ./crowdsec.nix
    ./ddclient.nix
  ];

  networking.hostName = "interloper";

  pluskinda = {
    tools = {
      git = enabled;
      misc = enabled;
      rpi = enabled;
    };

    hardware = {
      networking = enabled;
    };

    services = {
      authelia = enabled;
      avahi = enabled;
      glances = {
        enable = true;
        refreshInterval = 5;
      };
      redis = {
        enable = true;
        databases = 1;
      };
      traefik = enabled;
      openssh = {
        enable = true;
        allowPasswordAuth = false;
      };
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