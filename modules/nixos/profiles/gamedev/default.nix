{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.profiles.gamedev;
in
{
  options.profiles.gamedev = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable game development configuration.";
  };

  config = mkIf cfg.enable {
    programs = {
      godot = enabled;
      pixelorama = enabled;
    };
  };
}
# Profile enabling game-development tools and related applications.