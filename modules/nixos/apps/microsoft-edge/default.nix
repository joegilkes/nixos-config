{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.microsoft-edge;
in
{
  options.programs.microsoft-edge = with types; {
    enable = mkBoolOpt false "Whether or not to enable Microsoft Edge.";
  };

  config =
    mkIf cfg.enable { 
      environment.systemPackages = with pkgs; [ microsoft-edge ];
    };
}