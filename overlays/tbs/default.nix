{ channels, ... }:

with channels.nixpkgs;
let 
  media = fetchFromGitHub rec {
    name = repo;
    owner = "tbsdtv";
    repo = "linux_media";
    rev = "a2e856bfb243942a9e9aaae004353501f513a5d7";
    hash = "";
  };

  build = fetchFromGitHub rec {
    name = repo;
    owner = "tbsdtv";
    repo = "media_build";
    rev = "0f49c76b80838ded04bd64c56af9e1f9b8ac1965";
    hash = "";
  };
in 
  final: prev: {
    tbs = prev.tbs.overrideAttrs (old: {
      srcs = [ media build ];
    });
  }