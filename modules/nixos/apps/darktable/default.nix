{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.darktable;
in
{
  options.pluskinda.apps.darktable = with types; {
    enable = mkBoolOpt false "Whether or not to enable Darktable.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ darktable ]; };
}