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
      MISSING_CMD=false
      START_SUNSHINE=false
      STOP_SUNSHINE=false

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
      		*)
            MISSING_CMD=true
            HAS_HELP=true
      			shift
      			;;
      	esac
      done

      if [ $MISSING_CMD == true ]; then
        echo "Missing argument, needs one of [start/stop]."
      fi

      if [ $HAS_HELP == true ]; then
      	HELP_MSG="
      sunshinectl

      USAGE

        sunshinectl [start/stop]

      OPTIONS

        -h, --help              Show this help message

      EXAMPLES

        $ # Start the Sunshine service
        $ sunshinectl start

        $ # Stop the Sunshine service
        $ sunshinectl stop
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
    '';
in
override-meta new-meta package