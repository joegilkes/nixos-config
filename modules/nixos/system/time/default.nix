{ options, config, pkgs, lib, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.system.time;
in
{
  options.pluskinda.system.time = with types; {
    enable =
      mkBoolOpt false "Whether or not to configure timezone information.";
  };

  config = mkIf cfg.enable { time.timeZone = "Europe/London"; };
}