{ options, config, pkgs, lib, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.hardware.surface;
in
{
  options.pluskinda.hardware.surface = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable additional support for Microsoft Surface devices.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libwacom-surface
      libcamera 
    ];
  };
}