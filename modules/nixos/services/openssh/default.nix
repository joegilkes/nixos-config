{ lib, config, options, ... }:

let
  cfg = config.pluskinda.services.openssh;

  inherit (lib) types mkEnableOption mkIf;
in
{
  options.pluskinda.services.openssh = with types; {
    enable = mkBoolOpt false "Whether or not to configure OpenSSH support.";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no";
      };
    };
  };
}