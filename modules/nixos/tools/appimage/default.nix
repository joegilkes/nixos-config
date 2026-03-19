{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.tools.appimage;

in
{
  options.pluskinda.tools.appimage = with types; {
    enable = mkBoolOpt false "Whether or not to enable AppImage support.";
  };

  config = mkIf cfg.enable {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}