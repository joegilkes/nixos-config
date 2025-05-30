{ options, config, lib, pkgs, ... }:

with lib;
with lib.pluskinda;
let
  cfg = config.pluskinda.desktop.gnome;
  gdmHome = config.users.users.gdm.home;

  defaultExtensions = with pkgs.gnomeExtensions; [
    appindicator
    # gtile
    just-perfection
    logo-menu
    # no-overview
    space-bar
    top-bar-organizer
    wireless-hid
  ];

  default-attrs = mapAttrs (key: mkDefault);
  nested-default-attrs = mapAttrs (key: default-attrs);
in
{
  options.pluskinda.desktop.gnome = with types; {
    enable =
      mkBoolOpt false "Whether or not to use Gnome as the desktop environment.";
    wallpaper = {
      light = mkOpt (oneOf [ str package ]) pkgs.pluskinda.wallpapers.nord-rainbow-light-nix "The light wallpaper to use.";
      dark = mkOpt (oneOf [ str package ]) pkgs.pluskinda.wallpapers.nord-rainbow-dark-nix "The dark wallpaper to use.";
    };
    color-scheme = mkOpt (enum [ "light" "dark" ]) "dark" "The color scheme to use.";
    wayland = mkBoolOpt true "Whether or not to use Wayland.";
    suspend = mkBoolOpt true "Whether or not to suspend the machine after inactivity.";
    monitors = mkOpt (nullOr path) null "The monitors.xml file to create.";
    extensions = mkOpt (listOf package) [ ] "Extra Gnome extensions to install.";
    enableExperimentalVRR = mkBoolOpt false "Whether to enable experimental support for VRR in Wayland.";
  };

  config = mkIf cfg.enable {
    pluskinda.system.kb.enable = true;
    pluskinda.desktop.addons = {
      wallpapers = enabled;
      electron-support = enabled;
      xdg-portal = enabled;
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
      gnome-tweaks
      nautilus-python
      dconf-editor
      gcolor3
    ] ++ defaultExtensions ++ cfg.extensions;

    environment.gnome.excludePackages = (with pkgs; [
      epiphany
      geary
      gnome-font-viewer
      gnome-system-monitor
      gnome-maps
      yelp
      cheese
      totem
      simple-scan
      gnome-music
      gnome-contacts
      gnome-characters
      gnome-weather
      gnome-calendar
      gedit
      gnome-tour
      gnome-photos
      gnome-maps
    ]);

    environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      gst-libav
    ]);

    systemd.tmpfiles.rules = [
      "d ${gdmHome}/.config 0711 gdm gdm"
    ] ++ (
      # "./monitors.xml" comes from ~/.config/monitors.xml when GNOME
      # display information is updated.
      lib.optional (cfg.monitors != null) "L+ ${gdmHome}/.config/monitors.xml - - - - ${cfg.monitors}"
    );

    systemd.services.pluskinda-user-icon = {
      before = [ "display-manager.service" ];
      wantedBy = [ "display-manager.service" ];

      serviceConfig = {
        Type = "simple";
        User = "root";
        Group = "root";
      };

      script = ''
        config_file=/var/lib/AccountsService/users/${config.pluskinda.user.name}
        icon_file=/run/current-system/sw/share/pluskinda-icons/user/${config.pluskinda.user.name}/${config.pluskinda.user.icon.fileName}

        if ! [ -d "$(dirname "$config_file")"]; then
          mkdir -p "$(dirname "$config_file")"
        fi

        if ! [ -f "$config_file" ]; then
          echo "[User]
          Session=gnome
          SystemAccount=false
          Icon=$icon_file" > "$config_file"
        else
          icon_config=$(sed -E -n -e "/Icon=.*/p" $config_file)

          if [[ "$icon_config" == "" ]]; then
            echo "Icon=$icon_file" >> $config_file
          else
            sed -E -i -e "s#^Icon=.*$#Icon=$icon_file#" $config_file
          fi
        fi
      '';
    };

    services = {
      # Required for app indicators
      udev.packages = with pkgs; [ gnome-settings-daemon ];

      libinput.enable = true;
      xserver.enable = true;

      displayManager.gdm = {
        enable = true;
        wayland = cfg.wayland;
        autoSuspend = cfg.suspend;
      };
      desktopManager.gnome.enable = true;
    };

    pluskinda.home.extraOptions = {
      dconf.settings =
        let
          user = config.users.users.${config.pluskinda.user.name};
          get-wallpaper = wallpaper:
            if lib.isDerivation wallpaper then
              builtins.toString wallpaper
            else
              wallpaper;
          customFonts = config.pluskinda.system.fonts.enable;
        in
        nested-default-attrs {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = (builtins.map (extension: extension.extensionUuid) (cfg.extensions ++ defaultExtensions))
              ++ [
              "native-window-placement@gnome-shell-extensions.gcampax.github.com"
              "drive-menu@gnome-shell-extensions.gcampax.github.com"
              "user-theme@gnome-shell-extensions.gcampax.github.com"
            ];
            favorite-apps =
              [ "org.gnome.Nautilus.desktop" ]
              ++ optional config.pluskinda.apps.chrome.enable "google-chrome.desktop"
              ++ optional config.pluskinda.apps.firefox.enable "firefox.desktop"
              ++ optional config.pluskinda.apps.vscode.enable "code.desktop"
              ++ optional config.pluskinda.apps.discord.enable "discord.desktop"
              ++ optional config.pluskinda.apps.steam.enable "steam.desktop";
          };

          "org/gnome/desktop/background" = {
            picture-uri = get-wallpaper cfg.wallpaper.light;
            picture-uri-dark = get-wallpaper cfg.wallpaper.dark;
          };
          "org/gnome/desktop/screensaver" = {
            picture-uri = get-wallpaper cfg.wallpaper.light;
            picture-uri-dark = get-wallpaper cfg.wallpaper.dark;
          };
          "org/gnome/desktop/interface" = {
            color-scheme = if cfg.color-scheme == "light" then "default" else "prefer-dark";
            enable-hot-corners = false;
            show-battery-percentage = true;
          } // optionalAttrs customFonts {
            monospace-font-name = "Hack Nerd Font Mono 10";
            font-name = "Noto Sans 10";
            document-font-name = "Noto Sans 10";
          };
          "org/gnome/desktop/peripherals/touchpad" = {
            disable-while-typing = false;
            natural-scroll = false;
            tap-to-click = true;
          };
          "org/gnome/desktop/wm/preferences" = {
            num-workspaces = 10;
            resize-with-right-button = true;
            button-layout = ":minimize,appmenu,close";
          };
          "org/gnome/desktop/wm/keybindings" = {
            switch-to-workspace-1 = [ "<Super>1" ];
            switch-to-workspace-2 = [ "<Super>2" ];
            switch-to-workspace-3 = [ "<Super>3" ];
            switch-to-workspace-4 = [ "<Super>4" ];
            switch-to-workspace-5 = [ "<Super>5" ];
            switch-to-workspace-6 = [ "<Super>6" ];
            switch-to-workspace-7 = [ "<Super>7" ];
            switch-to-workspace-8 = [ "<Super>8" ];
            switch-to-workspace-9 = [ "<Super>9" ];
            switch-to-workspace-10 = [ "<Super>0" ];

            move-to-workspace-1 = [ "<Shift><Super>1" ];
            move-to-workspace-2 = [ "<Shift><Super>2" ];
            move-to-workspace-3 = [ "<Shift><Super>3" ];
            move-to-workspace-4 = [ "<Shift><Super>4" ];
            move-to-workspace-5 = [ "<Shift><Super>5" ];
            move-to-workspace-6 = [ "<Shift><Super>6" ];
            move-to-workspace-7 = [ "<Shift><Super>7" ];
            move-to-workspace-8 = [ "<Shift><Super>8" ];
            move-to-workspace-9 = [ "<Shift><Super>9" ];
            move-to-workspace-10 = [ "<Shift><Super>0" ];
          };
          "org/gnome/shell/keybindings" = {
            # Remove the default hotkeys for opening favorited applications.
            switch-to-application-1 = [ ];
            switch-to-application-2 = [ ];
            switch-to-application-3 = [ ];
            switch-to-application-4 = [ ];
            switch-to-application-5 = [ ];
            switch-to-application-6 = [ ];
            switch-to-application-7 = [ ];
            switch-to-application-8 = [ ];
            switch-to-application-9 = [ ];
            switch-to-application-10 = [ ];
          };
          "org/gnome/mutter" = {
            edge-tiling = true;
            dynamic-workspaces = false;
            experimental-features = [] ++ optional (cfg.wayland && cfg.enableExperimentalVRR) "variable-refresh-rate";
          };

          "org/gnome/shell/extensions/just-perfection" = {
            panel-size = 48;
            activities-button = false;
            dash-icon-size = 48;
          };

          "org/gnome/shell/extensions/Logo-menu" = {
            hide-softwarecentre = true;

            # Use right click to open Activities.
            menu-button-icon-click-type = 3;

            # Use the NixOS logo.
            menu-button-icon-image = 23;

            menu-button-terminal = lib.getExe pkgs.gnome-terminal;
          };

          "org/gnome/shell/extensions/top-bar-organizer" = {
            left-box-order = [
              "menuButton"
              "activities"
              "dateMenu"
              "appMenu"
            ];

            center-box-order = [
              "Space Bar"
            ];

            right-box-order = [
              "keyboard"
              "EmojisMenu"
              "wireless-hid"
              "drive-menu"
              "vitalsMenu"
              "screenRecording"
              "screenSharing"
              "dwellClick"
              "a11y"
              "quickSettings"
            ];
          };

          "org/gnome/shell/extensions/space-bar/shortcuts" = {
            enable-activate-workspace-shortcuts = false;
          };
          "org/gnome/shell/extensions/space-bar/behavior" = {
            show-empty-workspaces = false;
          };

          "org/gnome/shell/extensions/gtile" = {
            show-icon = false;
            grid-sizes = "8x2,4x2,2x2";
          };
        };
    };
  };
}