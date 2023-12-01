{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.gamemode;
in
{
  options.pluskinda.apps.gamemode = with types; {
    enable = mkBoolOpt false "Whether or not to enable Gamemode.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      gamemode
    ];

    # Gamemode GNOME extension not officially working for GNOME 45 yet.
    # See https://github.com/gicmo/gamemode-extension/issues/70
    # 
    # pluskinda.desktop.gnome.extensions = with pkgs; [
    #   gnomeExtensions.gamemode
    # ];
  };
}