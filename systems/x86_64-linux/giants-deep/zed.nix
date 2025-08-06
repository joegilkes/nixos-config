{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;

{
  age.secrets = {
    smtp2go_zed_pass = {
      file = ../../../secrets/smtp2go_zed_pass.age;
      mode = "0440";
    };
  };

  pluskinda.services.zfs = {
    useZedEmails = true;
    smtpUser = "giants-deep";
    smtpPassFile = config.age.secrets.smtp2go_zed_pass.path;
    smtpServer = "mail.smtp2go.com";
    smtpPort = 2525;
    smtpFrom = "zed@mail.joegilk.es";
    smtpTo = "joe@joegilk.es";
  };
}