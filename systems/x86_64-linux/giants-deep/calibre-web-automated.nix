{ config, lib, ... }:

with lib;
with lib.pluskinda;
{
  age.secrets = {
    hardcover-api-token = {
      file = ../../../secrets/hardcover_api_token.age;
    };
  };

  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet) networks volumes;
  in
  { 
    autoEscape = true;

    containers.calibre_web_automated = {
      containerConfig = {
        image = "crocodilestick/calibre-web-automated:latest";
        networks = [ networks.cwa.ref ];
        publishPorts = [ "8083:8083" ];
        volumes = [
          "${volumes.cwa_config.ref}:/config"
          "${volumes.cwa_ingest.ref}:/cwa-book-ingest"
          "${volumes.cwa_library.ref}:/calibre-library"
          "${volumes.cwa_plugins.ref}:/config/.config/calibre/plugins"
        ];
        environments = {
          PUID = "1000";
          PGID = "1000";
          TZ = "UTC";
          NETWORK_SHARE_MODE = "false";
        };
        environmentFiles = [ config.age.secrets.hardcover-api-token.path ];
      };
      serviceConfig = {
        Restart = "always";
      };
    };

    networks.cwa = {};

    volumes = {
      cwa_config = {
        volumeConfig.device = "/mnt/gabbro/storage/calibre-web-automated/config";
        volumeConfig.driver = "local";
        volumeConfig.options = "bind";
      };
      cwa_ingest = {
        volumeConfig.device = "/mnt/gabbro/storage/calibre-web-automated/ingest";
        volumeConfig.driver = "local";
        volumeConfig.options = "bind";
      };
      cwa_library = {
        volumeConfig.device = "/mnt/gabbro/storage/calibre-web-automated/calibre-library";
        volumeConfig.driver = "local";
        volumeConfig.options = "bind";
      };
      cwa_plugins = {
        volumeConfig.device = "/mnt/gabbro/storage/calibre-web-automated/plugins";
        volumeConfig.driver = "local";
        volumeConfig.options = "bind";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8083 ];
}