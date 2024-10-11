{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.kodi;
in
{
  options.pluskinda.apps.kodi = with types; {
    enable = mkBoolOpt false "Whether or not to enable the Kodi client.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      ( pkgs.kodi.withPackages ( kodiPkgs: with kodiPkgs; [
        jellyfin
        pvr-hts
      ]))
    ];
  };
}