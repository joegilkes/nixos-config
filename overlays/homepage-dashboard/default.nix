{ channels, ... }:

final: prev: {
  homepage-dashboard = prev.homepage-dashboard.overrideAttrs (oldAttrs: {
    postInstall = ''
      mkdir -p $out/share/homepage/public/images
      ln -s ${final.wallpapers.contour_sunrise_bi} $out/share/homepage/public/images/background.png
    '';
  });
}