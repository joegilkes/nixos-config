{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.services.jellyseerr;
in
{
  options.pluskinda.services.jellyseerr = with types; {
    enable = mkBoolOpt false "Whether to enable Jellyseerr and related services.";
    port = mkOpt port 5055 "Port to run Jellyseerr through";
    radarr-dataDir = mkOpt str "/var/lib/radarr/.config/Radarr" "Path for Radarr data files.";
    sonarr-dataDir = mkOpt str "/var/lib/sonarr/.config/NzbDrone" "Path for Sonarr data files.";
  };

  config = mkIf cfg.enable {
    services.jellyseerr = {
      enable = true;
      port = cfg.port;
      openFirewall = true;
    };

    services.radarr = {
      enable = true;
      openFirewall = true;
      user = "jellyfin";
      group = "jellyfin";
      dataDir = cfg.radarr-dataDir;
    };

    services.sonarr = {
      enable = true;
      openFirewall = true;
      user = "jellyfin";
      group = "jellyfin";
      dataDir = cfg.sonarr-dataDir;
    };
  };
}