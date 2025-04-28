{ config, lib, pkgs, ...}:

with lib;
with lib.pluskinda;
{
  age.secrets = {
    nextcloud-pass = {
      file = ../../../secrets/nextcloud-password.age;
      owner = "nextcloud";
    };
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;

    hostName = "localhost";
    https = true;
    
    home = "/mnt/gabbro/storage/nextcloud";
    database.createLocally = true;
    configureRedis = true;
    maxUploadSize = "16G";

    settings = {
      overwriteprotocol = "https";
      default_phone_region = "GB";
    };
    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = "${config.age.secrets.nextcloud-pass.path}";
    };

    autoUpdateApps.enable = true;
    extraApps = {
      inherit (pkgs.nextcloud31Packages.apps) mail calendar contacts phonetrack;
    };
  };

  services.nginx.virtualHosts."localhost".listen = [ { addr = "127.0.0.1"; port = 8084; } ];
  networking.firewall.allowedTCPPorts = [ 8084 ];
}