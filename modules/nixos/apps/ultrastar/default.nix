{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.ultrastar;
in
{
  options.programs.ultrastar = with types; {
    enable = mkBoolOpt false "Whether or not to enable Ultrastar Deluxe.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      ultrastardx
    ];
  };
}