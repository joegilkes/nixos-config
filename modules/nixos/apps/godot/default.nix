{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.godot;
in
{
  options.pluskinda.apps.godot = with types; {
    enable = mkBoolOpt false "Whether or not to enable Godot.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ godot ]; };
}