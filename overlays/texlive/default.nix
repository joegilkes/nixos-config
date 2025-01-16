{ channels, ... }:

# Roll back to 2023 to fix thesis compilation
final: prev: {
  inherit (channels.stable) texlive;
}
