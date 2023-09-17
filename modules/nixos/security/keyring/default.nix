{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.security.keyring;
in
{
  options.pluskinda.security.keyring = with types; {
    enable = mkBoolOpt false "Whether to enable gnome keyring.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome.gnome-keyring
      gnome.libgnome-keyring
      gnome.seahorse
    ];

    # Technically could be in services but fits better here.
    services.gnome.gnome-keyring.enable = true;
  };
}