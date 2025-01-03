{ lib, config, options, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.services.redis;
in
{
  options.pluskinda.services.redis = with types; {
    enable = mkBoolOpt false "Whether to enable Redis.";
    databases = mkOpt int 16 "Number of Redis databases.";
  };

  config = mkIf cfg.enable {
    services.redis = {
      servers."" = {
        enable = true;
        databases = cfg.databases;
        port = 0;
      };
    };
  };
}