{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.texlive;
in
{
  options.pluskinda.apps.texlive = with types; {
    enable = mkBoolOpt false "Whether or not to enable TeXLive.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ texlive.combined.scheme-full ]; };
}