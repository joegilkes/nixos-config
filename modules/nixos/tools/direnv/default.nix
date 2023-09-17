{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.tools.direnv;
in
{
  options.pluskinda.tools.direnv = with types; {
    enable = mkBoolOpt false "Whether or not to enable direnv.";
  };

  config = mkIf cfg.enable {
    pluskinda.home.extraOptions = {
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv = enabled;
      };
    };
  };
}