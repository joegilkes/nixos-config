{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.apps.firefox;
  defaultSettings = {
    "browser.aboutwelcome.enabled" = false;
    "browser.meta_refresh_when_inactive.disabled" = true;
    "browser.startup.homepage" = "https://google.co.uk";
    "browser.bookmarks.showMobileBookmarks" = true;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.aboutConfig.showWarning" = false;
    "browser.ssb.enabled" = true;
  };
in
{
  options.pluskinda.apps.firefox = with types; {
    enable = mkBoolOpt false "Whether or not to enable Firefox.";
    extraConfig =
      mkOpt str "" "Extra configuration for the user profile JS file.";
    userChrome =
      mkOpt str "" "Extra configuration for the user chrome CSS file.";
    settings = mkOpt attrs defaultSettings "Settings to apply to the profile.";
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-browser-connector.enable = config.pluskinda.desktop.gnome.enable;

    pluskinda.home = {
      extraOptions = {
        programs.firefox = {
          enable = true;
          package = pkgs.firefox.override (
            {
              cfg.enableGnomeExtensions = config.pluskinda.desktop.gnome.enable;
            }
          );
          profiles.${config.pluskinda.user.name} = {
            inherit (cfg) extraConfig userChrome settings;
            id = 0;
            name = config.pluskinda.user.name;
          };
        };
      };
    };
  };
}