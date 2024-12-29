{ pkgs, config, lib, channel, ...}:

{
  services.traefik = {
    dynamicConfigOptions = {
      http = {
        routers = {
          router1 = {
            rule = "Host(`home.joegilk.es`)";
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