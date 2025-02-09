{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;
let
  
in
{
  age.secrets = {
    crowdsec_api_key_env = {
      file = ../../../secrets/crowdsec-api-key-env.age;
      owner = "crowdsec";
      group = "crowdsec";
    };
  };

  # Security Engine
  services.crowdsec = {
    enable = true;
    package = pkgs.crowdsec;
    # enrollKeyFile = 
    settings = {
      api.server = {
        listen_uri = "127.0.0.1:41412";
      };
    };
  };

  # Firewall Bouncer
  services.crowdsec-firewall-bouncer = {
    enable = true;
    settings = {
      api_key = "\${CROWDSEC_API_KEY}";
      api_url = "http://localhost:41412";
    };
  };
  systemd.services.crowdsec-firewall-bouncer = {
    serviceConfig.EnvironmentFile = config.age.secrets.crowdsec_api_key_env.path;
  };
  systemd.services.crowdsec = {
    serviceConfig = {
      ExecStartPre = let
        script = pkgs.writeScriptBin "register-bouncer" ''
          #!${pkgs.runtimeShell}
          set -eu
          set -o pipefail

          if ! cscli bouncers list | grep -q "iptables-bouncer"; then
            cscli bouncers add "iptables-bouncer" --key "''${CROWDSEC_API_KEY}"
          fi
        '';
      in ["${script}/bin/register-bouncer"];
      EnvironmentFile = config.age.secrets.crowdsec_api_key_env.path;
    };
  };
}