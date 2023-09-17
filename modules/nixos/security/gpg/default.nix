{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.security.gpg;
in
{
  options.pluskinda.security.gpg = with types; {
    enable = mkBoolOpt false "Whether or not to enable GPG.";
  };

  config = mkIf cfg.enable {
    services.pcscd.enable = true;

    environment.systemPackages = with pkgs; [
      gnupg
      pinentry
      pinentry-curses
      pinentry-qt
      libsecret
    ];

    programs = {
      ssh.startAgent = false;

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        enableExtraSocket = true;
        pinentryFlavor = "gnome3";
      };
    };

    pluskinda = {
      home.file = {
        ".gnupg/.keep".text = "";
      };
    };
  };
}