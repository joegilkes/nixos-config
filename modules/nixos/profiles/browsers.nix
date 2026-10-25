{ config, lib, ... }:

with lib;
with (import ../../../lib/module-helpers.nix { inherit lib; });

let 
  cfg = config.profiles.browsers;
in
{
  options.profiles.browsers = with types; {
    enable = mkBoolOpt false "Whether or not to enable web browser apps.";
  };

  config = mkIf cfg.enable {
    programs = {
      chrome = enabled;
      firefox = enabled;
      proton-vpn = enabled;
    };
  };
}