{ config, lib, pkgs, inputs, ...}:

let 
  hname = config.networking.hostName;
in 
{
  age.secrets = {
    homepage-env = {
      file = ../../../secrets/giants-deep-homepage.age;
      owner = "root";
      group = "users";
      mode = "400";
    };
  };

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    environmentFile = config.age.secrets.homepage-env.path;
    settings = {
      title = "Dashboard - ${hname}";
      headerstyle = "clean";
      layout = {
        stats = {
          style = "row";
          columns = 4;
        };
        media = {
          style = "columns";
        };
        network = {
          style = "columns";
        };
      };
    };
    bookmarks = [{
      dev = [
        { github = [{
            abbr = "GitHub";
            href = "https://github.com/joegilkes";
            icon = "github-light.png";
          }];
        }
        { homepage-docs = [{
            abbr = "HPDocs";
            href = "https://gethomepage.dev/";
            icon = "homepage.png";
          }];
        }
      ];
    }];
    services = [
      {
        stats = [
          { 
            "CPU Usage" = {
              widget = {
                type = "glances";
                url = "http://192.168.0.41:61208";
                metric = "cpu";
                version = 4;
                refreshInterval = 5000;
              };
            };
          }
          { 
            "Memory Usage" = {
              widget = {
                type = "glances";
                url = "http://192.168.0.41:61208";
                metric = "memory";
                version = 4;
                refreshInterval = 5000;
              };
            };
          }
          { 
            "Network Usage" = {
              widget = {
                type = "glances";
                url = "http://192.168.0.41:61208";
                metric = "network:enp0s31f6";
                version = 4;
                refreshInterval = 5000;
              };
            };
          }
          { 
            "Top Processes" = {
              widget = {
                type = "glances";
                url = "http://192.168.0.41:61208";
                metric = "process";
                version = 4;
                refreshInterval = 5000;
              };
            };
          }
          { 
            "gabbro/public" = {
              widget = {
                type = "glances";
                url = "http://192.168.0.41:61208";
                metric = "fs:/mnt/gabbro/public";
                chart = false;
                version = 4;
                refreshInterval = 10000;
              };
            };
          }
          { 
            "gabbro/backups" = {
              widget = {
                type = "glances";
                url = "http://192.168.0.41:61208";
                metric = "fs:/mnt/gabbro/backups";
                chart = false;
                version = 4;
                refreshInterval = 10000;
              };
            };
          }
          { 
            "gabbro/media" = {
              widget = {
                type = "glances";
                url = "http://192.168.0.41:61208";
                metric = "fs:/mnt/gabbro/media";
                chart = false;
                version = 4;
                refreshInterval = 10000;
              };
            };
          }
          { 
            "gabbro/storage" = {
              widget = {
                type = "glances";
                url = "http://192.168.0.41:61208";
                metric = "fs:/mnt/gabbro/storage";
                chart = false;
                version = 4;
                refreshInterval = 10000;
              };
            };
          }
        ];
      }
      {
        media = [
          { 
            Jellyfin = {
              icon = "jellyfin.png";
              href = "http://192.168.0.41:8096";
              description = "film/TV streaming";
              widget = {
                type = "jellyfin";
                url = "http://192.168.0.41:8096";
                key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
              };
            };
          }
        ];
      }
      {
        network = [
        {
          "AdGuard Home" = {
            icon = "adguard-home.png";
            href = "http://192.168.0.41:3003";
            description = "DNS filter";
            widget = {
              type = "adguard";
              url = "http://192.168.0.41:3003";
              username = "{{HOMEPAGE_VAR_ADGUARD_USER}}";
              password = "{{HOMEPAGE_VAR_ADGUARD_PASS}}";
            };
          };
        }
      ];
    }];
    widgets = [
      {
        greeting = {
          text_size = "xl";
          text = "${hname}";
        };
      }
      {
        search = {
          provider = "google";
          target = "_self";
        };
      }
      {
        datetime = {
          text_size = "md";
          format = {
            dateStyle = "short";
            timeStyle = "short";
            hour12 = true;
          };
        };
      }
    ];
  };
}