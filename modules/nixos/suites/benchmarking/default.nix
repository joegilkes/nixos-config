{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.suites.benchmarking;
in
{
  options.pluskinda.suites.benchmarking = with types; {
    enable = mkBoolOpt false "Whether or not to enable benchmarking apps.";
  };

  config = mkIf cfg.enable {
    pluskinda = {
      apps = {
        phoronix-test-suite = enabled;
        unigine-heaven = enabled;
      };
    };
  };
}