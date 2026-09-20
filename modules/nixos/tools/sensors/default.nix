{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.sensors;
in
{
  options.programs.sensors = with types; {
    enable = mkBoolOpt false "Whether or not to enable lm_sensors.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lm_sensors
    ];

    # Sensory Perception GNOME extension not working for GNOME 45 yet.
    # Maintainer doesn't seem likely to update this anytime soon.
    # See https://github.com/HarlemSquirrel/gnome-shell-extension-sensory-perception/issues/49
    # 
    # services.desktop.gnome.extensions = [ pkgs.gnomeExtensions.sensory-perception ];
  };
}