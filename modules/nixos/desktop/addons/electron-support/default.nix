{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.services.desktop.addons.electron-support;
in
{
  options.services.desktop.addons.electron-support = with types; {
    enable = mkBoolOpt false
      "Whether to enable electron support in the desktop environment.";
  };

  config = mkIf cfg.enable {
    home.configFile."electron-flags.conf".source =
      ./electron-flags.conf;

    environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };
  };
}