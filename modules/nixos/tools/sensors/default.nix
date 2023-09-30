{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.tools.sensors;
  gnome = config.pluskinda.desktop.gnome;
in
{
  options.pluskinda.tools.sensors = with types; {
    enable = mkBoolOpt false "Whether or not to enable lm_sensors.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lm_sensors
    ];

    pluskinda.desktop.gnome.extensions = mkIf gnome.enable [ pkgs.gnomeExtensions.sensory-perception ];
  };
}