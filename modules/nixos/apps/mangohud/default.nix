{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.mangohud;
in
{
  options.programs.mangohud = with types; {
    enable = mkBoolOpt false "Whether or not to enable MangoHUD.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      mangohud
    ];
  };
}