{ pkgs, config, lib, ...}:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

let
  autheliaInstance = config.services.authelia.instances.main;
  autheliaUser = autheliaInstance.user;
  autheliaPort = 9091;
  lldapHttpPort = config.services.lldap.settings.http_port;
  lldapInternalPort = config.services.lldap.settings.ldap_port;
in
{
  users.groups = {
    lldap-secrets = { };
    mailrelay = { };
  };

  age.secrets = {
    authelia_jwt_secret = {
      file = ../../../secrets/authelia-jwt.age;
      owner = autheliaUser;
    };
    authelia_hmac_secret = {
      file = ../../../secrets/authelia-hmac.age;
      owner = autheliaUser;
    };
    authelia_issuer_priv_key = {
      file = ../../../secrets/authelia-issuer.age;
      owner = autheliaUser;
    };
    authelia_session_secret = {
      file = ../../../secrets/authelia-session.age;
      owner = autheliaUser;
    };
    authelia_storage_encryption_secret = {
      file = ../../../secrets/authelia-storage.age;
      owner = autheliaUser;
    };
    authelia_mysql_password = {
      file = ../../../secrets/authelia-mysql.age;
      owner = autheliaUser;
    };
    authelia_ldap_password = {
      file = ../../../secrets/authelia-ldap-password.age;
      owner = autheliaUser;
    };
    lldap_key_seed = {
      file = ../../../secrets/lldap-key-seed.age;
      group = "lldap-secrets";
      mode = "0440";
    };
    lldap_jwt_secret = {
      file = ../../../secrets/lldap-jwt.age;
      group = "lldap-secrets";
      mode = "0440";
    };
    lldap_user_pass = {
      file = ../../../secrets/lldap-user-password.age;
      group = "lldap-secrets";
      mode = "0440";
    };
    smtp2go_pass = {
      file = ../../../secrets/smtp2go_pass.age;
      group = "mailrelay";
      mode = "0440";
    };
  };

  # SQL Database
  services.mysql = {
    enable = mkForce true;
    package = pkgs.mariadb_1011;
    ensureDatabases = [ "authelia" ];
    ensureUsers = [
      {
        name = autheliaUser;
        ensurePermissions = {
          "authelia.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  # Redis Database
  services.redis.servers."" = {
    enable = true;
    databases = 1;
  };

  # LDAP Server
  services.lldap = {
    enable = true;
    settings = {
      ldap_base_dn = "dc=joegilk,dc=es";
      ldap_user_pass_file = config.age.secrets.lldap_user_pass.path;
      jwt_secret_file = config.age.secrets.lldap_jwt_secret.path;
      force_ldap_user_pass_reset = "always";
    };
  };
  systemd.services.lldap.serviceConfig.SupplementaryGroups = [ "lldap-secrets" ];

  # SMTP Relay
  programs.msmtp = {
    enable = true;
    accounts.default = {
      auth = true;
      tls = true;
      tls_starttls = false;
      host = "mail.smtp2go.com";
      port = 2525;
      user = "interloper";
      passwordeval = "${pkgs.coreutils}/bin/cat ${config.age.secrets.smtp2go_pass.path}";
    };
  };

  # Authelia
  services.authelia.instances.main = {
    enable = true;

    settings = {
      theme = "dark";
      default_2fa_method = "totp";
      server.address = "tcp://192.168.0.40:${toString autheliaPort}";

      log = {
        level = "info";
        file_path = "/var/log/authelia/authelia.log";
        keep_stdout = true;
      };

      session = {
        cookies = [{
          domain = "joegilk.es";
          authelia_url = "https://auth.joegilk.es";
          default_redirection_url = "https://home.joegilk.es";
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
          address = "ldap://localhost:${toString lldapInternalPort}";
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
            name = "home";
            networks = [ "192.168.0.0/24" "10.10.10.0/24" ];
          }
        ];
        rules = [
          {
            domain = "books.joegilk.es";
            policy = "bypass";
            networks = [ "home" ];
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
          username = autheliaUser;
        };
      };

      notifier = {
        disable_startup_check = false;
        smtp = {
          address = "smtp://mail.smtp2go.com:2525";
          username = "interloper";
          sender = "auth@mail.joegilk.es";
        };
        template_path = "/etc/authelia/config/email_templates";
      };
    };

    secrets = {
      jwtSecretFile = config.age.secrets.authelia_jwt_secret.path;
      # oidcHmacSecretFile = config.age.secrets.authelia_hmac_secret.path;
      # oidcIssuerPrivateKeyFile = config.age.secrets.authelia_issuer_priv_key.path;
      sessionSecretFile = config.age.secrets.authelia_session_secret.path;
      storageEncryptionKeyFile = config.age.secrets.authelia_storage_encryption_secret.path;
    };

    environmentVariables = {
      AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = config.age.secrets.authelia_ldap_password.path;
      AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = config.age.secrets.smtp2go_pass.path;
      AUTHELIA_STORAGE_MYSQL_PASSWORD_FILE = config.age.secrets.authelia_mysql_password.path;
    };
  };
  users.users.${autheliaUser}.extraGroups = [ "redis" "mailrelay" ];

  environment.etc = {
      "authelia/config/email_templates" = {
        source = ./authelia-templates;
        user = autheliaUser;
      };
    };

  systemd.services."authelia-main" = { 
    after = [ "lldap.service" ]; 
    serviceConfig.LogsDirectory = "authelia";
    };

  networking.firewall.allowedTCPPorts = [ lldapHttpPort lldapInternalPort ];
}