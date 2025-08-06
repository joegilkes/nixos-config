{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.services.zfs;
in
{
  options.pluskinda.services.zfs = with types; {
    enable = mkBoolOpt false "Whether to enable ZFS services.";
    useZedEmails = mkBoolOpt false "Whether to send event emails from the ZFS event daemon (ZED).";
    smtpUser = mkOpt str "zed" "Username for ZED on SMTP relay.";
    smtpPassFile = mkOpt str "" "Password file for SMTP relay.";
    smtpServer = mkOpt str "" "SMTP relay address.";
    smtpPort = mkOpt int 25 "SMTP relay port.";
    smtpFrom = mkOpt str "" "Email address to send ZED emails from.";
  };

  config = mkIf cfg.enable {
    services.zfs = {
      autoScrub = enabled;
      trim = enabled;

      zed = mkIf cfg.useZedEmails {
        settings = {
          ZED_DEBUG_LOG = "/tmp/zed.debug.log";
          ZED_EMAIL_ADDR = [ "root" ];
          ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
          ZED_EMAIL_OPTS = "@ADDRESS@";

          ZED_NOTIFY_INTERVAL_SECS = 3600;
          ZED_NOTIFY_VERBOSE = true;

          ZED_USE_ENCLOSURE_LEDS = true;
          ZED_SCRUB_AFTER_RESILVER = true;
        };
        enableMail = false;
      };
    };

    programs.msmtp = mkIf cfg.useZedEmails {
      enable = true;
      setSendmail = true;
      accounts.default = {
        auth = true;
        tls = true;
        tls_starttls = false;
        host = cfg.smtpServer;
        port = cfg.smtpPort;
        user = cfg.smtpUser;
        passwordeval = "${pkgs.coreutils}/bin/cat ${smtpPassFile}";
      };
    };

    environment.etc = mkIf cfg.useZedEmails {
      aliases.text = ''
        root: ${cfg.smtpFrom}
      '';
    };
  };
}