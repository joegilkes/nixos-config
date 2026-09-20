{ lib, config, options, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.services.openssh;
in
{
  options.services.openssh = with types; {
    allowPasswordAuth = mkBoolOpt true "Whether to allow SSH password authentication.";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "no";
        PasswordAuthentication = cfg.allowPasswordAuth;
      };
    };
  };
}