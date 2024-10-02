{
  fetchFromGitHub,
  lib,
  gccMultiStdenv,
  ...
}:

let
  name = "ffbtools";
in
  gccMultiStdenv.mkDerivation {
    inherit name;

    src = fetchFromGitHub {
      owner = "berarma";
      repo = name;
      rev = "ebc4702f4fa6284f641d3b58b8f3e234244f9deb";
      hash = "sha256-K9RdZ211nhzQhNaw+vPx6XZ047ERjU++eUyaMyyE170=";
    };

    installPhase = ''
      mkdir $out
      mkdir $out/bin
      cp build/ffbplay $out/bin
      cp build/rawcmd $out/bin
      mkdir $out/lib
      cp build/libffbwrapper-i386.so $out/lib
      cp build/libffbwrapper-x86_64.so $out/lib
    '';

    meta = with lib; {
      homepage = "https://github.com/berarma/ffbtools";
      description = "Set of tools for FFB testing and debugging on GNU/Linux";
      license = licenses.gpl3;
      platforms = [ "x86_64-linux" ];
    };
  }