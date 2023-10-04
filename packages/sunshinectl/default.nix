{ pkgs, lib, ... }:

let
  inherit (lib.pluskinda) override-meta;

  new-meta = with lib; {
    description = "A bash script to handle starting/stopping the Sunshine user service.";
    license = licenses.asl20;
    maintainers = with maintainers; [ joegilkes ];
  };

  package =
    pkgs.writeShellScriptBin "sunshinectl" ''
      HAS_HELP=false
      START_SUNSHINE=false
      STOP_SUNSHINE=false
      STATUS_SUNSHINE=false
      LOG_SUNSHINE=false

      if [[ $# -eq 0 ]]; then
        echo Missing argument.
        HAS_HELP=true
      fi

      while [[ $# -gt 0 ]]; do
      	case $1 in
      		-h|--help)
      			HAS_HELP=true
      			shift
      			;;
          start)
            START_SUNSHINE=true
            shift
            ;;
          stop)
            STOP_SUNSHINE=true
            shift
            ;;
          status|st)
            STATUS_SUNSHINE=true
            shift
            ;;
          log)
            LOG_SUNSHINE=true
            shift
            ;;
      		*)
            echo Unknown argument.
            HAS_HELP=true
      			shift
      			;;
      	esac
      done

      if [ $HAS_HELP == true ]; then
      	HELP_MSG="
      sunshinectl

      USAGE

        sunshinectl [start/stop/status/log]

      OPTIONS

        -h, --help              Show this help message

      EXAMPLES

        $ # Start the Sunshine service
        $ sunshinectl start

        $ # Stop the Sunshine service
        $ sunshinectl stop

        $ # Show the status of the Sunshine service
        $ sunshinectl st
        $ sunshinectl status

        $ # Show the journalctl log for the Sunshine service
        $ sunshinectl log
      "
      	echo "$HELP_MSG"
        exit 0
      fi

      if [ $START_SUNSHINE == true ]; then
        echo "Starting Sunshine service."
        systemctl --user start sunshine
        exit 0
      fi

      if [ $STOP_SUNSHINE == true ]; then
        echo "Stopping Sunshine service."
        systemctl --user stop sunshine
        exit 0
      fi

      if [ $STATUS_SUNSHINE == true ]; then
        systemctl --user status sunshine
        exit 0
      fi

      if [ $LOG_SUNSHINE == true ]; then
        journalctl --user --unit=sunshine
        exit 0
      fi
    '';
in
override-meta new-meta package