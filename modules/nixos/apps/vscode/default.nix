{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.apps.vscode;
in
{
  options.pluskinda.apps.vscode = with types; {
    enable = mkBoolOpt false "Whether or not to enable Visual Studio Code.";
  };

  config = mkIf cfg.enable {
    pluskinda.home = {
      extraOptions = {
        programs.vscode = {
          enable = true;
          package = pkgs.vscode.fhsWithPackages (ps: with ps; [ libsecret hack-font ]);
          extensions = with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            mkhl.direnv
          ];
        };
      };
    };
  };
}