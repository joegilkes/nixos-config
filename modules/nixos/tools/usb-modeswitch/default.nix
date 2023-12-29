{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.tools.usb-modeswitch;
in
{
  options.pluskinda.tools.usb-modeswitch = with types; {
    enable = mkBoolOpt false "Whether or not to enable usb-modeswitch.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      usb-modeswitch
    ];

    services.udev.packages = with pkgs; [
      usb-modeswitch-data
    ];
  };
}