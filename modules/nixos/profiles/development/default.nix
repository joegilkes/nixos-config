{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.profiles.development;
in
{
  options.profiles.development = with types; {
    enable = mkBoolOpt false "Whether or not to enable development apps.";
  };

  config = mkIf cfg.enable {
    programs = {
      vscode = enabled;
      nixd = enabled;
      android-platform-tools = enabled;
      conda = enabled;
      julia = enabled;
      direnv = enabled;
    };
  };
}
# Profile enabling software-development tools and language environments.