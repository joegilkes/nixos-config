{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.pixelorama;
in
{
  options.pluskinda.apps.pixelorama = with types; {
    enable = mkBoolOpt false "Whether or not to enable Pixelorama.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ pixelorama ]; };
}