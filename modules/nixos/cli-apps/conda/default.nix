{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let 
  cfg = config.pluskinda.cli-apps.conda;
  # Uses a separate install path to avoid clash with CondaPkg.jl, which also
  # writes to ~/.conda
  miniconda = pkgs.conda.override (prev: {
    installationPath = "~/.miniconda";
  });
in
{
  options.pluskinda.cli-apps.conda = with types; {
    enable = mkBoolOpt false "Whether or not to enable Miniconda package manager.";
  };

  config = mkIf cfg.enable { 
    environment.systemPackages = [ miniconda ]; 
  };
}