{  options, config, lib, pkgs, ... }:

with lib;
with (import ../../../../lib/module-helpers.nix { inherit lib; });
let
  cfg = config.programs.firefox;
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
  options.programs.firefox = with types; {
    extraConfig =
      mkOpt str "" "Extra configuration for the user profile JS file.";
    userChrome =
      mkOpt str "" "Extra configuration for the user chrome CSS file.";
    settings = mkOpt attrs defaultSettings "Settings to apply to the profile.";
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-browser-connector.enable = config.services.desktop.gnome.enable;

    home = {
      extraOptions = {
        programs.firefox = {
          enable = true;
          package = pkgs.firefox.override {
              cfg.enableGnomeExtensions = config.services.desktop.gnome.enable;
            };
          configPath = "${config.home-manager.users.${config.user.name}.xdg.configHome}/mozilla/firefox";
          profiles.${config.user.name} = {
            inherit (cfg) extraConfig userChrome settings;
            id = 0;
            name = config.user.name;
          };
        };
      };
    };
  };
}