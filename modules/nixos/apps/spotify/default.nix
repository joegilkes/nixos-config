{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.spotify;
in
{
  options.programs.spotify = with types; {
    enable = mkBoolOpt false "Whether or not to enable Spotify.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      spotifywm
    ];
  };
}