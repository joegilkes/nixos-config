{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.apps.xournalpp;
in
{
  options.pluskinda.apps.xournalpp = with types; {
    enable = mkBoolOpt false "Whether or not to enable Xournal++.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ xournalpp ]; };
}