{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.suites.browsers;
in
{
  options.pluskinda.suites.browsers = with types; {
    enable = mkBoolOpt false "Whether or not to enable web browser apps.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      apps = {
        chrome = enabled;
        firefox = enabled;
      };
    };
  };
}