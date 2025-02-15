{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;
{
  age.secrets = {
    crowdsec_api_key_env = {
      file = ../../../secrets/crowdsec-api-key-env.age;
      owner = "crowdsec";
      group = "crowdsec";
    };
    crowdsec_enroll_key = {
      file = ../../../secrets/crowdsec-enroll-key.age;
      owner = "crowdsec";
      group = "crowdsec";
    };
  };

  # Security Engine
  services.crowdsec = {
    enable = true;
    package = pkgs.crowdsec;
    enrollKeyFile = config.age.secrets.crowdsec_enroll_key.path;
    allowLocalJournalAccess = true;
    acquisitions = [
      {
        source = "journalctl";
        journalctl_filter = [ "_SYSTEMD_UNIT=sshd.service" ];
        labels.type = "syslog";
      }
      {
        filenames = [ "/var/log/authelia/authelia.log" ];
        labels.type = "authelia";
      }
    ];
    settings = {
      api.server.listen_uri = "192.168.0.40:41412";
      crowdsec_service.acquisition_path = acquisitions_file;
    };
  };

  networking.firewall.allowedTCPPorts = [ 41412 ];

  systemd.services.crowdsec = {
    serviceConfig = {
      ExecStartPre = let
        collection_script = pkgs.writeScriptBin "register-collection" ''
          #!${pkgs.runtimeShell}
          set -eu
          set -o pipefail

          if ! cscli collections list | grep -q "crowdsecurity/linux"; then
            cscli collections install crowdsecurity/linux
          fi
          if ! cscli collections list | grep -q "authelia"; then
            cscli collections install LePresidente/authelia
          fi
        '';
        bouncer_script = pkgs.writeScriptBin "register-bouncer" ''
          #!${pkgs.runtimeShell}
          set -eu
          set -o pipefail

          if ! cscli bouncers list | grep -q "iptables-bouncer"; then
            cscli bouncers add "iptables-bouncer" --key "''${CROWDSEC_API_KEY}"
          fi
        '';
      in [
        "${collection_script}/bin/register-collection"
        "${bouncer_script}/bin/register-bouncer"
      ];
      EnvironmentFile = config.age.secrets.crowdsec_api_key_env.path;
    };
  };

  # Firewall Bouncer
  services.crowdsec-firewall-bouncer = {
    enable = true;
    settings = {
      api_key = "\${CROWDSEC_API_KEY}";
      api_url = "http://192.168.0.40:41412";
    };
  };
  systemd.services.crowdsec-firewall-bouncer = {
    serviceConfig.EnvironmentFile = config.age.secrets.crowdsec_api_key_env.path;
  };
}