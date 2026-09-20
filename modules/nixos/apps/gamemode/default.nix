{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.gamemode;
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      gamemode
    ];

    # Gamemode GNOME extension not officially working for GNOME 45 yet.
    # See https://github.com/gicmo/gamemode-extension/issues/70
    # 
    # services.desktop.gnome.extensions = with pkgs; [
    #   gnomeExtensions.gamemode
    # ];
  };
}