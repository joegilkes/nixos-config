{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.profiles.common;
in
{
  options.profiles.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    nix = enabled;

    programs = {
      git = enabled;
      misc = enabled;
    };

    hardware = {
      audio = enabled;
      networking = enabled;
    };

    services = {
      avahi = enabled;
      printing = enabled;
      openssh = enabled;
      flatpak = enabled;
    };

    security = {
      gpg = enabled;
      keyring = enabled;
      pass = enabled;
    };

    system = {
      boot = enabled;
      fonts = enabled;
      locale = enabled;
      time = enabled;
      kb = enabled;
    };
  };
}
# Baseline profile shared by all systems.