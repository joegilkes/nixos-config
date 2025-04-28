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
    
    home = "/mnt/gabbro/nextcloud";
    database.createLocally = true;
    configureRedis = true;
    maxUploadSize = "16G";

    settings = {
      overwriteprotocol = "https";
      default_phone_region = "GB";
      trusted_proxies = [ "192.168.0.40" ];
      trusted_domains = [
        "cloud.joegilk.es"
        "192.168.0.41"
      ];
    };
    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = "${config.age.secrets.nextcloud-pass.path}";
    };

    appstoreEnable = false;
    extraApps = {
      inherit (pkgs.nextcloud31Packages.apps) mail calendar contacts phonetrack;
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}