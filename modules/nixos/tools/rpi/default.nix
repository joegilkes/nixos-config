{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.tools.rpi;
in
{
  options.pluskinda.tools.rpi = with types; {
    enable = mkBoolOpt false "Whether or not to enable libraspberrypi tools.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ libraspberrypi ]; };
}