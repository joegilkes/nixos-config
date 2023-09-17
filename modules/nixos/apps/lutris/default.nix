{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.apps.lutris;
in
{
  options.pluskinda.apps.lutris = with types; {
    enable = mkBoolOpt false "Whether or not to enable Lutris.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
      # Needed for some installers.
      openssl
      gnome.zenity
    ];
  };
}