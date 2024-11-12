{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.suites.desktop;
in
{
  options.pluskinda.suites.desktop = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable common desktop configuration.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      desktop = {
        gnome = enabled;
        addons = { wallpapers = enabled; };
      };
      apps = {
        proton-pass = enabled;
      };
    };
  };
}