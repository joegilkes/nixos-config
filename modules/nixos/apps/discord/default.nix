{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let cfg = config.programs.discord;
in
{
  options.programs.discord = with types; {
    enable = mkBoolOpt false "Whether or not to enable Discord.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ 
      discord 
      vesktop
    ];
  };
}