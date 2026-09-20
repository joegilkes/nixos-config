{ options, config, pkgs, lib, ... }:

with lib;
with (import ../../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.services.desktop.addons.wallpapers;
  wallpapers = pkgs.wallpapers;
in
{
  options.services.desktop.addons.wallpapers = with types; {
    enable = mkBoolOpt false
      "Whether or not to add wallpapers to ~/Pictures/wallpapers.";
  };

  config = {
    home.file = lib.foldl
      (acc: name:
        let wallpaper = wallpapers.${name};
        in
        acc // {
          "Pictures/wallpapers/${wallpaper.fileName}".source = wallpaper;
        })
      { }
      (wallpapers.names);
  };
}