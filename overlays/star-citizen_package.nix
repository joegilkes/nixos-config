{ inputs, ... }:

final: prev: {
  star-citizen = final.callPackage "${inputs.nix-gaming.outPath}/pkgs/star-citizen" {
    pkgs = final;
  };
}