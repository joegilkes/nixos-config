{ options, config, pkgs, lib, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.services.printing;
in
{
  options.pluskinda.services.printing = with types; {
    enable = mkBoolOpt false "Whether or not to configure printing support.";
  };

  config = mkIf cfg.enable { services.printing.enable = true; };
}