{ pkgs, config, lib, channel, ...}:

{
  services.traefik = {
    dynamicConfigOptions = {
      http = {
        routers = {
          mainRouter = {
            rule = "Host(`wilds.joegilk.es`)";
            service = "glances";
          };
        };
        services = {
          glances = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:61208";
                }
              ];
            };
          };
        };
      };
    };
  };
}