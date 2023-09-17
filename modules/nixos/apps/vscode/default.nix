{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.apps.vscode;
  inherit (inputs) unstable;
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
          package = unstable.vscode.fhsWithPackages (ps: with ps; [ libsecret ]);
          extensions = with unstable.vscode-extensions; [
            jnoortheen.nix-ide
            mkhl.direnv
          ];
        };
      };
    };
  };
}