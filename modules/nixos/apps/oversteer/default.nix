{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.oversteer;
in
{
  options.programs.oversteer = with types; {
    enable = mkBoolOpt false "Whether or not to enable Oversteer.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      oversteer
    ];
  };
}