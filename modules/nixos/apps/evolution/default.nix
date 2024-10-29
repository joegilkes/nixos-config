{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.evolution;
in
{
  options.pluskinda.apps.evolution = with types; {
    enable = mkBoolOpt false "Whether or not to enable Evolution mail client.";
  };

  config = mkIf cfg.enable { 
    programs.evolution = {
      enable = true;
      plugins = with pkgs; [ evolution-ews ];
    };
  };
}