{ pkgs, config, lib, channel, ...}:

with lib;
with lib.pluskinda;
let
  autheliaInstance = config.services.authelia.instances.main;
  autheliaUser = autheliaInstance.user;
  autheliaUrl = "http://${autheliaInstance.settings.server.address}";
in
{
  users.groups = {
    lldap-secrets = { };
    sendgrid = { };
  };

  age.secrets = {
    authelia_jwt_secret = {
      file = ../../../secrets/authelia-jwt.age;
      owner = autheliaUser;
      group = autheliaUser;
      mode = "400";
    };
    authelia_hmac_secret = {
      file = ../../../secrets/authelia-hmac.age;
      owner = autheliaUser;
      group = autheliaUser;
      mode = "400";
    };
    authelia_issuer_priv_key = {
      file = ../../../secrets/authelia-issuer.age;
      owner = autheliaUser;
      group = autheliaUser;
      mode = "400";
    };
    authelia_session_secret = {
      file = ../../../secrets/authelia-session.age;
      owner = autheliaUser;
      group = autheliaUser;
      mode = "400";
    };
    authelia_storage_encryption_secret = {
      file = ../../../secrets/authelia-storage.age;
      owner = autheliaUser;
      group = autheliaUser;
      mode = "400";
    };
    authelia_mysql_password = {
      file = ../../../secrets/authelia-mysql.age;
      owner = autheliaUser;
      group = autheliaUser;
      mode = "400";
    };
    ldap_password = {
      file = ../../../secrets/ldap-password.age;
      owner = autheliaUser;
      group = autheliaUser;
      mode = "400";
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
    sendgrid_api_token = {
      file = ../../../secrets/sendgrid-api-token.age;
      group = "sendgrid";
      mode = "0440";
    };
  };

  pluskinda.services.authelia = {
    secrets = {
      jwtSecretFile = config.age.secrets.authelia_jwt_secret.path;
      oidcHmacSecretFile = config.age.secrets.authelia_hmac_secret.path;
      oidcIssuerPrivateKeyFile = config.age.secrets.authelia_issuer_priv_key.path;
      sessionSecretFile = config.age.secrets.authelia_session_secret.path;
      storageEncryptionKeyFile = config.age.secrets.authelia_storage_encryption_secret.path;
    };
    envVars = {
      AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = config.age.secrets.ldap_password.path;
      AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = config.age.secrets.sendgrid_api_token.path;
      AUTHELIA_STORAGE_MYSQL_PASSWORD_FILE = config.age.secrets.authelia_mysql_password.path;
    };
  };

  services.lldap = {
    enable = true;
    settings = {
      ldap_base_dn = "dc=joegilk,dc=es";
    };
    environment = {
      LLDAP_JWT_SECRET_FILE = config.age.secrets.lldap_jwt_secret.path;
      LLDAP_KEY_SEED_FILE = config.age.secrets.lldap_key_seed.path;
      LLDAP_LDAP_USER_PASS_FILE = config.age.secrets.lldap_user_pass.path;
    };
  };
  systemd.services.lldap.serviceConfig.SupplementaryGroups = [ "lldap-secrets" ];
  systemd.services.authelia.after = [ "lldap.service" ];

  programs.msmtp = {
    enable = true;
    accounts.default = {
      auth = true;
      tls = true;
      tls_starttls = false;
      host = "smtp.sendgrid.net";
      port = 465;
      user = "apikey";
      passwordeval = "${pkgs.coreutils}/bin/cat ${config.age.secrets.sendgrid_api_token.path}";
    };
  };

  services.traefik = {
    dynamicConfigOptions = {
      http = {
        routers = {
          mainRouter = {
            rule = "Host(`wilds.joegilk.es`)";
            tls.certResolver = "letsencrypt";
            service = "glances";
            middlewares = [ "authelia@file" ];
          };
          authelia = {
            entryPoints = [ "websecure" ];
            rule = "Host(`auth.joegilk.es`)";
            tls.certResolver = "letsencrypt";
            service = "authelia@file";
          };
        };
        middlewares = {
          authelia.forwardAuth = {
            address = "http://authelia:9091/api/authz/forward-auth";
            trustForwardHeader = true;
            authResponseHeaders = [ "Remote-User" "Remote-Groups" "Remote-Name" "Remote-Email" ];
            tls.insecureSkipVerify = true;
          };
        };
        services = {
          glances.loadBalancer.servers = [
            {
              url = "http://localhost:61208";
            }
          ];
          auth.loadBalancer.servers = [
            {
              url = "http://authelia:9091";
            }
          ];
        };
      };
    };
  };
}