{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.programs.vscode;
  texenabled = config.programs.texlive.enable;
in
{
  config = mkIf cfg.enable {
    home = {
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