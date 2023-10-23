{ channels, nix-gaming, ... }:

final: prev: {
  star-citizen = nix-gaming.packages.${prev.system}.star-citizen;
}