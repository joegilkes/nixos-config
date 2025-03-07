{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.apps.vscode;
  texenabled = config.pluskinda.apps.texlive.enable;
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
          profiles = {
            default.extensions = with pkgs.vscode-extensions; mkMerge [
              [
                jnoortheen.nix-ide
                mkhl.direnv
              ]
              ( mkIf texenabled [
                pkgs.vscode-extensions.james-yu.latex-workshop
              ])
            ];
          };
        };
      };
    };
  };
}