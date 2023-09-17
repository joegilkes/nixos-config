{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.apps.vlc;
in
{
  options.pluskinda.apps.vlc = with types; {
    enable = mkBoolOpt false "Whether or not to enable vlc.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ vlc ]; };
}