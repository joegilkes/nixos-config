{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.profiles.vr;
in
{
  options.profiles.vr = with types; {
    enable = mkBoolOpt false "Whether or not to enable VR apps.";
  };

  config = mkIf cfg.enable {
    programs = {
      sidequest = enabled;
    };
  };
}
# Profile enabling virtual-reality hardware and software support.