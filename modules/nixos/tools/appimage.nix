{ config, lib, ... }:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

let 
  cfg = config.programs.appimage;
in
{
  config = mkIf cfg.enable {
    programs.appimage = {
      binfmt = true;
    };
  };
}