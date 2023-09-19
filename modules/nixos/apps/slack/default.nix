{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.slack;
in
{
  options.pluskinda.apps.slack = with types; {
    enable = mkBoolOpt false "Whether or not to enable Slack.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ slack ]; };
}