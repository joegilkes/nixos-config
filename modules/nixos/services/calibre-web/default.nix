{ options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.services.calibre-web;
in
{
  options.services.calibre-web = with types; {
    port = mkOpt port 8083 "Port to run calibre-web through.";
    libraryPath = mkOpt (nullOr path) null "Path to Calibre library.";
  };

  config = mkIf cfg.enable {
    services.calibre-web = {
      openFirewall = true;
      listen = {
        ip = "0.0.0.0";
        port = cfg.port;
      };
      user = "calibre";
      group = "calibre";
      options = {
        calibreLibrary = cfg.libraryPath;
      };
    };
  };
}
