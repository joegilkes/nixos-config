{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.phoronix-test-suite;
in
{
  options.pluskinda.apps.phoronix-test-suite = with types; {
    enable = mkBoolOpt false "Whether or not to enable the Phoronix test suite.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ phoronix-test-suite ]; };
}