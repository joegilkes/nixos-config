{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.pixelorama;
in
{
  options.programs.pixelorama = with types; {
    enable = mkBoolOpt false "Whether or not to enable Pixelorama.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ pixelorama ]; };
}