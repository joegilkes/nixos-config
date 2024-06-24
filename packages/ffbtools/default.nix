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
      rev = "master";
      hash = "sha256-jm7kp8VjrbeDdS45yD6tlSx0u84NETXA9NJ+Oz8wNu0=";
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