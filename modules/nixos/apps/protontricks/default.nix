{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.programs.protontricks;
in
{
  options.programs.protontricks = with types; {
    enable = mkBoolOpt false "Whether or not to enable Protontricks.";
  };

  config = mkIf cfg.enable { 
    environment.systemPackages = with pkgs; [ protontricks ]; 
  };
}