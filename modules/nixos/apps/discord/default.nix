{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.apps.discord;
in
{
  options.pluskinda.apps.discord = with types; {
    enable = mkBoolOpt false "Whether or not to enable Discord.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ 
      discord 
      vesktop
    ];
  };
}