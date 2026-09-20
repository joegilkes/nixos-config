{  options, config, lib, pkgs, ... }:

# qtwebkit 5 is EOL and has a lot of vulnerabilities, needs to be explicitly allowed
# for jellyfin-media-player to be enabled.
# See https://github.com/NixOS/nixpkgs/issues/437865 for nixpkgs tracking and
# https://github.com/jellyfin/jellyfin-media-player/issues/282 for tracking the
# update to qtwebkit 6 for jellyfin media player

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.jellyfin;
in
{
  options.programs.jellyfin = with types; {
    enable = mkBoolOpt false "Whether or not to enable the Jellyfin client.";
  };

  config = mkIf cfg.enable { 
    environment.systemPackages = with pkgs; [ jellyfin-media-player ]; 
  };
}