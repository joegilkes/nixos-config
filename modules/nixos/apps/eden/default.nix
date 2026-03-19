{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.eden;
in
{
  options.pluskinda.apps.eden = with types; {
    enable = mkBoolOpt false "Whether or not to enable Eden (Switch emulator).";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ eden ]; };
}