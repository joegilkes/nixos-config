{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.services.jellyfin;
in
{
  config = mkIf cfg.enable {
    services.jellyfin = {
      openFirewall = true;
    };
    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];
    users.users.jellyfin.extraGroups = [ "render" ];
  };
}