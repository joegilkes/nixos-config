{ pkgs, config, lib, channel, ...}:

{
  security.acme = {
    acceptTerms = true;
    defaults.email = "joe@joegilk.es";
    defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
    certs."wilds.joegilk.es" = {
      group = "traefik";
    };
  };
}