{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.cli-apps.comma;
in
{
  options.pluskinda.cli-apps.comma = with types; {
    enable = mkBoolOpt false "Whether or not to enable Comma.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      comma
    ];
  };
}