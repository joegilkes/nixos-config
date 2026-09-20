{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.tidal;
in
{
  options.programs.tidal = with types; {
    enable = mkBoolOpt false "Whether or not to enable Tidal-HiFi.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      tidal-hifi
    ];
  };
}