{ options, config, pkgs, lib, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.tools.git;
  gpg = config.pluskinda.security.gpg;
  user = config.pluskinda.user;
in
{
  options.pluskinda.tools.git = with types; {
    enable = mkBoolOpt false "Whether or not to install and configure git.";
    userName = mkOpt types.str user.fullName "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ git ];

    pluskinda.home = {
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