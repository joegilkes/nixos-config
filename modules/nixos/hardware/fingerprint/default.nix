{ options, config, pkgs, lib, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.hardware.fingerprint;
in
{
  options.pluskinda.hardware.fingerprint = with types; {
    enable = mkBoolOpt false "Whether or not to enable fingerprint support.";
  };

  config = mkIf cfg.enable { services.fprintd.enable = true; };
}