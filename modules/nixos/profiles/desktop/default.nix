{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.profiles.desktop;
in
{
  options.profiles.desktop = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable common desktop configuration.";
  };

  config = mkIf cfg.enable {
    services.desktop = {
      gnome = enabled;
      addons = { wallpapers = enabled; };
    };
    programs = {
      proton-pass = enabled;
      appimage = enabled;
    };
  };
}
# Profile composing the graphical desktop environment and desktop services.