{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.programs.xournalpp;
in
{
  options.programs.xournalpp = with types; {
    enable = mkBoolOpt false "Whether or not to enable Xournal++.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ xournalpp ]; };
}