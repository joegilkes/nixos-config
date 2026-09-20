{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.eden;
in
{
  options.programs.eden = with types; {
    enable = mkBoolOpt false "Whether or not to enable Eden (Switch emulator).";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ eden ]; };
}