{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.suites.emulation;
in
{
  options.pluskinda.suites.emulation = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable emulation configuration.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      apps = {
        # dolphin = enabled;  Disabled while not being used and it keeps recompiling from scratch.
        eden = enabled;
        ryujinx = enabled;
        pcsx2 = enabled;
        rpcs3 = enabled;
      };
      cli-apps = {
        fusee-nano = enabled;
      };

      user.extraGroups = [ "nintendo_switch" ];
    };

    users.groups = {
      nintendo_switch = { };
    };

    services.udev.extraRules = ''
      # Nintendo Switch RCM injection
      SUBSYSTEMS=="usb", ATTRS{manufacturer}=="NVIDIA Corp.", ATTRS{product}=="APX", GROUP="nintendo_switch"
      # nxdumptool USB dumping
      SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", TAG+="uaccess", MODE="0666"
    '';
  };
}