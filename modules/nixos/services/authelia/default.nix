{ config, lib, pkgs, ...}:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.services.authelia;
  autheliaMain = config.services.authelia.instances.main;
in
{
  options.pluskinda.services.authelia = with types; {
    enable = mkBoolOpt false "Whether or not to configure Authelia for web auth.";
    port = mkOpt port 9091 "Port to run the Authelia through";
    secrets = mkOpt attrs {} "Secrets to pass to Authelia";
    envVars = mkOpt attrs {} "Environment variables to pass to Authelia";
    smtpAddress = mkOpt str "smtp://mail.smtp2go.com:2525" "Address of SMTP relay.";
    smtpUser = mkOpt str "mail" "Username to use with SMTP relay.";
  };

  config = mkIf cfg.enable { 
    environment.systemPackages = [ autheliaMain.package ];
    environment.etc = {
      "authelia/config/email_templates" = {
        source = ./templates;
        user = autheliaMain.user;
      };
    };

    pluskinda.user.extraGroups = [ "authelia" ];
    users.users.${autheliaMain.user}.extraGroups = [ "redis" "sendgrid" ];

    services.mysql = {
      enable = mkForce true;
      package = pkgs.mariadb_1011;
      ensureDatabases = [ "authelia" ];
      ensureUsers = [
        {
          name = autheliaMain.user;
          ensurePermissions = {
            "authelia.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    services.authelia.instances.main = {
      enable = true;
      secrets = cfg.secrets;
      environmentVariables = cfg.envVars;

      settings = {
        theme = "dark";
        default_2fa_method = "totp";
        server.address = "tcp://127.0.0.1:${toString cfg.port}";
        log = {
          level = "info";
          file_path = "/var/log/authelia/authelia.log";
          keep_stdout = true;
        };
        session = {
          cookies = [{
            domain = "joegilk.es";
            authelia_url = "https://auth.joegilk.es";
            default_redirection_url = "https://wilds.joegilk.es";
          }];
          redis = {
            host = config.services.redis.servers."".unixSocket;
            port = 0;
            database_index = 0;
          };
        };
        regulation = {
          max_retries = 3;
          find_time = 120;
          ban_time = 300;
        };
        authentication_backend = {
          refresh_interval = 120;
          ldap = {
            implementation = "custom";
            address = "ldap://localhost:3890";
            timeout = "10s";
            start_tls = false;
            base_dn = "dc=joegilk,dc=es";
            additional_users_dn = "ou=people";
            users_filter = "(&(|({username_attribute}={input})({mail_attribute}={input}))(objectClass=person))";
            additional_groups_dn = "ou=groups";
            groups_filter = "(member={dn})";
            user = "uid=admin,ou=people,dc=joegilk,dc=es";
            attributes = {
              display_name = "displayName";
              group_name = "cn";
              mail = "mail";
              username = "uid";
            };
          };
        };
        access_control = {
          default_policy = "deny";
          networks = [
            {
              name = "localhost";
              networks = [ "127.0.0.1/32" ];
            }
            # Internal devices only on 192.168.0.40 through 192.168.0.43
            {
              name = "internal";
              networks = [ "192.168.0.40/30" ];
            }
          ];
          rules = [
            {
              domain = "*.joegilk.es";
              policy = "bypass";
              networks = "localhost";
            }
            {
              domain = "*.joegilk.es";
              policy = "one_factor";
              networks = "internal";
            }
            {
              domain = "*.joegilk.es";
              policy = "two_factor";
            }
          ];
        };
        storage = {
          mysql = {
            address = "/run/mysqld/mysqld.sock";
            database = "authelia";
            username = autheliaMain.user;
          };
        };
        notifier = {
          disable_startup_check = false;
          smtp = {
            address = cfg.smtpAddress;
            username = cfg.smtpUser;
            sender = "auth@mail.joegilk.es";
          };
          template_path = "/etc/authelia/config/email_templates";
        };
      };
    };

    systemd.services."authelia-main".serviceConfig.LogsDirectory = "authelia";
  };
}