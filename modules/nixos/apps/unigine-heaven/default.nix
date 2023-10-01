{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.unigine-heaven;
in
{
  options.pluskinda.apps.unigine-heaven = with types; {
    enable = mkBoolOpt false "Whether or not to enable Unigine Heaven.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ unigine-heaven ]; };
}