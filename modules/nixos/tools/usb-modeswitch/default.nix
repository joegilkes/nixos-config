{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.usb-modeswitch;
in
{
  options.programs.usb-modeswitch = with types; {
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