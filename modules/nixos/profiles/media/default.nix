{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.profiles.media;
in
{
  options.profiles.media = with types; {
    enable = mkBoolOpt false "Whether or not to enable media apps.";
  };

  config = mkIf cfg.enable {
    programs = {
      calibre = enabled;
      # jellyfin = enabled; deprecated dependency, see app config.
      # kodi = enabled; no longer required.
      # spotify = enabled;
      tidal = enabled;
      vlc = enabled;
    };
  };
}
# Profile enabling media playback, library, and streaming applications.