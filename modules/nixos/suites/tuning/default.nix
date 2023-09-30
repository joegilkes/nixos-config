{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.suites.tuning;
in
{
  options.pluskinda.suites.tuning = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable the performance tuning suite.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      cli-apps = {
        liquidctl = enabled;
      };

      tools = {
        diagnostics = enabled;
        sensors = enabled;
      };
    };
  };
}