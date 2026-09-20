{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.slack;
in
{
  options.programs.slack = with types; {
    enable = mkBoolOpt false "Whether or not to enable Slack.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ slack ]; };
}