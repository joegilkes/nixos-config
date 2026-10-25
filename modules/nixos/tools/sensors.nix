{ config, lib, pkgs, ... }:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

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
  };
}