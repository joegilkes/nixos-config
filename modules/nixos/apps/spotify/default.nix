{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.spotify;
in
{
  options.pluskinda.apps.spotify = with types; {
    enable = mkBoolOpt false "Whether or not to enable Spotify.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      spotifywm
    ];
  };
}