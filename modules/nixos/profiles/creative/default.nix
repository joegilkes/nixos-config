{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.profiles.creative;
in
{
  options.profiles.creative = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable the creative apps profile.";
  };

  config = mkIf cfg.enable {
    programs = {
      blender = enabled;
      darktable = enabled;
      texlive = enabled;
    };
  };
}
# Profile enabling creative, graphics, and document-authoring applications.