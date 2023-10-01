{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.cli-apps.mprime;
in
{
  options.pluskinda.cli-apps.mprime = with types; {
    enable = mkBoolOpt false "Whether or not to enable mprime.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ mprime ]; };
}