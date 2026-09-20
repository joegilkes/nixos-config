{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let 
  cfg = config.profiles.htpc;
in
{
  options.profiles.htpc = with types; {
    enable = mkBoolOpt false "Whether or not to enable HTPC apps and services.";
  };

  config = mkIf cfg.enable {
    # Enable for full HTPC experience, needs a GPU and a HDMI CEC adapter to really make sense.
    # services.desktop.kodi = enabled;
    services.jellyfin = enabled;
    # Only needed when running with a tuner card.
  };
}
# Profile composing services and applications for a home-theater PC.