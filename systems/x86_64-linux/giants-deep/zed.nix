{ config, lib, ...}:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

{
  age.secrets = {
    smtp2go_zed_pass = {
      file = ../../../secrets/smtp2go_zed_pass.age;
      mode = "0440";
    };
  };

  services.zfs = {
    useZedEmails = true;
    smtpUser = "giants-deep";
    smtpPassFile = config.age.secrets.smtp2go_zed_pass.path;
    smtpServer = "mail-eu.smtp2go.com";
    smtpPort = 443;
    smtpFrom = "zed@mail.joegilk.es";
    smtpTo = "joe@joegilk.es";
  };
}