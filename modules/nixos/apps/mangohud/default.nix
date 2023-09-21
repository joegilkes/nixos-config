{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.apps.mangohud;
in
{
  options.pluskinda.apps.mangohud = with types; {
    enable = mkBoolOpt false "Whether or not to enable MangoHUD.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      mangohud
    ];
  };
}