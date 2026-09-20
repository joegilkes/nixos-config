{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.godot;
in
{
  options.programs.godot = with types; {
    enable = mkBoolOpt false "Whether or not to enable Godot.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ godot ]; };
}