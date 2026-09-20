# Development shell providing the GNU-oriented tools used by this repository.
{ lib, pkgs, stdenv, ... }:

pkgs.mkShell {
  packages = with pkgs; [
    gcc
  ];
  shellHook = ''
    echo --- Development Environment: GNU ---
  '';
}