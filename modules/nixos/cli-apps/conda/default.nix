{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.programs.conda;
  # Uses a separate install path to avoid clash with CondaPkg.jl, which also
  # writes to ~/.conda
  miniconda = pkgs.conda.override (prev: {
    installationPath = "~/.miniconda";
  });
in
{
  options.programs.conda = with types; {
    enable = mkBoolOpt false "Whether or not to enable Miniconda package manager.";
  };

  config = mkIf cfg.enable { 
    environment.systemPackages = [ miniconda ]; 
  };
}