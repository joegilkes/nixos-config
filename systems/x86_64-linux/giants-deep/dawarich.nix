{ config, lib, ... }:

with lib;
with lib.pluskinda;
{
  age.secrets = {
    dawarich-db-password = {
      file = ../../../secrets/dawarich-db-password.age;
      owner = "nextcloud";
    };
  };

  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet) containers networks volumes;
  in
  { 
    # This seems to break things.
    # autoEscape = true;

    containers.dawarich_redis = {
      containerConfig = {
        image = "redis:7.4-alpine";
        exec = "redis-server";
        networks = [ networks.dawarich.ref ];
        volumes = [ "${volumes.dawarich_shared.ref}:/data" ];

        healthCmd = "redis-cli --raw incr ping";
        healthInterval = "10s";
        healthRetries = 5;
        healthStartPeriod = "30s";
        healthTimeout = "10s";
        notify = "healthy";
      };
    };

    containers.dawarich_db = {
      containerConfig = {
        image = "postgis/postgis:17-3.5-alpine";
        networks = [ networks.dawarich.ref ];
        volumes = [ 
          "${volumes.dawarich_db_data.ref}:/var/lib/postgresql/data"
          "${volumes.dawarich_shared.ref}:/var/shared"
        ];
        environments = {
          POSTGRES_USER = "postgres";
          POSTGRES_DB = "dawarich_development";
        };
        environmentFiles = [ config.age.secrets.dawarich-db-password.path ];
        shmSize = "1gb";

        healthCmd = "pg_isready -U postgres -d dawarich_development";
        healthInterval = "10s";
        healthRetries = 5;
        healthStartPeriod = "30s";
        healthTimeout = "10s";
        notify = "healthy";
      };
    };

    containers.dawarich_app = {
      containerConfig = {
        image = "freikin/dawarich:latest";
        exec = "bin/rails server -p 3000 -b ::";
        entrypoint = "web-entrypoint.sh";
        networks = [ networks.dawarich.ref ];
        publishPorts = [ "3000:3000" ];
        volumes = [
          "${volumes.dawarich_public.ref}:/var/app/public"  
          "${volumes.dawarich_watched.ref}:/var/app/tmp/imports/watched"
          "${volumes.dawarich_storage.ref}:/var/app/storage"
          "${volumes.dawarich_db_data.ref}:/dawarich_db_data"
        ];
        environments = {
          RAILS_ENV = "development";
          REDIS_URL = "redis://dawarich_redis:6379";
          DATABASE_HOST = "dawarich_db";
          DATABASE_USERNAME = "postgres";
          DATABASE_NAME = "dawarich_development";
          MIN_MINUTES_SPENT_IN_CITY = "60";
          APPLICATION_HOSTS = "localhost,maps.joegilk.es";
          TIME_ZONE = "Europe/London";
          APPLICATION_PROTOCOL = "http";
          PROMETHIUS_EXPORTER_ENABLED = "false";
          PROMETHIUS_EXPORTER_HOST = "0.0.0.0";
          PROMETHIUS_EXPORTER_PORT = "9394";
          SELF_HOSTED = "true";
          STORE_GEODATA = "true";
          PHOTON_API_HOST = "localhost:2322";
          PHOTON_API_USE_HTTPS = "false";
        };
        environmentFiles = [ config.age.secrets.dawarich-db-password.path ];
        logDriver = "json-file";
        podmanArgs = [
          "--attach stdin"
          "--log-opt 'max-size=100m'"
          "--log-opt 'max-file=5'"
          "--tty"
        ];

        healthCmd = "wget -qO - http://127.0.0.1:3000/api/v1/health | grep -q '\"status\"\s*:\s*\"ok\"'";
        healthInterval = "10s";
        healthRetries = 30;
        healthStartPeriod = "30s";
        healthTimeout = "10s";
        notify = "healthy";
      };
      serviceConfig = {
        Restart = "on-failure";
      };
      unitConfig = {
        After = [
          containers.dawarich_db.ref
          containers.dawarich_redis.ref
        ];
        Requires = [
          containers.dawarich_db.ref
          containers.dawarich_redis.ref
        ];
      };
    };

    containers.dawarich_sidekiq = {
      containerConfig = {
        image = "freikin/dawarich:latest";
        exec = "sidekiq";
        entrypoint = "sidekiq-entrypoint.sh";
        networks = [ networks.dawarich.ref ];
        volumes = [
          "${volumes.dawarich_public.ref}:/var/app/public"
          "${volumes.dawarich_watched.ref}:/var/app/tmp/imports/watched"
          "${volumes.dawarich_storage.ref}:/var/app/storage"
        ];
        environments = {
          RAILS_ENV = "development";
          REDIS_URL = "redis://dawarich_redis:6379";
          DATABASE_HOST = "dawarich_db";
          DATABASE_USERNAME = "postgres";
          DATABASE_NAME = "dawarich_development";
          APPLICATION_HOSTS = "localhost,maps.joegilk.es";
          BACKGROUND_PROCESSING_CONCURRENCY = "10";
          APPLICATION_PROTOCOL = "http";
          PROMETHIUS_EXPORTER_ENABLED = "false";
          PROMETHIUS_EXPORTER_HOST = "dawarich_app";
          PROMETHIUS_EXPORTER_PORT = "9394";
          SELF_HOSTED = "true";
          STORE_GEODATA = "true";
          PHOTON_API_HOST = "localhost:2322";
          PHOTON_API_USE_HTTPS = "false";
        };
        environmentFiles = [ config.age.secrets.dawarich-db-password.path ];
        logDriver = "json-file";
        podmanArgs = [
          "--attach stdin"
          "--log-opt 'max-size=100m'"
          "--log-opt 'max-file=5'"
          "--tty"
        ];

        healthCmd = "pgrep -f sidekiq";
        healthInterval = "10s";
        healthRetries = 30;
        healthStartPeriod = "30s";
        healthTimeout = "10s";
      };
      serviceConfig = {
        Restart = "on-failure";
      };
      unitConfig = {
        After = [
          containers.dawarich_db.ref
          containers.dawarich_redis.ref
          containers.dawarich_app.ref
        ];
        Requires = [
          containers.dawarich_db.ref
          containers.dawarich_redis.ref
          containers.dawarich_app.ref
        ];
      };
    };

    containers.photon = {
      containerConfig = {
        image = "ghcr.io/rtuszik/photon-docker:latest";
        networks = [ networks.dawarich.ref ];
        publishPorts = [ "2322:2322" ];
        volumes = [ "${volumes.photon_data.ref}:/photon/photon_data" ];
        environments = {
          UPDATE_STRATEGY = "PARALLEL";
          UPDATE_INTERVAL = "24h";
          LOG_LEVEL = "INFO";
        };
      };
      serviceConfig = {
        Restart = "unless-stopped";
      };
    };

    networks.dawarich = {};

    volumes = {
      dawarich_shared = {
        volumeConfig.device = "/mnt/gabbro/storage/dawarich/shared";
        volumeConfig.driver = "local";
        volumeConfig.options = "bind";
      };
      dawarich_db_data = {
        volumeConfig.device = "/mnt/gabbro/storage/dawarich/db_data";
        volumeConfig.driver = "local";
        volumeConfig.options = "bind";
      };
      dawarich_public = {
        volumeConfig.device = "/mnt/gabbro/storage/dawarich/public";
        volumeConfig.driver = "local";
        volumeConfig.options = "bind";
      };
      dawarich_watched = {
        volumeConfig.device = "/mnt/gabbro/storage/dawarich/watched";
        volumeConfig.driver = "local";
        volumeConfig.options = "bind";
      };
      dawarich_storage = {
        volumeConfig.device = "/mnt/gabbro/storage/dawarich/storage";
        volumeConfig.driver = "local";
        volumeConfig.options = "bind";
      };
      photon_data = {
        volumeConfig.device = "/mnt/gabbro/storage/dawarich/photon_data";
        volumeConfig.driver = "local";
        volumeConfig.options = "bind";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 2322 3000 ];
}
