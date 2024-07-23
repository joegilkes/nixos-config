{ inputs, ... }:

final: prev: {
  star-citizen = inputs.nix-gaming.packages.${prev.system}.star-citizen;
}