{  options, config, pkgs, lib, inputs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.security.gpg;
in
{
  options.security.gpg = with types; {
    enable = mkBoolOpt false "Whether or not to enable GPG.";
  };

  config = mkIf cfg.enable {
    services.pcscd.enable = true;

    environment.systemPackages = with pkgs; [
      gnupg
      libsecret
    ];

    programs = {
      ssh.startAgent = false;

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        enableExtraSocket = true;
        pinentryPackage = pkgs.pinentry-gnome3;
      };
    };

    home.file = {
      ".gnupg/.keep".text = "";
    };
  };
}