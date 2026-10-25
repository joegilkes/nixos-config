{ config, lib, ... }:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

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
      jellyfin-media-player = enabled;
      tidal = enabled;
      vlc = enabled;
    };
  };
}
