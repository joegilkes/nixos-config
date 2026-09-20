{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.programs.fusee-nano;
in
{
  options.programs.fusee-nano = with types; {
    enable = mkBoolOpt false "Whether or not to enable fusee-nano.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      fusee-nano
    ];
  };
}