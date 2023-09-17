{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.suites.development;
in
{
  options.pluskinda.suites.development = with types; {
    enable = mkBoolOpt false "Whether or not to enable development apps.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      apps = {
        vscode = enabled;
      };

      tools = {
        direnv = enabled;
      };
    };
  };
}