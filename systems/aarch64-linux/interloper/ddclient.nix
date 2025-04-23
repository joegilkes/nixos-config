{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;

{
  users.groups = {
    ddclient-secrets = { };
  };

  age.secrets = {
    ddclient_password = {
      file = ../../../secrets/ddclient-password.age;
      owner = "ddclient-secrets";
      mode = "0440";
    };
  };

  services.ddclient = {
    enable = true;
    usev4 = "webv4, webv4=dynamicdns.park-your-domain.com/getip";
    protocol = "namecheap";
    server = "dynamicdns.park-your-domain.com";
    username = "joegilk.es";
    passwordFile = config.age.secrets.ddclient_password.path;
    domains = [
      "auth"
      "home"
      "traefik"
      "interloper"
      "giants-deep"
      "books"
    ];
  };
  systemd.services.ddclient.serviceConfig.SupplementaryGroups = [ "ddclient-secrets" ];
}