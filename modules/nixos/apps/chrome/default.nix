{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.chrome;
in
{
  options.programs.chrome = with types; {
    enable = mkBoolOpt false "Whether or not to enable chrome.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ google-chrome ]; };
}