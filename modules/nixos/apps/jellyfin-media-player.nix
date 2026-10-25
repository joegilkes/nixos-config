{ config, lib, pkgs, ... }:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

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