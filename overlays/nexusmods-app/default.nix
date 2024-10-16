{ channels, ... }:

final: prev: {
  inherit (channels.nexusmods-latest) nexusmods-app nexusmods-app-unfree;
}
