{ options, config, pkgs, lib, ... }:

with lib;
with lib.pluskinda;
let cfg = config.pluskinda.system.locale;
in
{
  options.pluskinda.system.locale = with types; {
    enable = mkBoolOpt false "Whether or not to manage locale settings.";
  };

  config = mkIf cfg.enable {
      i18n.defaultLocale = "en_GB.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_GB.UTF-8";
        LC_IDENTIFICATION = "en_GB.UTF-8";
        LC_MEASUREMENT = "en_GB.UTF-8";
        LC_MONETARY = "en_GB.UTF-8";
        LC_NAME = "en_GB.UTF-8";
        LC_NUMERIC = "en_GB.UTF-8";
        LC_PAPER = "en_GB.UTF-8";
        LC_TELEPHONE = "en_GB.UTF-8";
        LC_TIME = "en_GB.UTF-8";
      };

    console = { keyMap = mkForce "uk"; };
  };
}