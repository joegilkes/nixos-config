{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.services.calibre-web;
in
{
  options.pluskinda.services.calibre-web = with types; {
    enable = mkBoolOpt false "Whether to enable the calibre-web eBook frontend.";
    port = mkOpt port 8083 "Port to run calibre-web through.";
    libraryPath = mkOpt (nullOr path) null "Path to Calibre library.";
  };

  config = mkIf cfg.enable {
    services.calibre-web = {
      enable = true;
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
