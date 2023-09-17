{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.chrome;
in
{
  options.pluskinda.apps.chrome = with types; {
    enable = mkBoolOpt false "Whether or not to enable chrome.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ google-chrome ]; };
}