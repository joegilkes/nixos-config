{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.suites.common;
in
{
  options.pluskinda.suites.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {

    pluskinda = {
      nix = enabled;

      cli-apps = {
        flake = enabled;
        comma = enabled;
      };

      tools = {
        git = enabled;
        misc = enabled;
      };

      hardware = {
        audio = enabled;
        networking = enabled;
      };

      services = {
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
  };
}