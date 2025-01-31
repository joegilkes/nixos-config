{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.suites.media;
in
{
  options.pluskinda.suites.media = with types; {
    enable = mkBoolOpt false "Whether or not to enable media apps.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      apps = {
        calibre = enabled;
        jellyfin = enabled;
        kodi = enabled;
        spotify = enabled;
        vlc = enabled;
      };
    };
  };
}