{
  lib,
  pkgs,
  ...
}:

let
  inherit (lib.pluskinda) override-meta;

  new-meta = with lib; {
    homepage = "https://github.com/berarma/ffbtools";
    description = "Set of tools for FFB testing and debugging on GNU/Linux";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    mainProgram = "ffbwrap";
    maintainers = with maintainers; [ joegilkes ];
  };

  package = pkgs.writeShellScriptBin "ffbwrap" ''
    #!/bin/bash
    #
    # Runs a command preloading libffbwrapper
    #
    # Copyright 2019 Bernat Arlandis <bernat@hotmail.com>
    #
    # This file is part of ffbtools.
    #
    # This program is free software: you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation, either version 3 of the License, or
    # (at your option) any later version.
    #
    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.
    #
    # You should have received a copy of the GNU General Public License
    # along with this program.  If not, see <https://www.gnu.org/licenses/>.

    OPTIONS=$(getopt --long 'logger:,update-fix,direction-fix,duration-fix,features-hack,force-inversion,ignore-set-gain,offset-fix,throttling,throttling-time:' -n "$0" -- "" "$@")

    if [ $? -ne 0 ]; then
      exit 1
    fi

    eval set -- "$OPTIONS"

    unset OPTIONS

    CURRENT_DIR=$(CDPATH= cd -- "$(dirname -- $(readlink -f "$0"))" && pwd)

    LIBDIR=${pkgs.pluskinda.ffbtools}/lib

    LD_PRELOAD="$LIBDIR/libffbwrapper-x86_64.so $LIBDIR/libffbwrapper-i386.so $LD_PRELOAD"

    FFBTOOLS_THROTTLING_TIME=3

    while true; do
        case "$1" in
            '--logger')
                FFBTOOLS_LOGGER=1
                FFBTOOLS_LOG_FILE="$2-$(date +%Y%m%d%H%M%S).log"
                shift 2
                continue
                ;;
            '--update-fix')
                FFBTOOLS_UPDATE_FIX=1
                shift
                continue
                ;;
            '--direction-fix')
                FFBTOOLS_DIRECTION_FIX=1
                shift
                continue
                ;;
            '--duration-fix')
                FFBTOOLS_DURATION_FIX=1
                shift
                continue
                ;;
            '--features-hack')
                FFBTOOLS_FEATURES_HACK=1
                shift
                continue
                ;;
            '--force-inversion')
                FFBTOOLS_FORCE_INVERSION=1
                shift
                continue
                ;;
            '--ignore-set-gain')
                FFBTOOLS_IGNORE_SET_GAIN=1
                shift
                continue
                ;;
            '--offset-fix')
                FFBTOOLS_OFFSET_FIX=1
                shift
                continue
                ;;
            '--throttling')
                FFBTOOLS_THROTTLING=1
                shift
                continue
                ;;
            '--throttling-time')
                FFBTOOLS_THROTTLING_TIME=$2
                shift 2
                continue
                ;;
            '--')
                shift
                break
                ;;
        esac
    done

    DEVICE_FILE=$(readlink -f "$1")

    if [ -n "$DEVICE_FILE" ]
    then
        FFBTOOLS_DEV_MAJOR=0x$(stat --format="%t" "$DEVICE_FILE")
        FFBTOOLS_DEV_MINOR=0x$(stat --format="%T" "$DEVICE_FILE")
        shift
    fi

    if [ "$FFBTOOLS_THROTTLING" = "1" ]; then
        FFBTOOLS_THROTTLING=$FFBTOOLS_THROTTLING_TIME
    fi

    COMMAND="$1"
    shift

    if [ -z "$FFBTOOLS_DEV_MAJOR" -o -z "$FFBTOOLS_DEV_MINOR" -o -z "$COMMAND" ]; then
        echo "Usage: $0 [--logger=logfile] [--update-fix] [--direction-fix] [--duration-fix] [--features-hack] [--force-inversion] [--ignore-set-gain] [--offset-fix] [--throttling] [--throttling-time=N] <device> -- <command>"
        exit 1
    fi

    FFBTOOLS_DEVICE_NAME="$(eval $(udevadm info -q property -x "$DEVICE_FILE") && echo "$ID_VENDOR ''${ID_MODEL//_/ }")"

    export LD_PRELOAD FFBTOOLS_DEVICE_NAME FFBTOOLS_DEV_MAJOR FFBTOOLS_DEV_MINOR FFBTOOLS_LOGGER FFBTOOLS_LOG_FILE FFBTOOLS_UPDATE_FIX FFBTOOLS_DIRECTION_FIX FFBTOOLS_DURATION_FIX FFBTOOLS_FEATURES_HACK FFBTOOLS_FORCE_INVERSION FFBTOOLS_IGNORE_SET_GAIN FFBTOOLS_OFFSET_FIX FFBTOOLS_THROTTLING

    "$COMMAND" "$@"
  '';
in
override-meta new-meta package