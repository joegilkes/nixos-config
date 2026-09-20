{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.mprime;
in
{
  options.programs.mprime = with types; {
    enable = mkBoolOpt false "Whether or not to enable mprime.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ mprime ]; };
}