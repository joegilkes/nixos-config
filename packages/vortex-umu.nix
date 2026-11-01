{
  coreutils,
  fetchurl,
  lib,
  makeDesktopItem,
  symlinkJoin,
  umu-launcher,
  writeShellApplication,

  # Optional argument to allow extra filesystem access.
  pressureVesselFilesystemsRW ? [],
}:

let
  vortexVersion = "2.9.1";

  vortexInstaller = fetchurl {
    name = "vortex-setup-${vortexVersion}.exe";
    url = "https://github.com/Nexus-Mods/Vortex/releases/download/v${vortexVersion}/vortex-setup-${vortexVersion}.exe";
    hash = "sha256-S8R5ex9lof3/wrIlMNL/Ngm4nzBLlPNkgaPkTLedg5U=";
  };

  launcher = writeShellApplication {
    name = "vortex-umu";
    runtimeInputs = [
      coreutils
      umu-launcher
    ];
    text = ''
      set +u -eo pipefail

      if [[ -z "''${HOME:-}" || ! -d "$HOME" ]]; then
        printf 'Vortex UMU requires HOME to point to an existing directory.\n' >&2
        exit 1
      fi

      home_dir="$(realpath -e "$HOME")"
      prefix_path="''${VORTEX_WINEPREFIX:-$home_dir/.local/share/vortex-umu/prefix}"
      WINEPREFIX="$(realpath -m "$prefix_path")"
      case "$WINEPREFIX" in
        "$home_dir"/*) ;;
        *)
          printf 'VORTEX_WINEPREFIX must be inside HOME: %s\n' "$WINEPREFIX" >&2
          exit 1
          ;;
      esac

      export WINEPREFIX
      export GAMEID="''${GAMEID:-umu-default}"
      export STORE="''${STORE:-none}"   
      if [[ ! -d "$WINEPREFIX/drive_c" ]]; then
        mkdir -p "$(dirname "$WINEPREFIX")"
        umu-run "" || true
        if [[ ! -d "$WINEPREFIX/drive_c" ]]; then
          printf 'UMU did not initialize a Wine prefix at %s.\n' "$WINEPREFIX" >&2
          exit 1
        fi
      fi

      version_from_marker() {
        local marker="$1"
        [[ -f "$marker" ]] || return 0
        cat "$marker"
      }

      version_is_older() {
        local installed="$1"
        local desired="$2"

        [[ -z "$installed" ]] && return 0
        [[ "$installed" =~ ^[0-9]+(\.[0-9]+)*$ ]] || {
          printf 'Cannot compare installed version: %s\n' "$installed" >&2
          exit 1
        }
        [[ "$installed" != "$desired" ]] || return 1
        [[ "$(printf '%s\n%s\n' "$installed" "$desired" | sort -V | head -n1)" == "$installed" ]]
      }

      write_version_marker() {
        local marker="$1"
        local version="$2"
        local temporary="$marker.tmp"

        printf '%s\n' "$version" > "$temporary"
        mv "$temporary" "$marker"
      }

      required_verbs=(win10 corefonts dotnet48 dotnetdesktop9 webview2)

      verb_is_installed() {
        local expected="$1"
        local line

        while IFS= read -r line; do
          [[ "$line" == "$expected" ]] && return 0
        done <<< "$installed_verbs"
        return 1
      }

      if ! installed_verbs="$(umu-run winetricks list-installed 2>&1)"; then
        printf 'Failed to list installed winetricks verbs:\n%s\n' "$installed_verbs" >&2
        exit 1
      fi

      for verb in "''${required_verbs[@]}"; do
        if verb_is_installed "$verb"; then
          continue
        fi

        printf 'Installing winetricks verb %s\n' "$verb"
        umu-run winetricks "$verb"
        if ! installed_verbs="$(umu-run winetricks list-installed 2>&1)"; then
          printf 'Failed to verify installed winetricks verbs:\n%s\n' "$installed_verbs" >&2
          exit 1
        fi
        if ! verb_is_installed "$verb"; then
          printf 'Winetricks did not report %s as installed.\n' "$verb" >&2
          exit 1
        fi
      done

      vortex_marker="$WINEPREFIX/.vortex-umu-vortex-version"
      installed_vortex="$(version_from_marker "$vortex_marker")"
      vortex_executable="$WINEPREFIX/drive_c/Program Files/Vortex/Vortex.exe"
      if [[ ! -f "$vortex_executable" ]] || version_is_older "$installed_vortex" "${vortexVersion}"; then
        printf 'Installing Vortex %s into %s\n' "${vortexVersion}" "$WINEPREFIX"
        umu-run "${vortexInstaller}" /S
        if [[ ! -f "$vortex_executable" ]]; then
          printf 'Vortex installer completed without creating %s.\n' "$vortex_executable" >&2
          exit 1
        fi
        write_version_marker "$vortex_marker" "${vortexVersion}"
      fi

      if [[ ! -f "$vortex_executable" ]]; then
        printf 'Vortex is not installed in %s.\n' "$WINEPREFIX" >&2
        exit 1
      fi

      pressureVesselFilesystemsRWString="${lib.concatStringsSep "," pressureVesselFilesystemsRW}"
      if [[ -n "$pressureVesselFilesystemsRWString" ]]; then
        export PRESSURE_VESSEL_FILESYSTEMS_RW="$pressureVesselFilesystemsRWString"
        export PROTON_SET_GAME_DRIVE=1
      fi   

      if [[ ("$1" == "-d" || "$1" == "-i") && "$2" != *"nxm"* ]]; then
        echo "No url provided, ignoring $1"
        exec umu-run "$vortex_executable"
      else
        export PROTON_VERB="runinprefix"
        exec umu-run "$vortex_executable" "$@"
      fi
    '';
  };

  desktopItem = makeDesktopItem {
    name = "vortex-umu";
    desktopName = "Vortex";
    comment = "Manage game mods with Vortex";
    exec = "vortex-umu -d %u";
    icon = "applications-games";
    categories = [ "Game" ];
    terminal = false;
    mimeTypes = [ "x-scheme-handler/nxm" "x-scheme-handler/nxm-protocol" ];
  };
in
symlinkJoin {
  name = "vortex-umu";
  paths = [
    launcher
    desktopItem
  ];
  meta = {
    description = "Vortex mod manager running in a managed UMU Wine prefix";
    homepage = "https://github.com/Nexus-Mods/Vortex";
    license = lib.licenses.MIT;
    mainProgram = "vortex-umu";
    platforms = [ "x86_64-linux" ];
  };
}
