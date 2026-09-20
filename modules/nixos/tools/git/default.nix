{  options, config, pkgs, lib, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.programs.git;
  gpg = config.security.gpg;
  user = config.user;
in
{
  options.programs.git = with types; {
    userName = mkOpt types.str user.fullName "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ git ];

    home = {
      extraOptions = {
        programs.git = {
          enable = true;
          settings = {
            user.name = cfg.userName;
            user.email = cfg.userEmail;
            init = { defaultBranch = "main"; };
            pull = { rebase = true; };
            push = { autoSetupRemote = true; };
            core = { 
              excludesfile = "~/.gitignore";
              whitespace = "trailing-space,space-before-tab"; 
            };
          };
        };
      };
      file = { 
        ".gitignore".text = ''
          .direnv
        '';
      };
    };
  };
}