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
      inherit (pkgs.nextcloud31Packages.apps) mail calendar contact;
      # phonetrack = pkgs.fetchNextcloudApp {
      #   name = "phonetrack";
      #   sha256 = "0qf366vbahyl27p9mshfma1as4nvql6w75zy2zk5xwwbp343vsbc";
      #   url = "https://gitlab.com/eneiluj/phonetrack-oc/-/wikis/uploads/931aaaf8dca24bf31a7e169a83c17235/phonetrack-0.6.9.tar.gz";
      #   version = "0.6.9";
      # };
    };
  };

  services.nginx.virtualHosts."localhost".listen = [ { addr = "127.0.0.1"; port = 8084; } ];
  networking.firewall.allowedTCPPorts = [ 8084 ];
}