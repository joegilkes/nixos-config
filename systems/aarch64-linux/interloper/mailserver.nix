{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;
{
  age.secrets = {
    mailserver_pass_hash = {
      file = ../../../secrets/mailserver-password-hash.age;
    };
  };

  mailserver = {
    enable = true;
    enableImap = false;
    enableImapSsl = false;

    fqdn = "mail.joegilk.es";
    domains = [ "wilds.joegilk.es" ];
    certificateScheme = "acme-nginx";

    loginAccounts = {
      "auth@wilds.joegilk.es" = {
        hashedPasswordFile = config.age.secrets.mailserver_pass_hash.path;
        aliases = [ "postmaster@wilds.joegilk.es" ];
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "joe@joegilk.es";
  };
}