{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.suites.emulation;
in
{
  options.pluskinda.suites.emulation = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable emulation configuration.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      apps = {
        dolphin = enabled;
      };
      cli-apps = {
        fusee-nano = enabled;
      };
    };
  };
}